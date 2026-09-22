package GUI.Components
{
    import mx.controls.Label;
    import mx.core.UITextField;
    import flash.display.DisplayObject;
    import flash.text.TextFieldAutoSize;

    public class MultilineLabel extends Label 
    {


        override protected function createChildren():void
        {
            if (!textField)
            {
                textField = new UITextField();
                textField.styleName = this;
                addChild(DisplayObject(textField));
            };
            super.createChildren();
            textField.multiline = true;
            textField.wordWrap = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
        }


    }
}
