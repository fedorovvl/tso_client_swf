package Collections
{
    import GUI.Components.Frame;
    import Enums.BUFF_TYPE;
    import Communication.VO.collectibles.CollectionVO;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import GUI.Components.ItemRenderer.StarMenuItemRenderer;
    import BuffSystem.cBuff;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.dUniqueID;
    import Communication.VO.dBuffVO;
    import Communication.VO.dResourceVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Communication.VO.dSpecialistVO;
    import Specialists.cSpecialist;
    import flash.display.DisplayObject;
    import flash.display.*;
    import GUI.Components.*;

    public class CollectionUtils 
    {

        private static const ONE_THOUSAND:int = 1000;
        private static const ONE_THOUSAND_SUFFIX:String = "k";


        public static function createCollectionRewardFrame(_arg_1:CollectionVO, _arg_2:DisplayObjectContainer, _arg_3:Point):Frame
        {
            var _local_4:Frame = new Frame();
            _local_4.contentType = Frame.CONTENT_TYPE_BUFF;
            switch (global.map_BuffName_BuffDefinition[_arg_1.getOutputBuffName()].GetBuffType())
            {
                case BUFF_TYPE.INSTANT:
                    _local_4.type = Frame.BUFF_INSTANT;
                    break;
                case BUFF_TYPE.TIMED:
                    _local_4.type = Frame.BUFF_TIMED;
                    break;
                case BUFF_TYPE.UPGRADE:
                    _local_4.type = Frame.BUFF_UPGRADE;
                    break;
                case BUFF_TYPE.ZONE:
                    _local_4.type = Frame.BUFF_TIMED;
                    break;
            };
            _local_4.content = _arg_1.getOutputBuffName();
            _local_4.x = _arg_3.x;
            _local_4.y = _arg_3.y;
            _arg_2.addChild(_local_4);
            _local_4.visible = false;
            _local_4.includeInLayout = false;
            return (_local_4);
        }

        public static function createRewardItem(_arg_1:CollectionVO, _arg_2:DisplayObjectContainer, _arg_3:Point):StarMenuItemRenderer
        {
            var _local_4:StarMenuItemRenderer = new StarMenuItemRenderer();
            var _local_5:cBuffDefinition = cBuff.getBuffDefinitionByName(_arg_1.getOutputBuffName());
            _local_4.data = new cBuff(_local_5, new dUniqueID(), Math.max(1, _local_5.GetAmount()));
            _local_4.x = _arg_3.x;
            _local_4.y = _arg_3.y;
            _arg_2.addChild(_local_4);
            _local_4.visible = false;
            _local_4.includeInLayout = false;
            return (_local_4);
        }

        public static function formatNumberToThousands(_arg_1:int):String
        {
            if (_arg_1 >= ONE_THOUSAND)
            {
                return (Math.floor((_arg_1 / ONE_THOUSAND)).toString() + ONE_THOUSAND_SUFFIX);
            };
            return (_arg_1.toString());
        }

        public static function createItemRendererFromVO(vo:*):DisplayObject
        {
            var frame:Frame;
            var item:* = undefined;
            var renderer:StarMenuItemRenderer;
            var buffVO:dBuffVO;
            if (((vo is dResourceVO) && ((vo.name_string == "XP") || (vo.name_string == defines.PVP_XP_string))))
            {
                frame = new Frame();
                frame.contentType = Frame.CONTENT_TYPE_RESOURCE;
                frame.amount = vo.amount;
                frame.content = vo.name_string;
                frame.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, vo.name_string);
                frame.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, function (_arg_1:ToolTipEvent):void
                {
                    cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
                });
                return (frame);
            };
            if ((vo is dBuffVO))
            {
                buffVO = (vo as dBuffVO);
                item = cBuff.CreateBuffFromVO(buffVO);
            }
            else
            {
                if ((vo is dSpecialistVO))
                {
                    item = cSpecialist.CreateSpecialistFromVO(global.getApplication().mGameInterface, vo, false);
                };
            };
            renderer = new StarMenuItemRenderer();
            renderer.data = item;
            renderer.flyToTarget = CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER;
            return (renderer);
        }


    }
}
