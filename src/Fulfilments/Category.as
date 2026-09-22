package Fulfilments
{
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import flash.utils.Dictionary;
    import Enums.DIRTY_INDICATOR;
    import __AS3__.vec.*;

    public class Category implements IIdentityTreeNode 
    {

        private var totalLeaves:int;
        private var parent:IIdentityTreeNode;
        private var progress:int;
        private var childrenVector:Vector.<ITreeNode> = new Vector.<ITreeNode>();
        public var mDirtyIndicator:int;
        private var rank:int;
        private var finishedLeaves:int;
        private var hasCategoryChildren:Boolean = false;
        private var playerId:int;
        private var childrenMap:Dictionary = new Dictionary();
        private var categoryDefinition:CategoryDefinition;
        private var visible:Boolean = false;
        private var finished:Boolean = false;

        public function Category(_arg_1:CategoryDefinition, _arg_2:int)
        {
            super();
            this.categoryDefinition = _arg_1;
            this.playerId = _arg_2;
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
        }

        public function updateProgress():void
        {
            var _local_2:ITreeNode;
            var _local_1:Boolean = this.finished;
            this.finishedLeaves = 0;
            this.totalLeaves = 0;
            for each (_local_2 in this.childrenVector)
            {
                if ((_local_2 is Category))
                {
                    this.updateChildCategoryProgress(_local_2);
                }
                else
                {
                    if ((_local_2 is Identity))
                    {
                        this.updateChildIdentityProgress(_local_2);
                    };
                };
            };
            this.progress = ((this.totalLeaves > 0) ? int((this.finishedLeaves / this.totalLeaves)) : 0);
            this.finished = (this.progress == 1);
            if (this.parent != null)
            {
                this.parent.updateProgress();
            };
            if ((((!(_local_1)) && (this.finished)) && (!(this.categoryDefinition.getParentID() == 0))))
            {
                if (this.playerId < 0)
                {
                    return;
                };
                this.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
            };
        }

        public function dispose():void
        {
            var _local_1:ITreeNode;
            this.categoryDefinition = null;
            this.parent = null;
            if (this.childrenVector != null)
            {
                for each (_local_1 in this.childrenVector)
                {
                    _local_1.dispose();
                };
                this.childrenVector = null;
            };
        }

        public function getParent():ITreeNode
        {
            return (this.parent);
        }

        public function getRank():int
        {
            return (this.rank);
        }

        public function getFinishedLeaves():int
        {
            return (this.finishedLeaves);
        }

        public function setParent(_arg_1:ITreeNode):void
        {
            this.parent = (_arg_1 as IIdentityTreeNode);
        }

        public function isLeaf():Boolean
        {
            return (false);
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this.visible = _arg_1;
            if (this.parent != null)
            {
                if (_arg_1)
                {
                    this.parent.setVisible(true);
                }
                else
                {
                    this.parent.updateVisibility();
                };
            };
        }

        public function getProgress():Number
        {
            return (this.progress);
        }

        public function updateChildCategoryProgress(_arg_1:ITreeNode):void
        {
            var _local_2:Category = (_arg_1 as Category);
            this.totalLeaves = (this.totalLeaves + _local_2.totalLeaves);
            this.finishedLeaves = (this.finishedLeaves + _local_2.finishedLeaves);
        }

        public function updateVisibility():void
        {
            var _local_1:ITreeNode;
            this.visible = false;
            for each (_local_1 in this.childrenVector)
            {
                if (_local_1.isVisible())
                {
                    this.visible = true;
                    break;
                };
            };
            this.setVisible(this.visible);
        }

        public function setRank(_arg_1:int):void
        {
            var _local_2:ITreeNode;
            this.rank = _arg_1;
            for each (_local_2 in this.childrenVector)
            {
                (_local_2 as IIdentityTreeNode).setRank((this.rank + 1));
            };
        }

        public function getTotalLeaves():int
        {
            return (this.totalLeaves);
        }

        public function getPlayerId():int
        {
            return (this.playerId);
        }

        public function getChildById(_arg_1:int):Identity
        {
            return (this.childrenMap[_arg_1]);
        }

        public function getCategoryDefinition():CategoryDefinition
        {
            return (this.categoryDefinition);
        }

        public function hasSubcategories():Boolean
        {
            return (this.hasCategoryChildren);
        }

        public function toString():String
        {
            return ("");
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function getCategory(_arg_1:int):Category
        {
            var _local_2:Category;
            var _local_3:Category;
            var _local_4:ITreeNode;
            if (this.categoryDefinition.getId() == _arg_1)
            {
                return (this);
            };
            for each (_local_4 in this.childrenVector)
            {
                _local_2 = (_local_4 as Category);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getCategory(_arg_1);
                    if (_local_3 != null)
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        public function isVisible():Boolean
        {
            return (this.visible);
        }

        public function addChild(_arg_1:ITreeNode):void
        {
            var _local_2:IIdentityTreeNode = (_arg_1 as IIdentityTreeNode);
            if (_local_2 != null)
            {
                this.childrenVector.push(_local_2);
                _local_2.setParent(this);
                if (_local_2.isVisible())
                {
                    this.setVisible(true);
                };
                if (((!(this.hasCategoryChildren)) && (_local_2 is Category)))
                {
                    this.hasCategoryChildren = true;
                };
                if ((_local_2 is Identity))
                {
                    this.childrenMap[(_local_2 as Identity).getId()] = _local_2;
                }
                else
                {
                    if ((_local_2 is Category))
                    {
                        this.childrenMap[(_local_2 as Category).getCategoryDefinition().getId()] = _local_2;
                    };
                };
            };
        }

        public function getChildren():Vector.<ITreeNode>
        {
            return (this.childrenVector);
        }

        public function updateChildIdentityProgress(_arg_1:ITreeNode):void
        {
            var _local_2:Identity = (_arg_1 as Identity);
            if (_local_2.getFinished())
            {
                if (_local_2.getFinished())
                {
                    this.finishedLeaves++;
                };
                this.totalLeaves++;
            };
        }

        public function removeChild(_arg_1:ITreeNode):void
        {
            var _local_2:int = this.childrenVector.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                this.childrenVector.splice(_local_2, 1);
                _arg_1.setParent(null);
                if (_arg_1.isVisible())
                {
                    this.updateVisibility();
                };
            };
        }


    }
}
