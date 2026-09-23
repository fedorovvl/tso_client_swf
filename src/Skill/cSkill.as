package Skill
{
    import flash.events.EventDispatcher;
    import Interface.cGeneralInterface;
    import Communication.VO.Skill.SkillVO;
    import __AS3__.vec.Vector;
    import Modifier.Modifier;
    import Enums.DIRTY_INDICATOR;
    import flash.geom.Point;
    import flash.events.Event;
    import mx.collections.ArrayCollection;
    import nLib.cLog;
    import ServerState.cResources;
    import Modifier.ModifierFactory;
    import Modifier.ModifierVO;
    import Enums.ModifyReason;
    import Utils.TriggerUtils;
    import __AS3__.vec.*;

    public class cSkill extends EventDispatcher 
    {

        public static const SKILL_APPLY_FAILED:String = "SKILL_APPLY_FAILED";

        private var _gi:cGeneralInterface;
        private var _level:int = 0;
        private var _isTemporary:Boolean;
        private var _originalSkillState:SkillVO = null;
        private var _skillTree:cSkillTree = null;
        private var _locked:Boolean = true;
        public var mDirtyIndicator:int;
        private var _owner:Skilled;
        private var _isTrait:Boolean;
        private var _modifier_vector:Vector.<Modifier>;
        private var _definition:SkillDefinition;

        public function cSkill(_arg_1:SkillDefinition, _arg_2:Skilled, _arg_3:cGeneralInterface, _arg_4:Boolean, _arg_5:Boolean)
        {
            super();
            this._definition = _arg_1;
            this._owner = _arg_2;
            this._gi = _arg_3;
            this._isTemporary = _arg_4;
            this._isTrait = _arg_5;
            this._modifier_vector = new Vector.<Modifier>();
            this._originalSkillState = this.getVO();
            this.mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
            if (((!(this._isTemporary)) && (!(this._isTrait))))
            {
                this.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
            };
        }

        public function dispose():void
        {
            for each (var modifier:Modifier in this._modifier_vector)
            {
                modifier.dispose();
            }
            this._modifier_vector.length = 0;
        }

        public function isTrait():Boolean
        {
            return (this._isTrait);
        }

        public function getResetCost():int
        {
            var _local_2:SkillpointDefinition;
            var _local_1:int;
            for each (_local_2 in global.skillPoints_vector)
            {
                if (_local_2.id_string == this._definition.concerningResource_string)
                {
                    _local_1 = _local_2.resetCost;
                    break;
                };
            };
            return (_local_1 * this._originalSkillState.level);
        }

        public function getName():String
        {
            return (this._definition.name_string);
        }

        public function getVO():SkillVO
        {
            var _local_1:SkillVO = new SkillVO();
            _local_1.id = this._definition.id;
            _local_1.level = this._level;
            return (_local_1);
        }

        public function getId():int
        {
            return (this._definition.id);
        }

        public function getPosition():Point
        {
            return (this._definition.position);
        }

        public function lock():void
        {
            if (this._locked)
            {
                return;
            };
            this._locked = true;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function playerHasMinimumLevel():Boolean
        {
            return (this._gi.mCurrentPlayer.GetPlayerLevel() >= this._definition.minimumLevel);
        }

        public function getPointsAccumulatedReferenceIds():ArrayCollection
        {
            return (this._definition.pointsAccumulatedReferenceIds);
        }

        public function removeAllSkillpoints():void
        {
            this._level = 0;
            this.apply(false);
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function getGI():cGeneralInterface
        {
            return (this._gi);
        }

        public function changed():Boolean
        {
            return (!(this._level == this._originalSkillState.level));
        }

        public function getUnappliedPoints():int
        {
            return (this._level - this._originalSkillState.level);
        }

        public function addSkillPoint():Boolean
        {
            return (this.setSkillPoint((this._level + 1), true));
        }

        public function getSkillPointType_string():String
        {
            return (this._definition.skillPointType_string);
        }

        public function skillpointsApplyable(_arg_1:uint):Boolean
        {
            return (this._definition.level_vector.length >= (this._level + _arg_1));
        }

        public function unlock():void
        {
            if (!this._locked)
            {
                return;
            };
            this._locked = false;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function getOriginalVO():SkillVO
        {
            return (this._originalSkillState);
        }

        public function setSkillPoint(_arg_1:int, _arg_2:Boolean):Boolean
        {
            var _local_3:int = this._definition.level_vector.length;
            if (((_arg_1 < this._level) || (_arg_1 > _local_3)))
            {
                cLog.warning((((((((("Set Skillpoint failed on " + this._definition) + " to lvl ") + _arg_1) + " cause: (") + this._locked) + (_arg_1 < this._level)) + (_arg_1 > _local_3)) + ")"));
                this._gi.channels.SKILL.send(SKILL_APPLY_FAILED, this);
                return (false);
            };
            this._level = _arg_1;
            if (_arg_2)
            {
                dispatchEvent(new Event(Event.CHANGE));
            };
            return (true);
        }

        public function getDefinition():SkillDefinition
        {
            return (this._definition);
        }

        public function setSkillTree(_arg_1:cSkillTree):void
        {
            this._skillTree = _arg_1;
        }

        public function getLevel():int
        {
            return (this._level);
        }

        public function isTemporary():Boolean
        {
            return (this._isTemporary);
        }

        public function getSkillTree():cSkillTree
        {
            return (this._skillTree);
        }

        public function isLocked():Boolean
        {
            return (this._locked);
        }

        public function removeSkillPoint():void
        {
            this.setSkillPoint((this._level - 1), true);
        }

        public function undo():void
        {
            this._level = this._originalSkillState.level;
            dispatchEvent(new Event(Event.CANCEL));
        }

        public function apply(_arg_1:Boolean):Boolean
        {
            var _local_3:Modifier;
            var _local_4:cResources;
            var _local_5:ModifierFactory;
            var _local_6:ModifierVO;
            var _local_7:Modifier;
            var _local_2:int = (this._level - this._originalSkillState.level);
            if (_local_2 == 0)
            {
                this._gi.channels.SKILL.send(SKILL_APPLY_FAILED, this);
                return (false);
            };
            if (((_arg_1) && (_local_2 > 0)))
            {
                _local_4 = this._gi.mCurrentPlayerZone.GetResources(this._gi.mCurrentPlayer);
                if (_local_4.HasPlayerResource(this._definition.concerningResource_string, _local_2))
                {
                    _local_4.AddResource(this._definition.concerningResource_string, -(_local_2), ModifyReason.APPLY_SKILL, null);
                }
                else
                {
                    this.undo();
                    this._gi.channels.SKILL.send(SKILL_APPLY_FAILED, this);
                    return (false);
                };
            };
            for each (_local_3 in this._modifier_vector)
            {
                _local_3.dispose();
            };
            this._modifier_vector.length = 0;
            if (this._level > 0)
            {
                _local_5 = new ModifierFactory(this._gi);
                for each (_local_6 in this._definition.level_vector[(this._level - 1)])
                {
                    _local_7 = _local_5.create(_local_6);
                    _local_7.applyOn(this._owner.getNotifier());
                    _local_7.setOwnerSkill(this);
                    this._modifier_vector.push(_local_7);
                };
            };
            if (((!(this._isTemporary)) && (!(this._isTrait))))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            this._originalSkillState = this.getVO();
            this._gi.channels.SKILL.send(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
            return (true);
        }

        public function getNumPointsAccumulated():int
        {
            return (this._definition.numPointsAccumulated);
        }

        override public function toString():String
        {
            return (((((((("<Skill id=" + this.getId()) + " name=") + this.getName()) + " Lvl=") + this._level) + " owner=") + this.getOwner().getName(true)) + " >");
        }

        public function getMaxLevel():int
        {
            return (this._definition.level_vector.length);
        }

        public function getOwner():Skilled
        {
            return (this._owner);
        }


    }
}
