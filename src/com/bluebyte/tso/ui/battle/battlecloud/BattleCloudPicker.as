package com.bluebyte.tso.ui.battle.battlecloud
{
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleCloudElementDefinition;
    import com.bluebyte.tso.util.RandomItemUtil;
    import __AS3__.vec.*;

    public class BattleCloudPicker implements IBattleCloudElement 
    {

        private var items:Vector.<IBattleCloudElement> = new Vector.<IBattleCloudElement>();
        private var conditionsProvider:IConditionsProvider;
        private var definition:BattleCloudElementDefinition;

        public function BattleCloudPicker(_arg_1:BattleCloudElementDefinition, _arg_2:IConditionsProvider, _arg_3:Vector.<IBattleCloudElement>)
        {
            super();
            this.definition = _arg_1;
            this.conditionsProvider = _arg_2;
            this.items = _arg_3;
        }

        private function getFilteredItems():Vector.<IBattleCloudElement>
        {
            var _local_2:IBattleCloudElement;
            var _local_1:Vector.<IBattleCloudElement> = new Vector.<IBattleCloudElement>();
            for each (_local_2 in this.items)
            {
                if (_local_2.getElementDefinition().isConditionValid(this.conditionsProvider.getConditions()))
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function getElementDefinition():BattleCloudElementDefinition
        {
            return (this.definition);
        }

        public function getChance():Number
        {
            return (this.definition.chance);
        }

        public function trigger(_arg_1:String):void
        {
            var _local_2:IBattleCloudElement;
            if (((_arg_1 == this.definition.trigger) && (this.definition.isConditionValid(this.conditionsProvider.getConditions()))))
            {
                _local_2 = (RandomItemUtil.getNext(this.getFilteredItems()) as IBattleCloudElement);
                if (_local_2)
                {
                    _local_2.trigger(null);
                };
            };
        }


    }
}
