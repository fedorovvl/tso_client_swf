package PathFinding
{
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import GO.cDeposit;
    import nLib.gMisc;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import GO.cBuilding;
    import __AS3__.vec.*;

    public class cCostMatrices 
    {

        public static const RESOURCE_NOT_AVAILABLE_list:Vector.<int> = new Vector.<int>(0);
        public static const WAREHOUSE_NOT_AVAILABLE_list:Vector.<int> = new Vector.<int>(0);

        private var destinations_Warehouse_vector:Vector.<int> = null;
        private var pathCostMatrix_Warehouse_list:Vector.<int> = null;
        private var playerId:int;
        private var mGeneralInterface:cGeneralInterface;

        private var DepositName_DestinationsAboveZero_map:Object = new Object();
        private var DepositName_PathCostMatrixAboveZero_map:Object = new Object();
        private var DepositName_DestinationsBelowMax_map:Object = new Object();
        private var DepositName_PathCostMatrixBelowMax_map:Object = new Object();

        public function cCostMatrices(_arg_1:int, _arg_2:cGeneralInterface)
        {
            super();
            this.playerId = _arg_1;
            this.mGeneralInterface = _arg_2;
        }

        public function getCostMatrixForDeposit_list(_arg_1:String, _arg_2:int):Vector.<int>
        {
            var _local_4:Vector.<int>;
            var _local_5:cDeposit;
            var _local_6:Vector.<int>;
            var _local_3:Vector.<int>;
            switch (_arg_2)
            {
                case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                    _local_3 = this.DepositName_PathCostMatrixAboveZero_map[_arg_1];
                    break;
                case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                    _local_3 = this.DepositName_PathCostMatrixBelowMax_map[_arg_1];
                    break;
                default:
                    gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
            };
            if (_local_3 == null)
            {
                _local_4 = new Vector.<int>();
                for each (_local_5 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetDeposits_vector())
                {
                    if ((((_arg_1 == _local_5.GetName_string()) && ((_arg_2 == cPathFinder.AMOUNT_TYPE_ABOVE_ZERO) ? (_local_5.GetAmount() > 0) : (_local_5.GetAmount() < _local_5.GetMaxAmount()))) && (_local_5.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)))
                    {
                        if (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.isSectorOwnedAtGridPosition(_local_5.GetGrid(), this.playerId))
                        {
                            _local_4.push(_local_5.GetGrid());
                        };
                    };
                };
                switch (_arg_2)
                {
                    case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                        this.DepositName_DestinationsAboveZero_map[_arg_1] = _local_4;
                        break;
                    case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                        this.DepositName_DestinationsBelowMax_map[_arg_1] = _local_4;
                        break;
                    default:
                        gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
                };
                if (_local_4.length == 0)
                {
                    _local_6 = RESOURCE_NOT_AVAILABLE_list;
                }
                else
                {
                    _local_6 = this.mGeneralInterface.mCreatePath.CalculatePathCostMatrix_list(_local_4, null);
                };
                switch (_arg_2)
                {
                    case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                        this.DepositName_PathCostMatrixAboveZero_map[_arg_1] = _local_6;
                        break;
                    case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                        this.DepositName_PathCostMatrixBelowMax_map[_arg_1] = _local_6;
                        break;
                    default:
                        gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
                };
                _local_3 = _local_6;
            };
            return (_local_3);
        }

        public function invalidateCostMatrixForDeposit(_arg_1:String, _arg_2:int):void
        {
            switch (_arg_2)
            {
                case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                    this.DepositName_DestinationsAboveZero_map[_arg_1] = null;
                    this.DepositName_PathCostMatrixAboveZero_map[_arg_1] = null;
                    return;
                case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                    this.DepositName_DestinationsBelowMax_map[_arg_1] = null;
                    this.DepositName_PathCostMatrixBelowMax_map[_arg_1] = null;
                    return;
                default:
                    gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
            };
        }

        public function getDestinationsForWarehouse_vector():Vector.<int>
        {
            if (this.pathCostMatrix_Warehouse_list == null)
            {
                this.getCostMatrixForWarehouse_list();
            };
            return (this.destinations_Warehouse_vector);
        }

        public function getDestinationsForDeposit_vector(_arg_1:String, _arg_2:int):Vector.<int>
        {
            var _local_3:Vector.<int>;
            switch (_arg_2)
            {
                case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                    _local_3 = this.DepositName_PathCostMatrixAboveZero_map[_arg_1];
                    break;
                case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                    _local_3 = this.DepositName_PathCostMatrixBelowMax_map[_arg_1];
                    break;
                default:
                    gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
            };
            if (_local_3 == null)
            {
                this.getCostMatrixForDeposit_list(_arg_1, _arg_2);
            };
            switch (_arg_2)
            {
                case cPathFinder.AMOUNT_TYPE_ABOVE_ZERO:
                    return (this.DepositName_DestinationsAboveZero_map[_arg_1]);
                case cPathFinder.AMOUNT_TYPE_BELOW_MAX:
                    return (this.DepositName_DestinationsBelowMax_map[_arg_1]);
                default:
                    gMisc.Assert(false, ("Could not interpret amountType " + _arg_2));
            };
            return (null);
        }

        public function InvalidateAll():void
        {
            this.destinations_Warehouse_vector = null;
            this.pathCostMatrix_Warehouse_list = null;
            this.DepositName_DestinationsAboveZero_map = new Object();
            this.DepositName_PathCostMatrixAboveZero_map = new Object();
            this.DepositName_DestinationsBelowMax_map = new Object();
            this.DepositName_PathCostMatrixBelowMax_map = new Object();
        }

        public function invalidateCostMatrixForWarehouse():void
        {
            this.destinations_Warehouse_vector = null;
            this.pathCostMatrix_Warehouse_list = null;
        }

        public function getCostMatrixForWarehouse_list():Vector.<int>
        {
            var _local_1:cBuilding;
            if (this.pathCostMatrix_Warehouse_list == null)
            {
                this.destinations_Warehouse_vector = new Vector.<int>();
                for each (_local_1 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                {
                    if (null != _local_1)
                    {
                        if (((_local_1.IsBuildingActive()) && (_local_1.IsWarehouseType())))
                        {
                            if (_local_1.getPlayerID() == this.playerId)
                            {
                                this.destinations_Warehouse_vector.push(_local_1.GetStreetGridEntry());
                            };
                        };
                    };
                };
                if (this.destinations_Warehouse_vector.length == 0)
                {
                    return (WAREHOUSE_NOT_AVAILABLE_list);
                };
                this.pathCostMatrix_Warehouse_list = this.mGeneralInterface.mCreatePath.CalculatePathCostMatrix_list(this.destinations_Warehouse_vector, null);
            };
            return (this.pathCostMatrix_Warehouse_list);
        }


    }
}
