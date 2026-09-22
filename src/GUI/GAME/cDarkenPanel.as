package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import mx.containers.Canvas;

    public class cDarkenPanel extends cGuiBaseElement 
    {

        protected var mPanel:Canvas;


        public function Init(_arg_1:Canvas):void
        {
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function Show():void
        {
            super.Show();
        }


    }
}
