package com.bluebyte.tso.rendering.buildinglayers
{
    import __AS3__.vec.Vector;
    import Communication.VO.dBuildingLayerVO;
    import Utils.Pair;
    import __AS3__.vec.*;

    public class BuildingLayers 
    {

        public var after:Vector.<BuildingLayer>;
        public var before:Vector.<BuildingLayer>;

        public function BuildingLayers(_arg_1:Vector.<BuildingLayer>, _arg_2:Vector.<BuildingLayer>)
        {
            super();
            this.before = _arg_1;
            this.after = _arg_2;
        }

        public static function createFromDefinition(_arg_1:Pair):BuildingLayers
        {
            return (new BuildingLayers(BuildingLayer.createFromDefinition((_arg_1.getLeft() as Vector.<dBuildingLayerVO>)), BuildingLayer.createFromDefinition((_arg_1.getRight() as Vector.<dBuildingLayerVO>))));
        }


        public function animate():void
        {
            var _local_1:BuildingLayer;
            var _local_2:BuildingLayer;
            for each (_local_1 in this.before)
            {
                _local_1.animate();
            };
            for each (_local_2 in this.after)
            {
                _local_2.animate();
            };
        }

        public function dispose():void
        {
            var _local_1:BuildingLayer;
            var _local_2:BuildingLayer;
            for each (_local_1 in this.before)
            {
                _local_1.dispose();
            };
            for each (_local_2 in this.after)
            {
                _local_2.dispose();
            };
            this.before.length = 0;
            this.after.length = 0;
        }

        public function renderBefore(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:BuildingLayer;
            for each (_local_5 in this.before)
            {
                _local_5.render(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        public function renderAfter(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:BuildingLayer;
            for each (_local_5 in this.after)
            {
                _local_5.render(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        public function compute():void
        {
            var _local_1:BuildingLayer;
            var _local_2:BuildingLayer;
            for each (_local_1 in this.before)
            {
                _local_1.compute();
            };
            for each (_local_2 in this.after)
            {
                _local_2.compute();
            };
        }


    }
}
