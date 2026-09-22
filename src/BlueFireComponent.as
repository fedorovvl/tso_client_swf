package 
{
    import mx.containers.Canvas;
    import mx.core.UIComponentDescriptor;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import flash.utils.getTimer;
    import mx.core.mx_internal;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import mx.events.FlexEvent;
    import com.bluebyte.bluefire.puremvc.view.ChatPanelMediator;
    import com.bluebyte.bluefire.flex3.defaultClient.ChatPanel;
    import flash.display.DisplayObject;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFConnectionMediator;
    import com.bluebyte.bluefire.api.model.vo.PlayerVO;
    import com.bluebyte.bluefire.flex3.defaultClient.CustomInput;
    import com.bluebyte.bluefire.api.model.vo.ServerVO;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.styles.*;
    import flash.text.*;
    import flash.media.*;
    import mx.binding.*;
    import flash.filters.*;
    import flash.utils.*;
    import flash.net.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.ui.*;
    import flash.external.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class BlueFireComponent extends Canvas 
    {

        private var _panel:Object;
        private var _panelClass:Class;
        private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":Canvas});
        private var _chatPanelMediatorClass:Class;
        private var _facade:BlueFireFacade = BlueFireFacade.getInstance(((getTimer() + "") + Math.random()));

        public function BlueFireComponent()
        {
            super();
            mx_internal::_document = this;
            this.addEventListener("creationComplete", this.___BlueFireComponent_Canvas1_creationComplete);
        }

        public function set chatPanelMediatorClass(_arg_1:Class):void
        {
            this._chatPanelMediatorClass = _arg_1;
        }

        public function addChannel(_arg_1:String, _arg_2:Array, _arg_3:Boolean, _arg_4:int):void
        {
            var _local_6:String;
            var _local_5:ChannelVO = new ChannelVO();
            _local_5.name = _arg_1;
            for each (_local_6 in _arg_2)
            {
                _local_5.addRoom(_local_6);
            };
            _local_5.visible = _arg_3;
            _local_5.sortingIndex = _arg_4;
            this._facade.sendNotification(BlueFireFacade.ADD_CHANNEL, _local_5);
        }

        public function ___BlueFireComponent_Canvas1_creationComplete(_arg_1:FlexEvent):void
        {
            this.init(_arg_1);
        }

        protected function init(_arg_1:FlexEvent):void
        {
            if (!this._chatPanelMediatorClass)
            {
                this._chatPanelMediatorClass = ChatPanelMediator;
                trace("No ChatPanelMediatorClass set, using default");
            };
            if (!this._panelClass)
            {
                this._panelClass = ChatPanel;
                trace("No ChatPanelClass set, using default");
            };
            this._panel = new this._panelClass();
            this.addChild((this._panel as DisplayObject));
            this._facade.startup(this._panel, this._chatPanelMediatorClass);
        }

        public function updateGroupSeperator(_arg_1:String):void
        {
            this._facade.sendNotification(BlueFireFacade.UPDATE_ROOM_GROUP_SEPERATOR, _arg_1);
        }

        public function set panelClass(_arg_1:Class):void
        {
            this._panelClass = _arg_1;
        }

        override public function initialize():void
        {
            (mx_internal::setDocumentDescriptor(this._documentDescriptor_));
            super.initialize();
        }

        public function connect():void
        {
            this._facade.sendNotification(XIFFConnectionMediator.XIFF_CONNECT);
        }

        public function updatePlayerData(_arg_1:PlayerVO):void
        {
            this._facade.sendNotification(BlueFireFacade.UPDATE_PLAYER_DATA, _arg_1);
        }

        public function get chatInput():CustomInput
        {
            if (this._panel == null)
            {
                return (null);
            };
            return (this._panel.chatInput);
        }

        public function updateServerData(_arg_1:ServerVO):void
        {
            this._facade.sendNotification(BlueFireFacade.UPDATE_SERVER_DATA, _arg_1);
        }

        public function registerMessageMediator(_arg_1:IMediator):void
        {
            this._facade.registerMediator(_arg_1);
        }

        public function getFacade():BlueFireFacade
        {
            return (this._facade);
        }


    }
}
