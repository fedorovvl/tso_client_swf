package PathFinding
{
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class cPathFinder 
    {

        public static const AMOUNT_TYPE_ABOVE_ZERO:int = 0;
        public static const AMOUNT_TYPE_BELOW_MAX:int = 1;

        public var map_PlayerId_CostMatrices:Object = new Object();
        private var mGeneralInterface:cGeneralInterface;

        public function cPathFinder(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function CalculatePathForDeposit(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int):cPathObject
        {
            var _local_5:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_3];
            if (_local_5 == null)
            {
                _local_5 = new cCostMatrices(_arg_3, this.mGeneralInterface);
                this.map_PlayerId_CostMatrices[_arg_3] = _local_5;
            };
            var _local_6:Vector.<int> = _local_5.getCostMatrixForDeposit_list(_arg_1, _arg_4);
            if (_local_6 === cCostMatrices.RESOURCE_NOT_AVAILABLE_list)
            {
                return (null);
            };
            var _local_7:cPathObject = this.mGeneralInterface.mCreatePath.CalculateStreetPathFromMatrix(_arg_2, _local_6);
            return (_local_7);
        }

        public function CalculatePathForDestinations(_arg_1:int, _arg_2:Vector.<int>, _arg_3:Vector.<PFAdditionalData>):cPathObject
        {
            var _local_4:Vector.<int> = this.mGeneralInterface.mCreatePath.CalculatePathCostMatrix_list(_arg_2, _arg_3);
            return (this.mGeneralInterface.mCreatePath.CalculateStreetPathFromMatrix(_arg_1, _local_4));
        }

        public function InvalidateDepositMatrix(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            var _local_4:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_1];
            if (_local_4 != null)
            {
                _local_4.invalidateCostMatrixForDeposit(_arg_2, _arg_3);
            };
        }

        public function CalculatePathForWarehouse(_arg_1:int, _arg_2:int):cPathObject
        {
            var _local_3:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_2];
            if (_local_3 == null)
            {
                _local_3 = new cCostMatrices(_arg_2, this.mGeneralInterface);
                this.map_PlayerId_CostMatrices[_arg_2] = _local_3;
            };
            var _local_4:Vector.<int> = _local_3.getCostMatrixForWarehouse_list();
            if (_local_4 == cCostMatrices.WAREHOUSE_NOT_AVAILABLE_list)
            {
                return (null);
            };
            var _local_5:cPathObject = this.mGeneralInterface.mCreatePath.CalculateStreetPathFromMatrix(_arg_1, _local_4);
            _local_5.dest_vector = _local_5.dest_vector.reverse();
            return (_local_5);
        }

        public function InvalidateAll(_arg_1:int):void
        {
            var _local_2:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_1];
            if (_local_2 != null)
            {
                _local_2.InvalidateAll();
            };
        }

        public function InvalidateWarehouseMatrix(_arg_1:int):void
        {
            var _local_2:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_1];
            if (_local_2 != null)
            {
                _local_2.invalidateCostMatrixForWarehouse();
            };
        }

        public function CalculatePath(_arg_1:int, _arg_2:int, _arg_3:Vector.<PFAdditionalData>, _arg_4:Boolean):cPathObject
        {
            var _local_5:Vector.<int> = new Vector.<int>();
            _local_5.push(_arg_2);
            var _local_6:cPathObject = this.CalculatePathForDestinations(_arg_1, _local_5, _arg_3);
            if (_arg_4)
            {
                _local_6.dest_vector = _local_6.dest_vector.reverse();
            };
            return (_local_6);
        }

        public function GetDepositDestinations(_arg_1:String, _arg_2:int, _arg_3:int):Vector.<int>
        {
            var _local_4:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_2];
            if (_local_4 == null)
            {
                _local_4 = new cCostMatrices(_arg_2, this.mGeneralInterface);
                this.map_PlayerId_CostMatrices[_arg_2] = _local_4;
            };
            return (_local_4.getDestinationsForDeposit_vector(_arg_1, _arg_3));
        }

        public function GetWarehouseDestinations(_arg_1:int):Vector.<int>
        {
            var _local_2:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_1];
            if (_local_2 == null)
            {
                _local_2 = new cCostMatrices(_arg_1, this.mGeneralInterface);
                this.map_PlayerId_CostMatrices[_arg_1] = _local_2;
            };
            return (_local_2.getDestinationsForWarehouse_vector());
        }

        public function PrintDepositMatrix(_arg_1:int, _arg_2:String):void
        {
            var _local_3:cCostMatrices = this.map_PlayerId_CostMatrices[_arg_1];
            if (_local_3 != null)
            {
                cCreatePath.printWayCostMatrix(this.mGeneralInterface, _local_3.getCostMatrixForDeposit_list(_arg_2, AMOUNT_TYPE_ABOVE_ZERO), false);
            };
        }


    }
}
