package LootTableSystem
{
    import ShopSystem.cItemContent;
    import __AS3__.vec.Vector;
    import Communication.VO.TriggerVO;
    import Communication.VO.EffectVO;
    import Enums.ITEM_CONTENT_TYPE;
    import nLib.cXML;
    import Effects.Effects.Reward;
    import __AS3__.vec.*;

    public class cLootTableItemContent extends cItemContent 
    {

        private var mIgnoresPremium:Boolean;
        private var mPrio:int;
        private var mIsJackpot:Boolean;

        private var conditions:Vector.<TriggerVO> = new Vector.<TriggerVO>();
        private var effects:Vector.<EffectVO> = new Vector.<EffectVO>();

        public function cLootTableItemContent(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:int, _arg_6:int, _arg_7:Boolean, _arg_8:Boolean)
        {
            super(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.mIsJackpot = _arg_8;
            this.mPrio = _arg_1;
            this.mIgnoresPremium = _arg_7;
        }

        public static function CreateLootTableItemContentFromEffectVO(_arg_1:EffectVO):cLootTableItemContent
        {
            return (new cLootTableItemContent(_arg_1.chance, ITEM_CONTENT_TYPE.parse(_arg_1.type_string), _arg_1.item_string, _arg_1.name_string, _arg_1.amount, _arg_1.value, true, ((_arg_1.action_string == "isJackpot") ? true : false)));
        }

        public static function CreateLootTableItemContentFromXml(_arg_1:cXML):cLootTableItemContent
        {
            var _local_8:cXML;
            var _local_9:Vector.<cXML>;
            var _local_10:cXML;
            var _local_2:cItemContent = cItemContent.CreateItemContentFromXml(_arg_1);
            var _local_3:int = _arg_1.GetAttributeInt("Prio");
            var _local_4:Boolean = _arg_1.GetAttributeBool("isJackpot", false);
            var _local_5:Boolean = _arg_1.GetAttributeBool("ignoresPremium");
            var _local_6:cLootTableItemContent = new cLootTableItemContent(_local_3, _local_2.GetType(), _local_2.GetName_string(), _local_2.GetResourceName_string(), _local_2.GetCount(), _local_2.GetRecurringChance(), _local_5, _local_4);
            var _local_7:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("conditions");
            for each (_local_8 in _local_7)
            {
                _local_6.conditions.push(TriggerVO.createFromXML(_local_8, 0));
            };
            _local_9 = _arg_1.MoveToSubNodeAndCreateChildrenArray("effects");
            for each (_local_10 in _local_9)
            {
                _local_6.effects.push(EffectVO.CreateFromXML(_local_10));
            };
            return (_local_6);
        }


        override public function toString():String
        {
            return (((((((((("<cLootTableItemContent prio='" + this.mPrio) + "' type='") + ITEM_CONTENT_TYPE.toString(GetType())) + "' resourceName_string='") + GetResourceName_string()) + "' name='") + GetName_string()) + "' count='") + GetCount()) + "' />");
        }

        public function GetPrio():int
        {
            return (this.mPrio);
        }

        public function SetIgnoresPremium(_arg_1:Boolean):void
        {
            this.mIgnoresPremium = _arg_1;
        }

        public function GetEffectVOFromLootTableItemContent():EffectVO
        {
            var _local_1:EffectVO = new EffectVO();
            _local_1.chance = this.mPrio;
            _local_1.type_string = ITEM_CONTENT_TYPE.toString(type);
            _local_1.name_string = (((!(resourceName_string == null)) && (resourceName_string.length > 0)) ? resourceName_string : name_string);
            _local_1.item_string = (((!(name_string == null)) && (name_string.length > 0)) ? name_string : resourceName_string);
            _local_1.amount = count;
            _local_1.value = recurringChance;
            _local_1.effect_string = Reward.XML_string;
            _local_1.action_string = ((this.mIsJackpot) ? "isJackpot" : "");
            return (_local_1);
        }

        public function SetIsJackpot(_arg_1:Boolean):void
        {
            this.mIsJackpot = _arg_1;
        }

        public function GetConditions():Vector.<TriggerVO>
        {
            return (this.conditions);
        }

        public function GetEffects():Vector.<EffectVO>
        {
            return (this.effects);
        }

        public function GetIsJackpot():Boolean
        {
            return (this.mIsJackpot);
        }

        public function SetPrio(_arg_1:int):void
        {
            this.mPrio = _arg_1;
        }

        public function GetIgnoresPremium():Boolean
        {
            return (this.mIgnoresPremium);
        }

        public function clone():cLootTableItemContent
        {
            var _local_1:cLootTableItemContent = new cLootTableItemContent(this.mPrio, type, name_string, resourceName_string, count, recurringChance, this.mIgnoresPremium, this.mIsJackpot);
            _local_1.conditions = this.conditions;
            _local_1.effects = this.effects;
            return (_local_1);
        }


    }
}
