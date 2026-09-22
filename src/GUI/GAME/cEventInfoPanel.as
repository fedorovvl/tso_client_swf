package GUI.GAME
{
    import GUI.Loca.cLocaManager;
    import GUI.Components.EventInfoPanel;
    import flash.utils.Timer;
    import Events.dEventVO;
    import Events.EventButtonData;
    import flash.events.MouseEvent;
    import GUI.Components.EventButton;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import GUI.LoadingScreen.LoadingScreenLoca;
    import flash.display.Bitmap;
    import GUI.ApplicationFacade;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import flash.events.TimerEvent;
    import GUI.Components.CustomText;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Utils.StringUtils;
    import nLib.gMisc;
    import flash.utils.getTimer;

    public class cEventInfoPanel extends cBasicPanel 
    {

        private const TIP_DURATION:int = 10000;

        private var lm:cLocaManager;
        private var clickWindowName:String;
        private var clickWindowItem:String;
        private var mMessageDuration:int = 10000;
        private var mPanel:EventInfoPanel;
        private var eventsData:Array;
        private var mTipChanged:Number;
        private var mPreviousMessage:int = 0;
        private var mLoadingMessageChanged:Number;
        private var currentEventIndex:int = 0;
        private var mTipTimer:Timer;
        private var mPreviousTip:int = 0;


        public function SelectEventByName(_arg_1:String):void
        {
            var _local_3:dEventVO;
            var _local_2:int;
            for each (_local_3 in this.eventsData)
            {
                if (_local_3.event_name_string == _arg_1)
                {
                    this.SelectEventByIndex(_local_2);
                };
                _local_2++;
            };
        }

        private function SelectEventByIndex(_arg_1:int):void
        {
            if (((_arg_1 >= 0) && (_arg_1 < this.eventsData.length)))
            {
                this.currentEventIndex = _arg_1;
                this.setCurrentEvent(this.eventsData[_arg_1]);
            };
        }

        public function disabledEventButtons():void
        {
            var _local_2:EventButtonData;
            var _local_1:Array = new Array();
            for each (_local_2 in this.mPanel.buttonList.dataProvider)
            {
                _local_2.enabled = false;
                _local_1.push(_local_2);
            };
            this.mPanel.buttonList.dataProvider = _local_1;
        }

        protected function btnLinkClickHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.OpenWindow(this.clickWindowName, this.clickWindowItem);
        }

        public function StartLoadingInfoState():void
        {
            this.mPanel.titleLabel.text = "";
            this.mPanel.timeRemaining.visible = false;
            this.mPanel.leftArrowCanvas.visible = false;
            this.mPanel.rightArrowCanvas.visible = false;
            this.mPanel.btnClose.enabled = false;
            this.SetRandomTip();
            this.mTipTimer.start();
            var _local_1:EventButtonData = new EventButtonData();
            _local_1.icon = "ChangeLogIcon";
            _local_1.name = EventButton.CHANGELOG;
            _local_1.tooltip = "changelog";
            _local_1.enabled = true;
            var _local_2:EventButtonData = new EventButtonData();
            _local_2.icon = "ButtonIconOK";
            _local_2.name = "CLOSE_WINDOW";
            _local_2.tooltip = "Ok";
            _local_2.enabled = false;
            this.mPanel.buttonList.dataProvider = [_local_1, _local_2];
            this.mPanel.pulsate.play();
            this.getLoadingBanner();
            this.mPanel.topBannerImage.source = this.getLoadingBanner();
            this.Show();
        }

        public function SetEvents(_arg_1:Array):void
        {
            if (_arg_1.length > 0)
            {
                this.eventsData = _arg_1;
                this.currentEventIndex = 0;
                this.eventsData.sortOn("prio", Array.NUMERIC);
                this.SelectEventByIndex(0);
                if (this.eventsData.length < 2)
                {
                    this.mPanel.leftArrowCanvas.visible = false;
                    this.mPanel.rightArrowCanvas.visible = false;
                }
                else
                {
                    this.mPanel.leftArrowCanvas.visible = true;
                    this.mPanel.rightArrowCanvas.visible = true;
                };
            };
        }

        protected function rightArrowClickHandler(_arg_1:MouseEvent):void
        {
            if (this.currentEventIndex == (this.eventsData.length - 1))
            {
                this.currentEventIndex = 0;
            }
            else
            {
                this.currentEventIndex++;
            };
            this.SelectEventByIndex(this.currentEventIndex);
            this.enableEventButtons();
        }

        protected function eventButtonClickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:EventButtonData;
            if ((_arg_1.target.data is EventButtonData))
            {
                _local_2 = (_arg_1.target.data as EventButtonData);
                if (_local_2.name == EventButton.CHANGELOG)
                {
                    if (global.changeLogUrl.charAt(0) == "/")
                    {
                        navigateToURL(new URLRequest((global.baseUri + global.changeLogUrl)), "_blank");
                    }
                    else
                    {
                        navigateToURL(new URLRequest(global.changeLogUrl), "_blank");
                    };
                }
                else
                {
                    if (_local_2.name == EventButton.EXTERNAL_SITE)
                    {
                        if (_local_2.url.charAt(0) == "/")
                        {
                            navigateToURL(new URLRequest((global.baseUri + _local_2.url)), "_blank");
                        }
                        else
                        {
                            navigateToURL(new URLRequest(_local_2.url), "_blank");
                        };
                    }
                    else
                    {
                        if (_local_2.name == EventButton.PROMOCODE)
                        {
                            if (global.promoCodeUrl.charAt(0) == "/")
                            {
                                navigateToURL(new URLRequest((global.baseUri + global.promoCodeUrl)), "_blank");
                            }
                            else
                            {
                                navigateToURL(new URLRequest(global.promoCodeUrl), "_blank");
                            };
                        }
                        else
                        {
                            if (_local_2.name == EventButton.WEB_SHOP)
                            {
                                navigateToURL(new URLRequest((global.baseUri + defines.PAYMENT_URL)), "_blank");
                                global.ui.mClientMessages.sendClientUITrack(defines.TRACK_WEBSHOP, defines.TRACK_WEBSHOP_WIDGET, 0);
                            }
                            else
                            {
                                if (_local_2.name == "GAMESTATE_ID_SHOP_WINDOW")
                                {
                                    globalFlash.gui.mShopWindow.origin = defines.TRANSACTION_FROM_WIDGET;
                                };
                                globalFlash.gui.mEventInfoPanel.Hide();
                                globalFlash.gui.OpenWindow(_arg_1.target.data.name, _arg_1.target.data.item);
                            };
                        };
                    };
                };
            };
        }

        private function getLoadingBanner():Bitmap
        {
            var _local_1:String;
            var _local_2:Boolean;
            if (global.getApplication().parameters.hasOwnProperty("realmLang"))
            {
                _local_1 = global.getApplication().parameters["realmLang"];
            };
            if (((_local_1 == null) || (_local_1 == "")))
            {
                _local_1 = defines.REALM_LANGUAGE;
            };
            if (global.getApplication().parameters.hasOwnProperty("realmBeta"))
            {
                _local_2 = ((global.getApplication().parameters["realmBeta"] == "true") || (global.getApplication().parameters["realmBeta"] == "1"));
            }
            else
            {
                _local_2 = defines.REALM_BETA_STATE;
            };
            return (LoadingScreenLoca.getLogoBitmap(global.loadingScreen, _local_1, _local_2));
        }

        protected function leftArrowClickHandler(_arg_1:MouseEvent):void
        {
            if (this.currentEventIndex == 0)
            {
                this.currentEventIndex = (this.eventsData.length - 1);
            }
            else
            {
                this.currentEventIndex--;
            };
            this.SelectEventByIndex(this.currentEventIndex);
            this.enableEventButtons();
        }

        protected function closeButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        override public function Show():void
        {
            super.Show();
            global.hasEventInfoPanelBeenShown = true;
        }

        public function StartEventInfoState():void
        {
            this.enableEventButtons();
            if (((!(this.eventsData == null)) && (this.eventsData.length > 0)))
            {
                this.mPanel.timeRemaining.visible = true;
                if (this.eventsData.length > 2)
                {
                    this.mPanel.leftArrowCanvas.visible = true;
                    this.mPanel.rightArrowCanvas.visible = true;
                };
            };
            this.mPanel.btnClose.enabled = true;
            this.mPanel.pulsate.stop();
            ApplicationFacade.getInstance().sendNotification(AvatarSelectionPanel.CHECK_SHOW, global.ui);
        }

        protected function tipTimerTickHandler(_arg_1:TimerEvent):void
        {
            this.SetRandomTip();
        }

        override public function Hide():void
        {
            super.Hide();
            globalFlash.gui.mAvatarMessageList.ActivateMessages();
        }

        private function setCurrentEvent(_arg_1:dEventVO):void
        {
            var _local_3:CustomText;
            var _local_4:Bitmap;
            this.mPanel.bulletList.removeAllChildren();
            if (this.eventsData.length == 1)
            {
                this.mPanel.titleLabel.text = this.lm.GetText(LOCA_GROUP.DESCRIPTIONS, (_arg_1.event_name_string + "_Title"));
            }
            else
            {
                this.mPanel.titleLabel.text = ((((this.lm.GetText(LOCA_GROUP.DESCRIPTIONS, (_arg_1.event_name_string + "_Title")) + " ") + (this.currentEventIndex + 1).toString()) + "/") + this.eventsData.length.toString());
            };
            this.mPanel.topBannerImage.source = gAssetManager.GetClass(_arg_1.event_name_string);
            this.mPanel.timeRemaining.SetDates(_arg_1.startDate, _arg_1.stopDate);
            this.mPanel.descriptionLabel.text = this.lm.GetText(LOCA_GROUP.DESCRIPTIONS, (_arg_1.event_name_string + "_Description"));
            this.mPanel.topBannerImage.source = (("event_banners//" + _arg_1.bannerImageString) + ".png");
            this.clickWindowName = _arg_1.clickWindowName;
            this.clickWindowItem = _arg_1.clickWindowItem;
            var _local_2:int;
            while (_local_2 < _arg_1.numberOfDescriptionItems)
            {
                _local_3 = new CustomText();
                _local_3.setStyle("color", 0xFFFF00);
                _local_3.setStyle("textAlign", "center");
                _local_3.setStyle("width", "100%");
                _local_3.percentWidth = 100;
                _local_3.text = this.lm.GetText(LOCA_GROUP.DESCRIPTIONS, ((_arg_1.event_name_string + "_DescItem_") + (_local_2 + 1).toString()));
                this.mPanel.bulletList.addChild(_local_3);
                _local_2++;
            };
            this.mPanel.buttonList.dataProvider = _arg_1.eventPanelButtons;
            this.mTipTimer.stop();
            this.mPanel.happyHourNumber.visible = false;
            if (StringUtils.contains("HappyHour", _arg_1.event_name_string))
            {
                _local_4 = gAssetManager.GetBitmapModifier(_arg_1.percentage, "percent");
                this.mPanel.happyHourNumber.source = _local_4;
                this.mPanel.happyHourVisible(true);
            };
            this.enableEventButtons();
        }

        private function SetRandomTip():void
        {
            var _local_2:String;
            var _local_1:int = gMisc.GetRandomMinMaxInt(1, global.tipOfTheDayCount);
            while (_local_1 == this.mPreviousTip)
            {
                _local_1 = gMisc.GetRandomMinMaxInt(1, global.tipOfTheDayCount);
            };
            if (_local_1 < 10)
            {
                _local_2 = ("TipOfTheDay0" + _local_1);
            }
            else
            {
                _local_2 = ("TipOfTheDay" + _local_1);
            };
            this.mPanel.descriptionLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mTipChanged = getTimer();
            this.mPreviousTip = _local_1;
        }

        public function enableEventButtons():void
        {
            var _local_2:EventButtonData;
            var _local_1:Array = new Array();
            for each (_local_2 in this.mPanel.buttonList.dataProvider)
            {
                _local_2.enabled = true;
                _local_1.push(_local_2);
            };
            this.mPanel.buttonList.dataProvider = _local_1;
        }

        public function Refresh():void
        {
            this.SetEvents(global.ui.mEventManager.GetActiveVisibleEvents());
        }

        public function Init(_arg_1:EventInfoPanel):void
        {
            this.mPanel = _arg_1;
            this.lm = cLocaManager.GetInstance();
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closeButtonClickHandler);
            this.mPanel.leftArrow.addEventListener(MouseEvent.CLICK, this.leftArrowClickHandler);
            this.mPanel.rightArrow.addEventListener(MouseEvent.CLICK, this.rightArrowClickHandler);
            this.mPanel.buttonList.addEventListener(MouseEvent.CLICK, this.eventButtonClickHandler);
            this.mTipTimer = new Timer(this.TIP_DURATION, 0);
            this.mTipTimer.addEventListener(TimerEvent.TIMER, this.tipTimerTickHandler);
            this.Refresh();
        }


    }
}
