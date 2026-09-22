package com.bluebyte.tso.ui.battle.battlecloud
{
    import com.bluebyte.tso.util.IRandomItem;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattleCloudElementDefinition;

    public interface IBattleCloudElement extends IRandomItem 
    {

        function trigger(_arg_1:String):void;
        function getElementDefinition():BattleCloudElementDefinition;

    }
}
