package GUI.Components
{
    import mx.controls.Label;
    import mx.styles.CSSStyleDeclaration;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.PropertyChangeEvent;
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

    public class PagerControl_inlineComponent1 extends Label 
    {

        private var _88844982outerDocument:PagerControl;

        public function PagerControl_inlineComponent1()
        {
            super();
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.color = 0xFFFFFF;
            };
            this.useHandCursor = true;
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener("click", this.___PagerControl_inlineComponent1_Label1_click);
        }

        public function ___PagerControl_inlineComponent1_Label1_click(_arg_1:MouseEvent):void
        {
            this.label1_clickHandler(_arg_1);
        }

        protected function label1_clickHandler(_arg_1:MouseEvent):void
        {
            if (data.page > -1)
            {
                dispatchEvent(new ListEvent("labelClicked", true, false, data.page));
            };
        }

        override public function initialize():void
        {
            super.initialize();
        }

        override public function set data(_arg_1:Object):void
        {
            super.data = _arg_1;
            setStyle("fontWeight", ((data["selected"]) ? "bold" : "normal"));
            text = data["label"];
            toolTip = ((data["page"] > -1) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ShowPage", [data["label"]]) : null);
        }

        [Bindable(event="propertyChange")]
        public function get outerDocument():PagerControl
        {
            return (this._88844982outerDocument);
        }

        public function set outerDocument(_arg_1:PagerControl):void
        {
            var _local_2:Object = this._88844982outerDocument;
            if (_local_2 !== _arg_1)
            {
                this._88844982outerDocument = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "outerDocument", _local_2, _arg_1));
            };
        }


    }
}
