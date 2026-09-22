package GUI.Components
{
    import mx.controls.RadioButton;
    import mx.styles.CSSStyleDeclaration;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
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

    public class StandardRadioButton extends RadioButton 
    {

        [Embed(source="../../../assets/embedded/radiobutton/radiobutton_radiobutton_active_mouseover.png")]
        private var _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_active_mouseover_png_602565963:Class;

        [Embed(source="../../../assets/embedded/radiobutton/radiobutton_radiobutton_active.png")]
        private var _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_active_png_267756491:Class;

        [Embed(source="../../../assets/embedded/radiobutton/radiobutton_radiobutton_inactive_mouseover.png")]
        private var _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_inactive_mouseover_png_502390731:Class;

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox01_inactive.png")]
        private var _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_inactive_png_1069701835:Class;

        public function StandardRadioButton()
        {
            super();
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.color = 0xFFFFFF;
                this.textRollOverColor = 0xFFFFFF;
                this.textSelectedColor = 0xFFFFFF;
                this.upIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_inactive_png_1069701835;
                this.overIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_inactive_mouseover_png_502390731;
                this.downIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_active_mouseover_png_602565963;
                this.selectedUpIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_active_png_267756491;
                this.selectedOverIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_active_mouseover_png_602565963;
                this.selectedDownIcon = _embed_mxml_____data_src_gfx_embedded_radiobutton_radiobutton_inactive_mouseover_png_502390731;
            };
            this.addEventListener("toolTipCreate", this.___StandardRadioButton_RadioButton1_toolTipCreate);
        }

        override public function initialize():void
        {
            super.initialize();
        }

        public function ___StandardRadioButton_RadioButton1_toolTipCreate(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
        }


    }
}
