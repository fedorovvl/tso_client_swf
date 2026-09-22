package Utils.Tree
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;

    public interface ITreeNode extends Disposable 
    {

        function getParent():ITreeNode;
        function getChildren():Vector.<ITreeNode>;
        function isVisible():Boolean;
        function removeChild(_arg_1:ITreeNode):void;
        function addChild(_arg_1:ITreeNode):void;
        function setParent(_arg_1:ITreeNode):void;
        function isLeaf():Boolean;

    }
}
