package Communication.VO
{
    import mx.collections.ArrayCollection;
    import ServerState.dResource;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class dContentGeneratorRollVO 
    {

        public var useHardCurrency:Boolean;
        public var rewards:ArrayCollection;
        public var costs:ArrayCollection;
        public var hash:int;
        public var rollAmount:int;
        public var categoryId:int;
        public var compilationId:int;


        public function toString():String
        {
            var _local_1:String;
            return ((((((("<dContentGeneratorRollVO CategoryId='" + this.categoryId) + "' ") + "CompilationId='") + this.compilationId) + "RollAmount='") + this.rollAmount) + "'/>\n");
        }

        public function getCostsAsResourceVector():Vector.<dResource>
        {
            var _local_2:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_2 in this.costs)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }


    }
}
