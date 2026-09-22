package GUI.Components
{
    import mx.controls.CheckBox;
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

    public class ColorCheckBox extends CheckBox 
    {

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox_colors_active_mouseover.png")]
        private var _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_mouseover_png_723025109:Class;

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox_colors_active.png")]
        private var _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_png_1542596821:Class;

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox_colors_inactive_mouseover.png")]
        private var _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_mouseover_png_346088085:Class;

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox_colors_inactive.png")]
        private var _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_png_1629475019:Class;

        public function ColorCheckBox()
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
                this.upIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_png_1542596821;
                this.overIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_mouseover_png_723025109;
                this.downIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_mouseover_png_346088085;
                this.selectedUpIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_png_1629475019;
                this.selectedOverIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_mouseover_png_346088085;
                this.selectedDownIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_mouseover_png_723025109;
                this.disabledIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_active_png_1542596821;
                this.selectedDisabledIcon = _embed_mxml_____data_src_gfx_embedded_checkbox_checkbox_colors_inactive_png_1629475019;
            };
            this.addEventListener("toolTipCreate", this.___ColorCheckBox_CheckBox1_toolTipCreate);
        }

        override public function initialize():void
        {
            super.initialize();
        }

        public function ___ColorCheckBox_CheckBox1_toolTipCreate(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
        }


    }
}
