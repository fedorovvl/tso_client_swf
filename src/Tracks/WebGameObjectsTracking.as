package Tracks
{
    import ServerState.cPlayerData;
    import Specialists.cSpecialistSubTaskDefinition;
    import Specialists.cSpecialist;
    import flash.external.ExternalInterface;
    import nLib.cLog;

    public class WebGameObjectsTracking extends TrackDispatcher 
    {


        override public function trackSpecialistTaskStarted(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:String):void
        {
        }

        override public function trackExternalFriendInviteCall(_arg_1:int):void
        {
            if (((ExternalInterface.available) && (null == ExternalInterface.call("gameevents.triggerFriendInvite"))))
            {
                cLog.warning("Unable to call the gameevents.triggerFriendInvite function");
            };
        }

        override public function trackSpecialistTaskFinished(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:Object, _arg_6:String):void
        {
        }

        override public function trackLevelUp(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:int = _arg_1.GetPlayerLevel();
            if (((ExternalInterface.available) && (null == ExternalInterface.call("gameevents.triggerLevelUp", _local_4))))
            {
                cLog.warning("Unable to call the gameevents.triggerLevelUp function");
            };
            if (_local_4 == 5)
            {
                this.tutorialEnd();
            };
        }

        override public function trackClientLoaded():void
        {
            if (((ExternalInterface.available) && (null == ExternalInterface.call("gameevents.triggerClientLoaded"))))
            {
                cLog.warning("Unable to call the gameevents.triggerClientLoaded function");
            };
        }

        public function tutorialEnd():void
        {
            if (((ExternalInterface.available) && (null == ExternalInterface.call("gameevents.triggerTutorialEnd"))))
            {
                cLog.warning("Unable to call the gameevents.triggerTutorialEnd function");
            };
        }


    }
}
