package Sound
{
    import nLib.cXML;
    import flash.media.SoundChannel;
    import flash.utils.Dictionary;
    import flash.media.SoundTransform;
    import Interface.cGameInterface;

    public class cSoundManager 
    {

        public static const BUTTON_CLICK:String = "ButtonClick";
        public static const CG_START_ROLL:String = "CGStartRoll";
        public static const CG_SHORT_COUNT:String = "CGShortCount";
        public static const CG_COUNT_CLICK:String = "CGCountClick";
        public static const CG_GEM_CLICK:String = "CGGemClick";
        public static const CG_JACKPOT:String = "CGJackpot";
        private static var mInstance:cSoundManager;

        private const SOUND_EXTENSION:String = ".mp3";
        private var defaultLoop:String = "Standard";
        private var mEffectsMuted:Boolean = false;
        private var mInitialized:Boolean = false;
        private var mLoopsMuted:Boolean = false;
        private var mXml:cXML;
        private var loopChannel:SoundChannel = null;

        private var mEffects:Dictionary = new Dictionary();
        private var mLoops:Dictionary = new Dictionary();
        private var currentLoop:String = defaultLoop;
        private var mLoopsVolume:SoundTransform = new SoundTransform(1, 0);
        private var mEffectsVolume:SoundTransform = new SoundTransform(1, 0);
        private var mEventLoopNames:Dictionary = new Dictionary();

        public function cSoundManager(_arg_1:cSingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("cSoundManager is a Singleton. Use GetInstance() to use this class."));
            };
            this.mEffectsMuted = cSettingsManager.getInstance().sfxMuted;
            this.mLoopsMuted = cSettingsManager.getInstance().loopsMuted;
        }

        public static function getInstance():cSoundManager
        {
            if (mInstance == null)
            {
                mInstance = new cSoundManager(new cSingletonEnforcer());
            };
            return (mInstance);
        }


        public function restartLoops():void
        {
            this.stopLoop();
            this.startLoop();
        }

        public function setEffectsVolume(_arg_1:Number):void
        {
            this.mEffectsVolume.volume = _arg_1;
        }

        private function stopLoop():void
        {
            if (this.loopChannel)
            {
                this.loopChannel.stop();
            };
        }

        public function playLoop(_arg_1:String=null):void
        {
            _arg_1 = ((_arg_1) ? _arg_1 : this.defaultLoop);
            if (_arg_1 == this.currentLoop)
            {
                return;
            };
            this.stopLoop();
            this.currentLoop = _arg_1;
            if (!this.mLoopsMuted)
            {
                this.startLoop();
            };
        }

        public function init():void
        {
            if (this.mInitialized)
            {
                return;
            };
            this.mInitialized = true;
            var _local_1:cXML = new cXML();
            _local_1.LoadFile(global.soundSettingsFilename, this.loadXML, definesMaster.LOAD_ENC);
        }

        private function loadXML(_arg_1:cXML):void
        {
            var _local_2:cXML;
            var _local_3:cXML;
            var _local_4:cXML;
            var _local_5:String;
            var _local_6:Boolean;
            for each (_local_2 in _arg_1.MoveToSubNodeAndCreateChildrenArray("Effects"))
            {
                this.loadSounds(this.mEffects, _local_2, "sounds/effects/");
            };
            if (!_arg_1.isEmpty())
            {
                _local_3 = _arg_1.MoveToSubNode("Loops");
                this.defaultLoop = _local_3.GetAttributeString_string("default");
                for each (_local_4 in _local_3.CreateChildrenArray())
                {
                    _local_5 = _local_4.GetAttributeString_string("requiresEvent");
                    if ((((!(_local_5 == null)) && (!(_local_5 == ""))) && ((global.ui as cGameInterface).mEventManager.isEventStarted(_local_5))))
                    {
                        _local_6 = (!(this.currentLoop == this.defaultLoop));
                        this.defaultLoop = _local_4.GetAttributeString_string("name");
                        if (!_local_6)
                        {
                            this.currentLoop = this.defaultLoop;
                        };
                    };
                    this.loadSounds(this.mLoops, _local_4, "sounds/loops/");
                };
                if (!this.mLoopsMuted)
                {
                    this.startLoop();
                };
            };
        }

        public function isEffectsMuted():Boolean
        {
            return (this.mEffectsMuted);
        }

        private function loadSounds(_arg_1:Dictionary, _arg_2:cXML, _arg_3:String):void
        {
            var _local_5:cXML;
            var _local_6:String;
            var _local_7:TSOSound;
            var _local_8:String;
            var _local_9:String;
            var _local_4:String = _arg_2.GetAttributeString_string("name");
            if (((!(_arg_1[_local_4] is TSOSound)) && (!(_arg_2.GetAttributeString_string("file") == ""))))
            {
                _local_6 = ((_arg_3 + _arg_2.GetAttributeString_string("file")) + this.SOUND_EXTENSION);
                _local_7 = new TSOSound();
                _local_7.loadSound(_local_6, _local_4);
                defines.soundEffects[_local_4] = true;
                _arg_1[_local_4] = _local_7;
                _local_8 = _arg_2.GetAttributeString_string("requiresEvent");
                if (_local_8 != "")
                {
                    this.mEventLoopNames[_local_8] = _local_4;
                };
            };
            for each (_local_5 in _arg_2.CreateChildrenArray())
            {
                _local_9 = ((_local_4 + "_") + _local_5.GetAttributeString_string("name"));
                if (((!(_arg_1[_local_9] is TSOSound)) && (!(_local_5.GetAttributeString_string("file") == ""))))
                {
                    _local_6 = ((_arg_3 + _local_5.GetAttributeString_string("file")) + this.SOUND_EXTENSION);
                    _local_7 = new TSOSound();
                    _local_7.loadSound(_local_6, _local_9);
                    defines.soundEffects[_local_9] = true;
                    _arg_1[_local_9] = _local_7;
                };
            };
        }

        public function toggleLoops():void
        {
            this.mLoopsMuted = (!(this.mLoopsMuted));
            if (((!(this.mLoopsMuted)) && (!(this.mInitialized))))
            {
                this.init();
            }
            else
            {
                if (this.mLoopsMuted)
                {
                    this.stopLoop();
                }
                else
                {
                    this.startLoop();
                };
            };
        }

        public function setLoopsVolume(_arg_1:Number):void
        {
            this.mLoopsVolume.volume = _arg_1;
        }

        public function refreshLoopWithEvent(_arg_1:String):void
        {
            var _local_2:String = this.mEventLoopNames[_arg_1];
            if (((!(this.mInitialized)) || (!(this.mLoops[_local_2]))))
            {
                return;
            };
            this.defaultLoop = _local_2;
            this.playLoop(_local_2);
        }

        public function toggleEffects():void
        {
            this.mEffectsMuted = (!(this.mEffectsMuted));
            if (((!(this.mEffectsMuted)) && (!(this.mInitialized))))
            {
                this.init();
            };
        }

        public function isLoopsMuted():Boolean
        {
            return (this.mLoopsMuted);
        }

        public function playEffect(_arg_1:String, _arg_2:String=""):void
        {
            if (this.mEffectsMuted)
            {
                return;
            };
            var _local_3:TSOSound = ((this.mEffects[((_arg_1 + "_") + _arg_2)]) ? this.mEffects[((_arg_1 + "_") + _arg_2)] : this.mEffects[_arg_1]);
            if (((_local_3) && (defines.soundEffects[_local_3.name])))
            {
                _local_3.play(0, 0, this.mEffectsVolume);
            };
        }

        private function startLoop():void
        {
            if ((this.mLoops[this.currentLoop] is TSOSound))
            {
                this.loopChannel = (this.mLoops[this.currentLoop] as TSOSound).play(0, int.MAX_VALUE, this.mLoopsVolume);
            };
        }


    }
}//package Sound

class cSingletonEnforcer 
{

    public function cSingletonEnforcer()
    {
        super();
    }

}


