package Fulfilments
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;

    public class FulfilmentPool 
    {

        private static var singletonInstance:FulfilmentPool;

        private var categories_vector:Vector.<CategoryDefinition>;
        private var identities_vector:Vector.<IdentityDefinition>;

        private var identityMap:Dictionary = new Dictionary();
        private var categoryMap:Dictionary = new Dictionary();
        private var disabledIdentities:Dictionary = new Dictionary();

        public function FulfilmentPool(_arg_1:Vector.<IdentityDefinition>, _arg_2:Vector.<CategoryDefinition>)
        {
            var _local_3:IdentityDefinition;
            var _local_4:CategoryDefinition;
            super();
            this.identities_vector = _arg_1;
            for each (_local_3 in _arg_1)
            {
                this.identityMap[_local_3.getId()] = _local_3;
            };
            this.categories_vector = _arg_2;
            for each (_local_4 in _arg_2)
            {
                this.categoryMap[_local_4.getId()] = _local_4;
            };
            this.buildDisabledFulfilments();
        }

        private function buildDisabledFulfilments():void
        {
            var _local_3:IdentityDefinition;
            var _local_1:int;
            var _local_2:int = this.identities_vector.length;
            while (_local_1 < _local_2)
            {
                _local_3 = this.identities_vector[_local_1];
                if (_local_3.getDisabled())
                {
                    this.disabledIdentities[_local_3.getId()] = _local_3;
                };
                _local_1++;
            };
        }

        public function getIdentities_vector():Vector.<IdentityDefinition>
        {
            return (this.identities_vector);
        }

        public function getCategories_vector():Vector.<CategoryDefinition>
        {
            return (this.categories_vector);
        }


    }
}
