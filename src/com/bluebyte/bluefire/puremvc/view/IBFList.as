package com.bluebyte.bluefire.puremvc.view
{
    public interface IBFList 
    {

        function set dataProvider(_arg_1:Object):void;
        function get dataProvider():Object;
        function set selectedItem(_arg_1:Object):void;
        function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void;
        function get selectedItem():Object;

    }
}
