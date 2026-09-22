package Effects
{
    import flash.utils.Dictionary;
    import Interface.cGameInterface;
    import Effects.Effects.Reward;
    import Effects.Effects.SendMail;
    import Effects.Effects.ShowHint;
    import Effects.Effects.OpenWindow;
    import Effects.Effects.CloseWindow;
    import Effects.Effects.Frontend.CloseCurrentWindow;
    import Effects.Effects.StartQuest;
    import Effects.Effects.ControlShopItem;
    import Effects.Effects.FulfillCondition;
    import Effects.Effects.ApplyFilter;
    import Effects.Effects.RefillDeposit;
    import Effects.Effects.SkillDeposit;
    import Effects.Effects.ResetQuest;
    import Effects.Effects.CancelQuest;
    import Effects.Effects.ChangeSkin;
    import Effects.Effects.ChangeLoopMusic;
    import Effects.Effects.ChangeDefaultSkin;
    import Effects.Effects.MoveCamera;
    import Effects.Effects.SpawnBuilding;
    import Effects.Effects.EventCounter;
    import Effects.Effects.RemoveBuilding;
    import Effects.Effects.ChangeAvatar;
    import Effects.Effects.AvatarMessage;
    import Effects.Effects.SkillSpecialist;
    import Effects.Effects.SkillPlayer;
    import Effects.Effects.RemoveSpecialistSkill;
    import Effects.Effects.FinishQuest;
    import Effects.Effects.RemovePlayerSkill;
    import Effects.Effects.RemoveBuff;
    import Effects.Effects.SpawnCollectibles;
    import Effects.Effects.DeletePlayerBuffs;
    import Effects.Effects.CleanUpQuest;
    import Effects.Effects.ApplyZoneBuff;
    import Effects.Effects.CancelZoneBuff;
    import Effects.Effects.GiveCollectibleResource;
    import Effects.Effects.UpgradeEpicWorkyardChain;
    import Effects.Effects.AdjustGenericValue;
    import Effects.Effects.ShuffleCollectibles;
    import Effects.Effects.HireMilitary;
    import Effects.Effects.ResetProductionModifiers;
    import Effects.Effects.CancelEventProduction;
    import Effects.Effects.ExploreSector;
    import Effects.Effects.LevelupEffect;
    import Effects.Effects.ProductionMultiplier;
    import Effects.Effects.ChangeDefaultBuffSkins;
    import Effects.Effects.ModifyItemLimit;
    import Effects.Effects.ApplyBuff;
    import Effects.Effects.ApplyLoottableBuff;
    import Effects.Effects.Particles;
    import nLib.cLog;
    import Communication.VO.EffectVO;
    import mx.collections.ArrayCollection;

    public final class EffectFactory 
    {

        private static var map:Dictionary = initClasses();

        private var gi:cGameInterface;

        public function EffectFactory(_arg_1:cGameInterface)
        {
            super();
            this.gi = _arg_1;
        }

        private static function initClasses():Dictionary
        {
            var map:Dictionary = new Dictionary();
            try
            {
                map[Reward.XML_string.toLowerCase()] = Reward;
                map[SendMail.XML_string.toLowerCase()] = SendMail;
                map[ShowHint.XML_string.toLowerCase()] = ShowHint;
                map[OpenWindow.XML_string.toLowerCase()] = OpenWindow;
                map[CloseWindow.XML_string.toLowerCase()] = CloseWindow;
                map[CloseCurrentWindow.XML_string.toLowerCase()] = CloseCurrentWindow;
                map[StartQuest.XML_string.toLowerCase()] = StartQuest;
                map[ControlShopItem.XML_string.toLowerCase()] = ControlShopItem;
                map[FulfillCondition.XML_string.toLowerCase()] = FulfillCondition;
                map[ApplyFilter.XML_string.toLowerCase()] = ApplyFilter;
                map[RefillDeposit.XML_string.toLowerCase()] = RefillDeposit;
                map[SkillDeposit.XML_string.toLowerCase()] = SkillDeposit;
                map[ResetQuest.XML_string.toLowerCase()] = ResetQuest;
                map[CancelQuest.XML_string.toLowerCase()] = CancelQuest;
                map[ChangeSkin.XML_string.toLowerCase()] = ChangeSkin;
                map[ChangeLoopMusic.XML_string.toLowerCase()] = ChangeLoopMusic;
                map[ChangeDefaultSkin.XML_string.toLowerCase()] = ChangeDefaultSkin;
                map["movecamera"] = MoveCamera;
                map["spawnbuilding"] = SpawnBuilding;
                map["eventcounter"] = EventCounter;
                map["removebuilding"] = RemoveBuilding;
                map["changeavatar"] = ChangeAvatar;
                map[AvatarMessage.XML_string.toLowerCase()] = AvatarMessage;
                map[SkillSpecialist.XML_string.toLowerCase()] = SkillSpecialist;
                map[SkillPlayer.XML_string.toLowerCase()] = SkillPlayer;
                map[RemoveSpecialistSkill.XML_string.toLowerCase()] = RemoveSpecialistSkill;
                map[FinishQuest.XML_string.toLowerCase()] = FinishQuest;
                map[RemovePlayerSkill.XML_string.toLowerCase()] = RemovePlayerSkill;
                map[RemoveBuff.XML_string.toLowerCase()] = RemoveBuff;
                map[SpawnCollectibles.XML_string.toLowerCase()] = SpawnCollectibles;
                map[DeletePlayerBuffs.XML_string.toLowerCase()] = DeletePlayerBuffs;
                map[CleanUpQuest.XML_string.toLowerCase()] = CleanUpQuest;
                map[ApplyZoneBuff.XML_string.toLowerCase()] = ApplyZoneBuff;
                map[CancelZoneBuff.XML_string.toLowerCase()] = CancelZoneBuff;
                map[GiveCollectibleResource.XML_string.toLowerCase()] = GiveCollectibleResource;
                map[UpgradeEpicWorkyardChain.XML_string.toLowerCase()] = UpgradeEpicWorkyardChain;
                map[AdjustGenericValue.XML_string.toLowerCase()] = AdjustGenericValue;
                map[ShuffleCollectibles.XML_string.toLowerCase()] = ShuffleCollectibles;
                map[HireMilitary.XML_string.toLowerCase()] = HireMilitary;
                map[ResetProductionModifiers.XML_string.toLowerCase()] = ResetProductionModifiers;
                map[CancelEventProduction.XML_string.toLowerCase()] = CancelEventProduction;
                map[ExploreSector.XML_string.toLowerCase()] = ExploreSector;
                map[LevelupEffect.XML_string.toLowerCase()] = LevelupEffect;
                map[ProductionMultiplier.XML_string.toLowerCase()] = ProductionMultiplier;
                map[ChangeDefaultBuffSkins.XML_string.toLowerCase()] = ChangeDefaultBuffSkins;
                map[ModifyItemLimit.XML_string.toLowerCase()] = ModifyItemLimit;
                map[ApplyBuff.XML_string.toLowerCase()] = ApplyBuff;
                map[ApplyLoottableBuff.XML_string.toLowerCase()] = ApplyLoottableBuff;
                map[Particles.XML_string.toLowerCase()] = Particles;
            }
            catch(e:Error)
            {
                cLog.error(("Unknown Effect Class init failed : " + e));
            };
            return (map);
        }


        public function applyAll(_arg_1:ArrayCollection):void
        {
            var _local_2:EffectVO;
            for each (_local_2 in _arg_1)
            {
                this.createEffect(_local_2).apply();
            };
        }

        public function createEffect(_arg_1:EffectVO):Effect
        {
            var _local_2:Effect;
            var _local_3:String = _arg_1.effect_string;
            var _local_4:Class = Class(map[_local_3.toLowerCase()]);
            if (_local_4 != null)
            {
                _local_2 = new (_local_4)();
            }
            else
            {
                cLog.error(("Unknown Effect action : " + _arg_1.effect_string));
                _local_2 = new Effect();
            };
            _local_2.init(_arg_1, this.gi);
            return (_local_2);
        }

        public function apply(_arg_1:EffectVO):void
        {
            this.createEffect(_arg_1).apply();
        }


    }
}
