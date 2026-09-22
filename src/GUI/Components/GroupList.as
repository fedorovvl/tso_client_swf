package GUI.Components
{
    import mx.containers.VBox;
    import mx.events.EffectEvent;
    import flash.geom.Point;
    import com.gskinner.motion.GTween;
    import flash.display.Sprite;
    import mx.core.Container;

    public class GroupList extends VBox 
    {

        public function GroupList()
        {
            super();
            this.addEventListener(EffectEvent.EFFECT_START, this.scrollToItem);
        }

        public static function scrollToItemInList(_arg_1:Sprite, _arg_2:Container):void
        {
            var _local_3:Number;
            var _local_5:Point;
            if (_arg_1.parent == _arg_2)
            {
                _local_3 = _arg_1.y;
            }
            else
            {
                _local_5 = _arg_2.globalToLocal(_arg_1.parent.localToGlobal(new Point(_arg_1.x, _arg_1.y)));
                _local_3 = (_arg_2.verticalScrollPosition + _local_5.y);
            };
            var _local_4:GTween = new GTween(_arg_2, 0.3, {"verticalScrollPosition":_local_3});
        }


        protected function scrollToItem(_arg_1:EffectEvent):void
        {
            _arg_1.stopPropagation();
            var _local_2:Sprite = (_arg_1.target as Sprite);
            scrollToItemInList(_local_2, this);
        }


    }
}
