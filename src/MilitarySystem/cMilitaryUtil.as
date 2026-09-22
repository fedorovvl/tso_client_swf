package MilitarySystem
{
    import Communication.VO.dResourceVO;
    import Specialists.cSpecialist;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Communication.VO.dSquadVO;
    import Communication.VO.dRaiseArmyVO;
    import nLib.gMisc;
    import Enums.COMMAND;

    public class cMilitaryUtil 
    {


        public static function RaiseArmy(_arg_1:cArmy, _arg_2:iMilitaryUnitHolder, _arg_3:Vector.<dResourceVO>):void
        {
            var _local_6:dResourceVO;
            var _local_7:int;
            _arg_2.GetArmy().DisbandArmy(_arg_1);
            var _local_4:int = _arg_2.GetMaxMilitaryUnits();
            var _local_5:int;
            if (_arg_3 != null)
            {
                for each (_local_6 in _arg_3)
                {
                    _local_7 = 0;
                    if ((_arg_2 is cSpecialist))
                    {
                        _local_7 = _arg_1.RemoveUnits(_local_6.name_string, _local_6.amount);
                    }
                    else
                    {
                        if ((_arg_2 is cBuilding))
                        {
                            _local_7 = _local_6.amount;
                        };
                    };
                    if ((_local_7 + _local_5) > _local_4)
                    {
                        _local_7 = (_local_4 - _local_5);
                    };
                    _arg_2.GetArmy().AddUnits(_local_6.name_string, _local_7, 0, true);
                    _local_5 = (_local_5 + _local_7);
                };
            };
        }

        public static function GetSpecialistFromGarrison(_arg_1:cBuilding, _arg_2:cGeneralInterface):cSpecialist
        {
            var _local_4:cSpecialist;
            var _local_3:cSpecialist;
            if (_arg_1.isGarrison())
            {
                for each (_local_4 in _arg_2.mCurrentPlayerZone.GetSpecialists_vector())
                {
                    if (_local_4.GetGarrison() == _arg_1)
                    {
                        _local_3 = _local_4;
                        break;
                    };
                };
            };
            return (_local_3);
        }

        public static function SendRaiseArmyToServer(_arg_1:cGeneralInterface, _arg_2:iMilitaryUnitHolder, _arg_3:Vector.<dSquadVO>):void
        {
            var _local_5:dSquadVO;
            var _local_6:dResourceVO;
            var _local_4:dRaiseArmyVO = new dRaiseArmyVO();
            if ((_arg_2 is cBuilding))
            {
                _local_4.armyHolderBuildingVO = (_arg_2 as cBuilding).CreateBuildingVOFromBuilding();
            }
            else
            {
                if ((_arg_2 is cSpecialist))
                {
                    _local_4.armyHolderSpecialistVO = (_arg_2 as cSpecialist).CreateSpecialistVOFromSpecialist();
                }
                else
                {
                    gMisc.Assert(false, (("Could not assign " + _arg_2) + " to dRaiseArmyVO!"));
                    return;
                };
            };
            for each (_local_5 in _arg_3)
            {
                _local_6 = new dResourceVO();
                _local_6.name_string = _local_5.GetType();
                _local_6.amount = _local_5.GetAmount();
                _local_4.unitSquads.addItem(_local_6);
            };
            _arg_1.mClientMessages.SendMessagetoServer(COMMAND.RAISE_ARMY, _arg_1.mCurrentViewedZoneID, _local_4);
        }


    }
}
