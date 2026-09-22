package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import flash.utils.Dictionary;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import AdventureSystem.cAdventureDefinition;
    import BuffSystem.cBuff;

    public class OwnStarMenuItemTypeListTrigger extends InstantTrigger implements Observer 
    {

        public static const TYPE_ALL:int = 0;
        public static const TYPE_ALL_string:String = "";
        public static const TYPE_ADVENTURE:int = 1;
        public static const TYPE_ADVENTURE_string:String = "Adventure";
        public static const TYPE_BUILDING:int = 2;
        public static const TYPE_BUILDING_string:String = "BuildBuilding";
        public static const TYPE_RESOURCE:int = 3;
        public static const TYPE_RESOURCE_string:String = "AddResource";
        public static const TYPE_FILL_DEPOSIT:int = 4;
        public static const TYPE_FILL_DEPOSIT_string:String = "FillDeposit";

        private var itemList:Array;
        private var notifier:Notifier;
        private var itemType:int;
        private var generalInterface:cGeneralInterface;
        private var knownTypes:Dictionary;

        public function OwnStarMenuItemTypeListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.itemList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.checkItemType();
            this.generalInterface = _arg_3;
            this.notifier = _arg_3.mCurrentPlayer;
            this.notifier.addPropertyObserver(TriggerUtils.STAR_MENU_UPDATED_PROPERTY_NAME, this);
        }

        private function checkAdventureType(_arg_1:cBuff):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.GetResourceName_string());
            return ((((definition.target_string.length == 0) || (StringUtils.contains(_local_2.GetType_string(), definition.target_string))) || (StringUtils.contains(_local_2.GetTheme_string(), definition.target_string))) || (StringUtils.contains(_local_2.GetCampaign_string(), definition.target_string)));
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_3 == null)
            {
                return;
            };
            if (this.checkBuffItem((_arg_3 as cBuff)))
            {
                this.check();
            };
        }

        private function createKnownTypes():void
        {
            if (this.knownTypes == null)
            {
                this.knownTypes = new Dictionary();
                this.knownTypes[TYPE_ALL_string] = TYPE_ALL;
                this.knownTypes[TYPE_ADVENTURE_string] = TYPE_ADVENTURE;
                this.knownTypes[TYPE_BUILDING_string] = TYPE_BUILDING;
                this.knownTypes[TYPE_RESOURCE_string] = TYPE_RESOURCE;
                this.knownTypes[TYPE_FILL_DEPOSIT_string] = TYPE_FILL_DEPOSIT;
            };
        }

        private function checkItemType():void
        {
            this.createKnownTypes();
            if (this.knownTypes[definition.GetTypeString()] == null)
            {
                throw (new Error((("Unknown shop item type[" + definition.item_string) + "]")));
            };
            this.itemType = this.knownTypes[definition.GetTypeString()];
        }

        private function checkBuildingBuff(_arg_1:cBuff):Boolean
        {
            var _local_2:String = _arg_1.GetBuffDefinition().GetName_string();
            return ((_local_2 == TYPE_BUILDING_string) && (this.checkAll(_arg_1)));
        }

        private function checkAdventureBuff(_arg_1:cBuff):Boolean
        {
            var _local_2:String = _arg_1.GetBuffDefinition().GetName_string();
            return (((_local_2 == TYPE_ADVENTURE_string) && (this.checkAll(_arg_1))) && (this.checkAdventureType(_arg_1)));
        }

        private function checkBuffItem(_arg_1:cBuff):Boolean
        {
            switch (this.itemType)
            {
                case TYPE_ALL:
                    return (this.checkAll(_arg_1));
                case TYPE_ADVENTURE:
                    return (this.checkAdventureBuff(_arg_1));
                case TYPE_BUILDING:
                    return (this.checkBuildingBuff(_arg_1));
                case TYPE_RESOURCE:
                    return (this.checkResourceBuff(_arg_1));
                case TYPE_FILL_DEPOSIT:
                    return (this.checkFillDepositBuff(_arg_1));
            };
            return (false);
        }

        private function checkResourceBuff(_arg_1:cBuff):Boolean
        {
            var _local_2:String = _arg_1.GetBuffDefinition().GetName_string();
            return ((!(_local_2.indexOf(TYPE_RESOURCE_string) == -1)) && (this.checkAll(_arg_1)));
        }

        private function checkFillDepositBuff(_arg_1:cBuff):Boolean
        {
            var _local_2:String = _arg_1.GetBuffDefinition().GetName_string();
            return ((!(_local_2.indexOf(TYPE_FILL_DEPOSIT_string) == -1)) && (this.checkAll(_arg_1)));
        }

        override public function dispose():void
        {
            if (this.notifier != null)
            {
                this.notifier.removePropertyObserver(TriggerUtils.STAR_MENU_UPDATED_PROPERTY_NAME, this);
                this.notifier = null;
            };
            this.itemList = null;
            this.generalInterface = null;
            this.knownTypes = null;
            super.dispose();
        }

        private function checkAll(_arg_1:cBuff):Boolean
        {
            return ((this.itemList.length == 0) || (TriggerUtils.contains(this.itemList, _arg_1.GetResourceName_string())));
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:cBuff;
            var _local_1:int;
            for each (_local_2 in this.generalInterface.mCurrentPlayer.getAvailableBuffs_vector())
            {
                if (this.checkBuffItem(_local_2))
                {
                    if (this.itemType == TYPE_ADVENTURE)
                    {
                        _local_1 = (_local_1 + _local_2.GetAmount());
                    }
                    else
                    {
                        _local_1++;
                    };
                };
            };
            return (_local_1);
        }


    }
}
