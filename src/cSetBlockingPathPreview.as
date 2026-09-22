package 
{
    import GO.cCombatPreviewPath;
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import Enums.COMMAND;
    import Communication.VO.dContextItemVO;
    import Communication.VO.CombatPreviewPathVO;
    import Enums.KILL_SWITCH;
    import mx.core.Application;
    import ServerState.cPlayerData;
    import Map.cPlayerZoneScreen;
    import __AS3__.vec.*;

    public class cSetBlockingPathPreview 
    {

        private var mMoveGridStart:Boolean;
        private var mCombatPreviewPath:cCombatPreviewPath;
        private var mMovePreviousGridValue:int;
        private var mGeneralInterface:cGeneralInterface;

        public function cSetBlockingPathPreview(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function InitBlockingPreview(_arg_1:int):void
        {
            this.mCombatPreviewPath = new cCombatPreviewPath(this.mGeneralInterface, _arg_1, _arg_1, null);
        }

        public function removePath(_arg_1:int):void
        {
            var _local_2:Vector.<cCombatPreviewPath>;
            var _local_3:Array;
            var _local_4:cCombatPreviewPath;
            if (_arg_1 > 0)
            {
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.getPaths(_arg_1);
                _local_3 = new Array();
                for each (_local_4 in _local_2)
                {
                    if (_local_4 != null)
                    {
                        this.mGeneralInterface.mCombatPersitedPreview.DeleteCombatPreviewPath(_local_4.mUniqueId);
                        _local_3.push(_local_4.mUniqueId);
                    };
                };
                this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.DELETE_BLOCKING_PATH_PREVIEW, this.mGeneralInterface.mCurrentViewedZoneID, _local_3);
            };
        }

        public function ShowPreview():Boolean
        {
            if (((!(this.mCombatPreviewPath == null)) && (this.mGeneralInterface.mCurrentCursor.GetGridPosition() > 0)))
            {
                if (this.mMoveGridStart)
                {
                    this.mCombatPreviewPath.SetGridPath(this.mGeneralInterface.mCurrentCursor.GetGridPosition(), -1);
                }
                else
                {
                    this.mCombatPreviewPath.SetGridPath(-1, this.mGeneralInterface.mCurrentCursor.GetGridPosition());
                };
                this.mCombatPreviewPath.RefreshPath();
                this.mCombatPreviewPath.ShowPath();
                this.mCombatPreviewPath.Render();
            };
            return (true);
        }

        public function AddPathToContextMenu(items:Vector.<dContextItemVO>, path:cCombatPreviewPath, EditMode:int):void
        {
            items.push(new dContextItemVO("Path", function ():void
            {
                mCombatPreviewPath = path;
                mMoveGridStart = (EditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START);
                mGeneralInterface.mCurrentCursor.SetCursorEditMode(EditMode);
                mGeneralInterface.mCombatPersitedPreview.DeleteCombatPreviewPath(path.mUniqueId);
            }, true, "", [(path.mUniqueId.uniqueID1 - 1)], function ():void
            {
                path.ShowPermPath();
            }, function ():void
            {
                path.HidePermPath();
            }));
        }

        public function CancelBlockingPreview():void
        {
            if (this.mCombatPreviewPath)
            {
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)
                {
                    this.mCombatPreviewPath.SetGridPath(this.mMovePreviousGridValue, this.mCombatPreviewPath.GetGridFinish());
                    this.mGeneralInterface.mCombatPersitedPreview.AddPreviewPath(this.mCombatPreviewPath.CreateVO());
                }
                else
                {
                    if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET)
                    {
                        this.mCombatPreviewPath.SetGridPath(this.mCombatPreviewPath.GetGridStart(), this.mMovePreviousGridValue);
                        this.mGeneralInterface.mCombatPersitedPreview.AddPreviewPath(this.mCombatPreviewPath.CreateVO());
                    };
                };
            };
            this.mCombatPreviewPath = null;
        }

        public function MouseClickOnMap(_arg_1:cPlayerData, _arg_2:cPlayerZoneScreen):Boolean
        {
            var _local_3:Vector.<cCombatPreviewPath>;
            var _local_4:Vector.<dContextItemVO>;
            var _local_5:cCombatPreviewPath;
            var _local_6:CombatPreviewPathVO;
            if (this.mGeneralInterface.mCurrentCursor.GetGridPosition() > 0)
            {
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING)
                {
                    _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.getAllPaths(this.mGeneralInterface.mCurrentCursor.GetGridPosition());
                    if (((_local_3.length > 0) && (this.mGeneralInterface.killswitch.isAccessible(KILL_SWITCH.TOOLBOX_PATHPREVIEW))))
                    {
                        if (_local_3.length == 1)
                        {
                            this.mCombatPreviewPath = _local_3[0];
                            if (((this.mCombatPreviewPath.GetGridStart() == this.mGeneralInterface.mCurrentCursor.GetGridPosition()) || (this.mCombatPreviewPath.isGridInBlocking(this.mGeneralInterface.mCurrentCursor.GetGridPosition()))))
                            {
                                this.mMoveGridStart = true;
                                this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START);
                                this.mMovePreviousGridValue = this.mCombatPreviewPath.GetGridStart();
                            }
                            else
                            {
                                this.mMoveGridStart = false;
                                this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET);
                                this.mMovePreviousGridValue = this.mCombatPreviewPath.GetGridFinish();
                            };
                            globalFlash.gui.mCancelActionPanel.Show();
                        }
                        else
                        {
                            _local_4 = new Vector.<dContextItemVO>();
                            for each (_local_5 in _local_3)
                            {
                                this.AddPathToContextMenu(_local_4, _local_5, ((_local_5.GetGridFinish() == this.mGeneralInterface.mCurrentCursor.GetGridPosition()) ? COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET : COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START));
                                _local_5.HidePermPath();
                            };
                            globalFlash.gui.ShowContextMenu(_local_4, Application.application.mouseX, Application.application.mouseY);
                            return (true);
                        };
                        this.mGeneralInterface.mCombatPersitedPreview.DeleteCombatPreviewPath(this.mCombatPreviewPath.mUniqueId);
                        return (true);
                    };
                };
                if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                {
                    return (false);
                };
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)
                {
                    this.mGeneralInterface.mSetBlockingPathPreview.InitBlockingPreview(this.mGeneralInterface.mCurrentCursor.GetGridPosition());
                    this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET);
                    this.mMoveGridStart = false;
                }
                else
                {
                    if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET)
                    {
                        if (this.mCombatPreviewPath.mPreviewPath.dest_vector.length == 0)
                        {
                            return (false);
                        };
                        _local_6 = new CombatPreviewPathVO();
                        _local_6.gridStart = this.mCombatPreviewPath.GetGridStart();
                        _local_6.gridFinish = this.mCombatPreviewPath.GetGridFinish();
                        this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.ADD_BLOCKING_PATH_PREVIEW, this.mGeneralInterface.mCurrentViewedZoneID, _local_6);
                        this.mGeneralInterface.mCombatPersitedPreview.addPathsWaitingForServer();
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    }
                    else
                    {
                        if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.DELETE_BLOCKING_PATH_PREVIEW)
                        {
                            this.removePath(this.mGeneralInterface.mCurrentCursor.GetGridPosition());
                            this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        }
                        else
                        {
                            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)
                            {
                                if (this.mCombatPreviewPath.mPreviewPath.dest_vector.length == 0)
                                {
                                    return (false);
                                };
                                this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START, this.mGeneralInterface.mCurrentViewedZoneID, this.mCombatPreviewPath.CreateVO());
                                this.mGeneralInterface.mCombatPersitedPreview.AddPreviewPath(this.mCombatPreviewPath.CreateVO());
                                this.mCombatPreviewPath = null;
                                this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                            }
                            else
                            {
                                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET)
                                {
                                    if (this.mCombatPreviewPath.mPreviewPath.dest_vector.length == 0)
                                    {
                                        return (false);
                                    };
                                    this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET, this.mGeneralInterface.mCurrentViewedZoneID, this.mCombatPreviewPath.CreateVO());
                                    this.mGeneralInterface.mCombatPersitedPreview.AddPreviewPath(this.mCombatPreviewPath.CreateVO());
                                    this.mCombatPreviewPath = null;
                                    this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                                };
                            };
                        };
                    };
                };
                return (true);
            };
            return (false);
        }


    }
}
