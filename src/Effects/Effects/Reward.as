package Effects.Effects
{
    import Effects.Effect;
    import Interface.RenderableItem;
    import ServerState.dResource;
    import Enums.AVATAR_MESSAGE_TYPE;
    import ServerState.cPlayerData;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuff;
    import ServerState.cResources;
    import Tracks.TrackManager;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import GUI.Components.Frame;
    import Utils.StringUtils;
    import GUI.Assets.gAssetManager;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.dUniqueID;
    import Enums.ModifyReason;
    import Enums.SPECIALIST_TYPE;
    import XpConversion.ConvertedXp;
    import XpConversion.XpConversionCalculator;

    public final class Reward extends Effect implements RenderableItem 
    {

        public static const XML_string:String = "reward";

        public var result:Object;


        public function getResourceGFXName():String
        {
            return (effect.name_string);
        }

        public function tryIntantApply(_arg_1:cPlayerData, _arg_2:int):Boolean
        {
            if (this.isDummy())
            {
                return (true);
            };
            var _local_3:int = effect.amount;
            var _local_4:dResource = gi.mCurrentPlayerZone.GetResources(_arg_1).GetPlayerResource(effect.name_string);
            var _local_5:int = Math.min((_local_4.maxLimit - _local_4.amount), effect.amount);
            if (((_local_5 > 0) && (gi.mCurrentPlayerZone.GetResources(_arg_1).AddResource(effect.name_string, _local_5, _arg_2, null))))
            {
                effect.amount = (effect.amount - _local_5);
            };
            if (effect.amount == 0)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF, [effect.name_string, _local_3]);
                return (true);
            };
            return (false);
        }

        public function getRenderAmount():int
        {
            return (effect.amount);
        }

        public function getRenderGFXBackgroundName():String
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "resource")
            {
                return ("AddResource");
            };
            if (((_local_1 == "xp") || (_local_1 == "pvpXp")))
            {
                return (null);
            };
            if (_local_1 == "specialist")
            {
                return (null);
            };
            if (_local_1 == "military")
            {
                return (null);
            };
            if (_local_1 == "buff")
            {
                return (null);
            };
            if (_local_1 == "adventure")
            {
                return (null);
            };
            if (_local_1 == "loottable")
            {
                return (null);
            };
            return (null);
        }

        public function isRequiresResourceIcon():Boolean
        {
            return (effect.item_string == defines.FILL_DEPOSIT_BUFF);
        }

        private function addResource(_arg_1:cPlayerData, _arg_2:EffectVO, _arg_3:int):void
        {
            var _local_7:int;
            var _local_8:dBuffVO;
            var _local_9:cBuff;
            var _local_10:int;
            if (this.isDummy())
            {
                return;
            };
            var _local_4:cResources = gi.mCurrentPlayerZone.GetResources(_arg_1);
            var _local_5:dResource = _local_4.GetPlayerResource(_arg_2.name_string);
            var _local_6:int = (_local_5.maxLimit - _local_5.amount);
            if (_arg_2.amount <= _local_6)
            {
                _local_7 = _arg_2.amount;
            }
            else
            {
                _local_7 = _local_6;
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.QUEST_REWARD_LIMIT_REACHED, new dResource().Init(_arg_2.name_string, _arg_2.amount));
                _local_8 = new dBuffVO();
                _local_8.buffName_string = "AddResource";
                _local_8.amount = (_arg_2.amount - _local_7);
                _local_8.resourceName_string = _arg_2.name_string;
                _local_8.uniqueId1 = _arg_2.uniqueID.uniqueID1;
                _local_8.uniqueId2 = _arg_2.uniqueID.uniqueID2;
                _local_9 = cBuff.CreateBuffFromVO(_local_8);
                _arg_1.addBuff(_local_9);
            };
            _local_4.AddResource(_arg_2.name_string, _local_7, _arg_3, null);
            if (_arg_2.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
            {
                _local_10 = _local_4.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                TrackManager.getInstance().trackGemQuestRewarded(_arg_1, "RewardEffect", _arg_2.amount, _local_10, _arg_2.source);
            };
        }

        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        public function getRenderFrameType():String
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "resource")
            {
                return ("buffInstant");
            };
            if (((_local_1 == "xp") || (_local_1 == "pvpXp")))
            {
                return ("buffInstant");
            };
            if (_local_1 == "specialist")
            {
                return ("specialist");
            };
            if (_local_1 == "military")
            {
                return ("buffInstant");
            };
            if (_local_1 == "buff")
            {
                return ("buffInstant");
            };
            if (_local_1 == "adventure")
            {
                return ("buffInstant");
            };
            if (_local_1 == "loottable")
            {
                return ("buffInstant");
            };
            if (this.isDummy())
            {
                return (Frame.DUMMY_REWARD);
            };
            return (null);
        }

        public function getRenderTooltip():String
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "resource")
            {
                return ("AddResource");
            };
            if (((_local_1 == "xp") || (_local_1 == "pvpXp")))
            {
                return ("AddResource");
            };
            if (_local_1 == "specialist")
            {
                return (effect.name_string);
            };
            if (_local_1 == "military")
            {
                return (effect.name_string);
            };
            if (_local_1 == "buff")
            {
                if (((effect.item_string.length > 0) && (effect.item_string.toLowerCase().indexOf("changecolorscheme") == 0)))
                {
                    return ((effect.item_string + "_") + effect.name_string);
                };
                if (((effect.name_string.length > 0) && (!(effect.item_string.toLowerCase().indexOf("loottable_") == 0))))
                {
                    return (effect.name_string);
                };
                return (effect.item_string);
            };
            if (_local_1 == "adventure")
            {
                return (effect.name_string);
            };
            if (_local_1 == "loottable")
            {
                return ("");
            };
            if (((this.isDummy()) && (!(effect.name_string == null))))
            {
                return (effect.name_string);
            };
            return (null);
        }

        private function addPvpXp(_arg_1:cPlayerData, _arg_2:EffectVO):void
        {
            _arg_1.AddPvPXp(_arg_2.amount);
        }

        public function isDummy():Boolean
        {
            return (StringUtils.equalsIgnoreCase(effect.type_string, "Dummy"));
        }

        public function getRenderGFXIcon():Object
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "resource")
            {
                return (gAssetManager.GetResourceIcon(effect.name_string));
            };
            if (((_local_1 == "xp") || (_local_1 == "pvpXp")))
            {
                return (gAssetManager.GetResourceIcon(effect.name_string));
            };
            if (_local_1 == "specialist")
            {
                return (gAssetManager.GetSpecialistIcon(effect.name_string));
            };
            if (_local_1 == "military")
            {
                return (gAssetManager.GetResourceIcon(effect.name_string));
            };
            if (_local_1 == "buff")
            {
                if (((effect.item_string.length > 0) && (effect.item_string == "ChangeColorScheme")))
                {
                    return (gAssetManager.GetBuffIcon(((effect.item_string + "_") + effect.name_string)));
                };
                return (gAssetManager.GetBuffIcon(this.getBuffName()));
            };
            if (_local_1 == "adventure")
            {
                return (gAssetManager.GetBitmap(effect.name_string));
            };
            if (_local_1 == "loottable")
            {
                return (null);
            };
            if (this.isDummy())
            {
                return (gAssetManager.GetBitmap(effect.item_string));
            };
            return (null);
        }

        override protected function action():void
        {
            var _local_3:int;
            var _local_4:dBuffVO;
            var _local_5:cBuffDefinition;
            var _local_6:cBuff;
            var _local_7:int;
            var _local_8:dUniqueID;
            var _local_9:cBuff;
            var _local_10:cBuffDefinition;
            var _local_11:cBuff;
            if (this.isDummy())
            {
                return;
            };
            var _local_1:cPlayerData;
            if (effect.playerId > 0)
            {
                _local_1 = gi.FindPlayerFromId(effect.playerId);
            }
            else
            {
                _local_1 = gi.mCurrentPlayer;
            };
            var _local_2:String = effect.type_string.toLowerCase();
            if (_local_2 == "resource")
            {
                this.addResource(_local_1, this.effect, ModifyReason.REWARD);
            }
            else
            {
                if (_local_2 == "xp")
                {
                    this.addXp(_local_1, this.effect);
                }
                else
                {
                    if (_local_2 == defines.PVP_XP_string.toLowerCase())
                    {
                        this.addPvpXp(_local_1, this.effect);
                    }
                    else
                    {
                        if (_local_2 == "specialist")
                        {
                            _local_3 = SPECIALIST_TYPE.parse(effect.name_string);
                            gi.BuySpecialistDirect(_local_1, _local_3, effect.uniqueID, false);
                        }
                        else
                        {
                            if (_local_2 != "military")
                            {
                                if (_local_2 == "buff")
                                {
                                    _local_4 = new dBuffVO();
                                    _local_4.buffName_string = effect.item_string;
                                    _local_5 = cBuffDefinition.GetByName(effect.item_string);
                                    _local_4.amount = ((effect.amount > 0) ? effect.amount : 1);
                                    _local_4.resourceName_string = ((effect.name_string != null) ? effect.name_string : "");
                                    _local_4.recurringChance = effect.chance;
                                    _local_4.uniqueId1 = effect.uniqueID.uniqueID1;
                                    _local_4.uniqueId2 = effect.uniqueID.uniqueID2;
                                    _local_6 = cBuff.CreateBuffFromVO(_local_4);
                                    _local_1.addBuff(_local_6);
                                    this.result = _local_6;
                                    if (effect.givesMultipleBuffs)
                                    {
                                        _local_7 = 1;
                                        while (_local_7 < effect.amount)
                                        {
                                            _local_8 = effect.additionalUniqueIds_vector[(_local_7 - 1)];
                                            _local_4.uniqueId1 = _local_8.uniqueID1;
                                            _local_4.uniqueId2 = _local_8.uniqueID2;
                                            _local_9 = cBuff.CreateBuffFromVO(_local_4);
                                            _local_1.addBuff(_local_9);
                                            _local_7++;
                                        };
                                    };
                                }
                                else
                                {
                                    if (_local_2 == "adventure")
                                    {
                                        _local_10 = cBuffDefinition.GetByName("Adventure");
                                        _local_11 = new cBuff(_local_10, effect.uniqueID, 1);
                                        _local_11.SetResourceName(effect.name_string);
                                        _local_1.addBuff(_local_11);
                                        this.result = _local_11;
                                    }
                                    else
                                    {
                                        if (_local_2 != "loottable")
                                        {
                                            if (_local_2 == "collectionpart")
                                            {
                                                gi.mContentGeneratorManager.AddPartsWithName(effect.name_string, effect.amount);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function getRenderTooltipType():String
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "resource")
            {
                return ("Buff");
            };
            if (((_local_1 == "xp") || (_local_1 == "pvpXp")))
            {
                return ("Simple");
            };
            if (_local_1 == "specialist")
            {
                return ("Specialist");
            };
            if (_local_1 == "military")
            {
                return ("Buff");
            };
            if (_local_1 == "buff")
            {
                return ("Buff");
            };
            if (_local_1 == "adventure")
            {
                return ("Adventure");
            };
            if (_local_1 == "loottable")
            {
                return (null);
            };
            if (((this.isDummy()) && (!(effect.name_string == null))))
            {
                return ("Simple");
            };
            return (null);
        }

        private function addXp(_arg_1:cPlayerData, _arg_2:EffectVO):void
        {
            var _local_5:EffectVO;
            var _local_6:ConvertedXp;
            var _local_3:int = _arg_2.amount;
            if (_arg_2.name_string == "formula")
            {
                _local_3 = int(((global.playerLevelRewardXPs_vector[_arg_1.GetPlayerLevel()] * _local_3) / 100));
            };
            var _local_4:int = _arg_1.AddXP(_local_3);
            if (_local_4 > 0)
            {
                _local_5 = new EffectVO();
                _local_6 = XpConversionCalculator.convertXp(_local_4);
                _local_5.name_string = _local_6.resourceName;
                _local_5.amount = _local_6.amount;
                _local_5.uniqueID = _arg_2.uniqueID;
                this.addResource(_arg_1, _local_5, ModifyReason.ADD_XP);
            };
        }

        public function getBuffName():String
        {
            if ((((!(StringUtils.isNullOrEmpty(effect.name_string))) && (!(effect.item_string == defines.FILL_DEPOSIT_BUFF))) && (!(effect.item_string.toLowerCase().indexOf("loottable_") == 0))))
            {
                return (effect.name_string);
            };
            return (effect.item_string);
        }


    }
}
