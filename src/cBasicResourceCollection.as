package 
{
    import ServerState.dResource;
    import __AS3__.vec.Vector;
    import ServerState.cResources;
    import __AS3__.vec.*;

    public class cBasicResourceCollection 
    {

        private var mMapResources:Object = new Object();


        public function SubtractResources(_arg_1:Object):cBasicResourceCollection
        {
            var _local_3:dResource;
            var _local_4:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if ((_arg_1 is Vector.<dResource>))
            {
                _local_2 = (_arg_1 as Vector.<dResource>);
            }
            else
            {
                if ((_arg_1 is cBasicResourceCollection))
                {
                    _local_2 = (_arg_1 as cBasicResourceCollection).GetResourcesVector();
                }
                else
                {
                    if ((_arg_1 is dResource))
                    {
                        _local_2.push((_arg_1 as dResource));
                    };
                };
            };
            for each (_local_3 in _local_2)
            {
                if (!this.mMapResources[_local_3.name_string])
                {
                    _local_4 = _local_3.clone();
                    _local_4.amount = -(_local_4.amount);
                    this.mMapResources[_local_3.name_string] = _local_4;
                }
                else
                {
                    this.mMapResources[_local_3.name_string].amount = (this.mMapResources[_local_3.name_string].amount - _local_3.amount);
                };
            };
            return (this);
        }

        public function GetResourcesVector():Vector.<dResource>
        {
            var _local_2:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_2 in this.mMapResources)
            {
                _local_1.push(_local_2.clone());
            };
            return (_local_1);
        }

        public function SetResources(_arg_1:Object):void
        {
            var _local_3:dResource;
            this.mMapResources = new Object();
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if ((_arg_1 is Vector.<dResource>))
            {
                _local_2 = (_arg_1 as Vector.<dResource>);
            }
            else
            {
                if ((_arg_1 is cBasicResourceCollection))
                {
                    _local_2 = (_arg_1 as cBasicResourceCollection).GetResourcesVector();
                }
                else
                {
                    if ((_arg_1 is cResources))
                    {
                        _local_2 = (_arg_1 as cResources).GetResources_Vector();
                    };
                };
            };
            for each (_local_3 in _local_2)
            {
                if (!this.mMapResources[_local_3.name_string])
                {
                    this.mMapResources[_local_3.name_string] = _local_3.clone();
                }
                else
                {
                    (this.mMapResources[_local_3.name_string] as dResource).amount = ((this.mMapResources[_local_3.name_string] as dResource).amount + _local_3.amount);
                };
            };
        }

        public function AddResources(_arg_1:Object):void
        {
            var _local_3:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if ((_arg_1 is Vector.<dResource>))
            {
                _local_2 = (_arg_1 as Vector.<dResource>);
            }
            else
            {
                if ((_arg_1 is cBasicResourceCollection))
                {
                    _local_2 = (_arg_1 as cBasicResourceCollection).GetResourcesVector();
                };
            };
            for each (_local_3 in _local_2)
            {
                if (!this.mMapResources[_local_3.name_string])
                {
                    this.mMapResources[_local_3.name_string] = _local_3.clone();
                }
                else
                {
                    this.mMapResources[_local_3.name_string].amount = (this.mMapResources[_local_3.name_string].amount + _local_3.amount);
                };
            };
        }

        public function GetResourceAmount(_arg_1:String):int
        {
            var _local_2:dResource;
            if (this.mMapResources[_arg_1])
            {
                _local_2 = (this.mMapResources[_arg_1] as dResource);
                return (_local_2.amount);
            };
            return (0);
        }

        public function HasResources(_arg_1:Object):Boolean
        {
            var _local_3:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if ((_arg_1 is Vector.<dResource>))
            {
                _local_2 = (_arg_1 as Vector.<dResource>);
            }
            else
            {
                if ((_arg_1 is cBasicResourceCollection))
                {
                    _local_2 = (_arg_1 as cBasicResourceCollection).GetResourcesVector();
                };
            };
            for each (_local_3 in _local_2)
            {
                if (!this.mMapResources[_local_3.name_string])
                {
                    return (false);
                };
                if (this.mMapResources[_local_3.name_string].amount < _local_3.amount)
                {
                    return (false);
                };
            };
            return (true);
        }

        public function AddResource(_arg_1:dResource):void
        {
            if (_arg_1 != null)
            {
                if (!this.mMapResources[_arg_1.name_string])
                {
                    this.mMapResources[_arg_1.name_string] = _arg_1.clone();
                }
                else
                {
                    this.mMapResources[_arg_1.name_string].amount = (this.mMapResources[_arg_1.name_string].amount + _arg_1.amount);
                };
            };
        }


    }
}
