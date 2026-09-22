package com.bluebyte.tso.ui.bridge
{
    import nLib.cPosInt;

    public interface NLibFlexBridgeSettingsProvider 
    {

        function get scaleWithZoom():Boolean;
        function set scaleWithZoom(_arg_1:Boolean):void;
        function set offsetPoint(_arg_1:cPosInt):void;
        function set gridPos(_arg_1:int):void;
        function get offsetPoint():cPosInt;
        function get gridPos():int;

    }
}
