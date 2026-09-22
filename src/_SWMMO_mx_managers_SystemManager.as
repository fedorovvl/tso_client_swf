package
{
    import mx.managers.SystemManager;
    import mx.core.IFlexModuleFactory;
    import flash.utils.Dictionary;
    import mx.core.FlexVersion;
    import mx.core.IFlexModule;
    import flash.system.Security;
    import flash.system.ApplicationDomain;
    import GUI.SWMMOPreloader;

    public class _SWMMO_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory 
    {

        private var _preloadedRSLs:Dictionary;

        public function _SWMMO_mx_managers_SystemManager()
        {
            FlexVersion.compatibilityVersionString = "3.0.0";
            super();
        }

        override public function create(... _args):Object
        {
            if (((_args.length > 0) && (!(_args[0] is String))))
            {
                return (super.create.apply(this, _args));
            };
            var _local_2:String = ((_args.length == 0) ? "SWMMO" : String(_args[0]));
            var _local_3:Class = Class(getDefinitionByName(_local_2));
            if (!_local_3)
            {
                return (null);
            };
            var _local_4:Object = new (_local_3)();
            if ((_local_4 is IFlexModule))
            {
                IFlexModule(_local_4).moduleFactory = this;
            };
            return (_local_4);
        }

        override public function allowInsecureDomain(... _args):void
        {
            var _local_2:Object;
            Security.allowInsecureDomain(_args);
            for (_local_2 in this._preloadedRSLs)
            {
                if (((_local_2.content) && ("allowInsecureDomainInRSL" in _local_2.content)))
                {
                    var _local_5:* = _local_2.content;
                    (_local_5["allowInsecureDomainInRSL"](_args));
                };
            };
        }

        override public function info():Object
        {
            return ({
                "applicationComplete":"applicationCompleteHandler(event)",
                "backgroundGradientColors":"[#3f576f, #3f576f]",
                "borderStyle":"none",
                "clipContent":"true",
                "compiledLocales":["en_US"],
                "compiledResourceBundleNames":["SharedResources", "collections", "containers", "controls", "core", "effects", "formatters", "logging", "messaging", "rpc", "skins", "states", "styles", "utils"],
                "creationPolicy":"all",
                "currentDomain":ApplicationDomain.currentDomain,
                "currentState":"LoadSettings",
                "enterFrame":"isoengine.update()",
                "frameRate":"30",
                "horizontalPageScrollSize":"0",
                "horizontalScrollPolicy":"off",
                "horizontalScrollPosition":"0",
                "layout":"absolute",
                "mainClassName":"SWMMO",
                "minHeight":"600",
                "minWidth":"800",
                "mixins":[ "_SWMMO_FlexInit"],
                "paddingBottom":"0",
                "paddingLeft":"0",
                "paddingRight":"0",
                "paddingTop":"0",
                "preloader":SWMMOPreloader,
                "verticalPageScrollSize":"0",
                "verticalScrollPolicy":"off",
                "verticalScrollPosition":"0"
            });
        }

        override public function get preloadedRSLs():Dictionary
        {
            if (this._preloadedRSLs == null)
            {
                this._preloadedRSLs = new Dictionary(true);
            };
            return (this._preloadedRSLs);
        }

        override public function allowDomain(... _args):void
        {
            var _local_2:Object;
            Security.allowDomain(_args);
            for (_local_2 in this._preloadedRSLs)
            {
                if (((_local_2.content) && ("allowDomainInRSL" in _local_2.content)))
                {
                    var _local_5:* = _local_2.content;
                    (_local_5["allowDomainInRSL"](_args));
                };
            };
        }


    }
}