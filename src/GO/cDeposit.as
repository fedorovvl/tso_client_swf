package GO
{
    import Skill.Skilled;
    import Skill.cSkillList;
    import GOSets.cGOSetList;
    import Enums.OBJECTTYPE;
    import Interface.cGeneralInterface;
    import Communication.VO.dDepositVO;
    import Model.Notifier;
    import Enums.DIRTY_INDICATOR;
    import ServerState.cResourceCreation;
    import mx.collections.ArrayCollection;
    import Skill.cSkillTree;
    import Model.Notifiers.ResourceChannel;
    import Enums.SKILL_OWNER;
    import Communication.VO.dUniqueID;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import Enums.RENDER_ORDER;

    public class cDeposit extends cIsoGO implements Skilled 
    {

        private var mAccessible:int = 0;
        private var mGOSetListName_string:String = null;
        private var mName_string:String;
        private var mAmount:int;
        public var mDirtyIndicator:int;
        public var skills:cSkillList;
        public var mDepositGfx:cGOSetList = null;
        private var mPlayerID:int = -1;
        private var mDepositGroupdId:int = -1;
        private var mRefillable:Boolean;
        private var mEmptied:uint = 0;
        private var mMaxAmount:int;

        public function cDeposit(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
            this.skills = new cSkillList(_arg_1);
            this.mPlayerID = -1;
            SetLevelEnumObjectType(OBJECTTYPE.DEPOSIT);
        }

        public static function CreateDepositFromVO(_arg_1:dDepositVO, _arg_2:cGeneralInterface):cDeposit
        {
            var _local_3:cDeposit = cDeposit.CreateFromString(global.guiIconGroup, ("Deposit" + _arg_1.name_string), _arg_2);
            _local_3.Init(_arg_1.name_string, _arg_1.gridIdx, _arg_1.amount, _arg_1.maxAmount, _arg_1.depositGroupdId, _arg_1.accessible, _arg_1.emptied, _arg_1.goSetListName_string, _arg_1.refillable, _arg_1.skills);
            return (_local_3);
        }

        public static function CreateFromString(_arg_1:cGOGroup, _arg_2:String, _arg_3:cGeneralInterface):cDeposit
        {
            var _local_4:int = _arg_1.GetNrFromName(_arg_2);
            var _local_5:cDeposit = new cDeposit(_arg_3);
            _local_5.InitFromNr(_arg_1, _local_4);
            _local_5.SetLevelEnumObjectType(OBJECTTYPE.DEPOSIT);
            return (_local_5);
        }


        public function getName(_arg_1:Boolean):String
        {
            return ("");
        }

        public function GetEmptied():int
        {
            return (this.mEmptied);
        }

        public function getNotifier():Notifier
        {
            return (this);
        }

        public function SetPlayerID(_arg_1:int):void
        {
            this.mPlayerID = _arg_1;
        }

        public function GetDepositID():int
        {
            return (global.guiIconGroup.GetNrFromName(("Deposit" + this.GetName_string())));
        }

        public function GetAmount():int
        {
            return (this.mAmount);
        }

        public function GetName_string():String
        {
            return (this.mName_string);
        }

        public function EmptyDeposit():void
        {
            this.mAmount = 0;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetDepositGroupID():int
        {
            return (this.mDepositGroupdId);
        }

        override public function Render():void
        {
            if (this.mDepositGfx != null)
            {
                this.mDepositGfx.Render(mXNotScaled, mYNotScaled);
            };
            var _local_1:cBuilding = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(GetGrid());
            if (((this.skills.getItems_vector().length > 0) && ((_local_1 == null) || ((!(_local_1.IsUpgradeInProgress())) && ((_local_1.GetResourceCreation() == null) || (_local_1.GetResourceCreation().GetProductionState() == cResourceCreation.PRODUCTIONSTATE_WORKING))))))
            {
                gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.SKILLED_OBJECT);
                gGfxResource.mBuildingInfoIcons.RenderPos(mXNotScaled, (((mYNotScaled - global.streetGridY) - global.streetGridYHalf) - mGeneralInterface.mWobblingInt));
            };
        }

        public function Init(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:String, _arg_9:Boolean, _arg_10:ArrayCollection):void
        {
            SetGrid(_arg_2);
            this.mName_string = _arg_1;
            this.mAmount = _arg_3;
            if (this.mAmount < 0)
            {
                this.mAmount = 0;
            };
            this.mMaxAmount = _arg_4;
            this.mDepositGroupdId = _arg_5;
            this.mAccessible = _arg_6;
            this.mEmptied = _arg_7;
            this.mRefillable = _arg_9;
            this.mGOSetListName_string = _arg_8;
            if (_arg_10 != null)
            {
                this.skills.init(_arg_10, this, mGeneralInterface);
            };
        }

        public function AddAmount(_arg_1:int):void
        {
            this.SetAmount((this.mAmount + _arg_1));
        }

        override public function getRenderSortGrid():int
        {
            return (super.getRenderSortGrid());
        }

        public function SetAmount(_arg_1:int):void
        {
            this.mAmount = _arg_1;
            if (this.mAmount < 0)
            {
                this.mAmount = 0;
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetGOSetListName_string():String
        {
            return (this.mGOSetListName_string);
        }

        public function GetMaxAmount():int
        {
            return (this.mMaxAmount);
        }

        public function setSkillTree(_arg_1:cSkillTree):void
        {
        }

        public function ChangeAmount(_arg_1:int):void
        {
            this.mAmount = (this.mAmount + _arg_1);
            if (this.mAmount < 0)
            {
                this.mAmount = 0;
            };
            if (((_arg_1 < 0) && (this.mAmount > 0)))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
            }
            else
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            mGeneralInterface.channels.RESOURCE.notifyPropertyObserver(ResourceChannel.DEPOSIT_CHANGED_AMOUNT_string, [this.mName_string, this.mAmount]);
        }

        public function SetMaxAmount(_arg_1:int):void
        {
            this.mMaxAmount = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function getOwnerType():int
        {
            return (SKILL_OWNER.DEPOSIT);
        }

        public function getOwnerID():dUniqueID
        {
            return (dUniqueID.Create(GetGrid(), 0));
        }

        public function getIconID():String
        {
            return ("");
        }

        public function getSkillTree():cSkillTree
        {
            return (null);
        }

        public function GetAccessibleType():int
        {
            return (this.mAccessible);
        }

        override public function getPlayerID():int
        {
            return (this.mPlayerID);
        }

        override public function toString():String
        {
            return (((((((((("<Deposit '" + this.mName_string) + "' @") + GetGrid()) + ", ") + this.GetAmount()) + "/") + this.GetMaxAmount()) + " accessible=") + DEPOSIT_ACCESSIBLE_TYPES.toString(this.mAccessible)) + " >");
        }

        public function SetAccessibleType(_arg_1:int):Boolean
        {
            this.mAccessible = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            if (this.mAccessible == DEPOSIT_ACCESSIBLE_TYPES.NOT_ACCESSIBLE)
            {
                this.skills.removeAllSkills();
            };
            return (true);
        }

        public function CreateDepositVOFromDeposit():dDepositVO
        {
            var _local_1:dDepositVO = new dDepositVO();
            _local_1.accessible = this.GetAccessibleType();
            _local_1.gridIdx = GetGrid();
            _local_1.depositGroupdId = this.GetDepositGroupID();
            _local_1.emptied = this.GetEmptied();
            _local_1.name_string = this.GetName_string();
            _local_1.amount = this.GetAmount();
            _local_1.maxAmount = this.GetMaxAmount();
            _local_1.goSetListName_string = this.GetGOSetListName_string();
            _local_1.refillable = this.IsRefillable();
            _local_1.skills = this.skills.getSkillVOs();
            return (_local_1);
        }

        public function IsRefillable():Boolean
        {
            return (this.mRefillable);
        }

        override public function getRenderSortSubGrid():int
        {
            return (RENDER_ORDER.ORDER_2);
        }

        public function IncEmptied():void
        {
            this.mEmptied++;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }


    }
}
