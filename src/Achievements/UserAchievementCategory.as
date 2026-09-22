package Achievements
{
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import flash.utils.Dictionary;
    import Enums.DIRTY_INDICATOR;
    import __AS3__.vec.*;

    public class UserAchievementCategory implements IAchievementTreeNode 
    {

        private var totalLeaves:int;
        private var hideProgress:Boolean = false;
        private var ignoreProgress:Boolean = false;
        private var childrenVector:Vector.<ITreeNode> = new Vector.<ITreeNode>();
        public var mDirtyIndicator:int;
        private var progress:Number = 0;
        private var finishedLeaves:int;
        private var parent:IAchievementTreeNode;
        private var achievementCategoryVO:AchievementCategoriesVO;
        private var rank:int;
        private var hasCategoryChildren:Boolean = false;
        private var playerId:int;
        private var childrenMap:Dictionary = new Dictionary();
        private var points:int;
        private var finished:Boolean = false;
        private var visible:Boolean = false;

        public function UserAchievementCategory(_arg_1:AchievementCategoriesVO, _arg_2:int)
        {
            super();
            this.achievementCategoryVO = _arg_1;
            this.playerId = _arg_2;
            this.ignoreProgress = _arg_1.getCategoryIgnoreProgress();
            this.hideProgress = _arg_1.getCategoryHideProgress();
        }

        public function getVisibleAchievementChildren():Vector.<ITreeNode>
        {
            var _local_4:UserAchievement;
            var _local_1:Vector.<ITreeNode> = new Vector.<ITreeNode>();
            var _local_2:int;
            var _local_3:int = this.childrenVector.length;
            while (_local_2 < _local_3)
            {
                _local_4 = (this.childrenVector[_local_2] as UserAchievement);
                if ((((!(_local_4 == null)) && (_local_4.getFinished())) || ((!(_local_4 == null)) && (_local_4.isVisible()))))
                {
                    _local_1.push(_local_4);
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
        }

        public function getHideProgress():Boolean
        {
            return (this.hideProgress);
        }

        public function getAchievementCategoryVO():AchievementCategoriesVO
        {
            return (this.achievementCategoryVO);
        }

        public function getIgnoreProgress():Boolean
        {
            return (this.ignoreProgress);
        }

        public function updateProgress():void
        {
            var _local_2:ITreeNode;
            var _local_3:UserAchievementCategory;
            var _local_4:UserAchievement;
            var _local_1:Boolean = this.finished;
            this.points = 0;
            this.finishedLeaves = 0;
            this.totalLeaves = 0;
            for each (_local_2 in this.childrenVector)
            {
                if ((_local_2 is UserAchievementCategory))
                {
                    _local_3 = (_local_2 as UserAchievementCategory);
                    if (!_local_3.getIgnoreProgress())
                    {
                        this.points = (this.points + _local_3.getPoints());
                        this.totalLeaves = (this.totalLeaves + _local_3.totalLeaves);
                        this.finishedLeaves = (this.finishedLeaves + _local_3.finishedLeaves);
                    };
                }
                else
                {
                    if ((_local_2 is UserAchievement))
                    {
                        _local_4 = (_local_2 as UserAchievement);
                        if (((_local_4.isVisible()) || (_local_4.getFinished())))
                        {
                            if (_local_4.getFinished())
                            {
                                this.points = (this.points + _local_4.getPoints());
                                this.finishedLeaves++;
                            };
                            this.totalLeaves++;
                        };
                    };
                };
            };
            this.progress = ((this.totalLeaves > 0) ? (this.finishedLeaves / this.totalLeaves) : 0);
            this.finished = (this.progress == 1);
            if (this.parent != null)
            {
                this.parent.updateProgress();
            };
            if ((((!(_local_1)) && (this.finished)) && (!(this.achievementCategoryVO.getCategoryParentID() == 0))))
            {
                if (this.playerId < 0)
                {
                    return;
                };
                this.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
            };
        }

        public function getParent():ITreeNode
        {
            return (this.parent);
        }

        public function getFinishedLeaves():int
        {
            return (this.finishedLeaves);
        }

        public function dispose():void
        {
            var _local_1:ITreeNode;
            this.achievementCategoryVO = null;
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

        public function isLeaf():Boolean
        {
            return (false);
        }

        public function setParent(_arg_1:ITreeNode):void
        {
            this.parent = (_arg_1 as IAchievementTreeNode);
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

        public function getRank():int
        {
            return (this.rank);
        }

        public function getProgress():Number
        {
            return (this.progress);
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

        public function getAchievementStatusHashMap(_arg_1:Boolean):Dictionary
        {
            var _local_3:Vector.<ITreeNode>;
            var _local_4:UserAchievement;
            var _local_2:Dictionary = new Dictionary(false);
            if (this.hasSubcategories())
            {
                return (null);
            };
            _local_3 = this.getChildren();
            for each (_local_4 in _local_3)
            {
                if (((!(_arg_1)) || ((_arg_1) && ((_local_4.getFinished()) || (_local_4.isVisible())))))
                {
                    _local_2[_local_4.getAchievementId()] = _local_4.getFinished();
                };
            };
            return (_local_2);
        }

        public function getTotalLeaves():int
        {
            return (this.totalLeaves);
        }

        public function setRank(_arg_1:int):void
        {
            var _local_2:ITreeNode;
            this.rank = _arg_1;
            for each (_local_2 in this.childrenVector)
            {
                (_local_2 as IAchievementTreeNode).setRank((this.rank + 1));
            };
        }

        public function getPlayerId():int
        {
            return (this.playerId);
        }

        public function getPoints():int
        {
            return (this.points);
        }

        public function getChildById(_arg_1:int):UserAchievement
        {
            return (this.childrenMap[_arg_1]);
        }

        public function hasSubcategories():Boolean
        {
            return (this.hasCategoryChildren);
        }

        public function isVisible():Boolean
        {
            return (this.visible);
        }

        public function toString():String
        {
            var _local_4:ITreeNode;
            var _local_1:* = "";
            var _local_2:int;
            while (_local_2 < this.rank)
            {
                _local_1 = (_local_1 + "\t");
                _local_2++;
            };
            var _local_3:* = ((((((((((((((((((_local_1 + '<CATEGORY id="') + this.achievementCategoryVO.getCategoryID()) + '" name="') + this.achievementCategoryVO.getCategoryName()) + '" parentID="') + this.achievementCategoryVO.getCategoryParentID()) + '" rank="') + this.rank) + '" playerID="') + this.playerId) + '" progress="') + this.progress) + '" finished="') + this.finished) + '" points="') + this.points) + '" ') + ">\n");
            for each (_local_4 in this.childrenVector)
            {
                _local_3 = (_local_3 + (_local_4 as IAchievementTreeNode).toString());
            };
            return (_local_3 + (_local_1 + "</CATEGORY>\n"));
        }

        public function getCategory(_arg_1:int):UserAchievementCategory
        {
            var _local_2:UserAchievementCategory;
            var _local_3:UserAchievementCategory;
            var _local_4:ITreeNode;
            if (this.achievementCategoryVO.getCategoryID() == _arg_1)
            {
                return (this);
            };
            for each (_local_4 in this.childrenVector)
            {
                _local_2 = (_local_4 as UserAchievementCategory);
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

        public function getChildren():Vector.<ITreeNode>
        {
            return (this.childrenVector);
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function addChild(_arg_1:ITreeNode):void
        {
            var _local_2:IAchievementTreeNode = (_arg_1 as IAchievementTreeNode);
            if (_local_2 != null)
            {
                this.childrenVector.push(_local_2);
                _local_2.setParent(this);
                if (_local_2.isVisible())
                {
                    this.setVisible(true);
                };
                if (((!(this.hasCategoryChildren)) && (_local_2 is UserAchievementCategory)))
                {
                    this.hasCategoryChildren = true;
                };
                if ((_local_2 is UserAchievement))
                {
                    this.childrenMap[(_local_2 as UserAchievement).getAchievementId()] = _local_2;
                }
                else
                {
                    if ((_local_2 is UserAchievementCategory))
                    {
                        this.childrenMap[(_local_2 as UserAchievementCategory).getAchievementCategoryVO().getCategoryID()] = _local_2;
                    };
                };
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
