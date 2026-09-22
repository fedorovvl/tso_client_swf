package com.bluebyte.tso.rendering.buildinglayers
{
    import com.bluebyte.tso.util.IPoolable;
    import GOSets.GORenderable;
    import Communication.VO.dBuildingLayerVO;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.util.InstancePool;
    import Enums.BUILDING_LAYER_COMPUTED_EFFECT;
    import flash.display.BlendMode;
    import Enums.RENDER_MODE;
    import GOSets.cGOSetManager;
    import GOSets.cGOSetListControllerPercentage;
    import Trigger.TriggerList;
    import __AS3__.vec.*;

    public class BuildingLayer implements IPoolable 
    {

        private var conditionsFulfilled:Boolean = false;
        private var renderable:GORenderable;
        private var definition:dBuildingLayerVO;


        public static function createFromDefinition(_arg_1:Vector.<dBuildingLayerVO>):Vector.<BuildingLayer>
        {
            var _local_3:dBuildingLayerVO;
            var _local_4:BuildingLayer;
            var _local_2:Vector.<BuildingLayer> = new Vector.<BuildingLayer>();
            for each (_local_3 in _arg_1)
            {
                _local_4 = (InstancePool.newInstance(BuildingLayer, _local_3) as BuildingLayer);
                _local_4.definition = _local_3;
                _local_2.push(_local_4);
            };
            return (_local_2);
        }


        public function animate():void
        {
            if (!this.conditionsFulfilled)
            {
                return;
            };
            if (this.renderable != null)
            {
                this.renderable.Animate((global.ui.mCalculateTicks.mDeltaTicksOne * (0.75 + (Math.random() * 0.5))));
            };
        }

        public function dispose():void
        {
            InstancePool.freeInstance(BuildingLayer, this);
        }

        public function reset():void
        {
            this.renderable = null;
            this.definition = null;
        }

        public function render(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            if (!this.conditionsFulfilled)
            {
                return;
            };
            var _local_5:int = (_arg_1 + this.definition.offsetX);
            var _local_6:int = (_arg_2 + this.definition.offsetY);
            var _local_7:int = -1;
            switch (this.definition.computedEffect)
            {
                case BUILDING_LAYER_COMPUTED_EFFECT.HOVER_INV:
                    _local_6 = (_local_6 - (global.ui.mOscillatingInt * this.definition.computedEffectData));
                    break;
                case BUILDING_LAYER_COMPUTED_EFFECT.HOVER:
                    _local_6 = (_local_6 + (global.ui.mOscillatingInt * this.definition.computedEffectData));
                    break;
                case BUILDING_LAYER_COMPUTED_EFFECT.BOUNCE:
                    _local_6 = (_local_6 + global.ui.mWobblingInt);
                case BUILDING_LAYER_COMPUTED_EFFECT.PRODUCTION:
                    _local_7 = ((_arg_4) ? -1 : 0);
            };
            if (this.renderable != null)
            {
                switch (_arg_3)
                {
                    case RENDER_MODE.HIGHLIGHT:
                        this.renderable.RenderFrame(_local_5, _local_6, _local_7);
                        this.renderable.RenderFrameTransform(_local_5, _local_6, BlendMode.SCREEN, _local_7);
                        return;
                    case RENDER_MODE.NOT_PLACABLE:
                        this.renderable.RenderFrameTransform(_local_5, _local_6, BlendMode.MULTIPLY, 0);
                        return;
                    default:
                        this.renderable.RenderFrame(_local_5, _local_6, _local_7);
                };
            };
        }

        public function compute():void
        {
            if (this.renderable == null)
            {
                if (this.definition.isGoset)
                {
                    this.renderable = cGOSetManager.CreateGOSet(this.definition.gosetlistName, true);
                }
                else
                {
                    this.renderable = cGOSetManager.CreateGOSetList(this.definition.gosetlistName, new cGOSetListControllerPercentage(100));
                };
            };
            this.conditionsFulfilled = TriggerList.instantCheck(this.definition.conditions, global.ui);
        }

        public function init(_arg_1:Object=null):void
        {
            this.definition = (_arg_1 as dBuildingLayerVO);
            this.conditionsFulfilled = (this.definition.conditions == null);
        }


    }
}
