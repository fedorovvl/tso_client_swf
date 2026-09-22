package com.bluebyte.tso.service.services
{
    import com.bluebyte.tso.service.AbstractService;
    import Enums.COMMAND;
    import Communication.VO.PvPCommandVO;
    import com.bluebyte.tso.service.responders.ColonyConquerResponder;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.ColonyCommandVO;
    import com.bluebyte.tso.service.responders.ColonyYieldResponder;

    public class ColonyService extends AbstractService 
    {


        public function startConquer(_arg_1:int):void
        {
            sendServerAction(COMMAND.START_CONQUERING_PVP_COLONY, PvPCommandVO.Create(COMMAND.START_CONQUERING_PVP_COLONY, _arg_1), new ColonyConquerResponder(_arg_1));
            AdventureManager.getInstance().increaseStartedAdventuresCount();
        }

        public function getPvPColonies(_arg_1:int, _arg_2:int):void
        {
            sendServerAction(COMMAND.GET_PVP_COLONIES, PvPCommandVO.Create(COMMAND.GET_PVP_COLONIES, _arg_1), null, 0, _arg_2);
        }

        public function requestYield():void
        {
            sendServerAction(COMMAND.COLONY_REQUEST_YIELD, ColonyCommandVO.Create(COMMAND.COLONY_REQUEST_YIELD, 0), new ColonyYieldResponder());
        }


    }
}
