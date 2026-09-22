package Skill
{
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;
    import mx.collections.ArrayCollection;
    import Communication.VO.Skill.SkillVO;
    import Enums.DIRTY_INDICATOR;
    import __AS3__.vec.*;

    public class cSkillList extends Notifier 
    {

        public static const SKILLLIST_CHANGED:String = "SKILLLIST_CHANGED";
        public static const SKILLLIST_APPLY_FAILED:String = "SKILLLIST_APPLY_FAILED";

        protected var _items_vector:Vector.<cSkill> = new Vector.<cSkill>();
        protected var _items:Dictionary = new Dictionary(true);

        public function cSkillList(_arg_1:cGeneralInterface)
        {
            super();
            _arg_1.skillLists_vector.push(this);
        }

        public function isEmpty():Boolean
        {
            return (this._items_vector.length > 0);
        }

        public function getSkillVOs():ArrayCollection
        {
            var _local_2:cSkill;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this._items_vector)
            {
                if (((_local_2.getLevel() > 0) && (!(_local_2.isTemporary()))))
                {
                    _local_1.addItem(_local_2.getVO());
                };
            };
            return (_local_1);
        }

        public function GetSkillsString(_arg_1:Boolean):String
        {
            var _local_2:String;
            var _local_4:cSkill;
            var _local_3:Boolean;
            _local_2 = "";
            for each (_local_4 in this._items_vector)
            {
                if (((_local_4.getLevel() > 0) && (!(_local_4.isTemporary()))))
                {
                    _local_2 = (_local_2 + (((((_local_4.getId().toString() + ":") + _local_4.getName()) + ":") + _local_4.getLevel().toString()) + ","));
                    _local_3 = true;
                };
            };
            if (((_local_3) && (_arg_1)))
            {
                _local_2 = _local_2.substr(0, (_local_2.length - 1));
            };
            return (_local_2);
        }

        public function removeSkill(_arg_1:int):void
        {
            var _local_2:cSkill = this.getItemByID(_arg_1);
            if (_local_2 != null)
            {
                _local_2.removeAllSkillpoints();
                this._items_vector.splice(this._items_vector.indexOf(_local_2), 1);
                this._items[_arg_1] = null;
            };
        }

        public function init(_arg_1:ArrayCollection, _arg_2:Skilled, _arg_3:cGeneralInterface):void
        {
            var _local_4:SkillVO;
            var _local_5:cSkill;
            for each (_local_4 in _arg_1)
            {
                _local_5 = this.addSkill(_local_4, _arg_2, _arg_3, false, false, false);
                _local_5.mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
            };
        }

        public function addSkill(_arg_1:SkillVO, _arg_2:Skilled, _arg_3:cGeneralInterface, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean):cSkill
        {
            var _local_7:cSkill = this.getItemByID(_arg_1.id);
            if (_local_7 == null)
            {
                _local_7 = new cSkill(global.skills_vector[_arg_1.id], _arg_2, _arg_3, _arg_4, _arg_5);
                this._items_vector.push(_local_7);
            };
            _local_7.setSkillPoint(_arg_1.level, _arg_6);
            if (((!(_arg_2 == null)) && (!(_arg_3 == null))))
            {
                _local_7.apply(false);
            };
            return (_local_7);
        }

        public function getItems_vector():Vector.<cSkill>
        {
            return (this._items_vector);
        }

        public function getItemByID(_arg_1:int):cSkill
        {
            var _local_2:cSkill;
            if (this._items[_arg_1] != null)
            {
                return (this._items[_arg_1]);
            };
            for each (_local_2 in this._items_vector)
            {
                if (_local_2.getId() == _arg_1)
                {
                    this._items[_arg_1] = _local_2;
                    return (_local_2);
                };
            };
            return (null);
        }

        public function removeAllSkills():void
        {
            while (this._items_vector.length > 0)
            {
                this.removeSkill(this._items_vector[0].getId());
            };
        }


    }
}
