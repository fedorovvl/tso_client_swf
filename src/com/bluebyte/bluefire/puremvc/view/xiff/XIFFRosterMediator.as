package com.bluebyte.bluefire.puremvc.view.xiff
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.igniterealtime.xiff.im.Roster;
    import org.igniterealtime.xiff.core.XMPPConnection;
    import org.igniterealtime.xiff.events.RosterEvent;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.igniterealtime.xiff.data.Presence;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import com.bluebyte.bluefire.api.model.vo.PresenceUpdatedVO;

    public class XIFFRosterMediator extends Mediator implements IMediator 
    {

        public static const NAME:String = "XIFFRosterMediator";

        public function XIFFRosterMediator()
        {
            super(NAME);
        }

        override public function listNotificationInterests():Array
        {
            return ([XIFFConnectionMediator.XIFF_CONNECTION_CREATED]);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            switch (_arg_1.getName())
            {
                case XIFFConnectionMediator.XIFF_CONNECTION_CREATED:
                    viewComponent = new Roster((_arg_1.getBody() as XMPPConnection));
                    this.roster.addEventListener(RosterEvent.ROSTER_LOADED, this.roster_RosterLoadedHandler);
                    this.roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED, this.roster_UserPresenceUpdatedHandler);
                    this.roster.addEventListener(RosterEvent.USER_ADDED, this.roster_UserAddedHandler);
                    this.roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST, this.roster_SubscriptionRequestHandler);
                    return;
            };
        }

        private function roster_RosterLoadedHandler(_arg_1:RosterEvent):void
        {
            var _local_2:Presence = new Presence(null, this.roster.connection.jid.escaped, null, null, null, 1);
            this.roster.connection.send(_local_2);
            this.roster.removeEventListener(RosterEvent.ROSTER_LOADED, this.roster_RosterLoadedHandler);
            sendNotification(BlueFireFacade.ROOM_JOIN_ALL);
        }

        private function roster_UserPresenceUpdatedHandler(_arg_1:RosterEvent):void
        {
            var _local_2:RosterItemVO = _arg_1.data;
            sendNotification(BlueFireFacade.FRIEND_PRESENCE_UPDATED, new PresenceUpdatedVO(_local_2.nickname, _local_2.online));
        }

        private function roster_UserAddedHandler(_arg_1:RosterEvent):void
        {
            var _local_2:RosterItemVO = _arg_1.data;
            sendNotification(BlueFireFacade.FRIEND_PRESENCE_UPDATED, new PresenceUpdatedVO(_local_2.nickname, _local_2.online));
        }

        private function get roster():Roster
        {
            return (viewComponent as Roster);
        }

        private function roster_SubscriptionRequestHandler(_arg_1:RosterEvent):void
        {
            this.roster.grantSubscription(_arg_1.jid, true);
        }


    }
}
