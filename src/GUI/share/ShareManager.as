package GUI.share
{
    import nLib.cLog;
    import nLib.gMisc;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.external.ExternalInterface;
    import Achievements.AchievementFacebookUrl;
    import mx.utils.URLUtil;
    import nLib.cFilenameUtil;
    import GUI.Assets.gAssetManager;

    public class ShareManager 
    {

        private static var singletonInstance:ShareManager = null;

        private var points:int;
        private var message:String = null;
        private var user:Object;
        private var FACEBOOK_POST_TITLE:String = "facebookPostTitle";
        private var FACEBOOK_DESCRIPTION_TITLE:String = "facebookDescriptionTitle";
        private var picture:String = null;
        private var loggedIn:Boolean = false;

        public function ShareManager(_arg_1:cSingletonEnforcer)
        {
            super();
            cLog.statusText("[ShareManager] constructor!");
            if (singletonInstance != null)
            {
                gMisc.Assert(false, "Singleton class, use getInstance!");
            };
            singletonInstance = this;
        }

        public static function getInstance():ShareManager
        {
            if (!singletonInstance)
            {
                singletonInstance = new ShareManager(new cSingletonEnforcer());
            };
            return (singletonInstance);
        }


        public function post(message:String, categoryname:String, points:int, picture:String=null):void
        {
            var response:* = undefined;
            var params:Object = {};
            params.name = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, this.FACEBOOK_POST_TITLE);
            params.description = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, this.FACEBOOK_DESCRIPTION_TITLE, [message, points]);
            var url:String = ExternalInterface.call("window.location.href.toString");
            if ((global.achievementFacebookUrl[categoryname] is AchievementFacebookUrl))
            {
                params.link = (global.achievementFacebookUrl[categoryname] as AchievementFacebookUrl).shortenerLink;
            }
            else
            {
                params.link = URLUtil.getServerNameWithPort(url);
            };
            if (picture != null)
            {
                params.picture = cFilenameUtil.getCompleteURL(0, gAssetManager.GetFacebookAchievementUrl(picture));
            };
            cLog.info((((((((("[ShareManager] Received post on wall params: name[" + params.name) + "] description[") + params.description) + "] link[") + params.link) + "] picture[") + params.picture) + "]"));
            if (ExternalInterface.available)
            {
                try
                {
                    response = ExternalInterface.call("gmFacebookPostAchievement", params.name, params.description, params.link, params.picture);
                    cLog.info(("[ShareManager] Received response from ExternalInterface call:" + response.toString()));
                }
                catch(e:Error)
                {
                    cLog.error(("[ShareManager] Exception in External interface call:" + e.toString()));
                };
            }
            else
            {
                cLog.error("[ShareManager] External interface not initialized!");
            };
        }


    }
}//package GUI.share

class cSingletonEnforcer 
{

    public function cSingletonEnforcer()
    {
        super();
    }

}


