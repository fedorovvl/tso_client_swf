package com.bluebyte.tso.bootstrap
{
    import flash.events.IEventDispatcher;
    import __AS3__.vec.Vector;

    public interface IBootstrap extends IEventDispatcher 
    {

        function add(_arg_1:BootstrapStep):IBootstrap;
        function start():void;
        function next(_arg_1:BootstrapStep):void;
        function getRemainingSteps(_arg_1:BootstrapStep):Vector.<BootstrapStep>;

    }
}
