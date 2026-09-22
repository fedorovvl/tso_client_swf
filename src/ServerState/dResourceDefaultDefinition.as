package ServerState
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class dResourceDefaultDefinition 
    {

        public var visibleInEconomy:Boolean;
        public var requiredEventName_string:String;
        public var group_string:String;
        public var category_string:String;
        public var expandMaxLimitList_vector:Vector.<dExpandMaxLimit> = new Vector.<dExpandMaxLimit>();
        public var maxLimit:int;
        public var tradable:Boolean;
        public var resourceName_string:String;


    }
}
