package GUI.Components
{
    import mx.controls.TextInput;

    public class CustomTextInput extends TextInput 
    {

        public function CustomTextInput()
        {
            super();
            this.tabEnabled = true;
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
