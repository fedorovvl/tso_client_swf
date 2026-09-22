package GUI.Components
{
    import mx.controls.Text;
    import mx.events.FlexEvent;

    public class CustomText extends Text 
    {

        private const PADDING:int = 5;

        private var _autoSize:String;
        private var _wordWrap:Boolean = true;

        public function CustomText()
        {
            super();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete, false, 0, true);
        }

        public function set autoSize(_arg_1:String):void
        {
            this._autoSize = _arg_1;
            if (textField != null)
            {
                textField.autoSize = _arg_1;
            };
        }

        private function handleCreationComplete(_arg_1:FlexEvent):void
        {
            this.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
            this.setProperties();
        }

        public function set wordWrap(_arg_1:Boolean):void
        {
            this._wordWrap = _arg_1;
            if (textField != null)
            {
                textField.wordWrap = _arg_1;
            };
        }

        public function getTextHeight():int
        {
            return ((textField) ? (textField.textHeight + this.PADDING) : 0);
        }

        public function get autoSize():String
        {
            return (this._autoSize);
        }

        public function get wordWrap():Boolean
        {
            return (this._wordWrap);
        }

        private function setProperties():void
        {
            if (textField != null)
            {
                textField.wordWrap = this._wordWrap;
                if (this._autoSize != null)
                {
                    textField.autoSize = this._autoSize;
                };
            };
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
            this.setProperties();
        }


    }
}
