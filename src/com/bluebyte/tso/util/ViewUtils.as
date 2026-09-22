package com.bluebyte.tso.util
{
    import flash.utils.Dictionary;
    import Skill.cSkill;
    import Modifier.ModifierVO;
    import Enums.CHANNELS;
    import mx.core.Application;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;

    public class ViewUtils 
    {

        private static var skillOnAdventureCache:Dictionary = new Dictionary();


        public static function hasActiveSkillForAdventure(_arg_1:String):Boolean
        {
            var _local_2:cSkill;
            var _local_3:Dictionary;
            var _local_4:Dictionary;
            var _local_5:ModifierVO;
            for each (_local_2 in global.ui.mCurrentPlayer.getSkills().getItems_vector())
            {
                if (_local_2.isTemporary())
                {
                    if (!(_local_2.getId() in skillOnAdventureCache))
                    {
                        _local_4 = new Dictionary();
                        for each (_local_5 in _local_2.getDefinition().level_vector[(_local_2.getLevel() - 1)])
                        {
                            if (_local_5.channel == CHANNELS.ADVENTURE)
                            {
                                _local_4[_local_5.type_string] = 1;
                            };
                        };
                        skillOnAdventureCache[_local_2.getId()] = _local_4;
                    };
                    _local_3 = (skillOnAdventureCache[_local_2.getId()] as Dictionary);
                    if ((_arg_1 in _local_3))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public static function keepInsideScreen(_arg_1:DisplayObject):void
        {
            var _local_2:DisplayObject = (Application.application as DisplayObject);
            var _local_3:Rectangle = _arg_1.getBounds(_local_2);
            var _local_4:Matrix = new Matrix();
            if (_local_3.x < 0)
            {
                _local_4.tx = -(_local_3.x);
            };
            if (_local_3.y < 0)
            {
                _local_4.ty = -(_local_3.y);
            };
            if (_local_3.x > (global.getApplication().stage.stageWidth - _arg_1.width))
            {
                _local_4.tx = (global.getApplication().stage.stageWidth - (_local_3.x + _arg_1.width));
            };
            if (_local_3.y > (global.getApplication().stage.stageHeight - _arg_1.height))
            {
                _local_4.ty = (global.getApplication().stage.stageHeight - (_local_3.y + _arg_1.height));
            };
        }


    }
}
