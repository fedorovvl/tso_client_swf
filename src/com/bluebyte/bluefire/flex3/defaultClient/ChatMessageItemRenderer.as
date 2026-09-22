package com.bluebyte.bluefire.flex3.defaultClient
{
    import mx.controls.Text;
    import flash.text.StyleSheet;
    import mx.formatters.DateFormatter;
    import mx.styles.CSSStyleDeclaration;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import flash.text.TextFormat;
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
    import flash.debugger.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class ChatMessageItemRenderer extends Text 
    {

        public static var STYLESHEET:StyleSheet;
        private static const STYLE_CACHE:Object = new Object();
        private static var formatter:DateFormatter = new DateFormatter();

        public function ChatMessageItemRenderer()
        {
            super();
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.paddingLeft = -2;
                this.paddingTop = -2;
                this.paddingBottom = -5;
            };
        }

        override public function initialize():void
        {
            super.initialize();
        }

        override public function set data(_arg_1:Object):void
        {
            var _local_2:MessageVO;
            var _local_6:TextFormat;
            if (this.data == _arg_1)
            {
                return;
            };
            super.data = _arg_1;
            if (_arg_1 == null)
            {
                return;
            };
            _local_2 = (_arg_1 as MessageVO);
            formatter.formatString = "JJ:NN";
            var _local_3:int;
            var _local_4:int;
            if (_local_2.time != null)
            {
                text = (("[" + formatter.format(_local_2.time)) + "] ");
            }
            else
            {
                text = "[--:--] ";
            };
            _local_3 = this.text.length;
            var _local_5:String = _local_2.sender.name;
            text = (text + (_local_5 + ":"));
            _local_4 = this.text.length;
            text = (text + (" " + _local_2.text));
            this.validateNow();
            if (_local_2.ownname)
            {
                _local_6 = this.getTextStyle(".ownname");
                this.textField.setTextFormat(_local_6, _local_4, this.text.length);
            }
            else
            {
                if (_local_2.moderator)
                {
                    _local_6 = this.getTextStyle(".moderator");
                    this.textField.setTextFormat(_local_6, _local_4, this.text.length);
                }
                else
                {
                    if (_local_2.important)
                    {
                        _local_6 = this.getTextStyle(".important");
                        this.textField.setTextFormat(_local_6, _local_4, this.text.length);
                    };
                };
            };
            this.validateNow();
        }

        private function getTextStyle(_arg_1:String):TextFormat
        {
            var _local_4:String;
            var _local_2:TextFormat = STYLE_CACHE[_arg_1];
            if (_local_2)
            {
                return (_local_2);
            };
            var _local_3:Object = ChatMessageItemRenderer.STYLESHEET.getStyle(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = _local_3.color;
                if (((!(_local_4 == null)) && (_local_4.indexOf("#") == 0)))
                {
                    _local_3.color = ("0x" + _local_4.substr(1));
                };
                _local_2 = new TextFormat(_local_3.fontFamily, _local_3.fontSize, _local_3.color, (_local_3.fontWeight == "bold"), (_local_3.fontStyle == "italic"), (_local_3.textDecoration == "underline"), _local_3.url, _local_3.target, _local_3.textAlign, _local_3.marginLeft, _local_3.marginRight, _local_3.indent, _local_3.leading);
                if (_local_3.hasOwnProperty("letterSpacing"))
                {
                    _local_2.letterSpacing = _local_3.letterSpacing;
                };
            };
            STYLE_CACHE[_arg_1] = _local_2;
            return (_local_2);
        }


    }
}
