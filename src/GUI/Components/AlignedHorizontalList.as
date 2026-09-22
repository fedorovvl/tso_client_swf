package GUI.Components
{
    import mx.controls.HorizontalList;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.styles.*;
    import flash.text.*;
    import flash.media.*;
    import mx.binding.*;
    import flash.filters.*;
    import flash.utils.*;
    import flash.net.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.ui.*;
    import flash.external.*;
    import flash.desktop.*;
    import flash.data.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.filesystem.*;
    import flash.html.*;
    import flash.html.script.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class AlignedHorizontalList extends HorizontalList 
    {

        public function AlignedHorizontalList()
        {
            super();
            this.horizontalScrollPolicy = "off";
        }

        override public function initialize():void
        {
            super.initialize();
        }

        override protected function measure():void
        {
            super.measure();
            if (this.dataProvider != null)
            {
                this.measuredWidth = (this.measureWidthOfItems(0, this.dataProvider.length) + 5);
                this.measuredMinWidth = 10;
            };
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            super.updateDisplayList(_arg_1, _arg_2);
            invalidateSize();
        }


    }
}
