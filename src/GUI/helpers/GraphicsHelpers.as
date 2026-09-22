package GUI.helpers
{
    import GUI.vo.UIComponentHeaderVO;
    import Interface.cGeneralInterface;

    public class GraphicsHelpers 
    {


        public static function getUIComponentHeaderClassName(_arg_1:cGeneralInterface, _arg_2:String):String
        {
            var _local_3:UIComponentHeaderVO;
            var _local_4:String;
            for each (_local_3 in global.uiComponentHeaders)
            {
                _local_4 = _local_3.getComponentHeaderClassName(_arg_1, _arg_2);
                if (_local_4 != null)
                {
                    return (_local_4);
                };
            };
            return (null);
        }


    }
}
