package com.bluebyte.tso.service
{
    import Interface.cGameInterface;
    import Communication.VO.dServerAction;
    import ServerState.Responding;

    public class AbstractService 
    {

        public function AbstractService():void
        {
            super();
        }

        protected function getGI():cGameInterface
        {
            return (global.getApplication().mGameInterface as cGameInterface);
        }

        protected function sendServerAction(_arg_1:int, _arg_2:Object, _arg_3:Responding=null, _arg_4:int=0, _arg_5:int=0, _arg_6:int=-1):void
        {
            this.sendToCurrentZone(((_arg_6 < 0) ? _arg_1 : _arg_6), dServerAction.create(_arg_1, _arg_4, _arg_5, _arg_2), _arg_3);
        }

        protected function sendToCurrentZone(_arg_1:int, _arg_2:Object, _arg_3:Responding=null):void
        {
            this.send(_arg_1, _arg_2, this.getGI().mCurrentViewedZoneID, _arg_3);
        }

        protected function send(_arg_1:int, _arg_2:Object, _arg_3:int, _arg_4:Responding=null):void
        {
            ServiceManager.getInstance().send(_arg_1, _arg_2, _arg_3, _arg_4);
        }


    }
}
