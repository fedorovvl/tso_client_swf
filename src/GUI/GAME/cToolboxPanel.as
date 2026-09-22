package GUI.GAME
{
    import Model.Observer;
    import Interface.cGameInterface;
    import GUI.Components.ToolboxPanel;
    import GO.cGOSpriteLibContainer;
    import GUI.Assets.gAssetManager;
    import com.bluebyte.tso.util.TimeUtil;
    import Enums.KILL_SWITCH;
    import GUI.Effects.gHintManager;
    import mx.collections.ArrayCollection;
    import mx.events.FlexEvent;
    import Model.Notifier;
    import GO.cToolBoxSectionData;
    import Enums.REQUIREMENT_TYPE;
    import __AS3__.vec.Vector;
    import Communication.VO.dRequirementVO;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import mx.events.ResizeEvent;
    import Enums.COMMAND;
    import Enums.OBJECTTYPE;
    import mx.events.ItemClickEvent;
    import Skill.cSkill;
    import Modifier.ModifierVO;
    import Modifier.Modifiers.Common.MoveCost;

    public class cToolboxPanel extends cBasicPanel implements Observer 
    {

        private static var TOOLBOX_STATE_NONE:int = 0;
        private static var TOOLBOX_STATE_HOME:int = 1;
        private static var TOOLBOX_STATE_DEFENSE:int = 2;
        private static var TOOLBOX_STATE_ATTACK:int = 3;

        private var mGI:cGameInterface;
        private var mToolboxState:int = TOOLBOX_STATE_NONE;
        protected var mToolboxPanel:ToolboxPanel;
        private var nextAllowedBuildingMove:Number = 0;


        private function SelectGroup(_arg_1:int):void
        {
            var _local_5:Number;
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_2:Array = [];
            if (_arg_1 == cGOSpriteLibContainer.UI_TYPE_UNDEFINED)
            {
                if (this.mToolboxState == TOOLBOX_STATE_HOME)
                {
                    _local_2.push({
                        "label":"BuildStreet",
                        "gfx":gAssetManager.GetBitmap("IconBuildStreet"),
                        "disabled":false
                    });
                    _local_2.push({
                        "label":"EraseStreet",
                        "gfx":gAssetManager.GetBitmap("IconEraseStreet"),
                        "disabled":false
                    });
                };
                if (((this.mToolboxState == TOOLBOX_STATE_HOME) || (this.mToolboxState == TOOLBOX_STATE_DEFENSE)))
                {
                    _local_2.push({
                        "label":"DeleteBuilding",
                        "gfx":gAssetManager.GetBitmap("IconDeleteBuilding"),
                        "disabled":false
                    });
                };
                if (this.mToolboxState == TOOLBOX_STATE_HOME)
                {
                    _local_5 = TimeUtil.getClientTime();
                    _local_6 = (((this.mGI.mRequirements.buildingRequirements_vector["MoveBuilding"].isFulfilled()) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.TOOLBOX_MOVEBUILDING))) && (this.nextAllowedBuildingMove < _local_5));
                    _local_2.push({
                        "label":"MoveBuilding",
                        "gfx":gAssetManager.GetBitmap("IconMoveBuilding", _local_6),
                        "disabled":(!(_local_6)),
                        "isModified":this.IsMoveBuildingModified()
                    });
                };
                if ((((this.mToolboxState == TOOLBOX_STATE_ATTACK) || (this.mToolboxState == TOOLBOX_STATE_DEFENSE)) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.TOOLBOX_PATHPREVIEW))))
                {
                    _local_7 = this.mGI.mCombatPersitedPreview.isLimitReached();
                    _local_2.push({
                        "label":"PathPreviewStart",
                        "gfx":gAssetManager.GetBitmap("IconPathPreviewStart", (!(_local_7))),
                        "disabled":_local_7
                    });
                    _local_2.push({
                        "label":"PathPreviewDelete",
                        "gfx":gAssetManager.GetBitmap("IconPathPreviewDelete"),
                        "disabled":false
                    });
                };
            }
            else
            {
                this.ChooseBuildingView(global.buildingGroup.mGOList_vector, _local_2, _arg_1);
                _local_2.sort(this.OrderIcons);
            };
            if (this.mToolboxPanel.tileList.dataProvider.length > 0)
            {
                gHintManager.HideHintsForParent(this.mToolboxPanel.tileList, true);
            };
            var _local_3:Number = (Math.ceil((this.mToolboxPanel.tileList.dataProvider.length / 5)) * 60);
            this.mToolboxPanel.tileList.dataProvider = new ArrayCollection(_local_2);
            this.mToolboxPanel.tileList.windowID = ((mUiElement.id + ".") + _arg_1);
            var _local_4:Number = (Math.ceil((this.mToolboxPanel.tileList.dataProvider.length / 5)) * 60);
            this.mToolboxPanel.y = ((this.mToolboxPanel.y + _local_3) - _local_4);
            if (this.mToolboxPanel.y < 0)
            {
                this.mToolboxPanel.y = 0;
            };
            this.mToolboxPanel.height = (92 + _local_4);
        }

        private function ChangedItemList(_arg_1:FlexEvent):void
        {
            gHintManager.TryRemainingHints();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            Hide();
            this.Show();
        }

        private function UpdateToolBoxIcon(_arg_1:ArrayCollection):void
        {
            var _local_3:cToolBoxSectionData;
            var _local_2:Class = ((this.IsMoveBuildingModified()) ? gAssetManager.GetClass("IconToolboxStar") : gAssetManager.GetClass("IconToolbox"));
            for each (_local_3 in _arg_1)
            {
                if (_local_3.id == "toolbox")
                {
                    _local_3.icon = _local_2;
                };
            };
        }

        private function OrderIcons(_arg_1:Object, _arg_2:Object):int
        {
            var _local_3:int = -1;
            var _local_4:Vector.<dRequirementVO> = this.mGI.mRequirements.buildingRequirements_vector[_arg_1.label].getRequirementsByType(REQUIREMENT_TYPE.LEVEL);
            if (_local_4.length > 0)
            {
                _local_3 = parseInt(_local_4.pop().value);
            };
            var _local_5:int = -1;
            var _local_6:Vector.<dRequirementVO> = this.mGI.mRequirements.buildingRequirements_vector[_arg_2.label].getRequirementsByType(REQUIREMENT_TYPE.LEVEL);
            if (_local_6.length > 0)
            {
                _local_5 = parseInt(_local_6.pop().value);
            };
            if (_local_3 > -1)
            {
                if (_local_5 > -1)
                {
                    return (_local_3 - _local_5);
                };
                return (-1);
            };
            return (1);
        }

        private function PinPanel(_arg_1:Event):void
        {
            this.mToolboxPanel.btnPin.selected = (!(this.mToolboxPanel.btnPin.selected));
            if (this.mToolboxPanel.btnPin.selected)
            {
                global.ui.mQuestClientCallbacks.InitiateWindowOpen("PinToolbox");
                global.getApplication().inputNotifier.notifyClick("PinToolbox");
                mCurrentActivePanel = null;
            }
            else
            {
                HideCurrentActivePanel();
                mCurrentActivePanel = this;
            };
        }

        private function ChooseBuildingView(_arg_1:Vector.<cGOSpriteLibContainer>, _arg_2:Array, _arg_3:int):void
        {
            var _local_4:cGOSpriteLibContainer;
            var _local_5:String;
            var _local_6:Boolean;
            for each (_local_4 in _arg_1)
            {
                if ((((!(_local_4 == null)) && (!(_local_4.mShowInGui == 0))) && (_local_4.mUITyp == _arg_3)))
                {
                    _local_5 = _local_4.mGfxResourceListName_string;
                    _local_6 = ((((!(this.mGI.mRequirements.buildingRequirements_vector[_local_5].isFulfilled())) || (this.mGI.mCurrentPlayer.mBuildQueue.IsFull())) || (this.mGI.mCurrentPlayer.IsMaximumPlacedBuildingCountReached(_local_5))) || (this.mGI.mCurrentPlayer.mBuildQueue.IsBlockedUntilBuildQueueIsProceed()));
                    _arg_2.push({
                        "label":_local_5,
                        "gfx":gAssetManager.GetBuildingIcon(_local_5, (!(_local_6))),
                        "disabled":_local_6
                    });
                };
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mToolboxPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mToolboxPanel.btnPin.visible = true;
            this.mToolboxPanel.btnPin.addEventListener(MouseEvent.CLICK, this.PinPanel);
            this.mToolboxPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mToolboxPanel.tileList.addEventListener(ListEvent.ITEM_CLICK, this.Select);
            this.mToolboxPanel.tileList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedItemList);
            this.mToolboxPanel.buttonBar.addEventListener(ListEvent.ITEM_CLICK, this.ShowBuildingsList);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
            globalFlash.gui.windowController.addWindow(this.mToolboxPanel);
            this.mGI.killswitch.addPropertyObserver(KILL_SWITCH.TOOLBOX_MOVEBUILDING, this);
            EnableDragging();
        }

        public function ClosePanel(_arg_1:Event):void
        {
            if (this.mToolboxPanel.btnPin.selected)
            {
                HideCurrentActivePanel();
            };
            this.mGI.mCurrentlySelectededBuilding = null;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            this.mToolboxPanel.btnPin.selected = false;
            this.Hide();
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mToolboxPanel.x < 0)
            {
                this.mToolboxPanel.x = 0;
            };
            if (this.mToolboxPanel.y < 0)
            {
                this.mToolboxPanel.y = 0;
            };
            if (this.mToolboxPanel.x > (global.getApplication().stage.stageWidth - this.mToolboxPanel.width))
            {
                this.mToolboxPanel.x = (global.getApplication().stage.stageWidth - this.mToolboxPanel.width);
            };
            if (this.mToolboxPanel.y > (global.getApplication().stage.stageHeight - this.mToolboxPanel.height))
            {
                this.mToolboxPanel.y = (global.getApplication().stage.stageHeight - this.mToolboxPanel.height);
            };
        }

        private function Select(_arg_1:ListEvent):void
        {
            if ((((!(_arg_1.currentTarget)) || (!(_arg_1.currentTarget.selectedItem))) || (_arg_1.currentTarget.selectedItem.disabled)))
            {
                return;
            };
            var _local_2:String = _arg_1.currentTarget.selectedItem.label;
            if (_local_2 == "BuildStreet")
            {
                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.BUILD_WAY);
            }
            else
            {
                if (_local_2 == "EraseStreet")
                {
                    this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.ERASE_WAY);
                }
                else
                {
                    if (_local_2 == "DeleteBuilding")
                    {
                        this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.DELETE_BUILDING);
                    }
                    else
                    {
                        if (_local_2 == "MoveBuilding")
                        {
                            if (this.nextAllowedBuildingMove < TimeUtil.getClientTime())
                            {
                                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING_TO_MOVE);
                            };
                        }
                        else
                        {
                            if (_local_2 == "PathPreviewStart")
                            {
                                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.ADD_BLOCKING_PATH_PREVIEW_START);
                            }
                            else
                            {
                                if (_local_2 == "PathPreviewDelete")
                                {
                                    this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.DELETE_BLOCKING_PATH_PREVIEW);
                                }
                                else
                                {
                                    if (global.ui.mIsDefenseMode)
                                    {
                                        if (this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone().CanPlayerAffordBuilding(_local_2))
                                        {
                                            this.mGI.mCurrentCursor.SetCursorEditModeObjectName(COMMAND.SET_BUILDING_IN_DEFENSE_MODE, _local_2);
                                            this.mGI.mCurrentCursor.SetCursor(OBJECTTYPE.BUILDING, _local_2);
                                        };
                                    }
                                    else
                                    {
                                        this.mGI.mCurrentCursor.SetCursorEditModeObjectName(COMMAND.SET_BUILDING_IN_GAME, _local_2);
                                        this.mGI.mCurrentCursor.SetCursor(OBJECTTYPE.BUILDING, _local_2);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (!this.mToolboxPanel.btnPin.selected)
            {
                Hide();
            };
        }

        public function buildingMoved():void
        {
        }

        private function ShowBuildingsList(_arg_1:ItemClickEvent):void
        {
            this.SelectGroup((this.mToolboxPanel.buttonBar.dataProvider as ArrayCollection).getItemAt(_arg_1.index).group);
        }

        override public function Show():void
        {
            globalFlash.gui.windowController.closeModal();
            this.mToolboxPanel.x = (global.getApplication().GAMESTATE_ID_ACTIONBAR.getAnchorX(global.getApplication().GAMESTATE_ID_ACTIONBAR.actionBarLeft.btnActionBar01) - (this.mToolboxPanel.width / 2));
            this.mToolboxPanel.y = (global.getApplication().GAMESTATE_ID_ACTIONBAR.y - 92);
            this.mToolboxPanel.tileList.dataProvider = null;
            this.SelectGroup((this.mToolboxPanel.buttonBar.dataProvider as ArrayCollection).getItemAt(this.mToolboxPanel.buttonBar.selectedIndex).group);
            super.Show();
        }

        public function Init(_arg_1:ToolboxPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mToolboxPanel = _arg_1;
            this.mToolboxPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function IsMoveBuildingModified():Boolean
        {
            var _local_2:cSkill;
            var _local_3:ModifierVO;
            if (this.mGI.mCurrentPlayer.getSkills() == null)
            {
                return (false);
            };
            var _local_1:Boolean;
            for each (_local_2 in this.mGI.mCurrentPlayer.getSkills().getItems_vector())
            {
                for each (_local_3 in _local_2.getDefinition().level_vector[(_local_2.getLevel() - 1)])
                {
                    _local_1 = ((_local_1) || (_local_3.modifier_string == MoveCost.xml_string));
                };
            };
            return (_local_1);
        }

        public function Refresh():void
        {
            var _local_1:Boolean;
            if (!global.ui.mIsDefenseMode)
            {
                if (global.ui.mCurrentPlayer.mIsColony)
                {
                    if (this.mToolboxState != TOOLBOX_STATE_ATTACK)
                    {
                        this.UpdateToolBoxIcon(global.attackModeToolBoxSectionData);
                        this.mToolboxPanel.buttonBar.dataProvider = global.attackModeToolBoxSectionData;
                        this.mToolboxState = TOOLBOX_STATE_ATTACK;
                        _local_1 = true;
                    };
                }
                else
                {
                    if (this.mToolboxState != TOOLBOX_STATE_HOME)
                    {
                        this.UpdateToolBoxIcon(global.homeZoneToolBoxSectionData);
                        this.mToolboxPanel.buttonBar.dataProvider = global.homeZoneToolBoxSectionData;
                        this.mToolboxState = TOOLBOX_STATE_HOME;
                        _local_1 = true;
                    };
                };
            }
            else
            {
                if (this.mToolboxState != TOOLBOX_STATE_DEFENSE)
                {
                    this.UpdateToolBoxIcon(global.defenseModeToolBoxSectionData);
                    this.mToolboxPanel.buttonBar.dataProvider = global.defenseModeToolBoxSectionData;
                    this.mToolboxState = TOOLBOX_STATE_DEFENSE;
                    _local_1 = true;
                };
            };
            if (_local_1)
            {
                this.mToolboxPanel.buttonBar.selectedIndex = 0;
                this.mToolboxPanel.buttonBar.validateProperties();
            };
            if (((this.IsVisible()) && ((_local_1) || (this.mToolboxPanel.buttonBar.selectedIndex >= 0))))
            {
                this.SelectGroup((this.mToolboxPanel.buttonBar.dataProvider as ArrayCollection).getItemAt(this.mToolboxPanel.buttonBar.selectedIndex).group);
            };
        }

        public function getMoveBuildingBlockedTime():Number
        {
            return (Math.max(0, (this.nextAllowedBuildingMove - TimeUtil.getClientTime())));
        }


    }
}
