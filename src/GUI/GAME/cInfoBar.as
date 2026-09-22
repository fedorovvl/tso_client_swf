package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import flash.filters.GlowFilter;
    import Interface.cGameInterface;
    import GUI.Components.InfoBar;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import mx.core.Container;
    import GUI.Effects.gGlowManager;
    import ServerState.cResources;
    import mx.events.FlexEvent;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cInfoBar extends cGuiBaseElement 
    {

        private var glow:GlowFilter = new GlowFilter(0xC1001D, 1, 14, 14, 6);
        private var mGI:cGameInterface;
        protected var mInfoBar:InfoBar;


        private function CheckTargetArea(_arg_1:MouseEvent, _arg_2:Container):Boolean
        {
            var _local_3:Point = new Point(_arg_2.x, _arg_2.y);
            _local_3 = _arg_2.parent.localToGlobal(_local_3);
            if (((_arg_1.stageX > _local_3.x) && (_arg_1.stageX < (_local_3.x + _arg_2.width))))
            {
                return (true);
            };
            return (false);
        }

        public function HandleInfoBarClick(_arg_1:MouseEvent):void
        {
            if (((_arg_1.target == this.mInfoBar.btnAddCash) || (this.mGI.mPacketLost)))
            {
                return;
            };
            if (this.CheckTargetArea(_arg_1, this.mInfoBar.buildings))
            {
                globalFlash.gui.mShopWindow.ShowDeepLink("InfoBar", 5004, 5);
            }
            else
            {
                if (this.CheckTargetArea(_arg_1, this.mInfoBar.hardCurrency))
                {
                    globalFlash.gui.mShopWindow.Show();
                }
                else
                {
                    if (this.CheckTargetArea(_arg_1, this.mInfoBar.population))
                    {
                        globalFlash.gui.ShowNextGarrison();
                    }
                    else
                    {
                        if (this.CheckTargetArea(_arg_1, this.mInfoBar.infoBarBuffs))
                        {
                            globalFlash.gui.mZoneBuffPanel.Show();
                        }
                        else
                        {
                            globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                        };
                    };
                };
            };
        }

        public function SetPopulation(_arg_1:cResources):void
        {
            var _local_2:int = _arg_1.GetFree();
            if (((_local_2 <= 3) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.population, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.population);
            };
            this.mInfoBar.resourceLabelPopulation.text = _local_2.toString();
            this.mInfoBar.resourceLabelPopulation.setStyle("color", ((_arg_1.GetFree() <= 0) ? 0xFF0000 : 0xFFFFFF));
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mInfoBar.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mInfoBar.addEventListener(MouseEvent.CLICK, this.HandleInfoBarClick);
            this.mInfoBar.resourceIconPopulation.source = gAssetManager.GetResourceIcon("Population");
            this.mInfoBar.resourceIconBuildings.source = gAssetManager.GetResourceIcon("Building");
            this.mInfoBar.resourceIconHardCurrency.source = gAssetManager.GetResourceIcon("HardCurrency");
            this.mInfoBar.resourceIconZoneBuff.source = gAssetManager.GetResourceIcon("ZoneBuff");
            this.mInfoBar.btnAddCash.addEventListener(MouseEvent.CLICK, this.AddHardCurrency);
            this.mInfoBar.resourceIcon1.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_1);
            this.mInfoBar.resourceIcon2.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_2);
            this.mInfoBar.resourceIcon3.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_3);
            this.mInfoBar.resourceIcon4.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_4);
            this.mInfoBar.resourceIcon5.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_5);
            this.mInfoBar.resourceIcon6.source = gAssetManager.GetResourceIcon(defines.INFO_RESOURCE_6);
        }

        public function SetZoneBuffs(_arg_1:int):void
        {
            this.mInfoBar.resourceLabelZoneBuff.text = (_arg_1 + ((global.ui.mCurrentPlayer.GetPremiumDuration() > 0) ? 1 : 0)).toString();
        }

        public function SetResource(_arg_1:cResources):void
        {
            var _local_2:uint;
            _local_2 = _arg_1.GetResourceAmount("HardCurrency");
            this.mInfoBar.resourceLabelHardCurrency.text = _local_2.toString();
            this.mInfoBar.hardCurrency.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "HardCurrency");
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_1);
            if (((_local_2 <= 10) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource1, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource1);
            };
            this.mInfoBar.resourceLabel1.text = _local_2.toString();
            this.mInfoBar.resource1.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_1);
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_2);
            if ((((_local_2 <= 5) && (this.mGI.mCurrentPlayer.GetPlayerLevel() >= 12)) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource2, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource2);
            };
            this.mInfoBar.resourceLabel2.text = _local_2.toString();
            this.mInfoBar.resource2.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_2);
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_3);
            if (((_local_2 <= 10) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource3, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource3);
            };
            this.mInfoBar.resourceLabel3.text = _local_2.toString();
            this.mInfoBar.resource3.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_3);
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_4);
            if ((((_local_2 <= 10) && (this.mGI.mCurrentPlayer.GetPlayerLevel() >= 18)) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 30)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource4, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource4);
            };
            this.mInfoBar.resourceLabel4.text = _local_2.toString();
            this.mInfoBar.resource4.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_4);
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_5);
            if (((_local_2 <= 10) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource5, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource5);
            };
            this.mInfoBar.resourceLabel5.text = _local_2.toString();
            this.mInfoBar.resource5.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_5);
            _local_2 = _arg_1.GetResourceAmount(defines.INFO_RESOURCE_6);
            if ((((_local_2 <= 10) && (this.mGI.mCurrentPlayer.GetPlayerLevel() >= 18)) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 30)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.resource6, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.resource6);
            };
            this.mInfoBar.resourceLabel6.text = _local_2.toString();
            this.mInfoBar.resource6.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, defines.INFO_RESOURCE_6);
        }

        public function SetBuildingsCount(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int = (_arg_2 - _arg_1);
            if (((_local_3 <= 5) && (this.mGI.mCurrentPlayer.GetPlayerLevel() <= 20)))
            {
                gGlowManager.addElementWithGlow(this.mInfoBar.buildings, this.glow);
            }
            else
            {
                gGlowManager.removeElement(this.mInfoBar.buildings);
            };
            this.mInfoBar.resourceLabelBuildings.text = _local_3.toString();
            this.mInfoBar.resourceLabelBuildings.setStyle("color", ((_local_3 > 0) ? 0xFFFFFF : 0xFF0000));
            this.mInfoBar.buildings.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BuildingsOnMap", [_local_3.toString(), _arg_2.toString()]);
        }

        private function AddHardCurrency(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mShopWindow.AddHardCurrency(_arg_1);
        }

        public function Init(_arg_1:InfoBar):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mInfoBar = _arg_1;
            this.mInfoBar.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
