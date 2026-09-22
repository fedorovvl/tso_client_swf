package Fulfilments
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import Utils.HashMapWrapper;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import flash.utils.Dictionary;
    import Communication.VO.Fulfilments.FulfilmentTriggerValueUpdateVO;
    import Communication.VO.Fulfilments.FulfilmentFinishedUpdateVO;
    import Communication.VO.Fulfilments.CategoryVO;
    import Enums.DIRTY_INDICATOR;
    import mx.collections.ArrayCollection;
    import Communication.VO.Fulfilments.FulfilmentTriggerVO;
    import Communication.VO.TriggerVO;
    import Interface.cGameInterface;
    import Trigger.TriggerFactory;
    import Communication.VO.Fulfilments.FulfilmentTriggerFinishedUpdateVO;
    import Communication.VO.Fulfilments.IdentityVO;
    import __AS3__.vec.*;

    public class FulfilmentsManager implements Disposable 
    {

        public static const BOOL_TRUE_INT:int = 1;

        private var identitiesToDelete:Vector.<int>;
        private var categories:HashMapWrapper;
        private var treeRoot:IIdentityTreeNode;
        private var finishedIdentitiesCounter:int = 0;
        private var playerID:int;
        private var fulfilmentTriggersToDelete:Vector.<int>;
        private var initialized:Boolean = false;
        private var identities:HashMapWrapper;
        private var activeTriggers:Vector.<FulfilmentTrigger>;

        private var recentlyFinishedIdentities:Vector.<Identity> = new Vector.<Identity>();
        private var finishedIdentityVOs:Dictionary = new Dictionary();


        public function getIdentityByID(_arg_1:int):Identity
        {
            return (this.identities.getItem(_arg_1) as Identity);
        }

        private function updateTree():void
        {
            var _local_1:Boolean;
            var _local_2:Identity;
            this.treeRoot.setRank(0);
            for each (_local_2 in this.identities.valueSet())
            {
                _local_1 = _local_2.getFinished();
                _local_2.checkForUpdates();
                _local_2.updateProgress();
            };
        }

        public function setIdentitiesToDelete(_arg_1:Vector.<int>):void
        {
            this.identitiesToDelete = _arg_1;
        }

        public function disposeFinishedTriggers():void
        {
            var _local_1:Identity;
            for each (_local_1 in this.identities.valueSet())
            {
                _local_1.disposeFinishedTriggers();
            };
        }

        public function updateIdentityValue(_arg_1:FulfilmentTriggerValueUpdateVO):void
        {
            var _local_2:Identity = this.getIdentityByID(_arg_1.identityId);
            if (_local_2 != null)
            {
                _local_2.updateTriggerValue(_arg_1.triggerId, _arg_1.updatedValue);
            };
        }

        public function getCategories():HashMapWrapper
        {
            return (this.categories);
        }

        public function allUpdatesHandled():void
        {
            this.recentlyFinishedIdentities = new Vector.<Identity>();
        }

        public function getTree():IIdentityTreeNode
        {
            return (this.treeRoot);
        }

        public function handleIdentityFinished(_arg_1:Identity):void
        {
            this.finishedIdentitiesCounter++;
            if (this.initialized)
            {
                this.recentlyFinishedIdentities.push(_arg_1);
            };
        }

        public function addIdentityFinishedVO(_arg_1:FulfilmentFinishedUpdateVO):void
        {
            this.finishedIdentityVOs[_arg_1.identityId] = _arg_1;
        }

        public function getCategoryByName(_arg_1:String):Category
        {
            var _local_3:Category;
            var _local_2:String;
            for each (_local_3 in this.categories.valueSet())
            {
                _local_2 = _local_3.getCategoryDefinition().getName();
                if (_arg_1 == _local_2)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function getInitialized():Boolean
        {
            return (this.initialized);
        }

        public function dispose():void
        {
            var _local_1:Identity;
            var _local_2:Category;
            for each (_local_1 in this.identities.valueSet())
            {
                _local_1.dispose();
            };
            this.identities = null;
            for each (_local_2 in this.categories.valueSet())
            {
                _local_2.dispose();
            };
            this.categories = null;
            if (this.treeRoot != null)
            {
                this.treeRoot.dispose();
                this.treeRoot = null;
            };
        }

        public function setInitialized(_arg_1:Boolean):void
        {
            this.initialized = _arg_1;
        }

        public function buildCategories(_arg_1:FulfilmentPool, _arg_2:ArrayCollection, _arg_3:int):HashMapWrapper
        {
            var _local_4:CategoryDefinition;
            var _local_5:Category;
            var _local_9:CategoryVO;
            var _local_10:CategoryVO;
            var _local_6:HashMapWrapper = new HashMapWrapper();
            var _local_7:Vector.<CategoryDefinition> = _arg_1.getCategories_vector();
            var _local_8:HashMapWrapper = new HashMapWrapper();
            for each (_local_9 in _arg_2)
            {
                _local_8.putItem(_local_9.categoryID, _local_9);
            };
            for each (_local_4 in _local_7)
            {
                if (!((_local_4.isMainCategory()) && (!(this.isCategoryAllowed(_local_4)))))
                {
                    _local_5 = new Category(_local_4, _arg_3);
                    _local_10 = (_local_8.getItem(_local_4.getId()) as CategoryVO);
                    if (_local_10 != null)
                    {
                        _local_5.setFinished((_local_10.finished == BOOL_TRUE_INT));
                        if (_local_10.isDirty)
                        {
                            if (((_local_10.identityList == null) || (_local_10.identityList.length == 0)))
                            {
                                _local_5.mDirtyIndicator = DIRTY_INDICATOR.DELETED_BIT;
                            }
                            else
                            {
                                _local_5.mDirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
                            };
                            _local_10.isDirty = false;
                        };
                    }
                    else
                    {
                        _local_5.mDirtyIndicator = DIRTY_INDICATOR.DELETED_BIT;
                    };
                    _local_6.putItem(_local_4.getId(), _local_5);
                };
            };
            return (_local_6);
        }

        public function getAllActiveTriggers():Vector.<FulfilmentTrigger>
        {
            var _local_1:Identity;
            var _local_2:FulfilmentTrigger;
            if (this.activeTriggers == null)
            {
                this.activeTriggers = new Vector.<FulfilmentTrigger>();
                for each (_local_1 in this.identities.valueSet())
                {
                    for each (_local_2 in _local_1.getTriggers())
                    {
                        this.activeTriggers.push(_local_2);
                    };
                };
            };
            return (this.activeTriggers);
        }

        public function getPlayerID():int
        {
            return (this.playerID);
        }

        private function buildTree():void
        {
            var _local_1:int;
            var _local_2:Category;
            var _local_3:Identity;
            for each (_local_2 in this.categories.valueSet())
            {
                _local_1 = _local_2.getCategoryDefinition().getParentID();
                if (_local_1 == 0)
                {
                    this.treeRoot.addChild(_local_2);
                }
                else
                {
                    if (this.categories.hasKey(_local_1))
                    {
                        this.getCategoryByID(_local_1).addChild(_local_2);
                    };
                };
            };
            for each (_local_3 in this.identities.valueSet())
            {
                _local_1 = _local_3.getDefinition().getCategoryID();
                if (((!(_local_1 == 0)) && (this.categories.hasKey(_local_1))))
                {
                    this.getCategoryByID(_local_1).addChild(_local_3);
                };
            };
            this.updateTree();
        }

        public function getFulfilmentTriggersToDelete():Vector.<int>
        {
            return (this.fulfilmentTriggersToDelete);
        }

        public function getCategoryByID(_arg_1:int):Category
        {
            return (this.categories.getItem(_arg_1) as Category);
        }

        protected function isCategoryAllowed(_arg_1:CategoryDefinition):Boolean
        {
            return (true);
        }

        public function buildTriggers(_arg_1:cGameInterface, _arg_2:Identity, _arg_3:HashMapWrapper, _arg_4:int, _arg_5:Boolean, _arg_6:TriggerFactory):Vector.<FulfilmentTrigger>
        {
            var _local_7:FulfilmentTriggerVO;
            var _local_8:TriggerVO;
            var _local_9:FulfilmentTrigger;
            var _local_12:String;
            var _local_10:Vector.<FulfilmentTrigger> = new Vector.<FulfilmentTrigger>();
            var _local_11:int = _arg_2.getDefinition().getId();
            var _local_13:Vector.<TriggerVO> = _arg_2.getDefinition().getTriggersVector();
            var _local_14:Boolean;
            for each (_local_8 in _local_13)
            {
                _local_9 = new FulfilmentTrigger(_local_8, _arg_1);
                _local_12 = ((_local_11 + "_") + _local_8.triggerIdx);
                if (_arg_2.getFinished())
                {
                    _local_9.init(null, _arg_6, _arg_2, false);
                }
                else
                {
                    if (((!(_arg_3 == null)) && (!(_arg_3.getItem(_local_12) == null))))
                    {
                        _local_7 = (_arg_3.getItem(_local_12) as FulfilmentTriggerVO);
                        _local_9.init(_local_7, _arg_6, _arg_2, _local_14);
                    }
                    else
                    {
                        _local_9.init(null, _arg_6, _arg_2, _local_14);
                    };
                };
                _local_10.push(_local_9);
            };
            return (_local_10);
        }

        public function getIdentityTriggerUpdates(_arg_1:ArrayCollection, _arg_2:ArrayCollection):void
        {
            var _local_3:Identity;
            var _local_4:FulfilmentTrigger;
            for each (_local_3 in this.identities.valueSet())
            {
                for each (_local_4 in _local_3.getTriggers())
                {
                    if (_local_4.getFinished())
                    {
                        _arg_1.addItem(new FulfilmentTriggerFinishedUpdateVO().init(_local_4.getIdentityId(), _local_4.getTriggerId()));
                    }
                    else
                    {
                        if (((!(_arg_2 == null)) && (!(_local_4.getCurrentAmount() == 0))))
                        {
                            _arg_2.addItem(new FulfilmentTriggerValueUpdateVO().init(_local_4.getIdentityId(), _local_4.getTriggerId(), _local_4.getValue()));
                        };
                    };
                };
            };
        }

        public function getIdentities():HashMapWrapper
        {
            return (this.identities);
        }

        public function checkForIdentityUpdates():void
        {
            var _local_1:Identity;
            for each (_local_1 in this.identities.valueSet())
            {
                _local_1.checkForUpdates();
            };
        }

        public function isTriggerActive(_arg_1:String):Boolean
        {
            var _local_3:Identity;
            var _local_4:FulfilmentTrigger;
            var _local_2:String = _arg_1.toLocaleLowerCase();
            for each (_local_3 in this.identities)
            {
                for each (_local_4 in _local_3.getTriggers())
                {
                    if (_local_4.getDefinition().action_string == _local_2)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function getFinishedIdentities():Vector.<Identity>
        {
            return (this.recentlyFinishedIdentities);
        }

        public function setFulfilmentTriggersToDelete(_arg_1:Vector.<int>):void
        {
            this.fulfilmentTriggersToDelete = _arg_1;
        }

        public function removeIdentityFinishedVOs():void
        {
            var _local_1:String;
            var _local_2:Identity;
            for (_local_1 in this.finishedIdentityVOs)
            {
                _local_2 = this.getIdentityByID(int(_local_1));
                _local_2.reward();
                delete this.finishedIdentityVOs[_local_1];
            };
        }

        public function buildIdentities(_arg_1:cGameInterface, _arg_2:FulfilmentPool, _arg_3:HashMapWrapper, _arg_4:ArrayCollection, _arg_5:ArrayCollection, _arg_6:int, _arg_7:ArrayCollection):HashMapWrapper
        {
            var _local_8:IdentityDefinition;
            var _local_9:Identity;
            var _local_10:Category;
            var _local_11:Boolean;
            var _local_15:IdentityVO;
            var _local_16:FulfilmentTriggerVO;
            var _local_17:HashMapWrapper;
            var _local_18:TriggerFactory;
            var _local_19:IdentityVO;
            var _local_12:HashMapWrapper = new HashMapWrapper();
            var _local_13:Vector.<IdentityDefinition> = _arg_2.getIdentities_vector();
            var _local_14:HashMapWrapper = new HashMapWrapper();
            for each (_local_15 in _arg_4)
            {
                _local_14.putItem(_local_15.ID, _local_15);
            };
            _local_17 = new HashMapWrapper();
            for each (_local_16 in _arg_5)
            {
                _local_17.putItem(((_local_16.ID + "_") + _local_16.triggerID), _local_16);
            };
            _local_18 = new TriggerFactory(_arg_1);
            for each (_local_8 in _local_13)
            {
                _local_9 = new Identity(_local_8, _arg_6, _arg_1);
                _local_19 = (_local_14.getItem(_local_8.getId()) as IdentityVO);
                _local_11 = true;
                if (_local_19 != null)
                {
                    _local_9.setFinished((_local_19.finished == BOOL_TRUE_INT));
                    if (_local_9.getFinished())
                    {
                        _local_9.setVisible(true);
                    };
                    if (_local_8.getDisabled())
                    {
                        if (!_local_9.getFinished())
                        {
                            _local_9.setVisible(false);
                        };
                        _local_11 = false;
                    };
                }
                else
                {
                    _local_10 = (_arg_3.getItem(_local_8.getCategoryID()) as Category);
                    _local_9.setFinished(_local_10.getFinished());
                };
                _local_9.setTriggers(this.buildTriggers(_arg_1, _local_9, _local_17, _arg_6, _local_11, _local_18));
                _local_12.putItem(_local_8.getId(), _local_9);
            };
            return (_local_12);
        }

        public function setTriggerIdentityFinished(_arg_1:FulfilmentTriggerFinishedUpdateVO):void
        {
            var _local_2:Identity = this.getIdentityByID(_arg_1.identityId);
            if (_local_2 != null)
            {
                _local_2.setTriggerFinished(_arg_1.triggerId);
            };
        }

        public function build(_arg_1:cGameInterface, _arg_2:FulfilmentPool, _arg_3:int, _arg_4:ArrayCollection, _arg_5:ArrayCollection, _arg_6:ArrayCollection):void
        {
            var _local_7:HashMapWrapper = this.buildCategories(_arg_2, _arg_4, _arg_3);
            var _local_8:HashMapWrapper = this.buildIdentities(_arg_1, _arg_2, _local_7, _arg_5, _arg_6, _arg_3, _arg_4);
            this.playerID = _arg_3;
            this.identities = _local_8;
            this.categories = _local_7;
            this.createRoot();
            this.buildTree();
            this.initialized = false;
        }

        public function toString():String
        {
            return (this.treeRoot.toString());
        }

        public function getIdentitiesToDelete():Vector.<int>
        {
            return (this.identitiesToDelete);
        }

        private function createRoot():void
        {
            var _local_1:CategoryDefinition = new CategoryDefinition(0, "ROOT", 0, false);
            this.treeRoot = new Category(_local_1, this.playerID);
        }


    }
}
