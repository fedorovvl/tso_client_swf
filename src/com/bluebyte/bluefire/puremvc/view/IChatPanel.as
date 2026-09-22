package com.bluebyte.bluefire.puremvc.view
{
    import flash.events.IEventDispatcher;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;

    public interface IChatPanel extends IEventDispatcher 
    {

        function set selectedChannel(_arg_1:ChannelVO):void;
        function get whispers():IBFList;
        function get visible():Boolean;
        function get messageInput():IBFTextInput;
        function set visible(_arg_1:Boolean):void;
        function activateWhisper():void;
        function get mucs():IBFList;
        function get editable():Boolean;
        function deactivateWhisper():void;
        function get selectedChannel():ChannelVO;

    }
}
