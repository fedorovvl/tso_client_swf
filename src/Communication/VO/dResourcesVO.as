package Communication.VO
{
    import mx.collections.ArrayCollection;
    import ServerState.cResources;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import __AS3__.vec.*;

    public class dResourcesVO 
    {

        public var resources_vector:ArrayCollection = new ArrayCollection();
        public var workers:int;
        public var free:int;
        public var military:int;


        public function CreateResourcesFromVO(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int):cResources
        {
            var _local_6:dResourceVO;
            var _local_4:cResources = new cResources(_arg_1, _arg_2, _arg_3);
            _local_4.CreateResourceEntries();
            var _local_5:Vector.<dResourceVO> = new Vector.<dResourceVO>();
            for each (_local_6 in this.resources_vector)
            {
                _local_5.push(_local_6);
            };
            _local_4.Init(this.workers, this.military, this.free, _local_5);
            return (_local_4);
        }


    }
}
