package Fulfilments
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import Communication.VO.TriggerVO;

    public class IdentityDefinition implements Disposable 
    {

        private var name:String;
        private var categoryID:int;
        private var id:int;
        private var disabled:Boolean;
        private var triggersVector:Vector.<TriggerVO>;

        public function IdentityDefinition(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:Vector.<TriggerVO>)
        {
            super();
            this.id = _arg_1;
            this.name = _arg_2;
            this.categoryID = _arg_3;
            this.triggersVector = _arg_5;
            this.disabled = _arg_4;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getDisabled():Boolean
        {
            return (this.disabled);
        }

        public function getCategoryID():int
        {
            return (this.categoryID);
        }

        public function getId():int
        {
            return (this.id);
        }

        public function getTriggersVector():Vector.<TriggerVO>
        {
            return (this.triggersVector);
        }

        public function dispose():void
        {
            this.name = null;
            this.triggersVector = null;
        }


    }
}
