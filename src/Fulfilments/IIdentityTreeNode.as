package Fulfilments
{
    import Utils.Tree.ITreeNode;

    public interface IIdentityTreeNode extends ITreeNode 
    {

        function setVisible(_arg_1:Boolean):void;
        function getRank():int;
        function getProgress():Number;
        function updateProgress():void;
        function getFinished():Boolean;
        function hasSubcategories():Boolean;
        function updateVisibility():void;
        function toString():String;
        function setRank(_arg_1:int):void;

    }
}
