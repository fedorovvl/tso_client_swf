package GUI.Assets
{
    import mx.controls.Image;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.ui.assets.SpriteVO;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.xml.XMLNode;
    import flash.events.Event;
    import nLib.cXML;
    import flash.display.Bitmap;
    import __AS3__.vec.*;

    public final class Animation extends Image 
    {

        private var time:Number;
        private var sprites:Vector.<SpriteVO>;
        private var offset:Point;
        private var spriteSheet:BitmapData;
        private var i:int;
        private var rubber:Rectangle;
        public var onAnimationEnd:Function;
        public var onAnimationLoop:Function;
        private var bmd:BitmapData;
        private var timeScale:Number;
        public var looping:Boolean = false;

        public function Animation(_arg_1:XMLNode=null)
        {
            super();
            this.xml = _arg_1;
        }

        override public function set y(_arg_1:Number):void
        {
            super.y = (_arg_1 - this.offset.y);
        }

        protected function anim(_arg_1:Event):void
        {
            this.bmd.fillRect(this.rubber, 0);
            this.time = (this.time + this.timeScale);
            this.i = int(this.time);
            if (this.i >= this.sprites.length)
            {
                this.i = (this.time = 0);
                if (!this.looping)
                {
                    removeEventListener(Event.ENTER_FRAME, this.anim);
                    if (this.onAnimationEnd != null)
                    {
                        this.onAnimationEnd();
                    };
                    return;
                };
                if (this.onAnimationLoop != null)
                {
                    this.onAnimationLoop();
                };
            };
            var _local_2:SpriteVO = this.sprites[this.i];
            this.rubber.x = _local_2.offset.x;
            this.rubber.y = _local_2.offset.y;
            this.rubber.width = _local_2.rect.width;
            this.rubber.height = _local_2.rect.height;
            this.bmd.copyPixels(this.spriteSheet, _local_2.rect, _local_2.offset);
        }

        public function set xml(_arg_1:XMLNode):void
        {
            var _local_2:XMLNode;
            var _local_3:SpriteVO;
            if (_arg_1 == null)
            {
                return;
            };
            this.sprites = new Vector.<SpriteVO>();
            for each (_local_2 in cXML.getChildNodes(_arg_1, "sprite"))
            {
                _local_3 = new SpriteVO();
                _local_3.rect = new Rectangle(parseFloat(_local_2.attributes["x"]), parseFloat(_local_2.attributes["y"]), parseFloat(_local_2.attributes["w"]), parseFloat(_local_2.attributes["h"]));
                _local_3.offset = new Point(parseFloat(_local_2.attributes["oX"]), parseFloat(_local_2.attributes["oY"]));
                this.sprites.push(_local_3);
            };
            this.spriteSheet = gAssetManager.GetGfx(_arg_1.attributes["imagePath"]).bitmapData;
            this.bmd = new BitmapData(parseFloat(cXML.getFirstChildNode(_arg_1, "sprite").attributes["oW"]), parseFloat(cXML.getFirstChildNode(_arg_1, "sprite").attributes["oH"]), true, 0);
            this.timeScale = parseFloat(_arg_1.attributes["timeScale"]);
            this.offset = new Point(parseFloat(_arg_1.attributes["oX"]), parseFloat(_arg_1.attributes["oY"]));
            this.rubber = new Rectangle(0, 0, 0, 0);
            if (this.timeScale == 0)
            {
                this.timeScale = 1;
            };
            this.includeInLayout = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.source = new Bitmap(this.bmd);
        }

        override public function set x(_arg_1:Number):void
        {
            super.x = (_arg_1 - this.offset.x);
        }

        public function play():void
        {
            this.i = (this.time = 0);
            if ((((!(this.spriteSheet == null)) && (this.sprites.length > 0)) && (!(hasEventListener(Event.ENTER_FRAME)))))
            {
                addEventListener(Event.ENTER_FRAME, this.anim);
            };
        }


    }
}
