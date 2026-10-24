package GUI
{
    import flash.net.SharedObject;
    import flash.utils.getQualifiedClassName;
    import mx.core.UIComponent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import com.bluebyte.tso.util.ClientLogger;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    /** Device-local geometry for movable windows. Storage failure is non-fatal. */
    public final class WindowGeometry
    {
        private static var storage:SharedObject;
        private static var layouts:Object;
        public static const RESET:String = "windowGeometryReset";
        public static const events:EventDispatcher = new EventDispatcher();

        public static function get enabled():Boolean
        {
            return loadLayouts()["_enabled"] !== false;
        }

        public static function set enabled(value:Boolean):void
        {
            loadLayouts()["_enabled"] = value;
            persistLayouts();
        }

        public static function reset():void
        {
            var remember:Boolean = enabled;
            layouts = {_enabled:remember, _ignoreLegacy:true};
            persistLayouts();
            try { getStorage().clear(); } catch (error:Error) { }
            events.dispatchEvent(new Event(RESET));
        }

        private static function persistLayouts():void
        {
            var stream:FileStream = new FileStream();
            try
            {
                var file:File = layoutFile();
                file.parent.createDirectory();
                var temporary:File = file.parent.resolvePath("window-layouts-v1.tmp");
                stream.open(temporary, FileMode.WRITE);
                stream.writeObject(layouts);
                stream.close();
                temporary.moveTo(file, true);
            }
            catch (error:Error)
            {
                ClientLogger.log("[WindowGeometry] Write failed: " + error.message);
            }
            finally
            {
                try { stream.close(); } catch (closeError:Error) { }
            }
        }

        private static function layoutFile():File
        {
            // The launcher generates a new AIR application ID for each instance.
            // Keep preferences outside that application's temporary storage directory.
            return File.userDirectory.resolvePath("AppData/Local/tso_portable/window-layouts-v1.dat");
        }

        private static function loadLayouts():Object
        {
            if (layouts != null) return layouts;
            layouts = {};
            var stream:FileStream = new FileStream();
            try
            {
                var file:File = layoutFile();
                ClientLogger.log("[WindowGeometry] Storage: " + file.nativePath);
                if (file.exists)
                {
                    stream.open(file, FileMode.READ);
                    var loaded:Object = stream.readObject();
                    if (loaded != null) layouts = loaded;
                };
            }
            catch (error:Error)
            {
                ClientLogger.log("[WindowGeometry] Read failed: " + error.message);
            }
            finally
            {
                try { stream.close(); } catch (closeError:Error) { }
            }
            return layouts;
        }

        private static function getStorage():SharedObject
        {
            if (storage == null) storage = SharedObject.getLocal("tsoWindowGeometryV1");
            return storage;
        }

        public static function save(panel:UIComponent):void
        {
            if (!enabled || !panel.stage || panel.width <= 0 || panel.height <= 0) return;
            var key:String = getQualifiedClassName(panel);
            var bounds:Object = {x:panel.x, y:panel.y, width:panel.width, height:panel.height};
            var stream:FileStream = new FileStream();
            try
            {
                loadLayouts()[key] = bounds;
                var file:File = layoutFile();
                file.parent.createDirectory();
                var temporary:File = file.parent.resolvePath("window-layouts-v1.tmp");
                stream.open(temporary, FileMode.WRITE);
                stream.writeObject(layouts);
                stream.close();
                temporary.moveTo(file, true);
            }
            catch (error:Error)
            {
                ClientLogger.log("[WindowGeometry] Write failed: " + error.message);
                try
                {
                    var local:SharedObject = getStorage();
                    local.data[key] = bounds;
                    ClientLogger.log("[WindowGeometry] Fallback flush: " + local.flush());
                }
                catch (storageError:Error)
                {
                    ClientLogger.log("[WindowGeometry] Fallback failed: " + storageError.message);
                }
            }
            finally
            {
                try { stream.close(); } catch (closeError:Error) { }
            }
        }

        public static function restore(panel:UIComponent, minimumWidth:Number, minimumHeight:Number):void
        {
            if (!enabled || !panel.stage) return;
            try
            {
                var key:String = getQualifiedClassName(panel);
                var saved:Object = loadLayouts()[key];
                if (!saved && layouts["_ignoreLegacy"] !== true)
                {
                    try { saved = getStorage().data[key]; }
                    catch (storageError:Error)
                    {
                        ClientLogger.log("[WindowGeometry] Legacy read failed: " + storageError.message);
                    }
                };
                if (!saved || !isFinite(saved.x) || !isFinite(saved.y) ||
                    !isFinite(saved.width) || !isFinite(saved.height) || saved.width <= 0 || saved.height <= 0) return;
                panel.clearStyle("horizontalCenter");
                panel.clearStyle("verticalCenter");
                panel.clearStyle("left");
                panel.clearStyle("right");
                panel.clearStyle("top");
                panel.clearStyle("bottom");
                panel.width = Math.max(minimumWidth, Math.min(saved.width, panel.stage.stageWidth));
                panel.height = Math.max(minimumHeight, Math.min(saved.height, panel.stage.stageHeight));
                panel.x = Math.max(0, Math.min(saved.x, panel.stage.stageWidth - panel.width));
                panel.y = Math.max(0, Math.min(saved.y, panel.stage.stageHeight - panel.height));
            }
            catch (error:Error)
            {
                ClientLogger.log("[WindowGeometry] Restore failed: " + error.message);
            }
        }
    }
}
