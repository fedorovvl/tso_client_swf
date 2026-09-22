package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import Map.GridPosition;

    public class EffectVO 
    {

        public var effect_string:String;
        // Included in server data, but absent from the original client schema.
        public var questName:String;
        public var otherPlayerId:int;
        public var serverOnly:Boolean;
        public var clientOnly:Boolean;
        public var onQuestSight:Boolean;
        public var id:int;
        public var additionalUniqueIds_vector:ArrayCollection = new ArrayCollection();
        public var reactivate:Boolean;
        public var source:String = "";
        public var skillID:int;
        public var mode_string:String;
        public var skillLevel:int;
        public var chance:int;
        public var isFromTimedProductionQueue:Boolean;
        public var uniqueID:dUniqueID;
        public var type_string:String;
        public var conditions:TriggerListVO = null;
        public var startDelay:int;
        public var item_string:String;
        public var name_string:String;
        public var action_string:String;
        public var index:int;
        public var randomSeed:int;
        public var playerId:int;
        public var targetGridPos:int = 0;
        public var amount:int;
        public var targetX:int;
        public var givesMultipleBuffs:Boolean;
        public var targetY:int;
        public var value:int;
        public var effectDelay:int;
        public var units:String;
        public var target_string:String;


        public static function CreateFromXML(_arg_1:cXML):EffectVO
        {
            var _local_2:EffectVO = new (EffectVO)();
            _local_2.effect_string = _arg_1.GetName_string().toLowerCase();
            _local_2.effectDelay = _arg_1.GetAttributeInt("delay");
            _local_2.reactivate = _arg_1.GetAttributeBool("reactivate");
            _local_2.onQuestSight = _arg_1.GetAttributeBool("onquestsight");
            _local_2.clientOnly = _arg_1.GetAttributeBool("clientOnly", false);
            _local_2.serverOnly = _arg_1.GetAttributeBool("serverOnly", false);
            _local_2.mode_string = _arg_1.GetAttributeString_string("mode");
            _local_2.type_string = _arg_1.GetAttributeString_string("type");
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            _local_2.item_string = _arg_1.GetAttributeString_string("item");
            _local_2.action_string = _arg_1.GetAttributeString_string("action");
            _local_2.target_string = _arg_1.GetAttributeString_string("pointTo");
            if (_local_2.target_string.length == 0)
            {
                _local_2.target_string = _arg_1.GetAttributeString_string("target");
            };
            _local_2.id = _arg_1.GetAttributeInt("id");
            _local_2.index = _arg_1.GetAttributeInt("index");
            _local_2.amount = _arg_1.GetAttributeInt("amount");
            _local_2.value = _arg_1.GetAttributeInt("value");
            _local_2.chance = _arg_1.GetAttributeInt("recurringChance");
            if (_local_2.chance == 0)
            {
                _local_2.chance = _arg_1.GetAttributeInt("chance");
            };
            _local_2.targetGridPos = _arg_1.GetAttributeInt("grid", 0);
            _local_2.targetX = _arg_1.GetAttributeInt("x", -1);
            _local_2.targetY = _arg_1.GetAttributeInt("y", -1);
            _local_2.units = _arg_1.GetAttributeString_string("units");
            _local_2.startDelay = _arg_1.GetAttributeInt("startDelay");
            _local_2.uniqueID = new dUniqueID();
            _local_2.givesMultipleBuffs = _arg_1.GetAttributeBool("givesMultipleBuffs", false);
            _local_2.conditions = TriggerListVO.fromXML(_arg_1, "conditions");
            return (_local_2);
        }


        public function calculateGridPosFromXY(_arg_1:int):void
        {
            if (((!(this.targetX == -1)) && (!(this.targetY == -1))))
            {
                this.targetGridPos = GridPosition.getGridIndexFromXY(this.targetX, this.targetY, _arg_1);
            };
        }

        public function toString():String
        {
            return (((((((((((((((((("<EffectVO " + this.effect_string) + " ") + this.mode_string) + " ") + this.type_string) + " ") + this.name_string) + " ") + this.item_string) + " ") + this.action_string) + " ") + this.target_string) + " ") + this.id) + " ") + this.amount) + "/>");
        }

        public function clone():EffectVO
        {
            var _local_1:EffectVO = new EffectVO();
            _local_1.effect_string = this.effect_string;
            _local_1.questName = this.questName;
            _local_1.effectDelay = this.effectDelay;
            _local_1.serverOnly = this.serverOnly;
            _local_1.clientOnly = this.clientOnly;
            _local_1.reactivate = this.reactivate;
            _local_1.onQuestSight = this.onQuestSight;
            _local_1.mode_string = this.mode_string;
            _local_1.type_string = this.type_string;
            _local_1.name_string = this.name_string;
            _local_1.item_string = this.item_string;
            _local_1.action_string = this.action_string;
            _local_1.target_string = this.target_string;
            _local_1.id = this.id;
            _local_1.index = this.index;
            _local_1.value = this.value;
            _local_1.amount = this.amount;
            _local_1.chance = this.chance;
            _local_1.uniqueID = this.uniqueID;
            _local_1.skillID = this.skillID;
            _local_1.skillLevel = this.skillLevel;
            _local_1.isFromTimedProductionQueue = this.isFromTimedProductionQueue;
            _local_1.targetGridPos = this.targetGridPos;
            _local_1.targetX = this.targetX;
            _local_1.targetY = this.targetY;
            _local_1.units = this.units;
            _local_1.randomSeed = this.randomSeed;
            _local_1.startDelay = this.startDelay;
            _local_1.givesMultipleBuffs = this.givesMultipleBuffs;
            this.additionalUniqueIds_vector = new ArrayCollection();
            if (this.conditions != null)
            {
                _local_1.conditions = (this.conditions.clone() as TriggerListVO);
            };
            return (_local_1);
        }


    }
}
