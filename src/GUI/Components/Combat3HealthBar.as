package GUI.Components
{
    import mx.controls.Image;
    import GUI.Assets.gAssetManager;

    public class Combat3HealthBar extends Image 
    {


        override public function initialize():void
        {
            super.initialize();
        }

        public function set value(_arg_1:Number):void
        {
            if (_arg_1 >= 0)
            {
                if (_arg_1 == 0)
                {
                    source = gAssetManager.GetClass("WinConditionHealthBar1");
                }
                else
                {
                    if (_arg_1 <= (1 / 6))
                    {
                        source = gAssetManager.GetClass("WinConditionHealthBar2");
                    }
                    else
                    {
                        if (_arg_1 <= (2 / 6))
                        {
                            source = gAssetManager.GetClass("WinConditionHealthBar3");
                        }
                        else
                        {
                            if (_arg_1 <= (3 / 6))
                            {
                                source = gAssetManager.GetClass("WinConditionHealthBar4");
                            }
                            else
                            {
                                if (_arg_1 <= (4 / 6))
                                {
                                    source = gAssetManager.GetClass("WinConditionHealthBar5");
                                }
                                else
                                {
                                    if (_arg_1 <= (5 / 6))
                                    {
                                        source = gAssetManager.GetClass("WinConditionHealthBar6");
                                    }
                                    else
                                    {
                                        source = gAssetManager.GetClass("WinConditionHealthBar7");
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }


    }
}
