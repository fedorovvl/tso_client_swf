package LootTableSystem
{
    import Modifier.Modifieable;
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;
    import nLib.cXML;
    import Modifier.Modifier;
    import Utils.StringUtils;
    import Modifier.ModifierVO;
    import __AS3__.vec.*;

    public class cLootTable implements Modifieable 
    {

        public static const USE_LOOTTABLE:String = "USE_LOOTTABLE";

        private var name_string:String;
        private var mPlayerLevelMax:int;
        public var mItemContents_vector:Vector.<cLootTableItemContent> = new Vector.<cLootTableItemContent>();
        private var mMinContribution:int;
        public var temporaryOwner:Modifieable = null;
        public var appliedSkills_vector:Vector.<SkillVO> = new Vector.<SkillVO>();
        private var requiresEvent_string:String;
        private var mChanceItemsAmount:int;
        private var mPlayerLevelMin:int;

        public function cLootTable(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int)
        {
            super();
            this.name_string = _arg_1;
            this.requiresEvent_string = _arg_2;
            this.mMinContribution = _arg_3;
            this.mChanceItemsAmount = _arg_4;
            this.mPlayerLevelMin = _arg_5;
            this.mPlayerLevelMax = _arg_6;
        }

        public static function CreateLootTableFromXml(_arg_1:cXML):cLootTable
        {
            var _local_10:cXML;
            var _local_2:String = _arg_1.GetAttributeString_string("name");
            var _local_3:String = _arg_1.GetAttributeString_string("requiresEvent");
            var _local_4:int = _arg_1.GetAttributeInt("MinContribution");
            var _local_5:int = _arg_1.GetAttributeInt("ChanceItemsAmount");
            var _local_6:int = _arg_1.GetAttributeInt("PlayerLevelMin");
            var _local_7:int = _arg_1.GetAttributeInt("PlayerLevelMax");
            if (_local_7 == 0)
            {
                _local_7 = 1000;
            };
            var _local_8:Vector.<cXML> = _arg_1.CreateChildrenArray();
            var _local_9:cLootTable = new cLootTable(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7);
            for each (_local_10 in _local_8)
            {
                _local_9.mItemContents_vector.push(cLootTableItemContent.CreateLootTableItemContentFromXml(_local_10));
            };
            return (_local_9);
        }


        public function SetChanceItemsAmount(_arg_1:int):void
        {
            this.mChanceItemsAmount = _arg_1;
        }

        public function setModified(_arg_1:Modifier):void
        {
            if (((!(_arg_1 == null)) && (!(_arg_1.ownerSkill == null))))
            {
                this.appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
        }

        public function GetPlayerLevelMin():int
        {
            return (this.mPlayerLevelMin);
        }

        public function isModified():Boolean
        {
            return (this.appliedSkills_vector.length > 0);
        }

        public function GetPlayerLevelMax():int
        {
            return (this.mPlayerLevelMax);
        }

        public function getRequiresEvent_string():String
        {
            return (this.requiresEvent_string);
        }

        public function GetChanceItemsAmount():int
        {
            return (this.mChanceItemsAmount);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (this.temporaryOwner != null)
            {
                return (this.temporaryOwner.isModifierApplyable(_arg_1));
            };
            if (((_arg_1.rules_string.length > 0) && (_arg_1.rules_string.toLowerCase().indexOf("explicit") > -1)))
            {
                return (StringUtils.splitToHashSet(_arg_1.name_string, ",", true).contains(this.name_string));
            };
            if (((_arg_1.name_string.length > 0) && (_arg_1.name_string.indexOf(this.name_string) < 0)))
            {
                return (false);
            };
            return (true);
        }

        public function GetMinContribution():int
        {
            return (this.mMinContribution);
        }

        public function GetName_string():String
        {
            return (this.name_string);
        }

        public function clone():cLootTable
        {
            var _local_2:cLootTableItemContent;
            var _local_1:cLootTable = new cLootTable(this.name_string, this.requiresEvent_string, this.mMinContribution, this.mChanceItemsAmount, this.mPlayerLevelMin, this.mPlayerLevelMax);
            for each (_local_2 in this.mItemContents_vector)
            {
                _local_1.mItemContents_vector.push(_local_2.clone());
            };
            return (_local_1);
        }

        public function toString():String
        {
            var _local_2:cLootTableItemContent;
            var _local_1:* = (("<cLootTable ChanceItemsAmount='" + this.mChanceItemsAmount) + "' >\n");
            for each (_local_2 in this.mItemContents_vector)
            {
                _local_1 = (_local_1 + (_local_2.toString() + "\n"));
            };
            return (_local_1 + "</cLootTable>\n");
        }


    }
}
