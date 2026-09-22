package GUI.Components
{
    import mx.controls.Label;
    import mx.controls.HRule;
    import flash.text.TextLineMetrics;

    public class CustomLabel extends Label 
    {

        private var _lineThrough:Boolean = false;
        private var _lineThroughHR:HRule = null;


        public function get lineThrough():Boolean
        {
            return (this._lineThrough);
        }

        public function set lineThrough(_arg_1:Boolean):void
        {
            this._lineThrough = _arg_1;
            invalidateProperties();
        }

        override protected function commitProperties():void
        {
            var _local_1:TextLineMetrics;
            super.commitProperties();
            if (((!(this._lineThroughHR)) && (this._lineThrough)))
            {
                this._lineThroughHR = new HRule();
                addChild(this._lineThroughHR);
            }
            else
            {
                if (((this._lineThroughHR) && (!(this._lineThrough))))
                {
                    removeChild(this._lineThroughHR);
                    this._lineThroughHR = null;
                };
            };
            if (this._lineThroughHR)
            {
                _local_1 = this.getLineMetrics(0);
                this._lineThroughHR.height = Math.ceil((_local_1.height * 0.1));
                this._lineThroughHR.setStyle("strokeColor", 0xFF0000);
                this._lineThroughHR.setStyle("shadowColor", 0xFF0000);
                this._lineThroughHR.x = (_local_1.x - 2);
                this._lineThroughHR.y = ((_local_1.ascent * 0.8) - (this._lineThroughHR.height / 2));
                this._lineThroughHR.width = (_local_1.width + 4);
            };
        }


    }
}
