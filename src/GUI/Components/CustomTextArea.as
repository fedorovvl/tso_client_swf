package GUI.Components
{
    import mx.controls.TextArea;

    public class CustomTextArea extends TextArea 
    {


        override public function setSelection(_arg_1:int, _arg_2:int):void
        {
            super.setSelection(_arg_1, _arg_2);
        }

        public function set leading(_arg_1:String):void
        {
            this.setStyle("leading", _arg_1);
        }

        public function get leading():String
        {
            return (this.getStyle("leading"));
        }


    }
}
