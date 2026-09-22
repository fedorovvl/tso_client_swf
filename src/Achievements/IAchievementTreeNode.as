package Achievements
{
    import Utils.Tree.ITreeNode;

    public interface IAchievementTreeNode extends ITreeNode 
    {

        function setVisible(_arg_1:Boolean):void;
        function hasSubcategories():Boolean;
        function getRank():int;
        function getProgress():Number;
        function updateProgress():void;
        function getFinished():Boolean;
        function getPoints():int;
        function updateVisibility():void;
        function toString():String;
        function setRank(_arg_1:int):void;

    }
}
