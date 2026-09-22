package Skill
{
    import Interface.cGameInterface;
    import Interface.cGeneralInterface;
    import flash.events.Event;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import Effects.Effects.Reward;
    import Communication.VO.Skill.ResetSkillsVO;
    import Enums.COMMAND;
    import Communication.VO.Skill.ChangeSkillsVO;
    import nLib.cLog;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class cSkillTree extends cSkillList 
    {

        private var _gi:cGameInterface;
        public var waiting:Boolean;
        private var _sumPoints:int;
        private var _definition:SkillTreeDefinition;
        private var _owner:Skilled;

        public function cSkillTree(_arg_1:int, _arg_2:Skilled, _arg_3:cGeneralInterface)
        {
            super(_arg_3);
            this._owner = _arg_2;
            this._gi = (_arg_3 as cGameInterface);
            this._definition = SkillTreeDefinition.getByID(_arg_1);
            this._createItems();
            this._calculateDependenciesAll();
        }

        override public function toString():String
        {
            return (((("<SkillTree name=" + this._definition.name_string) + " id=") + this._definition.id) + ">");
        }

        private function _onItemChange(_arg_1:Event):void
        {
            this._calculateDependenciesAll();
        }

        public function getDefinition():SkillTreeDefinition
        {
            return (this._definition);
        }

        public function getResetRewards(_arg_1:Boolean):Vector.<EffectVO>
        {
            var _local_5:cSkill;
            var _local_6:String;
            var _local_7:int;
            var _local_8:EffectVO;
            var _local_9:EffectVO;
            var _local_10:EffectVO;
            var _local_11:EffectVO;
            var _local_2:Vector.<EffectVO> = new Vector.<EffectVO>();
            var _local_3:* = "resource";
            var _local_4:String = Reward.XML_string;
            for each (_local_5 in _items_vector)
            {
                _local_6 = _local_5.getDefinition().concerningResource_string;
                _local_7 = _local_5.getOriginalVO().level;
                if (_local_7 >= 1)
                {
                    _local_8 = null;
                    for each (_local_9 in _local_2)
                    {
                        if (_local_9.name_string == _local_6)
                        {
                            _local_8 = _local_9;
                            break;
                        };
                    };
                    if (_local_8 == null)
                    {
                        _local_8 = new EffectVO();
                        _local_8.effect_string = _local_4;
                        _local_8.type_string = _local_3;
                        _local_8.name_string = _local_6;
                        _local_2.push(_local_8);
                    };
                    _local_8.amount = (_local_8.amount + _local_7);
                };
            };
            if (_arg_1)
            {
                _local_10 = new EffectVO();
                _local_10.effect_string = _local_4;
                _local_10.type_string = _local_3;
                _local_10.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_10.amount = -(this.getResetCosts());
                _local_2.push(_local_10);
            }
            else
            {
                for each (_local_11 in _local_2)
                {
                    _local_11.amount++;
                    _local_11.amount = (_local_11.amount >> 1);
                };
            };
            return (_local_2);
        }

        private function _calculateDependenciesAll():void
        {
            var _local_1:cSkill;
            var _local_2:int;
            if (this._definition.maxPoints <= 0)
            {
                _local_2 = 0;
                for each (_local_1 in _items_vector)
                {
                    _local_2 = (_local_2 + _local_1.getMaxLevel());
                };
                this._definition.maxPoints = _local_2;
            };
            this._sumPoints = 0;
            for each (_local_1 in _items_vector)
            {
                this._sumPoints = (this._sumPoints + _local_1.getLevel());
            };
            for each (_local_1 in _items_vector)
            {
                this._calculateDependencies(_local_1);
            };
        }

        public function resetSkillpointsGUI(_arg_1:Boolean):void
        {
            var _local_3:ResetSkillsVO;
            this.undo();
            var _local_2:Vector.<EffectVO> = this.getResetRewards(_arg_1);
            if (_local_2.length > 0)
            {
                _local_3 = new ResetSkillsVO();
                _local_3.owner = this._owner.getOwnerType();
                _local_3.ownerID = this._owner.getOwnerID();
                _local_3.premium = _arg_1;
                this._gi.SendServerActionSimple(COMMAND.RESET_SKILLPOINTS, _local_3);
            };
            this.waiting = true;
            notifyPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
        }

        public function getSumPoints():int
        {
            return (this._sumPoints);
        }

        public function GetOwner():Skilled
        {
            return (this._owner);
        }

        public function isPointApplyable(_arg_1:int):Boolean
        {
            return ((this._sumPoints + _arg_1) <= this._definition.maxPoints);
        }

        public function resetSkillpoints(_arg_1:ResetSkillsVO):void
        {
            var _local_2:cSkill;
            this._gi.effectFactory.applyAll(_arg_1.returnedResources);
            for each (_local_2 in _items_vector)
            {
                _local_2.removeAllSkillpoints();
            };
            this.waiting = false;
            this.changed();
        }

        public function applyVO(_arg_1:ChangeSkillsVO):ChangeSkillsVO
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_2:Boolean;
            var _local_3:Boolean;
            var _local_4:ChangeSkillsVO = new ChangeSkillsVO();
            _local_4.owner = _arg_1.owner;
            _local_4.ownerID = _arg_1.ownerID;
            do 
            {
                if (_local_3)
                {
                    this._calculateDependenciesAll();
                    _local_3 = false;
                };
                _local_5 = (_arg_1.skills_vector.length - 1);
                while (_local_5 >= 0)
                {
                    _local_6 = _arg_1.skills_vector[_local_5];
                    _local_7 = getItemByID(_local_6.id);
                    if (_local_7 == null)
                    {
                        _arg_1.skills_vector.removeItemAt(_local_5);
                        cLog.error((((("ApplyVO: Couldn't find skill " + _local_6.id) + " for skill tree ") + this._definition.id) + "!"));
                        this._gi.channels.SKILL.send(SKILLLIST_APPLY_FAILED, this);
                    }
                    else
                    {
                        if (_local_7.isLocked())
                        {
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((((("ApplyVO: The skill " + _local_6.id) + " is currently locked for skill tree ") + this._definition.id) + "!"));
                            };
                        }
                        else
                        {
                            _local_8 = (_local_6.level - _local_7.getLevel());
                            if (!this.isPointApplyable(_local_8))
                            {
                                _arg_1.skills_vector.removeItemAt(_local_5);
                                cLog.error(((((("ApplyVO: Skilltree is over the maximum! SkillID: " + _local_6.id) + ", Diff: ") + _local_8) + ", CurrentPoints:") + this._sumPoints));
                                this._gi.channels.SKILL.send(SKILLLIST_APPLY_FAILED, this);
                            }
                            else
                            {
                                if (((_local_7.setSkillPoint(_local_6.level, true)) && (_local_7.apply(true))))
                                {
                                    this._sumPoints = (this._sumPoints + _local_8);
                                    _local_2 = true;
                                    _local_3 = true;
                                    _local_6.level = _local_8;
                                    _local_4.skills_vector.addItem(_local_6);
                                }
                                else
                                {
                                    cLog.error((((((("ApplyVO: Couldn't apply Skillpoint! SkillID: " + _local_6.id) + ", Level: ") + _local_6.level) + ", SkillTree: ") + this._definition.id) + ", Setskillpoint or apply fault?"));
                                    this._gi.channels.SKILL.send(SKILLLIST_APPLY_FAILED, this);
                                };
                                _arg_1.skills_vector.removeItemAt(_local_5);
                            };
                        };
                    };
                    _local_5--;
                };
            } while (_local_3);
            this.waiting = false;
            if (_local_2)
            {
                this.changed();
            };
            return (_local_4);
        }

        public function getSumPointsByType(_arg_1:String):int
        {
            var _local_3:cSkill;
            var _local_2:int;
            for each (_local_3 in _items_vector)
            {
                if (_local_3.getSkillPointType_string() == _arg_1)
                {
                    _local_2 = (_local_2 + _local_3.getOriginalVO().level);
                };
            };
            return (_local_2);
        }

        public function isChanged():Boolean
        {
            var _local_1:cSkill;
            for each (_local_1 in _items_vector)
            {
                if (_local_1.changed())
                {
                    return (true);
                };
            };
            return (false);
        }

        public function undo():void
        {
            var _local_1:cSkill;
            for each (_local_1 in _items_vector)
            {
                this._sumPoints = (this._sumPoints - _local_1.getUnappliedPoints());
                _local_1.undo();
            };
            this._calculateDependenciesAll();
        }

        public function setData(_arg_1:ArrayCollection):void
        {
            super.init(_arg_1, this._owner, this._gi);
            this._calculateDependenciesAll();
        }

        public function getResetCosts():int
        {
            var _local_2:cSkill;
            var _local_1:int;
            for each (_local_2 in _items_vector)
            {
                _local_1 = (_local_1 + _local_2.getResetCost());
            };
            return (_local_1);
        }

        public function IsFullySkilled():Boolean
        {
            return (this._sumPoints == this._definition.maxPoints);
        }

        public function getMaxPoints():int
        {
            return (this._definition.maxPoints);
        }

        private function _calculateDependencies(_arg_1:cSkill):void
        {
            var _local_2:int;
            _local_2 = this.getSumPoints();
            if (((this._gi.mCurrentViewedZoneID <= defines.ADVENTUREZONEID) || ((_arg_1.playerHasMinimumLevel()) && (_local_2 >= _arg_1.getNumPointsAccumulated()))))
            {
                _arg_1.unlock();
            }
            else
            {
                if (_arg_1.getLevel() > 0)
                {
                    cLog.error(((((("Preconditions not fit, but skill is set. :" + _arg_1) + " cause: ") + _arg_1.playerHasMinimumLevel()) + " ") + (_local_2 >= _arg_1.getNumPointsAccumulated())));
                    _arg_1.setSkillPoint(0, true);
                };
                _arg_1.lock();
            };
        }

        private function changed():void
        {
            this.undo();
            notifyPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
        }

        public function applyGUI():void
        {
            var _local_2:cSkill;
            var _local_1:ChangeSkillsVO = new ChangeSkillsVO();
            for each (_local_2 in _items_vector)
            {
                if (_local_2.changed())
                {
                    _local_1.skills_vector.addItem(_local_2.getVO());
                };
            };
            if (_local_1.skills_vector.length > 0)
            {
                _local_1.owner = this._owner.getOwnerType();
                _local_1.ownerID = this._owner.getOwnerID();
                this._gi.SendServerActionSimple(COMMAND.SET_SKILLPOINTS, _local_1);
                this.waiting = true;
                notifyPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
            };
        }

        private function _createItems():void
        {
            var _local_1:SkillDefinition;
            var _local_2:cSkill;
            for each (_local_1 in this._definition.items_vector)
            {
                _local_2 = new cSkill(_local_1, this._owner, this._gi, false, false);
                _local_2.addEventListener(Event.CHANGE, this._onItemChange, false, 0, true);
                _local_2.setSkillTree(this);
                _items_vector.push(_local_2);
            };
        }


    }
}
