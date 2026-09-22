package GUI
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import GUI.Components.Frame;
    import Collections.CollectionsConsts;
    import flash.display.Bitmap;
    import com.gskinner.motion.GTween;
    import com.gskinner.motion.easing.Sine;
    import mx.events.FlexEvent;
    import flash.utils.setTimeout;
    import flash.geom.Point;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import com.gskinner.motion.easing.Back;
    import nLib.cLog;
    import com.bluebyte.client.particle.follow.StarRover;
    import Collections.CollectionUtils;
    import __AS3__.vec.*;

    public class FloatingItemsManager 
    {

        private static var stack:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private static const dummyBMD:BitmapData = new BitmapData(10, 10, true, 0);


        public static function flyRewards(_arg_1:Array):void
        {
            var _local_2:Frame;
            var _local_3:String;
            for each (_local_2 in _arg_1)
            {
                if (_local_2.isMovable)
                {
                    switch (_local_2.contentType)
                    {
                        case Frame.CONTENT_TYPE_RESOURCE:
                            _local_3 = null;
                            switch (_local_2.content)
                            {
                                case "XP":
                                case "PvPXP":
                                    _local_3 = "GAMESTATE_ID_AVATAR.animXP";
                                    break;
                                case "Population":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIconPopulation";
                                    break;
                                case "HardCurrency":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIconHardCurrency";
                                    break;
                                case "Tool":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon1";
                                    break;
                                case "Coin":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon2";
                                    break;
                                case "Plank":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon3";
                                    break;
                                case "RealPlank":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon4";
                                    break;
                                case "Stone":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon5";
                                    break;
                                case "Marble":
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.resourceIcon6";
                                    break;
                                default:
                                    _local_3 = "GAMESTATE_ID_INFO_BAR.infoBarMiddle";
                            };
                            FloatingItemsManager.createJumpFlyDestroy(_local_2.framedIcon, _local_3);
                            break;
                        case Frame.CONTENT_TYPE_ADVENTURE:
                        case Frame.CONTENT_TYPE_BUFF:
                        case Frame.CONTENT_TYPE_DEPOSIT_BUFF:
                        case Frame.CONTENT_TYPE_BUILDING:
                        case Frame.CONTENT_TYPE_NORMAL:
                            FloatingItemsManager.createJumpFlyDestroy(_local_2, CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                            break;
                        case Frame.CONTENT_TYPE_UNLOCK:
                            FloatingItemsManager.fadeOutWithStars(_local_2);
                            break;
                    };
                };
            };
        }

        public static function fadeOutWithStars(_arg_1:DisplayObject):void
        {
            var _local_2:Bitmap = createFloatingItem(_arg_1);
            new GTween(_local_2, 2, {"alpha":0}, {
                "ease":Sine.easeIn,
                "onComplete":destroyItem
            });
        }

        private static function onLootItemRendererDisplayed(_arg_1:FlexEvent):void
        {
            _arg_1.target.removeEventListener(FlexEvent.DATA_CHANGE, onLootItemRendererDisplayed);
            setTimeout(makeItemRendererFly, 1000, _arg_1.target);
        }

        private static function calculateTargetPoint(_arg_1:String, _arg_2:Point=null):Point
        {
            var _local_3:DisplayObject;
            if (_arg_2 == null)
            {
                _arg_2 = new Point();
            };
            _local_3 = global.getApplication().getGUIItem(_arg_1);
            if (_local_3 == null)
            {
                _local_3 = global.getApplication().stage;
            };
            var _local_4:Point = _local_3.localToGlobal(new Point());
            _local_4.x = (_local_4.x + int(((_local_3.width / 2) + _arg_2.x)));
            _local_4.y = (_local_4.y + int(((_local_3.height / 2) + _arg_2.y)));
            return (_local_4);
        }

        public static function jumpOutsideWindow(_arg_1:DisplayObject, _arg_2:DisplayObject):void
        {
            var _local_3:Point = new Point(((Math.random() * (_arg_2.x - 20)) + 20), ((Math.random() * _arg_2.height) + _arg_2.y));
            var _local_4:Bitmap = createFloatingItem(_arg_1);
            jumpTo(_local_4, _local_3, stackItem);
        }

        public static function spawnLootedItemsSequentially(_arg_1:dLootItemsVO, _arg_2:Number, _arg_3:Number):void
        {
            var _local_5:*;
            var _local_4:int;
            for each (_local_5 in _arg_1.items)
            {
                setTimeout(spawnLootItem, (_arg_3 + (_arg_2 * _local_4)), _local_5);
                _local_4++;
            };
            for each (_local_5 in _arg_1.premiumItems)
            {
                setTimeout(spawnLootItem, (_arg_3 + (_arg_2 * _local_4)), _local_5);
                _local_4++;
            };
        }

        private static function jumpTo(_arg_1:DisplayObject, _arg_2:Point, _arg_3:Function=null, _arg_4:int=0):void
        {
            _arg_2.x = (_arg_2.x - int((_arg_1.width / 2)));
            _arg_2.y = (_arg_2.y - int((_arg_1.height / 2)));
            new GTween(_arg_1, 0.4, {"x":_arg_2.x}, {"ease":Sine.easeIn});
            new GTween(_arg_1, 0.4, {"y":_arg_2.y}, {
                "ease":Back.easeIn,
                "delay":_arg_4,
                "onComplete":_arg_3
            });
        }

        private static function destroyItem(_arg_1:GTween):void
        {
            _arg_1.suppressEvents = true;
            global.getApplication().stage.removeChild((_arg_1.target as DisplayObject));
        }

        private static function flyTo(_arg_1:DisplayObject, _arg_2:Point, _arg_3:Function, _arg_4:int=0):void
        {
            new GTween(_arg_1, 1.2, {
                "x":(_arg_2.x - (_arg_1.width / 2)),
                "y":(_arg_2.y - (_arg_1.height / 2))
            }, {
                "ease":Sine.easeInOut,
                "delay":_arg_4,
                "onComplete":_arg_3
            });
        }

        private static function makeItemRendererFly(_arg_1:DisplayObject):void
        {
            createJumpFlyDestroy(_arg_1, CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER, null, null, true);
            global.getApplication().isoengine.removeChild(_arg_1);
        }

        private static function fadeOut(_arg_1:GTween):void
        {
            new GTween(_arg_1.target, 0.3, {"alpha":0}, {
                "ease":Sine.easeIn,
                "onComplete":destroyItem
            });
        }

        private static function createFloatingItem(from:DisplayObject, sourcePoint:Point=null):Bitmap
        {
            var bmd:BitmapData = dummyBMD;
            try
            {
                bmd = new BitmapData(from.width, from.height, true, 0);
            }
            catch(error:Error)
            {
                cLog.error((((("Create new BitmapData for Floating Element Error. W: " + from.width) + " H: ") + from.height) + error.getStackTrace()));
            };
            bmd.draw(from);
            var item:Bitmap = new Bitmap(bmd);
            if (sourcePoint == null)
            {
                if (from.stage == null)
                {
                    sourcePoint = new Point(global.screenWidthHalf, global.screenHeightHalf);
                }
                else
                {
                    sourcePoint = from.localToGlobal(new Point());
                };
            };
            item.x = sourcePoint.x;
            item.y = sourcePoint.y;
            global.getApplication().stage.addChild(item);
            new StarRover(item);
            return (item);
        }

        private static function spawnLootItem(_arg_1:*):void
        {
            var _local_2:* = 250;
            var _local_3:DisplayObject = CollectionUtils.createItemRendererFromVO(_arg_1);
            _local_3.visible = false;
            _local_3.addEventListener(FlexEvent.DATA_CHANGE, onLootItemRendererDisplayed);
            _local_3.x = ((global.screenWidthHalf + (Math.random() * _local_2)) - (Math.random() * _local_2));
            _local_3.y = ((global.screenHeightHalf + (Math.random() * _local_2)) - (Math.random() * _local_2));
            global.getApplication().isoengine.addChild(_local_3);
        }

        public static function createJumpFlyDestroy(_arg_1:DisplayObject, _arg_2:String, _arg_3:Point=null, _arg_4:Point=null, _arg_5:Boolean=false):void
        {
            var _local_6:Bitmap = createFloatingItem(_arg_1, _arg_4);
            if (_arg_3 == null)
            {
                _arg_3 = calculateTargetPoint(_arg_2, new Point((-(_local_6.width) / 2), (-(_local_6.height) / 2)));
            }
            else
            {
                _arg_3.x = (_arg_3.x - int((_local_6.width / 2)));
                _arg_3.y = (_arg_3.y - int((_local_6.height / 2)));
            };
            var _local_7:Number = (0.2 + Math.random());
            new GTween(_local_6, 0.7, {"x":(_local_6.x + (((Math.random() * 10) - 5) * 20))}, {"ease":Sine.easeIn});
            new GTween(_local_6, 0.7, {"y":(_local_6.y + 60)}, {"ease":Back.easeIn});
            new GTween(_local_6, 1, {
                "x":_arg_3.x,
                "y":_arg_3.y
            }, {
                "ease":Sine.easeInOut,
                "delay":(0.7 + _local_7),
                "onComplete":fadeOut
            });
            if (_arg_5)
            {
                _local_6.alpha = 0;
                new GTween(_local_6, 0.35, {"alpha":1});
            };
        }

        public static function releaseStack(_arg_1:String, _arg_2:Point=null):void
        {
            if (_arg_2 == null)
            {
                _arg_2 = calculateTargetPoint(_arg_1);
            };
            var _local_3:int;
            var _local_4:int = stack.length;
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                flyTo(stack.pop(), _arg_2, fadeOut);
                _local_3++;
            };
        }

        private static function stackItem(_arg_1:GTween):void
        {
            stack.push(DisplayObject(_arg_1.target));
        }


    }
}
