package GUI.GAME
{
    import Model.Observer;
    import BuffSystem.cBuff;
    import Interface.cGameInterface;
    import GUI.Components.StarMenu;
    import flash.utils.Timer;
    import Specialists.cSpecialist;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import mx.controls.Alert;
    import Enums.COMMAND;
    import mx.events.CloseEvent;
    import flash.events.Event;
    import GUI.Assets.gAssetManager;
    import GUI.helpers.GraphicsHelpers;
    import mx.controls.Button;
    import flash.geom.Point;
    import mx.events.FlexEvent;
    import flash.events.TimerEvent;
    import Utils.StringUtils;
    import mx.events.ItemClickEvent;
    import Model.Notifiers.ZoneChannel;
    import Model.Notifier;
    import GUI.Effects.gHintManager;
    import mx.events.ScrollEvent;
    import flash.events.MouseEvent;
    import mx.events.ResizeEvent;
    import mx.events.ListEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Model.Notifiers.SpecialistNotifier;
    import Enums.SPECIALIST_TYPE;
    import Specialists.cSpecialistTask_TravelToZone;
    import Specialists.cSpecialistGroupStarItem;
    import Enums.SPECIALIST_TASK_TYPES;
    import nLib.gMisc;
    import GO.cGOSpriteLibContainer;
    import Enums.GO_SUBTYPE;
    import GO.cBuilding;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.dPersistedBuffApplianceVO;
    import BuffSystem.cBuffDefinition;
    import Enums.OBJECTTYPE;
    import GUI.Components.CustomAlert;
    import Enums.HALLOWEEN_EVENT;
    import Enums.BUFF_TYPE;
    import Enums.BUFF_TARGET_ZONE;
    import com.bluebyte.tso.adventure.logic.AdventureManager;

    public class cStarMenu extends cBasicPanel implements Observer
    {

        public static function CompareDefault(_arg_1:Object, _arg_2:Object, _arg_3:int):Number
        {
            return SortOptions.compareDefault(new SortOptions(_arg_1),new SortOptions(_arg_2),_arg_3);
        }

        public static function CompareName(_arg_1:Object, _arg_2:Object, _arg_3:int):Number
        {
            return SortOptions.compareName(new SortOptions(_arg_1),new SortOptions(_arg_2),_arg_3);
        }

        public static function CompareDate(_arg_1:Object, _arg_2:Object, _arg_3:int):Number
        {
            return SortOptions.compareDate(new SortOptions(_arg_1),new SortOptions(_arg_2),_arg_3);
        }

        public static function CompareType(_arg_1:Object, _arg_2:Object, _arg_3:int):Number
        {
            return SortOptions.compareType(new SortOptions(_arg_1),new SortOptions(_arg_2),_arg_3);
        }

        public static function GetSortName(_arg_1:Object):String
        {
            return new SortOptions(_arg_1).Name;
        }

        public static const CLICK_ITEM:String = "CLICK_ITEM";
        public static const CLICK_DELETE_BUTTON:String = "CLICK_DELETE_BUTTON";
        public static const GROUP_ALL:int = 0;
        public static const GROUP_SPECIALISTS:int = 1;
        public static const GROUP_RESOURCES:int = 2;
        public static const GROUP_BUFFS:int = 3;
        public static const GROUP_BUILDINGS:int = 4;
        public static const GROUP_ADVENTURES:int = 5;
        public static const GROUP_MISC:int = 6;
        public static const GROUP_GEOLOGISTS:int = 7;
        public static const GROUP_GENERALS:int = 8;
        public static const GROUP_EXPLORERS:int = 9;
        public static const GROUP_ADVENTURE_TARGETS:int = 10;

        private var selectedBuff:cBuff;
        private var mGI:cGameInterface;
        protected var mPanel:StarMenu;
        private var mResetScrollPosition:Boolean;
        private var mLastScrollPosition:Number;
        private var lastKnownCollectibleAmount:int = 0;
        private var refreshTimer:Timer = new Timer(5000);
        private var selectedSpecialist:cSpecialist;
        private var collection:ArrayCollection;
        private var mSpecialists:Vector.<cSpecialist>;
        private var mSelectedGroup:int;
        private var collectionBuffSortOptions:Dictionary;
        private var _ascending:Boolean = true;
        private var intialX:Number = 0;
        private var searchFilterString:String;
        private var selectedSortIndex:int = 0;


        private function addPermBuildQueueSlot(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:cBuff = this.mGI.mCurrentCursor.mCurrentBuff;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, this.mGI.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse().GetGrid(), 0, _local_2.GetUniqueId());
            _local_2.IncWaitingForServerCount(this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
        }

        override protected function UnselectBuildingWhenHide():void
        {
        }

        public function ClosePanel(_arg_1:Event):void
        {
            if (this.mPanel.btnPin.selected)
            {
                HideCurrentActivePanel();
            };
            this.mPanel.btnPin.selected = false;
            this.Hide();
        }

        private function applyZoneTimedBuff(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:cBuff = this.mGI.mCurrentCursor.mCurrentBuff;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, 0, 0, _local_2.GetUniqueId());
            this.mGI.mCurrentCursor.mCurrentBuff = null;
        }

        public function sortFilteredList(_arg_1:Event=null):void
        {
            this.collection.disableAutoUpdate();
            switch (this.mPanel.sortCombo.selectedItem.data)
            {
                case 0:
                    if (_arg_1)
                    {
                        this.ascending = true;
                    };
                    this.collection.source.sort(this.sortDefault);
                    break;
                case 1:
                    if (_arg_1)
                    {
                        this.ascending = true;
                    };
                    this.collection.source.sort(this.sortByName);
                    break;
                case 2:
                    if (_arg_1)
                    {
                        this.ascending = false;
                    };
                    this.collection.source.sort(this.sortByDate);
                    break;
                case 3:
                    if (_arg_1)
                    {
                        this.ascending = true;
                    };
                    this.collection.source.sort(this.sortByType);
                    break;
                case 4:
                    if (_arg_1)
                    {
                        this.ascending = false;
                    };
                    this.collection.source.sort(this.sortByAmount);
                    break;
            };
            this.selectedSortIndex = this.mPanel.sortCombo.selectedIndex;
            this.collection.refresh();
            this.collection.enableAutoUpdate();
        }

        private function PinPanel(_arg_1:Event):void
        {
            this.mPanel.btnPin.selected = (!(this.mPanel.btnPin.selected));
            if (this.mPanel.btnPin.selected)
            {
                mCurrentActivePanel = null;
            }
            else
            {
                mCurrentActivePanel = this;
            };
        }

        override public function Show():void
        {
            globalFlash.gui.mActionBar.HideStarAnim();
            globalFlash.gui.windowController.closeModal();
            this.mPanel.dragon.source = gAssetManager.GetClass(GraphicsHelpers.getUIComponentHeaderClassName(this.mGI, this.mPanel.id));
            this.resetPosition();
            this.mPanel.sortCombo.selectedIndex = this.selectedSortIndex;
            this.mPanel.ascending = this.ascending;
            super.Show();
            this.Refresh();
            this.refreshScrollPosition();
            this.collection.enableAutoUpdate();
            this.refreshTimer.start();
        }

        private function resetPosition():void
        {
            var _local_1:Button = global.getApplication().GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04;
            this.intialX = ((_local_1.parent.localToGlobal(new Point(_local_1.x, _local_1.y)).x + (_local_1.width / 2)) - (this.mPanel.width / 2));
            this.mPanel.x = this.intialX;
            this.mPanel.y = Math.max(50, ((global.getApplication().GAMESTATE_ID_ACTIONBAR.y - this.mPanel.height) - 20));
        }

        public function Init(_arg_1:StarMenu):void
        {
            this.mGI = (global.ui as cGameInterface);
            openSound = "MenuOpenStar";
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function ResetScrollPosition():void
        {
            this.mResetScrollPosition = true;
        }

        private function filterList(_arg_1:Object, _arg_2:int=0, _arg_3:Vector.<Object>=null):Boolean
        {
            if ((this.mSelectedGroup >= cStarMenu.GROUP_GEOLOGISTS) && (this.mSelectedGroup <= cStarMenu.GROUP_EXPLORERS))
            {
                if (!this.matchesSpecialistGroup(_arg_1, this.mSelectedGroup))
                {
                    return (false);
                };
            }
            else if (((!(this.mSelectedGroup == cStarMenu.GROUP_ALL)) && (!(this.collectionBuffSortOptions[_arg_1].Group == this.mSelectedGroup))))
            {
                return (false);
            };
            if (this.searchFilterString)
            {
                return (this.collectionBuffSortOptions[_arg_1].filter(this.searchFilterString));
            };
            return (true);
        }

        private function matchesSpecialistGroup(_arg_1:Object, _arg_2:int):Boolean
        {
            if (_arg_1 is cSpecialistGroupStarItem)
            {
                return (_arg_2 == GROUP_EXPLORERS);
            };
            if (!(_arg_1 is cSpecialist))
            {
                return (false);
            };
            var _local_3:int = (_arg_1 as cSpecialist).GetBaseType();
            switch (_arg_2)
            {
                case GROUP_GEOLOGISTS:
                    return (_local_3 == SPECIALIST_TYPE.GEOLOGIST);
                case GROUP_EXPLORERS:
                    return (_local_3 == SPECIALIST_TYPE.EXPLORER);
                case GROUP_GENERALS:
                    return (((_local_3 == SPECIALIST_TYPE.GENERAL) || (_local_3 == SPECIALIST_TYPE.TRANSPORTER_GENERAL)) || (_local_3 == SPECIALIST_TYPE.ADMIRAL));
            };
            return (false);
        }

        public function Refresh():void
        {
            if (IsVisible())
            {
                this.mLastScrollPosition = this.mPanel.itemList.verticalScrollPosition;
                this.initialiseBuffList();
                this.sortFilteredList();
                this.mPanel.itemList.verticalScrollPosition = this.mLastScrollPosition;
            };
        }

        public function RefreshBuff(_arg_1:cBuff):void
        {
            var _local_3:int;
            var _local_2:ArrayCollection = (this.mPanel.itemList.dataProvider as ArrayCollection);
            if (_arg_1.isDeleted())
            {
                _local_3 = _local_2.getItemIndex(_arg_1);
                if (_local_3 > -1)
                {
                    _local_2.removeItemAt(_local_3);
                };
            };
            (this.mPanel.itemList.dataProvider as ArrayCollection).refresh();
        }

        private function set ascending(_arg_1:Boolean):void
        {
            this.mPanel.ascending = _arg_1;
            this._ascending = _arg_1;
        }

        private function refreshTimerHandler(_arg_1:TimerEvent):void
        {
            this.Refresh();
            if (IsVisible())
            {
                this.refreshTimer.start();
            };
        }

        private function moveGarisson():void
        {
            this.mGI.UnselectBuilding();
            this.mGI.mCurrentCursor.mCurrentSpecialist = this.selectedSpecialist;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.MOVE_GARISSON);
            this.selectedSpecialist = null;
            this.Hide();
        }

        private function sortDefault(_arg_1:Object, _arg_2:Object):Number
        {
            var _local_3:int = ((this.ascending) ? 1 : -1);
            var _local_4:SortOptions = this.collectionBuffSortOptions[_arg_1];
            var _local_5:SortOptions = this.collectionBuffSortOptions[_arg_2];
            return SortOptions.compareDefault(_local_4,_local_5,_local_3);
        }

        private function changeTab(_arg_1:ItemClickEvent):void
        {
            var _local_2:int = ((_arg_1) ? _arg_1.index : 0);
            var _local_3:* = this.mPanel.buttonBar;
            this.mSelectedGroup = ((_local_3.dataProvider as ArrayCollection).getItemAt(_local_2).group as int);
            if (_local_3 == this.mPanel.buttonBar)
            {
            }
            else
            {
                this.mPanel.buttonBar.selectedIndex = -1;
            };
            this.ResetScrollPosition();
            this.refreshScrollPosition();
            this.collection.refresh();
        }

        private function sortByName(_arg_1:Object, _arg_2:Object):Number
        {
            var _local_3:int = ((this.ascending) ? 1 : -1);
            var _local_4:SortOptions = this.collectionBuffSortOptions[_arg_1];
            var _local_5:SortOptions = this.collectionBuffSortOptions[_arg_2];
            return SortOptions.compareName(_local_4,_local_5,_local_3);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (((_arg_1 == this.mGI.channels.ZONE) && (_arg_2 == ZoneChannel.COLLECTIBLES_UPDATED)))
            {
                if (this.lastKnownCollectibleAmount == _arg_3)
                {
                    return;
                };
                this.lastKnownCollectibleAmount = int(_arg_3);
                this.mGI.mCurrentPlayer.forceResortBuffsForStarMenu();
            };
            this.Refresh();
        }

        private function mouseWheelHandler(_arg_1:ScrollEvent):void
        {
            gHintManager.HideHintsForParent(this.mPanel.itemList, true);
            gHintManager.TryRemainingHints();
        }

        private function sortByAmount(_arg_1:Object, _arg_2:Object):Number
        {
            var _local_3:int = ((this.ascending) ? 1 : -1);
            var _local_4:SortOptions = this.collectionBuffSortOptions[_arg_1];
            var _local_5:SortOptions = this.collectionBuffSortOptions[_arg_2];
            if (_local_4.Amount > _local_5.Amount)
            {
                return (_local_3);
            };
            if (_local_5.Amount > _local_4.Amount)
            {
                return (-(_local_3));
            };
            if (_local_4.Group > _local_5.Group)
            {
                return (_local_3);
            };
            if (_local_5.Group > _local_4.Group)
            {
                return (-(_local_3));
            };
            if (_local_4.Type > _local_5.Type)
            {
                return (_local_3);
            };
            if (_local_5.Type > _local_4.Type)
            {
                return (-(_local_3));
            };
            if (!StringUtils.equalsIgnoreCase(_local_4.Name, _local_5.Name))
            {
                return (_local_4.Name.localeCompare(_local_5.Name) * _local_3);
            };
            return ((_local_4.UniqueId.greater(_local_5.UniqueId)) ? _local_3 : -(_local_3));
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.selectedSpecialist = null;
            this.selectedBuff = null;
            this.collection = new ArrayCollection();
            this.mPanel.btnPin.visible = true;
            this.resetPosition();
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnPin.addEventListener(MouseEvent.CLICK, this.PinPanel);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
            this.mPanel.addEventListener(cStarMenu.CLICK_ITEM, this.itemClickHandler);
            this.mPanel.addEventListener(cStarMenu.CLICK_DELETE_BUTTON, this.removeButtonClick);
            this.mPanel.buttonBar.addEventListener(ListEvent.ITEM_CLICK, this.changeTab);
            this.mPanel.searchInput.addEventListener(Event.CHANGE, this.refreshSearchFilteredList);
            this.mPanel.itemList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.changedItemListHandler);
            this.mPanel.itemList.addEventListener(ScrollEvent.SCROLL, this.mouseWheelHandler);
            this.mPanel.itemList.selectable = false;
            this.mPanel.itemList.dataProvider = this.collection;
            this.mPanel.sortCombo.addEventListener(Event.CHANGE, this.sortFilteredList);
            this.mPanel.btnArrow.addEventListener(MouseEvent.CLICK, this.btnArrowHandler);
            this.mPanel.buttonBar.dataProvider = [{
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "All"),
                "group":cStarMenu.GROUP_ALL,
                "icon":gAssetManager.GetClass("StarMenuTabIconAll")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Specialists"),
                "group":cStarMenu.GROUP_SPECIALISTS,
                "icon":gAssetManager.GetClass("StarMenuTabIconSpecialist")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, "Geologist"),
                "group":cStarMenu.GROUP_GEOLOGISTS,
                "icon":StarMenuGeologistTabIcon
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, "General"),
                "group":cStarMenu.GROUP_GENERALS,
                "icon":StarMenuGeneralTabIcon
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, "Explorer"),
                "group":cStarMenu.GROUP_EXPLORERS,
                "icon":StarMenuExplorerTabIcon
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Resources"),
                "group":cStarMenu.GROUP_RESOURCES,
                "icon":gAssetManager.GetClass("StarMenuTabIconResource")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Buffs"),
                "group":cStarMenu.GROUP_BUFFS,
                "icon":gAssetManager.GetClass("StarMenuTabIconBuff")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Buildings"),
                "group":cStarMenu.GROUP_BUILDINGS,
                "icon":gAssetManager.GetClass("StarMenuTabIconBuilding")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Adventures"),
                "group":cStarMenu.GROUP_ADVENTURES,
                "icon":gAssetManager.GetClass("StarMenuTabIconAdventure")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_LABELS, "TutAdvancedReadyArmy"),
                "group":cStarMenu.GROUP_ADVENTURE_TARGETS,
                "icon":gAssetManager.GetClass("ChatTabIconGlobal")
            }, {
                "toolTip":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Misc"),
                "group":cStarMenu.GROUP_MISC,
                "icon":gAssetManager.GetClass("StarMenuTabIconMisc")
            }];
            this.initialiseBuffList();
            this.mGI.mCurrentPlayerZone.addPropertyObserver("mSpecialists_vector", this);
            this.mGI.mCurrentPlayer.addPropertyObserver("mAvailableBuffs_vector", this);
            this.mGI.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.NAME_CHANGED, this);
            this.mGI.channels.ZONE.addPropertyObserver(ZoneChannel.COLLECTIBLES_UPDATED, this);
            this.refreshTimer.addEventListener(TimerEvent.TIMER, this.refreshTimerHandler);
            EnableDragging();
        }

        private function removeButtonClick(_arg_1:ItemClickEvent):void
        {
            var _local_2:String;
            if (((!(_arg_1.item)) || (this.selectedBuff)))
            {
                return;
            };
            this.selectedBuff = (_arg_1.item as cBuff);
            _local_2 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.selectedBuff.GetType(), [this.selectedBuff.GetAmount(), this.selectedBuff.GetResourceName_string()]);
            globalFlash.gui.mDeleteBuffResourcePanel.setData(this.selectedBuff);
            this.selectedBuff = null;
            this.Hide();
            globalFlash.gui.mDeleteBuffResourcePanel.Show();
        }

        private function itemClickHandler(_arg_1:ItemClickEvent):void
        {
            var _local_2:cSpecialist;
            var _local_3:int;
            var _local_4:cBuff;
            var _local_5:cSpecialistGroupStarItem;
            if ((((!(_arg_1.item)) || (this.selectedBuff)) || (this.selectedSpecialist)))
            {
                return;
            };
            if ((_arg_1.item is cSpecialistGroupStarItem))
            {
                _local_5 = (_arg_1.item as cSpecialistGroupStarItem);
                if (_local_5.representative == null) return;
                if (_local_5.isActive)
                {
                    globalFlash.gui.mSpecialistCooldownPanel.SetGroupData(_local_5.representative,_local_5.entry,_local_5.memberCount,_local_5.groupIndex);
                    globalFlash.gui.mSpecialistCooldownPanel.Show();
                }
                else
                {
                    globalFlash.gui.mSpecialistPanel.SetGroupData(_local_5.representative,_local_5.entry,_local_5.memberCount,_local_5.groupIndex);
                    globalFlash.gui.mSpecialistPanel.Show();
                };
            }
            else if ((_arg_1.item is cSpecialist))
            {
                _local_2 = (_arg_1.item as cSpecialist);
                _local_3 = _local_2.GetGarrisonGridIdx();
                if (global.getApplication().mGameInterface.mCurrentPlayerZone.IsPositionInsideZoneGridPos(_local_3))
                {
                    global.getApplication().mGameInterface.mCurrentPlayerZone.ScrollToGrid(_local_2.GetGarrisonGridIdx());
                };
                if ((((_local_2.GetBaseType() == SPECIALIST_TYPE.GENERAL) || (_local_2.GetBaseType() == SPECIALIST_TYPE.TRANSPORTER_GENERAL)) || (_local_2.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)))
                {
                    if ((((_local_2.GetGarrison() == null) && (_local_2.GetTask() == null)) && (((!(_local_2.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)) && (!(this.mGI.UsesCombatThree()))) || (_local_2.GetBaseType() == SPECIALIST_TYPE.ADMIRAL))))
                    {
                        this.selectedSpecialist = _local_2;
                        this.moveGarisson();
                    }
                    else
                    {
                        if (_local_2.GetGarrison())
                        {
                            this.mGI.SelectBuilding(_local_2.GetGarrison());
                        }
                        else
                        {
                            if (((((_local_2.GetTask()) && (_local_2.DisplayTaskProgress())) && (!(_local_2.GetType() == SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER))) && (_local_2.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)))
                            {
                                this.showCooldownPanel(_local_2);
                            };
                        };
                    };
                }
                else
                {
                    if (_local_2.GetType() != SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER)
                    {
                        if (_local_2.GetTask() == null)
                        {
                            globalFlash.gui.mSpecialistPanel.SetData(_local_2);
                            globalFlash.gui.mSpecialistPanel.Show();
                        }
                        else
                        {
                            if (_local_2.DisplayTaskProgress())
                            {
                                this.showCooldownPanel(_local_2);
                            };
                        };
                    };
                };
            }
            else
            {
                if ((_arg_1.item is cBuff))
                {
                    _local_4 = (_arg_1.item as cBuff);
                    if (((!(_local_4.GetWaitingForServer())) && (_local_4.enable)))
                    {
                        this.selectedBuff = _local_4;
                        this.activateBuff();
                    };
                };
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > (global.getApplication().stage.stageHeight - this.mPanel.height))
            {
                this.mPanel.y = (global.getApplication().stage.stageHeight - this.mPanel.height);
            };
        }

        private function showCooldownPanel(_arg_1:cSpecialist):void
        {
            var _local_2:cSpecialistTask_TravelToZone;
            if (_arg_1.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)
            {
                if (_arg_1.GetTask().GetType() == SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE)
                {
                    _local_2 = (_arg_1.GetTask() as cSpecialistTask_TravelToZone);
                    if (_local_2.GetDestinationZoneID() == _arg_1.getPlayerID())
                    {
                        globalFlash.gui.mSpecialistCooldownPanel.SetData(_arg_1);
                        globalFlash.gui.mSpecialistCooldownPanel.Show();
                    };
                };
            }
            else
            {
                globalFlash.gui.mSpecialistCooldownPanel.SetData(_arg_1);
                globalFlash.gui.mSpecialistCooldownPanel.Show();
            };
        }

        private function get ascending():Boolean
        {
            return (this._ascending);
        }

        private function refreshScrollPosition():void
        {
            this.mPanel.itemList.windowID = ((mUiElement.id + ".") + this.mSelectedGroup);
            if (this.mResetScrollPosition)
            {
                this.mPanel.itemList.verticalScrollPosition = 0;
                this.mLastScrollPosition = 0;
            }
            else
            {
                if (this.mLastScrollPosition > this.mPanel.itemList.maxVerticalScrollPosition)
                {
                    this.mLastScrollPosition = this.mPanel.itemList.maxVerticalScrollPosition;
                };
                this.mPanel.itemList.verticalScrollPosition = this.mLastScrollPosition;
            };
            this.mResetScrollPosition = false;
        }

        private function sortByDate(_arg_1:Object, _arg_2:Object):Number
        {
            var _local_3:int = ((this.ascending) ? 1 : -1);
            var _local_4:SortOptions = this.collectionBuffSortOptions[_arg_1];
            var _local_5:SortOptions = this.collectionBuffSortOptions[_arg_2];
            return SortOptions.compareDate(_local_4,_local_5,_local_3);
        }

        private function changedItemListHandler(_arg_1:FlexEvent):void
        {
            gHintManager.TryRemainingHints();
        }

        private function refreshSearchFilteredList(_arg_1:Event=null):void
        {
            this.searchFilterString = gMisc.Trim_string(this.mPanel.searchInput.text.toLocaleLowerCase());
            this.collection.refresh();
            this.mPanel.itemList.scrollToIndex(0);
        }

        private function initialiseBuffList():void
        {
            var _local_2:cSpecialist;
            var _local_3:Array;
            var _local_4:cBuff;
            var _local_5:int;
            var _local_6:cGOSpriteLibContainer;
            var _local_7:cSpecialistGroupStarItem;
            if (!this.collectionBuffSortOptions)
            {
                this.collectionBuffSortOptions = new Dictionary(true);
            };
            var _local_1:Array = [];
            gHintManager.HideHintsForParent(this.mPanel.itemList, true);
            for each (_local_2 in this.mGI.mCurrentPlayerZone.GetSpecialists_vector())
            {
                if (_local_2.getPlayerID() == this.mGI.mCurrentPlayer.GetPlayerId())
                {
                    if (!this.collectionBuffSortOptions[_local_2])
                    {
                        this.collectionBuffSortOptions[_local_2] = new SortOptions(_local_2);
                    }
                    else
                    {
                        this.collectionBuffSortOptions[_local_2].update(_local_2);
                    };
                    _local_1.push(_local_2);
                };
            };
            for each (_local_7 in this.getSpecialistGroupItems())
            {
                this.collectionBuffSortOptions[_local_7] = new SortOptions(_local_7);
                _local_1.push(_local_7);
            };
            _local_3 = this.mGI.mCurrentPlayer.getBuffsSortedForStarMenu();
            for each (_local_4 in _local_3)
            {
                if (!_local_4.IsExhausted)
                {
                    if (!this.collectionBuffSortOptions[_local_4])
                    {
                        this.collectionBuffSortOptions[_local_4] = new SortOptions(_local_4);
                    }
                    else
                    {
                        this.collectionBuffSortOptions[_local_4].update(_local_4);
                    };
                    if (this.collectionBuffSortOptions[_local_4].Group == GROUP_BUILDINGS)
                    {
                        _local_5 = global.buildingGroup.GetNrFromName(_local_4.GetResourceName_string());
                        _local_6 = global.buildingGroup.GetGoSpriteLibContainerFromNr(_local_5);
                        if (_local_6.mEnumGoSubType == GO_SUBTYPE.DECORATION)
                        {
                            _local_4.markAsDeletable();
                        };
                        if (_local_4.GetResourceName_string() == cBuilding.PVP_PROGRESSION_BUILDING_string)
                        {
                            _local_4.setDeletable(false);
                        };
                    }
                    else
                    {
                        if (((_local_4.GetId() == defines.ADVENTURE_BUFF_ID) && (!(cAdventureDefinition.FindAdventureDefinition(_local_4.GetResourceName_string()).isDeletable(this.mGI)))))
                        {
                            _local_4.setDeletable(false);
                        }
                        else
                        {
                            _local_4.markAsDeletable();
                        };
                    };
                    _local_1.push(_local_4);
                };
            };
            this.collection.source = _local_1;
            this.collection.filterFunction = this.filterList;
            this.collection.refresh();
        }

        private function getSpecialistGroupItems():Array
        {
            var result:Array = [];
            var container:Object = this.mGI.mCurrentPlayerZone.mSpecialistGroups;
            var entries:Object = container != null ? container.SpecialistGroups : null;
            var entry:Object;
            var group:Object;
            var count:int;
            var index:int;
            var name:String;
            if (entries == null) return result;
            for each (entry in entries)
            {
                count = this.groupMemberCount(entry);
                if (count > 0)
                {
                    group = entry != null ? entry.SpecialistGroup : null;
                    name = group != null ? String(group.Name) : "";
                    if (name.length == 0)
                    {
                        name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS,"DefaultSpecialistGroupName",[index + 1]);
                    };
                    result.push(new cSpecialistGroupStarItem(entry,this.groupRepresentative(entry),name,count,index));
                };
                index++;
            };
            return result;
        }

        private function groupMemberCount(_arg_1:Object):int
        {
            var refs:Object = _arg_1 != null ? _arg_1.SpecialistReferences : null;
            var count:int;
            var value:Object;
            if (refs != null) for each (value in refs) count++;
            return count;
        }

        private function groupRepresentative(_arg_1:Object):cSpecialist
        {
            var refs:Object = _arg_1 != null ? _arg_1.SpecialistReferences : null;
            var ref:Object;
            var specialist:cSpecialist;
            var fallback:cSpecialist;
            var slowest:cSpecialist;
            var remainingTime:int;
            var longestRemainingTime:int = -1;
            for each (specialist in this.mGI.mCurrentPlayerZone.GetSpecialists_vector())
            {
                for each (ref in refs)
                {
                    if (ref != null && ref.UniqueID != null && specialist.GetUniqueID().uniqueID1 == ref.UniqueID.uniqueID1 && specialist.GetUniqueID().uniqueID2 == ref.UniqueID.uniqueID2)
                    {
                        if (fallback == null) fallback = specialist;
                        if (specialist.GetTask() != null)
                        {
                            remainingTime = specialist.GetTask().GetRemainingTime();
                            if (slowest == null || remainingTime > longestRemainingTime)
                            {
                                slowest = specialist;
                                longestRemainingTime = remainingTime;
                            };
                        };
                    };
                };
            };
            return slowest != null ? slowest : fallback;
        }

        private function activateChangeColorScheme(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:cBuff = this.mGI.mCurrentCursor.mCurrentBuff;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, this.mGI.mCurrentPlayerZone.GetFirstBuildingOnMap(_local_2.GetBuffDefinition().GetTargetDescription_string()).GetGrid(), 0, _local_2.GetUniqueId());
            _local_2.IncWaitingForServerCount(this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
        }

        private function activateBuff():void
        {
            var _local_2:int;
            var _local_3:cBuilding;
            var _local_4:String;
            var _local_5:String;
            var _local_6:Vector.<dPersistedBuffApplianceVO>;
            var _local_7:Boolean;
            var _local_8:cBuffDefinition;
            var _local_9:String;
            var _local_1:cBuff = this.selectedBuff;
            this.selectedBuff = null;
            this.mGI.mCurrentCursor.mCurrentBuff = _local_1;
            this.Hide();
            if (_local_1.GetBuffDefinition().GetName_string() == defines.BUILD_BUILDING_BUFF)
            {
                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SET_BUILDING_BY_BUFF);
                this.mGI.mCurrentCursor.SetCursor(OBJECTTYPE.BUILDING, _local_1.GetResourceName_string());
            }
            else
            {
                if (_local_1.GetBuffDefinition().GetName_string() == defines.BUILD_DEFENSE_MODE_BUILDING_BUFF)
                {
                    this.mGI.mCurrentCursor.SetCursorEditModeObjectName(COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF, _local_1.GetResourceName_string());
                    this.mGI.mCurrentCursor.SetCursor(OBJECTTYPE.BUILDING, _local_1.GetResourceName_string());
                }
                else
                {
                    if (_local_1.GetBuffDefinition().GetName_string().indexOf(defines.LOOTTABLE_BUFF) == 0)
                    {
                        this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        globalFlash.gui.mMysteryBoxPanel.SetData(_local_1);
                        globalFlash.gui.mMysteryBoxPanel.ShowConfirmation();
                    }
                    else
                    {
                        if (_local_1.GetType() == "Adventure")
                        {
                            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                            globalFlash.gui.mAdventurePanel.SetBuffData(_local_1.GetResourceName_string());
                            globalFlash.gui.mAdventurePanel.Show();
                        }
                        else
                        {
                            if (_local_1.GetType() == "PermanentBuildQueueSlot")
                            {
                                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                                CustomAlert.show("ConfirmAddPermBuildQueueSlot", "ConfirmAddPermBuildQueueSlot", (Alert.OK | Alert.CANCEL), null, this.addPermBuildQueueSlot, null, 4, true);
                            }
                            else
                            {
                                if (_local_1.GetType().indexOf(defines.PREMIUM_ACCOUNT_BUFF) == 0)
                                {
                                    this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                                    globalFlash.gui.mPremiumAccountActivationWindow.SetPremiumBuff(_local_1);
                                    globalFlash.gui.mPremiumAccountActivationWindow.Show();
                                }
                                else
                                {
                                    if (_local_1.GetType().indexOf("ChangeColorSchemeInstant") > -1)
                                    {
                                        return;
                                    };
                                    if (_local_1.GetType().indexOf(HALLOWEEN_EVENT.BUFF_HIT_MONSTER) == 0)
                                    {
                                        _local_2 = _local_1.GetBuffDefinition().GetRedeemable_vector().length;
                                        if (((_local_2 > 0) && (!(this.mGI.mEventManager.isEventStarted(_local_1.GetBuffDefinition().GetRedeemableEventName())))))
                                        {
                                            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.APPLY_BUFF);
                                        }
                                        else
                                        {
                                            for each (_local_3 in this.mGI.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                                            {
                                                if (((!(_local_3 == null)) && (_local_3.mIsEventMonster)))
                                                {
                                                    if (_local_1.IsApplyable(this.mGI.mCurrentPlayer, this.mGI, _local_3.GetGrid()) == _local_3)
                                                    {
                                                        globalFlash.gui.mEventMonster.SetData(_local_3);
                                                        globalFlash.gui.mEventMonster.Show();
                                                        break;
                                                    };
                                                };
                                            };
                                        };
                                    }
                                    else
                                    {
                                        if (_local_1.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE_TIMED)
                                        {
                                            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                                            _local_4 = (_local_1.GetBuffDefinition().GetName_string() + ((_local_1.GetResourceName_string().length > 0) ? ("_" + _local_1.GetResourceName_string()) : ""));
                                            _local_6 = this.mGI.mZoneBuffManager.getBuffInExclusivityGroup_vector(_local_1.GetBuffDefinition().GetExclusivityGroup());
                                            _local_7 = this.mGI.mZoneBuffManager.isBuffRunning(_local_4);
                                            if (_local_7)
                                            {
                                                CustomAlert.show((_local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuffExtend", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_4)])), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuff"), (Alert.OK | Alert.CANCEL), null, this.applyZoneTimedBuff, null, 4, false);
                                            }
                                            else
                                            {
                                                if (_local_6.length > 0)
                                                {
                                                    _local_8 = cBuffDefinition.GetById(_local_6[0].buffID);
                                                    _local_9 = (_local_8.GetName_string() + ((_local_6[0].resourceName_string.length > 0) ? ("_" + _local_6[0].resourceName_string) : ""));
                                                    if (((this.mGI.isOnHomzone()) || ((this.mGI.IsAdventureZone()) && (AdventureManager.getInstance().getAdventure(this.mGI.mCurrentViewedZoneID).ownerPlayerID == this.mGI.mCurrentPlayer.getPlayerID()))))
                                                    {
                                                        CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuffReplace", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_4), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_9)]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuff"), (Alert.OK | Alert.CANCEL), null, this.applyZoneTimedBuff, null, 4, false);
                                                    }
                                                    else
                                                    {
                                                        CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuffCannotReplace", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_4), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_9)]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuffCannotPlace"), Alert.CANCEL, null, null, null, 4, false);
                                                    };
                                                }
                                                else
                                                {
                                                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuff", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_4)]);
                                                    CustomAlert.show(_local_5, cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuff"), (Alert.OK | Alert.CANCEL), null, this.applyZoneTimedBuff, null, 4, false);
                                                };
                                            };
                                        }
                                        else
                                        {
                                            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.APPLY_BUFF);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function sortByType(_arg_1:Object, _arg_2:Object):Number
        {
            var _local_3:int = ((this.ascending) ? 1 : -1);
            var _local_4:SortOptions = this.collectionBuffSortOptions[_arg_1];
            var _local_5:SortOptions = this.collectionBuffSortOptions[_arg_2];
            return SortOptions.compareType(_local_4,_local_5,_local_3);
        }

        override public function Hide():void
        {
            if (!this.mPanel.btnPin.selected)
            {
                this.mLastScrollPosition = this.mPanel.itemList.verticalScrollPosition;
                super.Hide();
                this.collection.disableAutoUpdate();
                this.refreshTimer.stop();
            };
        }

        private function removeBuff(_arg_1:CloseEvent):void
        {
            if (!this.selectedBuff)
            {
                return;
            };
            var _local_2:cBuff = this.selectedBuff;
            this.selectedBuff = null;
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            _local_2.SetWaitingForServer(this.mGI);
            globalFlash.gui.mStarMenu.Refresh();
            this.mGI.SendServerAction(COMMAND.REMOVE_BUFF, 0, 0, 0, _local_2.GetUniqueId());
        }

        private function btnArrowHandler(_arg_1:MouseEvent):void
        {
            this.ascending = (!(this.ascending));
            this.sortFilteredList();
        }


    }
}//package GUI.GAME

import GUI.GAME.cStarMenu;
import Communication.VO.dUniqueID;
import Specialists.cSpecialist;
import Specialists.cSpecialistGroupStarItem;
import BuffSystem.cBuff;
import GUI.Loca.cLocaManager;
import Enums.LOCA_GROUP;
import AdventureSystem.cAdventureDefinition;
import GUI.Assets.gAssetManager;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import mx.core.BitmapAsset;
import Utils.StringUtils;
import Enums.SPECIALIST_TYPE;

class StarMenuSpecialistTabIcon extends BitmapAsset
{
    public function StarMenuSpecialistTabIcon(_arg_1:String)
    {
        super(createBitmap(_arg_1));
    }

    private static function createBitmap(_arg_1:String):BitmapData
    {
        var _local_2:BitmapData = gAssetManager.GetBitmap(_arg_1).bitmapData;
        var _local_3:Rectangle = _local_2.getColorBoundsRect(0xFF000000, 0, false);
        var _local_4:Number = Math.min(20 / _local_3.width, 20 / _local_3.height);
        var _local_5:BitmapData = new BitmapData(22, 22, true, 0);
        var _local_6:Matrix = new Matrix(_local_4, 0, 0, _local_4, ((22 - (_local_3.width * _local_4)) / 2) - (_local_3.x * _local_4), ((22 - (_local_3.height * _local_4)) / 2) - (_local_3.y * _local_4));
        _local_5.draw(_local_2, _local_6, null, null, null, true);
        return (_local_5);
    }
}

class StarMenuGeologistTabIcon extends StarMenuSpecialistTabIcon
{
    public function StarMenuGeologistTabIcon()
    {
        super("IconAllGeologists");
    }
}

class StarMenuGeneralTabIcon extends StarMenuSpecialistTabIcon
{
    public function StarMenuGeneralTabIcon()
    {
        super("IconAllGenerals");
    }
}

class StarMenuExplorerTabIcon extends StarMenuSpecialistTabIcon
{
    public function StarMenuExplorerTabIcon()
    {
        super("IconAllExplorers");
    }
}

class SortOptions 
{

    /*private*/ static const GROUPS:Object = {
        "specialist":cStarMenu.GROUP_SPECIALISTS,
        "AddResource":cStarMenu.GROUP_RESOURCES,
        "FillDeposit":cStarMenu.GROUP_RESOURCES,
        "PremiumAccount":cStarMenu.GROUP_BUFFS,
        "ProductivityBuff":cStarMenu.GROUP_BUFFS,
        "ProductivityAreaBuff":cStarMenu.GROUP_BUFFS,
        "SpeedUpPopulationGrowth":cStarMenu.GROUP_BUFFS,
        "RecruitingBuff":cStarMenu.GROUP_BUFFS,
        "ProvisionerBuff":cStarMenu.GROUP_BUFFS,
        "EventBuff":cStarMenu.GROUP_BUFFS,
        "HalloweenEvent":cStarMenu.GROUP_BUFFS,
        "AddRecipe":cStarMenu.GROUP_BUFFS,
        "EmptyEffectBuff":cStarMenu.GROUP_BUFFS,
        "#donate-resource#":cStarMenu.GROUP_BUFFS,
        "MultiplierBuffZone":cStarMenu.GROUP_BUFFS,
        "EffectBuff":cStarMenu.GROUP_BUFFS,
        "RemoveBuff":cStarMenu.GROUP_BUFFS,
        "BattleBuff":cStarMenu.GROUP_BUFFS,
        "BookbinderBuff":cStarMenu.GROUP_BUFFS,
        "ShuffleCollectibles":cStarMenu.GROUP_BUFFS,
        "AnimalBuff":cStarMenu.GROUP_BUFFS,
        "RevealCollectiblesBuff":cStarMenu.GROUP_BUFFS,
        "ChangeColorScheme":cStarMenu.GROUP_BUFFS,
        "ChangeSkin":cStarMenu.GROUP_BUFFS,
        "ChangeDefaultSkin":cStarMenu.GROUP_BUFFS,
        "EventMonsterBuff":cStarMenu.GROUP_BUFFS,
        "GeneralSpeed":cStarMenu.GROUP_BUFFS,
        "BuildBuilding":cStarMenu.GROUP_BUILDINGS,
        "BuildDefenseModeBuilding":cStarMenu.GROUP_BUILDINGS,
        "Adventure":cStarMenu.GROUP_ADVENTURES,
        "RarityArea":cStarMenu.GROUP_MISC,
        "QuestStart":cStarMenu.GROUP_MISC,
        "HiredMilitary":cStarMenu.GROUP_MISC,
        "ChangeAvatar":cStarMenu.GROUP_MISC,
        "#withdraw-resource#":cStarMenu.GROUP_MISC,
        "#transfer-resource#":cStarMenu.GROUP_MISC,
        "MountainDemolition":cStarMenu.GROUP_MISC
    };
    /*private*/ static const EFFECT_TYPES:Object = {
        "null":1,
        "PremiumAccount":2,
        "ProductivityBuff":3,
        "ProductivityAreaBuff":4,
        "MultiplierBuffZone":4.1,
        "SpeedUpPopulationGrowth":5,
        "BookbinderBuff":5.1,
        "AnimalBuff":5.2,
        "RevealCollectiblesBuff":5.4,
        "RecruitingBuff":6,
        "ProvisionerBuff":7,
        "EventBuff":8,
        "HalloweenEvent":9,
        "FillDeposit":11,
        "AddResource":12,
        "BuildBuilding":13,
        "AddRecipe":14,
        "RarityArea":14.1,
        "BuffAdventures":14.2,
        "EventMonsterBuff":14.3,
        "QuestStart":15,
        "Adventure":16,
        "BattleBuff":17,
        "MountainDemolition":18,
        "HiredMilitary":19,
        "BuildDefenseModeBuilding":20,
        "EmptyEffectBuff":21,
        "EffectBuff":22,
        "RemoveBuff":23,
        "ChangeColorScheme":24,
        "ChangeDefaultSkin":25,
        "ChangeSkin":26,
        "ChangeAvatar":27,
        "ShuffleCollectibles":28,
        "GeneralSpeed":29,
        "#donate-resource#":10,
        "#withdraw-resource#":50,
        "#transfer-resource#":51
    };
    /*private*/ static var replacePattern:RegExp = /<[^>]+>/g;

    public var Default:int;
    public var Name:String;
    public var UniqueId:dUniqueID;
    public var Date:Number;
    public var Amount:int;
    public var Type:Number;
    public var Group:int;
    private var item:Object;

    public static function compareDefault(_arg_1:SortOptions, _arg_2:SortOptions, _arg_3:int):Number
    {
        var result:Number = compareNumber(_arg_1.Group,_arg_2.Group,_arg_3);
        if(result == 0)
        {
            result = compareNumber(_arg_1.Type,_arg_2.Type,_arg_3);
        };
        return result != 0 ? result : compareName(_arg_1,_arg_2,_arg_3);
    }

    public static function compareName(_arg_1:SortOptions, _arg_2:SortOptions, _arg_3:int):Number
    {
        if(!StringUtils.equalsIgnoreCase(_arg_1.Name,_arg_2.Name))
        {
            return (_arg_1.Name.localeCompare(_arg_2.Name) * _arg_3);
        };
        return compareUniqueId(_arg_1.UniqueId,_arg_2.UniqueId,_arg_3);
    }

    public static function compareDate(_arg_1:SortOptions, _arg_2:SortOptions, _arg_3:int):Number
    {
        var result:Number = compareNumber(_arg_1.Date,_arg_2.Date,_arg_3);
        if(result == 0)
        {
            result = compareNumber(_arg_1.Type,_arg_2.Type,_arg_3);
        };
        return result != 0 ? result : compareName(_arg_1,_arg_2,_arg_3);
    }

    public static function compareType(_arg_1:SortOptions, _arg_2:SortOptions, _arg_3:int):Number
    {
        var result:Number = compareNumber(_arg_1.Type,_arg_2.Type,_arg_3);
        return result != 0 ? result : compareName(_arg_1,_arg_2,_arg_3);
    }

    private static function compareNumber(_arg_1:Number, _arg_2:Number, _arg_3:int):Number
    {
        if(_arg_1 > _arg_2)
        {
            return _arg_3;
        };
        if(_arg_2 > _arg_1)
        {
            return -_arg_3;
        };
        return 0;
    }

    private static function compareUniqueId(_arg_1:dUniqueID, _arg_2:dUniqueID, _arg_3:int):Number
    {
        if(_arg_1 == null || _arg_2 == null)
        {
            return 0;
        };
        return _arg_1.greater(_arg_2) ? _arg_3 : -_arg_3;
    }

    public function SortOptions(_arg_1:Object)
    {
        var _local_6:dUniqueID;
        var _local_7:SortOptions;
        var _local_8:String;
        var _local_9:String;
        var _local_11:cSpecialist;
        var _local_12:cBuff;
        var _local_13:cLocaManager;
        var _local_14:String;
        var groupItem:cSpecialistGroupStarItem;
        super();
        this.item = _arg_1;
        var _local_2:* = "";
        var _local_3:Number = 0;
        var _local_4:int;
        var _local_5:int;
        var _local_10:Number = 0;
        if ((_arg_1 is cSpecialist))
        {
            _local_11 = (_arg_1 as cSpecialist);
            _local_2 = _local_11.getName(false).replace(replacePattern, "");
            _local_3 = _local_11.insertedAt;
            _local_4 = 1;
            _local_10 = (_local_11.GetSortIndex() / 10);
            _local_5 = cStarMenu.GROUP_SPECIALISTS;
            _local_6 = _local_11.GetUniqueID();
        }
        else if ((_arg_1 is cSpecialistGroupStarItem))
        {
            groupItem = (_arg_1 as cSpecialistGroupStarItem);
            _local_2 = groupItem.name;
            _local_3 = 0;
            _local_4 = groupItem.memberCount;
            _local_10 = 0.9;
            _local_5 = cStarMenu.GROUP_SPECIALISTS;
            _local_6 = new dUniqueID();
            _local_6.uniqueID1 = -1;
            _local_6.uniqueID2 = groupItem.groupIndex;
        }
        else
        {
            if ((_arg_1 is cBuff))
            {
                _local_12 = (_arg_1 as cBuff);
                _local_13 = cLocaManager.GetInstance();
                _local_14 = _local_12.GetResourceName_string();
                _local_3 = _local_12.insertedAt;
                _local_8 = _local_12.GetBuffDefinition().GetName_string();
                if (_local_8.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
                {
                    _local_2 = _local_13.GetText(LOCA_GROUP.RESOURCES, ((defines.CHANGE_COLOR_SCHEME_BUFF + "_") + _local_14));
                }
                else
                {
                    if (_local_8.indexOf(defines.ADVENTURE_BUFF) == 0)
                    {
                        _local_2 = _local_13.GetText(LOCA_GROUP.ADVENTURE_NAME, _local_14);
                        _local_10 = (EFFECT_TYPES[_local_9] + (cAdventureDefinition.FindAdventureDefinition(_local_14).GetType() / 10));
                    }
                    else
                    {
                        _local_2 = _local_13.getLabel(_local_8, [_local_12.GetAmount(), _local_14]);
                    };
                };
                _local_9 = this.getEffectType(_local_8);
                if ((_local_12.GetBuffDefinition().getTargetZoneTypes() & (Enums.BUFF_TARGET_ZONE.ADVENTURE | Enums.BUFF_TARGET_ZONE.EXPEDITION)) != 0)
                {
                    _local_5 = cStarMenu.GROUP_ADVENTURE_TARGETS;
                }
                else
                {
                if (_local_10 == 0)
                {
                    _local_10 = EFFECT_TYPES[_local_9];
                };
                if (GROUPS[_local_9])
                {
                    _local_5 = GROUPS[_local_9];
                }
                else
                {
                    _local_5 = cStarMenu.GROUP_MISC;
                };
                };
                _local_4 = _local_12.GetAmount();
                _local_6 = _local_12.GetUniqueId();
            };
        };
        this.Name = _local_2.toLocaleLowerCase();
        this.Date = _local_3;
        this.Type = _local_10;
        this.Amount = _local_4;
        this.Group = _local_5;
        this.UniqueId = _local_6;
    }

    public function filter(_arg_1:String):Boolean
    {
        if (this.Name.indexOf(_arg_1) > -1)
        {
            return true;
        };
        var loca:cLocaManager = cLocaManager.GetInstance();
        if (!loca.IsInitialized())
        {
            return false;
        };
        var key:String;
        var group:String = LOCA_GROUP.DESCRIPTIONS;
        var params:Array = null;
        if (this.item is cSpecialist)
        {
            key = SPECIALIST_TYPE.toString((this.item as cSpecialist).GetType());
        }
        else if (this.item is cBuff)
        {
            var buff:cBuff = this.item as cBuff;
            key = buff.GetBuffDefinition().GetName_string();
            var resource:String = buff.GetResourceName_string();
            params = [loca.FormatNumber(buff.GetAmount()), resource];
            if (key == defines.ADVENTURE_BUFF)
            {
                key = resource;
                group = LOCA_GROUP.ADVENTURE_OPENER;
            }
            else if (key.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
            {
                key = defines.CHANGE_COLOR_SCHEME_BUFF + "_" + resource;
            }
            else if (key == defines.FILL_DEPOSIT_BUFF && (resource == "" || resource == defines.FILL_DEPOSIT_BUFF))
            {
                key += "Any";
            };
        };
        // Resolve on search so language and amount changes cannot stale the description.
        if (!key || !loca.exist(group, key))
        {
            return false;
        };
        var description:String = loca.GetText(group, key, params);
        return description.replace(replacePattern, "").toLocaleLowerCase().indexOf(_arg_1) > -1;
    }

    /*private*/ function getEffectType(_arg_1:String):String
    {
        var _local_2:String;
        for (_local_2 in EFFECT_TYPES)
        {
            if (_arg_1.indexOf(_local_2) == 0)
            {
                return (_local_2);
            };
        };
        return ("null");
    }

    public function update(_arg_1:Object):void
    {
        if ((_arg_1 is cSpecialist))
        {
            this.Name = (_arg_1 as cSpecialist).getName(false).replace(replacePattern, "").toLocaleLowerCase();
            this.Amount = 1;
        }
        else
        {
            this.Amount = (_arg_1 as cBuff).GetAmount();
        };
    }


}



