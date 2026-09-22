package Modifier
{
    import Model.Observer;
    import Interface.cGameInterface;
    import __AS3__.vec.Vector;
    import Model.Notifier;
    import Skill.cSkill;
    import nLib.gMisc;
    import nLib.cLog;
    import Interface.cGeneralInterface;
    import __AS3__.vec.*;

    public class Modifier implements Observer 
    {

        public static const xml_string:String = "modifier";

        protected var gi:cGameInterface;
        protected var propertySignals_vector:Vector.<String> = new Vector.<String>();
        private var notifiers_vector:Vector.<Notifier>;
        public var modifierVO:ModifierVO;
        protected var modifieable:Modifieable;
        public var ownerSkill:cSkill;


        public function applyOn(_arg_1:Notifier):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:String;
            if (this.notifiers_vector == null)
            {
                this.notifiers_vector = new Vector.<Notifier>();
                _local_3 = this.modifierVO.channel;
                if (_local_3.length > 0)
                {
                    for each (_local_4 in this.propertySignals_vector)
                    {
                        this.notifiers_vector.concat(this.gi.channels.CHANNEL_MAP.addObserver(_local_3, _local_4, this));
                    };
                };
            };
            this.notifiers_vector.push(_arg_1);
            for each (_local_2 in this.propertySignals_vector)
            {
                _arg_1.addPropertyObserver(_local_2, this);
            };
        }

        protected function registerPropertySignal(_arg_1:String):void
        {
            this.propertySignals_vector.push(_arg_1);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:Number;
            if (this.checkPropertyForSignal(_arg_2))
            {
                if (this.modifierVO.chance >= 1)
                {
                    this.attemptModify(_arg_3);
                }
                else
                {
                    _local_4 = gMisc.getPseudoRandom(this.gi.getSeed());
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((((((((" # Modifier CHANCE Throw: " + _local_4) + " <= Mod-Chance ") + this.modifierVO.chance) + " ? #  For Modifier:") + this.modifierVO.modifier_string) + " while ") + _arg_2));
                    };
                    if (_local_4 <= this.modifierVO.chance)
                    {
                        this.attemptModify(_arg_3);
                    };
                };
                return;
            };
        }

        protected function setModified(_arg_1:Modifier):void
        {
            if (this.modifieable != null)
            {
                this.modifieable.setModified(this);
            };
        }

        private function attemptModify(_arg_1:Object):void
        {
            this.modifieable = (_arg_1 as Modifieable);
            if (this.modifieable == null)
            {
                cLog.error((("Cant modify class: " + _arg_1) + " because is not a Modifieable class!"));
                return;
            };
            if (this.modifieable.isModifierApplyable(this.modifierVO))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(((("Modify: " + this.modifierVO) + " ON: ") + _arg_1));
                };
                this.modify(_arg_1);
            };
        }

        public function setOwnerSkill(_arg_1:cSkill):void
        {
            this.ownerSkill = _arg_1;
        }

        protected function checkPropertyForSignal(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.propertySignals_vector)
            {
                if (_local_2.indexOf(_arg_1) >= 0)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            this.modifierVO = _arg_1;
            this.gi = (_arg_2 as cGameInterface);
        }

        public function modify(_arg_1:Object):Object
        {
            cLog.warning(((("Empty Modifier. Please Override modify()!  Modifier:" + this.modifierVO.modifier_string) + " while ") + this.propertySignals_vector));
            return (_arg_1);
        }

        public function dispose():void
        {
            var _local_2:String;
            var _local_1:int;
            while (_local_1 < this.notifiers_vector.length)
            {
                for each (_local_2 in this.propertySignals_vector)
                {
                    this.notifiers_vector[_local_1].removePropertyObserver(_local_2, this);
                };
                _local_1++;
            };
            this.notifiers_vector = null;
        }


    }
}
