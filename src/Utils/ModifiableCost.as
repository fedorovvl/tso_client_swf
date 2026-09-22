package Utils
{
    import Modifier.Modifieable;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Modifier.Modifier;
    import Modifier.ModifierVO;
    import __AS3__.vec.*;

    public class ModifiableCost implements Modifieable 
    {

        public static const MOVE_COST:String = "MOVE_COST";

        private var modified:Boolean = false;
        public var cost:Vector.<dResource> = new Vector.<dResource>();


        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (this.cost != null)
            {
                return (true);
            };
            return (false);
        }


    }
}
