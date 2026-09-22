package com.bluebyte.bluefire.puremvc.view
{
    public interface IBFTextInput 
    {

        function get visible():Boolean;
        function set visible(_arg_1:Boolean):void;
        function setFocus():void;
        function set text(_arg_1:String):void;
        function get text():String;
        function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void;

    }
}
