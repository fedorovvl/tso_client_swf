package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import ServerState.cBigBrotherSettings;

    public class StepBigbrother extends BootstrapStep 
    {


        private function _next():void
        {
            next(this);
        }

        override protected function execute():void
        {
            var _local_1:cBigBrotherSettings;
            if (global.useBigBrother)
            {
                _local_1 = new cBigBrotherSettings(this._next);
            }
            else
            {
                this._next();
            };
        }


    }
}
