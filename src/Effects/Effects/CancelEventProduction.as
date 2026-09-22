package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import __AS3__.vec.Vector;
    import TimedProduction.cTimedProduction;
    import TimedProduction.cTimedProductionQueue;
    import nLib.cLog;
    import Enums.TIMED_PRODUCTION_TYPE;
    import Communication.VO.collectibles.CollectionVO;
    import TimedProduction.EffectTimedProductionDefinition;
    import Utils.StringUtils;
    import __AS3__.vec.*;

    public final class CancelEventProduction extends Effect 
    {

        public static const XML_string:String = "canceleventprod";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:Vector.<cTimedProduction>;
            var _local_2:cTimedProductionQueue;
            var _local_3:cTimedProduction;
            var _local_4:cTimedProduction;
            var _local_5:String;
            if (cLog.isInfoEnabled())
            {
                cLog.info(("CancelEventProduction.action() " + effect));
            };
            if (effect.name_string != null)
            {
                _local_1 = new Vector.<cTimedProduction>();
                _local_2 = gi.mCurrentPlayerZone.GetProductionQueue(TIMED_PRODUCTION_TYPE.fromString(effect.type_string));
                for each (_local_3 in _local_2.mTimedProductions_vector)
                {
                    _local_5 = null;
                    if ((_local_3.GetProductionOrder().GetDefinition() is CollectionVO))
                    {
                        _local_5 = (_local_3.GetProductionOrder().GetDefinition() as CollectionVO).GetProductionName_string();
                    }
                    else
                    {
                        if ((_local_3.GetProductionOrder().GetDefinition() is EffectTimedProductionDefinition))
                        {
                            _local_5 = ("" + (_local_3.GetProductionOrder().GetDefinition() as EffectTimedProductionDefinition).GetProductionName_string());
                        };
                    };
                    if ((((!(_local_5 == null)) && (!(StringUtils.isEmpty(_local_5)))) && (_local_5 == effect.name_string)))
                    {
                        _local_1.push(_local_3);
                    };
                };
                for each (_local_4 in _local_1)
                {
                    gi.mCurrentPlayerZone.GetProductionQueue(_local_4.GetProductionType()).cancelProduction(_local_4.GetUniqueID(), true, gi.mCurrentPlayer);
                };
            };
        }


    }
}
