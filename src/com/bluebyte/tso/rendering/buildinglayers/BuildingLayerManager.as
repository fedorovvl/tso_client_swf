package com.bluebyte.tso.rendering.buildinglayers
{
    import Model.Observer;
    import flash.utils.Dictionary;
    import Model.Notifiers.TickChannel;
    import Model.Notifier;
    import nLib.cXML;
    import Communication.VO.dBuildingLayerVO;
    import __AS3__.vec.Vector;
    import Utils.Pair;
    import __AS3__.vec.*;

    public class BuildingLayerManager implements Observer 
    {

        private static var instance:BuildingLayerManager;

        private var definitions:Dictionary = new Dictionary();
        private var layers:Dictionary = new Dictionary();
        private var needRegister:Boolean = true;

        public function BuildingLayerManager(_arg_1:SingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("BuildingLayerManager is a Singleton. Use getInstance() to use this class."));
            };
        }

        public static function getInstance():BuildingLayerManager
        {
            if (instance == null)
            {
                instance = new BuildingLayerManager(new SingletonEnforcer());
            };
            return (instance);
        }


        public function initLayers(_arg_1:String):void
        {
            if (((this.layers[_arg_1] == null) && (!(this.definitions[_arg_1] == null))))
            {
                this.layers[_arg_1] = BuildingLayers.createFromDefinition(this.definitions[_arg_1]);
            };
            if (this.needRegister)
            {
                global.ui.channels.TICK.addPropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
                global.ui.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
                this.needRegister = false;
            };
        }

        public function renderAfter(_arg_1:String, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            if ((_arg_1 in this.layers))
            {
                this.layers[_arg_1].renderAfter(_arg_3, _arg_4, _arg_5, _arg_2);
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String;
            var _local_5:String;
            if (_arg_2 == TickChannel.DELAYED_COMPUTE_TICK)
            {
                for (_local_4 in this.layers)
                {
                    this.layers[_local_4].compute();
                };
            }
            else
            {
                for (_local_5 in this.layers)
                {
                    this.layers[_local_5].animate();
                };
            };
        }

        public function clear():void
        {
            var _local_1:String;
            for (_local_1 in this.layers)
            {
                this.layers[_local_1].dispose();
                delete this.layers[_local_1];
            };
            if (!this.needRegister)
            {
                global.ui.channels.TICK.removePropertyObserver(TickChannel.GAME_TICK, this);
                global.ui.channels.TICK.removePropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
                this.needRegister = true;
            };
        }

        public function renderBefore(_arg_1:String, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            if ((_arg_1 in this.layers))
            {
                this.layers[_arg_1].renderBefore(_arg_3, _arg_4, _arg_5, _arg_2);
            };
        }

        public function registerDefinition(_arg_1:String, _arg_2:cXML):void
        {
            var _local_7:cXML;
            var _local_3:Boolean;
            var _local_4:Vector.<dBuildingLayerVO> = new Vector.<dBuildingLayerVO>();
            var _local_5:Vector.<dBuildingLayerVO> = new Vector.<dBuildingLayerVO>();
            var _local_6:Vector.<dBuildingLayerVO> = _local_4;
            for each (_local_7 in _arg_2.CreateChildrenArray())
            {
                if (_local_7.GetName_string() == "building")
                {
                    _local_6 = _local_5;
                    _local_3 = true;
                }
                else
                {
                    _local_6.push(dBuildingLayerVO.createFromXML(_local_7));
                };
            };
            if (((_local_4.length > 0) || (_local_5.length > 0)))
            {
                if (!_local_3)
                {
                    _local_5 = _local_4;
                    _local_4 = new Vector.<dBuildingLayerVO>();
                };
                this.definitions[_arg_1] = new Pair(_local_4, _local_5);
            };
        }

        public function hasLayers(_arg_1:String):Boolean
        {
            return (_arg_1 in this.definitions);
        }


    }
}//package com.bluebyte.tso.rendering.buildinglayers

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


