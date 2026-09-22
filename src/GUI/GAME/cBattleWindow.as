package GUI.GAME
{
    import flash.utils.Dictionary;
    import Interface.cGameInterface;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import Communication.VO.dSquadVO;
    import GUI.Components.BattleWindow;
    import GUI.Components.ItemRenderer.BattleSlotItemRenderer;
    import Communication.VO.dPlayerListItemVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import nLib.gMisc;
    import flash.events.Event;
    import Communication.VO.Skill.SkillVO;
    import Skill.SkillDefinition;
    import Modifier.ModifierVO;
    import nLib.cXML;
    import Enums.COMBAT_MODIFIER_SIDE;
    import mx.core.UIComponent;
    import MilitarySystem.cMilitaryUnitSkill;
    import Enums.MILLITARY_UNIT_SKILLS;
    import nLib.cLog;
    import MilitarySystem.cMilitaryUnitBase;
    import __AS3__.vec.*;
    import Communication.VO.Skill.*;

    public class cBattleWindow extends cBasicPanel 
    {

        public static var mSlotPreferences:Dictionary = new Dictionary();

        private const NEXT_ROUND:int = 1;
        private const NEXT_PHASE:int = 2;
        private const HIGHLIGHT_ATTACKING_UNIT:int = 7;
        private const DISPLAY_RESULTS:int = 14;
        private const NONE:int = -1;
        private const HIDE_CASUALTIES_HIGHLIGHT:int = 13;
        private const BATTLE_ENDED:int = 15;
        private const NEXT_ATTACK_DEFENDERS:int = 6;
        private const DISPLAY_CASUALTIES:int = 12;
        private const NEXT_ATTACK_ATTACKERS:int = 5;
        private const HIGHLIGHT_DEFENDING_UNIT:int = 8;
        private const ROTATE_INDICATOR_LEFT:int = 3;
        private const ROTATE_INDICATOR_RIGHT:int = 4;
        private const SETUP_BATTLE:int = 0;
        private const MAKE_DAMAGE:int = 11;
        private const REMOVE_HIGHLIGHTS:int = 9;
        private const DEFENDER:int = 1;
        private const DISPLAY_STRIKE:int = 10;
        private const ATTACKER:int = 0;

        private var mReport:XML;
        private var mPhase:int = 0;
        private var mGI:cGameInterface;
        private var mAttack:int = 0;
        private var mRound:int = 0;
        private var mCasualtiesGroup:int = 0;
        private var mNextTickTime:int;
        private var mAttackerAdditionalModifiers:ArrayCollection;
        private var mSquadsDefender:Vector.<dSquadVO>;
        private var mSquadsAttacker:Vector.<dSquadVO>;
        private var mCurrentCasualtiesGroup:XML;
        private var mAttackGroup:int = 0;
        private var mNextTickDuration:int;
        private var mDefenderActiveSkills:ArrayCollection;
        private var mCurrentAttacksGroup:XML;
        private var mDefenderAdditionalModifiers:ArrayCollection;
        private var mAttackerActiveSkills:ArrayCollection;
        private var mCurrentPhase:XML;
        protected var mPanel:BattleWindow;
        private var mCurrentRound:XML;
        private var mCurrentCasualty:XML;
        private var mFirstRotateAnim:Boolean;
        private var mCurrentAttack:XML;
        private var mAvailableSlotsDefender:Vector.<BattleSlotItemRenderer>;
        private var mCasualty:int = 0;
        private var mNextTick:int;
        private var mSlotsDefender:Object;
        private var mAvailableSlotsAttacker:Vector.<BattleSlotItemRenderer>;
        private var mSlotsAttacker:Object;


        public function SetData(_arg_1:String):void
        {
            var _local_3:XML;
            this.Clear();
            this.mReport = new XML(_arg_1);
            this.mPanel.attackerAvatar.data = this.mGI.mCurrentPlayer.GetPlayerListItem();
            this.mPanel.attackerNameLabel.text = this.mGI.mCurrentPlayer.GetPlayerListItem().username;
            var _local_2:dPlayerListItemVO = new dPlayerListItemVO();
            _local_2.id = -1;
            _local_2.avatarId = -1;
            _local_2.username = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Bandit");
            this.mPanel.defenderAvatar.data = _local_2;
            this.mPanel.defenderNameLabel.text = _local_2.username;
            this.InitActiveSkills();
            this.GetAvailableSlots();
            for each (_local_3 in this.mReport.ArmyDescription.Army)
            {
                this.InitArmy(_local_3);
            };
            this.DisplayArmies();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        public function Init(_arg_1:BattleWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel, false, 0, true);
        }

        private function GetNextAttackGroup():Boolean
        {
            var _local_1:XMLList = this.mCurrentPhase.child("Attacks");
            if (((_local_1) && (this.mAttackGroup < _local_1.length())))
            {
                this.mCurrentAttacksGroup = _local_1[this.mAttackGroup];
                this.mAttackGroup++;
                this.mAttack = 0;
                this.mCurrentAttack = null;
                this.DisableNotEngagedUnits();
                return (true);
            };
            return (false);
        }

        private function Clear():void
        {
            this.mPanel.overlayTextPhase.visible = false;
            this.mPanel.overlayTextRound.visible = false;
            this.mPanel.rotationContainer.rotation = 0;
        }

        private function DisplayArmies():void
        {
            var _local_2:int;
            var _local_3:dSquadVO;
            var _local_4:String;
            var _local_5:int;
            var _local_6:int;
            var _local_7:BattleSlotItemRenderer;
            var _local_1:Vector.<dSquadVO> = new Vector.<dSquadVO>();
            _local_2 = this.mPanel.attackerAvatar.GetColorIndex();
            for each (_local_3 in this.mSquadsAttacker)
            {
                _local_4 = ("attacker" + this.GetPrefferedSlotName(_local_3.GetType()));
                _local_5 = -1;
                _local_6 = 0;
                while (_local_6 < this.mAvailableSlotsAttacker.length)
                {
                    if (this.mAvailableSlotsAttacker[_local_6].id == _local_4)
                    {
                        _local_5 = _local_6;
                        break;
                    };
                    _local_6++;
                };
                if (_local_5 > -1)
                {
                    this.mAvailableSlotsAttacker[_local_5].SetSquad(_local_3, _local_2, this.mAttackerActiveSkills, this.mAttackerAdditionalModifiers);
                    this.mSlotsAttacker[_local_3.GetType()] = this.mAvailableSlotsAttacker[_local_5];
                    this.mAvailableSlotsAttacker.splice(_local_5, 1);
                }
                else
                {
                    _local_1.push(_local_3);
                };
            };
            for each (_local_3 in _local_1)
            {
                _local_7 = this.mAvailableSlotsAttacker.shift();
                if (_local_7 == null) break;
                _local_7.SetSquad(_local_3, _local_2, this.mAttackerActiveSkills, this.mAttackerAdditionalModifiers);
                this.mSlotsAttacker[_local_3.GetType()] = _local_7;
            };
            _local_1 = new Vector.<dSquadVO>();
            _local_2 = this.mPanel.defenderAvatar.GetColorIndex();
            for each (_local_3 in this.mSquadsDefender)
            {
                _local_4 = ("defender" + this.GetPrefferedSlotName(_local_3.GetType()));
                _local_5 = -1;
                _local_6 = 0;
                while (_local_6 < this.mAvailableSlotsDefender.length)
                {
                    if (this.mAvailableSlotsDefender[_local_6].id == _local_4)
                    {
                        _local_5 = _local_6;
                        break;
                    };
                    _local_6++;
                };
                if (_local_5 > -1)
                {
                    this.mAvailableSlotsDefender[_local_5].SetSquad(_local_3, _local_2, this.mDefenderActiveSkills, this.mDefenderAdditionalModifiers);
                    this.mAvailableSlotsDefender[_local_5].disabled = true;
                    this.mSlotsDefender[_local_3.GetType()] = this.mAvailableSlotsDefender[_local_5];
                    this.mAvailableSlotsDefender.splice(_local_5, 1);
                }
                else
                {
                    _local_1.push(_local_3);
                };
            };
            for each (_local_3 in _local_1)
            {
                _local_7 = this.mAvailableSlotsDefender.shift();
                if (_local_7 == null) break;
                _local_7.SetSquad(_local_3, _local_2, this.mDefenderActiveSkills, this.mDefenderAdditionalModifiers);
                this.mSlotsDefender[_local_3.GetType()] = _local_7;
            };
            this.SetNextTick(this.SETUP_BATTLE);
            this.ResetBattle();
            this.StartPlayback();
        }

        private function Perform(_arg_1:Event):void
        {
            if (gMisc.GetTimeSinceStartup() >= this.mNextTickTime)
            {
                this.PerformBattleTick();
            };
        }

        private function InitActiveSkills():void
        {
            var _local_1:XML;
            var _local_2:SkillVO;
            var _local_3:SkillDefinition;
            var _local_4:ModifierVO;
            var _local_5:XML;
            var _local_6:ModifierVO;
            this.mAttackerActiveSkills = new ArrayCollection();
            this.mDefenderActiveSkills = new ArrayCollection();
            if (this.mReport.Skills[0] != null)
            {
                for each (_local_1 in this.mReport.Skills[0].SkillVO)
                {
                    if (_local_1.attribute("isUsed") != "false")
                    {
                        _local_2 = new SkillVO();
                        _local_2.id = parseInt(_local_1.attribute("id"));
                        _local_2.level = parseInt(_local_1.attribute("level"));
                        for each (_local_3 in global.skills_vector)
                        {
                            if (((!(_local_3 == null)) && (_local_2.id == _local_3.id)))
                            {
                                for each (_local_4 in _local_3.level_vector[(_local_2.level - 1)])
                                {
                                    if (((_local_4.modifier_string == "CombatModifier") && (_local_4.name_string == "Enemy")))
                                    {
                                        this.mDefenderActiveSkills.addItem(_local_2);
                                    };
                                    if (((_local_4.modifier_string == "CombatModifier") && (_local_4.name_string == "Player")))
                                    {
                                        this.mAttackerActiveSkills.addItem(_local_2);
                                    };
                                    break;
                                };
                                break;
                            };
                        };
                    };
                };
            };
            this.mAttackerAdditionalModifiers = new ArrayCollection();
            this.mDefenderAdditionalModifiers = new ArrayCollection();
            if (this.mReport.CombatModifiers[0] != null)
            {
                for each (_local_5 in this.mReport.CombatModifiers.children())
                {
                    if (String(_local_5.name()) == "ModifierVO")
                    {
                        _local_5.@modifier = _local_5.@modifier_string;
                        _local_5.@id = _local_5.@id_data;
                        _local_5.@type = _local_5.@type_string;
                        _local_5.@item = _local_5.@item_string;
                        _local_5.@name = _local_5.@name_string;
                    };
                    _local_6 = ModifierVO.CreateFromXML(cXML.fromE4X(_local_5));
                    if (_local_6.name_string == COMBAT_MODIFIER_SIDE.ENEMY_string)
                    {
                        this.mDefenderAdditionalModifiers.addItem(_local_6);
                    }
                    else
                    {
                        this.mAttackerAdditionalModifiers.addItem(_local_6);
                    };
                };
            };
        }

        private function StopPlayback():void
        {
            this.mPanel.removeEventListener(Event.ENTER_FRAME, this.Perform);
        }

        private function GetPrefferedSlotName(_arg_1:String):String
        {
            var _local_2:int = mSlotPreferences[_arg_1];
            return ("Slot" + ((_local_2 < 10) ? ("0" + _local_2) : _local_2.toString()));
        }

        private function StartPlayback():void
        {
            this.mPanel.addEventListener(Event.ENTER_FRAME, this.Perform, false, 0, true);
        }

        private function GetNextCasualty():Boolean
        {
            if (!this.mCasualtiesGroup)
            {
                return (false);
            };
            var _local_1:XMLList = this.mCurrentCasualtiesGroup.child("Casualty");
            if (((_local_1) && (this.mCasualty < _local_1.length())))
            {
                this.mCurrentCasualty = _local_1[this.mCasualty];
                this.mCasualty++;
                return (true);
            };
            return ((this.GetNextCasualtiesGroup()) && (this.GetNextCasualty()));
        }

        private function PerformBattleTick():void
        {
            var _local_1:BattleSlotItemRenderer;
            var _local_2:int;
            this.mNextTickTime = (this.mNextTickTime + this.mNextTickDuration);
            switch (this.mNextTick)
            {
                case this.SETUP_BATTLE:
                    this.SetNextTick(this.NEXT_ROUND);
                    return;
                case this.NEXT_ROUND:
                    if (this.GetNextRound())
                    {
                        this.SetNextTick(this.NEXT_PHASE);
                    }
                    else
                    {
                        this.SetNextTick(this.DISPLAY_RESULTS);
                    };
                    return;
                case this.NEXT_PHASE:
                    if (this.mPanel.overlayTextRound.visible)
                    {
                        this.mPanel.overlayTextRound.visible = false;
                    };
                    if (this.GetNextPhase())
                    {
                        if ((((this.mCurrentPhase.@initiative == 1) && (this.mCurrentAttacksGroup.@group == "Attackers")) && (this.mCurrentAttacksGroup.child("Attack").length() == 0)))
                        {
                            this.SetNextTick(this.ROTATE_INDICATOR_LEFT);
                        }
                        else
                        {
                            this.SetNextTick(this.ROTATE_INDICATOR_RIGHT);
                        };
                    }
                    else
                    {
                        this.SetNextTick(this.NEXT_ROUND);
                    };
                    return;
                case this.ROTATE_INDICATOR_LEFT:
                    this.mPanel.rotateToAttacker.play();
                    this.SetNextTick(this.HIGHLIGHT_ATTACKING_UNIT);
                    return;
                case this.ROTATE_INDICATOR_RIGHT:
                    if (this.mPanel.overlayTextPhase.visible)
                    {
                        this.mPanel.overlayTextPhase.visible = false;
                    };
                    if (this.mFirstRotateAnim)
                    {
                        this.mPanel.rotateToDefenderFirst.play();
                        this.mFirstRotateAnim = false;
                    }
                    else
                    {
                        this.mPanel.rotateToDefender.play();
                    };
                    this.SetNextTick(this.HIGHLIGHT_ATTACKING_UNIT);
                    return;
                case this.HIGHLIGHT_ATTACKING_UNIT:
                    if (this.GetNextAttack())
                    {
                        if (this.mCurrentAttacksGroup.@group == "Attackers")
                        {
                            this.mSlotsAttacker[this.mCurrentAttack.@attackingUnitType].highlightAttacker = true;
                        }
                        else
                        {
                            if (this.mCurrentAttacksGroup.@group == "Defenders")
                            {
                                this.mSlotsDefender[this.mCurrentAttack.@attackingUnitType].highlightAttacker = true;
                            };
                        };
                        this.SetNextTick(this.HIGHLIGHT_DEFENDING_UNIT);
                    }
                    else
                    {
                        this.SetNextTick(this.DISPLAY_CASUALTIES);
                    };
                    return;
                case this.HIGHLIGHT_DEFENDING_UNIT:
                    if (this.mCurrentAttacksGroup.@group == "Attackers")
                    {
                        this.mSlotsDefender[this.mCurrentAttack.@defendingUnitType].highlightDefender = true;
                    }
                    else
                    {
                        if (this.mCurrentAttacksGroup.@group == "Defenders")
                        {
                            this.mSlotsAttacker[this.mCurrentAttack.@defendingUnitType].highlightDefender = true;
                        };
                    };
                    this.SetNextTick(this.DISPLAY_STRIKE);
                    return;
                case this.DISPLAY_STRIKE:
                    if (this.mCurrentAttacksGroup.@group == "Attackers")
                    {
                        _local_1 = this.mSlotsDefender[this.mCurrentAttack.@defendingUnitType];
                    }
                    else
                    {
                        if (this.mCurrentAttacksGroup.@group == "Defenders")
                        {
                            _local_1 = this.mSlotsAttacker[this.mCurrentAttack.@defendingUnitType];
                        };
                    };
                    this.mPanel.attackAnimation.x = ((_local_1.parent.x + _local_1.x) - 20);
                    this.mPanel.attackAnimation.y = ((_local_1.parent.y + _local_1.y) - 40);
                    this.mPanel.attackAnimation.visible = true;
                    this.SetNextTick(this.MAKE_DAMAGE);
                    return;
                case this.MAKE_DAMAGE:
                    _local_1 = null;
                    if (this.mCurrentAttacksGroup.@group == "Attackers")
                    {
                        _local_1 = this.mSlotsDefender[this.mCurrentAttack.@defendingUnitType];
                    }
                    else
                    {
                        if (this.mCurrentAttacksGroup.@group == "Defenders")
                        {
                            _local_1 = this.mSlotsAttacker[this.mCurrentAttack.@defendingUnitType];
                        };
                    };
                    _local_1.MakeDamage(this.mCurrentAttack.@damage);
                    this.SetNextTick(this.REMOVE_HIGHLIGHTS);
                    return;
                case this.REMOVE_HIGHLIGHTS:
                    if (this.mCurrentAttacksGroup.@group == "Attackers")
                    {
                        this.mSlotsAttacker[this.mCurrentAttack.@attackingUnitType].highlightAttacker = false;
                        this.mSlotsDefender[this.mCurrentAttack.@defendingUnitType].highlightDefender = false;
                    }
                    else
                    {
                        if (this.mCurrentAttacksGroup.@group == "Defenders")
                        {
                            this.mSlotsAttacker[this.mCurrentAttack.@defendingUnitType].highlightDefender = false;
                            this.mSlotsDefender[this.mCurrentAttack.@attackingUnitType].highlightAttacker = false;
                        };
                    };
                    if (((this.mAttack == this.mCurrentAttacksGroup.child("Attack").length()) && (this.mCurrentAttacksGroup.@group == "Attackers")))
                    {
                        this.SetNextTick(this.ROTATE_INDICATOR_LEFT);
                    }
                    else
                    {
                        this.SetNextTick(this.HIGHLIGHT_ATTACKING_UNIT);
                    };
                    return;
                case this.DISPLAY_CASUALTIES:
                    _local_2 = 0;
                    while (this.GetNextCasualty())
                    {
                        _local_2++;
                        if (this.mCurrentCasualtiesGroup.@group == "Attackers")
                        {
                            _local_1 = this.mSlotsAttacker[this.mCurrentCasualty.@unitType];
                        }
                        else
                        {
                            if (this.mCurrentCasualtiesGroup.@group == "Defenders")
                            {
                                _local_1 = this.mSlotsDefender[this.mCurrentCasualty.@unitType];
                            };
                        };
                        _local_1.DisplayCasualties(this.mCurrentCasualty.@dead, this.mCurrentCasualty.@totalHealth);
                        _local_1.damageHighlight = true;
                    };
                    if (_local_2 > 0)
                    {
                        this.SetNextTick(this.HIDE_CASUALTIES_HIGHLIGHT);
                    }
                    else
                    {
                        this.SetNextTick(this.NEXT_PHASE);
                    };
                    return;
                case this.HIDE_CASUALTIES_HIGHLIGHT:
                    this.mCasualtiesGroup = 0;
                    this.mCasualty = 0;
                    this.GetNextCasualtiesGroup();
                    while (this.GetNextCasualty())
                    {
                        if (this.mCurrentCasualtiesGroup.@group == "Attackers")
                        {
                            _local_1 = this.mSlotsAttacker[this.mCurrentCasualty.@unitType];
                        }
                        else
                        {
                            if (this.mCurrentCasualtiesGroup.@group == "Defenders")
                            {
                                _local_1 = this.mSlotsDefender[this.mCurrentCasualty.@unitType];
                            };
                        };
                        _local_1.damageHighlight = false;
                    };
                    this.SetNextTick(this.NEXT_PHASE);
                    return;
                case this.DISPLAY_RESULTS:
                    if (((!(this.mReport.@resultMsg == null)) && (!(this.mReport.@resultMsg.toString() == ""))))
                    {
                        this.mPanel.overlayTextPhase.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, this.mReport.@resultMsg);
                        this.mPanel.overlayTextPhase.visible = true;
                    };
                    this.SetNextTick(this.BATTLE_ENDED);
                    return;
                case this.BATTLE_ENDED:
                    this.mPanel.overlayTextPhase.visible = false;
                    this.StopPlayback();
                    this.SetNextTick(this.NONE);
                    return;
            };
        }

        private function DisableNotEngagedUnits():void
        {
            var _local_2:XML;
            var _local_3:String;
            var _local_1:Vector.<String> = new Vector.<String>();
            if (this.mCurrentAttacksGroup.@group == "Attackers")
            {
                for each (_local_2 in this.mCurrentAttacksGroup.child("Attack"))
                {
                    _local_1.push(_local_2.@attackingUnitType);
                };
                for (_local_3 in this.mSlotsAttacker)
                {
                    (this.mSlotsAttacker[_local_3] as BattleSlotItemRenderer).disabled = (_local_1.indexOf(_local_3) == -1);
                };
                for (_local_3 in this.mSlotsDefender)
                {
                    (this.mSlotsDefender[_local_3] as BattleSlotItemRenderer).disabled = false;
                };
            }
            else
            {
                if (this.mCurrentAttacksGroup.@group == "Defenders")
                {
                    for each (_local_2 in this.mCurrentAttacksGroup.child("Attack"))
                    {
                        _local_1.push(_local_2.@attackingUnitType);
                    };
                    for (_local_3 in this.mSlotsDefender)
                    {
                        (this.mSlotsDefender[_local_3] as BattleSlotItemRenderer).disabled = (_local_1.indexOf(_local_3) == -1);
                    };
                    for (_local_3 in this.mSlotsAttacker)
                    {
                        (this.mSlotsAttacker[_local_3] as BattleSlotItemRenderer).disabled = false;
                    };
                };
            };
        }

        private function SetNextTick(_arg_1:int):void
        {
            this.mNextTick = _arg_1;
            switch (this.mNextTick)
            {
                case this.SETUP_BATTLE:
                    this.mNextTickTime = gMisc.GetTimeSinceStartup();
                    this.mNextTickDuration = 2000;
                    this.mFirstRotateAnim = true;
                    return;
                case this.HIGHLIGHT_ATTACKING_UNIT:
                case this.HIGHLIGHT_DEFENDING_UNIT:
                    this.mNextTickDuration = 300;
                    return;
                case this.DISPLAY_STRIKE:
                    this.mNextTickDuration = 1000;
                    return;
                case this.DISPLAY_CASUALTIES:
                    this.mNextTickDuration = 2000;
                    return;
                case this.NEXT_ROUND:
                case this.NEXT_PHASE:
                    this.mNextTickDuration = 2000;
                    return;
                case this.DISPLAY_RESULTS:
                    this.mNextTickDuration = 3500;
                    return;
                case this.ROTATE_INDICATOR_LEFT:
                case this.ROTATE_INDICATOR_RIGHT:
                    this.mNextTickDuration = 2000;
                    return;
                case this.NEXT_ATTACK_ATTACKERS:
                case this.NEXT_ATTACK_DEFENDERS:
                case this.REMOVE_HIGHLIGHTS:
                case this.DISPLAY_RESULTS:
                case this.HIDE_CASUALTIES_HIGHLIGHT:
                default:
                    this.mNextTickDuration = 200;
            };
        }

        override protected function HideWithoutQueue():void
        {
            this.StopPlayback();
            super.HideWithoutQueue();
        }

        private function GetNextPhase():Boolean
        {
            var _local_1:XMLList = this.mCurrentRound.child("Phase");
            if (((_local_1) && (this.mPhase < _local_1.length())))
            {
                this.mCurrentPhase = _local_1[this.mPhase];
                this.mPanel.phaseLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("BattlePhaseInitiative" + this.mCurrentPhase.@initiative));
                this.mPanel.overlayTextPhase.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("BattlePhaseInitiative" + this.mCurrentPhase.@initiative));
                this.mPanel.overlayTextPhase.visible = true;
                this.mAttackGroup = 0;
                this.mCurrentAttacksGroup = null;
                this.mCasualtiesGroup = 0;
                this.mCurrentCasualtiesGroup = null;
                this.mPhase++;
                this.GetNextAttackGroup();
                this.GetNextCasualtiesGroup();
                return (true);
            };
            return (false);
        }

        private function GetNextRound():Boolean
        {
            var _local_1:XMLList = this.mReport.child("Round");
            if (((_local_1) && (this.mRound < _local_1.length())))
            {
                this.mCurrentRound = _local_1[this.mRound];
                this.mPanel.roundLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BattleRound", [(this.mRound + 1).toString()]);
                this.mPanel.overlayTextRound.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BattleRound", [(this.mRound + 1).toString()]);
                this.mPanel.overlayTextRound.visible = true;
                this.mPanel.phaseLabel.text = "";
                this.mPhase = 0;
                this.mCurrentPhase = null;
                this.mRound++;
                return (true);
            };
            return (false);
        }

        private function ResetBattle():void
        {
            this.mRound = 0;
            this.mPhase = 0;
            this.mAttackGroup = 0;
            this.mAttack = 0;
            this.mCasualtiesGroup = 0;
            this.mCasualty = 0;
            this.mPanel.roundLabel.text = "";
            this.mPanel.phaseLabel.text = "";
        }

        private function GetAvailableSlots():void
        {
            var _local_1:UIComponent;
            this.mAvailableSlotsAttacker = new Vector.<BattleSlotItemRenderer>();
            this.mAvailableSlotsDefender = new Vector.<BattleSlotItemRenderer>();
            this.mSlotsAttacker = new Object();
            this.mSlotsDefender = new Object();
            this.mSquadsAttacker = new Vector.<dSquadVO>();
            this.mSquadsDefender = new Vector.<dSquadVO>();
            for each (_local_1 in this.mPanel.attackerHolder.getChildren())
            {
                if ((_local_1 is BattleSlotItemRenderer))
                {
                    (_local_1 as BattleSlotItemRenderer).Clear();
                    this.mAvailableSlotsAttacker.push(_local_1);
                };
            };
            for each (_local_1 in this.mPanel.defenderHolder.getChildren())
            {
                if ((_local_1 is BattleSlotItemRenderer))
                {
                    (_local_1 as BattleSlotItemRenderer).Clear();
                    this.mAvailableSlotsDefender.push(_local_1);
                };
            };
        }

        private function GetNextCasualtiesGroup():Boolean
        {
            var _local_1:XMLList = this.mCurrentPhase.child("Casualties");
            if (((_local_1) && (this.mCasualtiesGroup < _local_1.length())))
            {
                this.mCurrentCasualtiesGroup = _local_1[this.mCasualtiesGroup];
                this.mCasualtiesGroup++;
                this.mCurrentCasualty = null;
                this.mCasualty = 0;
                return (true);
            };
            return (false);
        }

        private function ArmyHasFirstStrikeUnits(_arg_1:Vector.<dSquadVO>):Boolean
        {
            var _local_2:dSquadVO;
            var _local_3:cMilitaryUnitSkill;
            for each (_local_2 in _arg_1)
            {
                for each (_local_3 in _local_2.GetUnitDescription().GetSkills())
                {
                    if (_local_3.GetType() == MILLITARY_UNIT_SKILLS.FIRST_STRIKE)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        private function InitArmy(_arg_1:XML):void
        {
            var _local_3:XML;
            var _local_4:dSquadVO;
            var _local_2:Vector.<dSquadVO> = new Vector.<dSquadVO>();
            if (_arg_1.@group == "Attackers")
            {
                this.mSquadsAttacker = _local_2;
            }
            else
            {
                if (_arg_1.@group == "Defenders")
                {
                    this.mSquadsDefender = _local_2;
                }
                else
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Could not interpret army group: " + _arg_1.@group));
                    };
                    return;
                };
            };
            for each (_local_3 in _arg_1.Squad)
            {
                _local_4 = new dSquadVO().init(_local_3.@unitType, _local_3.@amount, cMilitaryUnitBase.GetHitPointsForUnit(_local_3.@unitType));
                _local_4.mTotalHealth = _local_3.@totalHealth;
                _local_2.push(_local_4);
            };
        }

        private function GetNextAttack():Boolean
        {
            if (!this.mCurrentAttacksGroup)
            {
                return (false);
            };
            var _local_1:XMLList = this.mCurrentAttacksGroup.child("Attack");
            if (((_local_1) && (this.mAttack < _local_1.length())))
            {
                this.mCurrentAttack = _local_1[this.mAttack];
                this.mAttack++;
                return (true);
            };
            return ((this.GetNextAttackGroup()) && (this.GetNextAttack()));
        }


    }
}
