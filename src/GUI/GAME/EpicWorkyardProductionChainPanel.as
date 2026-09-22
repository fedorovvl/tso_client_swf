package GUI.GAME
{
    import flash.events.EventDispatcher;
    import GUI.Components.ItemRenderer.EpicWorkyardEmptyProductionChain;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import GUI.Components.ItemRenderer.WorkyardProductionChainRenderer;
    import flash.display.DisplayObjectContainer;
    import Interface.cGeneralInterface;
    import GUI.helpers.MovieClipHelpers;
    import EpicWorkyard.EpicWorkyardChangeProductionEvent;
    import EpicWorkyard.EpicWorkyardConsts;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import BuffSystem.BuffAppliance;
    import GUI.Components.ItemRenderer.ResourceIconRenderer;

    public class EpicWorkyardProductionChainPanel extends EventDispatcher 
    {

        private var emptyProductionChainView:EpicWorkyardEmptyProductionChain;
        private var enabled:Boolean;
        private var epicWorkyardSubBuilding:EpicWorkyardSubBuilding;
        private var productionChainView:WorkyardProductionChainRenderer;
        private var chainIndex:int;
        private var viewParent:DisplayObjectContainer;
        private var productionChainHandler:EpicWorkyardProductionPanel;
        private var generalInterface:cGeneralInterface;

        public function EpicWorkyardProductionChainPanel(_arg_1:cGeneralInterface)
        {
            super();
            this.generalInterface = _arg_1;
        }

        private function removeViews():void
        {
            MovieClipHelpers.removeFromParent(this.productionChainView);
            MovieClipHelpers.removeFromParent(this.emptyProductionChainView);
        }

        public function init(_arg_1:EpicWorkyardSubBuilding, _arg_2:DisplayObjectContainer, _arg_3:int, _arg_4:Boolean):void
        {
            this.reset();
            this.epicWorkyardSubBuilding = _arg_1;
            this.viewParent = _arg_2;
            this.chainIndex = _arg_3;
            this.enabled = _arg_4;
            this.initView();
        }

        private function handleChangeProduction(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            this.dispatchEvent(new EpicWorkyardChangeProductionEvent(EpicWorkyardConsts.CHANGE_PRODUCTION, this.epicWorkyardSubBuilding));
        }

        private function initView():void
        {
            if (this.epicWorkyardSubBuilding != null)
            {
                this.initProductionView();
            }
            else
            {
                this.initEmptyProductionView();
            };
        }

        private function reset():void
        {
            this.removeViews();
            this.removeListeners();
        }

        private function removeListeners():void
        {
            if (this.productionChainHandler)
            {
                this.productionChainHandler.removeEventListener(MouseEvent.CLICK, this.handleChangeProduction);
            };
            if (this.emptyProductionChainView)
            {
                this.emptyProductionChainView.btnStartProduction.removeEventListener(MouseEvent.CLICK, this.handleStartProduction);
            };
        }

        private function addView(_arg_1:DisplayObject):void
        {
            _arg_1.x = (EpicWorkyardConsts.PRODUCTION_CHAIN_RENDERER_BORDERED_WIDTH * this.chainIndex);
            _arg_1.y = 0;
            if (((_arg_1.parent == null) || (!(_arg_1.parent == this.viewParent))))
            {
                this.viewParent.addChild(_arg_1);
            };
        }

        public function updateBuffActive():void
        {
            var _local_1:BuffAppliance;
            if (this.epicWorkyardSubBuilding != null)
            {
                _local_1 = this.epicWorkyardSubBuilding.getMasterBuilding().productionBuff;
                if (_local_1 != null)
                {
                    this.productionChainHandler.setBuffed(((_local_1.GetBuffDefinition().getProductivityOutputPercent() < 100) ? ResourceIconRenderer.BUFFED_NEGATIVE : ResourceIconRenderer.BUFFED_POSITIVE));
                }
                else
                {
                    this.productionChainHandler.setBuffed(ResourceIconRenderer.BUFFED_NONE);
                };
            };
        }

        private function createAndAddView(_arg_1:Class):DisplayObject
        {
            var _local_2:DisplayObject = (new (_arg_1)() as DisplayObject);
            this.addView(_local_2);
            return (_local_2);
        }

        private function initProductionView():void
        {
            if (this.productionChainView == null)
            {
                this.productionChainView = (this.createAndAddView(WorkyardProductionChainRenderer) as WorkyardProductionChainRenderer);
            }
            else
            {
                this.addView(this.productionChainView);
            };
            if (this.productionChainHandler)
            {
                this.productionChainHandler.destroy();
                this.productionChainHandler = null;
            };
            this.productionChainHandler = new EpicWorkyardProductionPanel(this.generalInterface, this.epicWorkyardSubBuilding, this.productionChainView);
            this.productionChainHandler.setProductionDetails();
            this.productionChainView.houseImage.setStyle("bottom", 40);
            this.productionChainView.workerIcon.setStyle("bottom", 46);
            this.productionChainView.height = EpicWorkyardConsts.PRODUCTION_CHAIN_RENDERER_HEIGHT;
            this.productionChainView.lowerContentCanvas.height = EpicWorkyardConsts.PRODUCTION_CHAIN_RENDERER_LOWER_CONTENT_HEIGHT;
            this.productionChainView.lowerContentCanvasBackground.height = EpicWorkyardConsts.PRODUCTION_CHAIN_RENDERER_LOWER_CONTENT_HEIGHT;
            this.productionChainView.btnChangeProduction.visible = true;
            this.productionChainHandler.addEventListener(MouseEvent.CLICK, this.handleChangeProduction, false, 0, true);
        }

        private function handleStartProduction(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            this.dispatchEvent(new EpicWorkyardChangeProductionEvent(EpicWorkyardConsts.CHANGE_PRODUCTION, null));
        }

        private function initEmptyProductionView():void
        {
            if (this.emptyProductionChainView == null)
            {
                this.emptyProductionChainView = (this.createAndAddView(EpicWorkyardEmptyProductionChain) as EpicWorkyardEmptyProductionChain);
            }
            else
            {
                this.addView(this.emptyProductionChainView);
            };
            this.emptyProductionChainView.btnStartProduction.addEventListener(MouseEvent.CLICK, this.handleStartProduction, false, 0, true);
            this.emptyProductionChainView.btnStartProduction.enabled = this.enabled;
        }

        public function refreshProductionState():void
        {
            if (this.epicWorkyardSubBuilding != null)
            {
                this.productionChainHandler.displayProductionState();
            };
        }


    }
}
