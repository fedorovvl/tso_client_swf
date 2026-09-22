package com.bluebyte.tso.chat
{
    import org.igniterealtime.xiff.data.Extension;
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;
    import org.igniterealtime.xiff.data.ISerializable;
    import flash.xml.XMLNode;
    import org.igniterealtime.xiff.data.ExtensionClassRegistry;

    public class SWMMOChatMessage extends Extension implements IMessageExtension, ISerializable 
    {

        public static var NS:String = "bbmsg";
        public static var ELEMENT_NAME:String = "bbmsg";
        private static var GIMPLI_ID:String = "GIMPLICIT";

        private var _playerName:String;
        private var _playerID:int;
        private var _playerTag:String = "";

        public function SWMMOChatMessage(_arg_1:XMLNode=null)
        {
            super(null);
        }

        public function get mPlayerName():String
        {
            return (this._playerName);
        }

        public function set mPlayerName(_arg_1:String):void
        {
            this._playerName = _arg_1;
            if (xml != null)
            {
                if (_arg_1 == null)
                {
                    delete xml.@playername;
                }
                else
                {
                    xml.@playername = _arg_1;
                };
            };
        }

        public function get mPlayerID():int
        {
            return (this._playerID);
        }

        public function set mPlayerID(_arg_1:int):void
        {
            this._playerID = _arg_1;
            if (xml != null)
            {
                xml.@playerid = String(_arg_1);
            };
        }

        public function get mPlayerTag():String
        {
            return (this._playerTag);
        }

        public function set mPlayerTag(_arg_1:String):void
        {
            this._playerTag = _arg_1;
            if (xml != null)
            {
                if (_arg_1 == null)
                {
                    delete xml.@playertag;
                }
                else
                {
                    xml.@playertag = _arg_1;
                };
            };
        }

        override public function set xml(_arg_1:XML):void
        {
            super.xml = _arg_1;
            this.readFromXml(_arg_1);
        }

        private function readFromXml(_arg_1:XML):void
        {
            var _local_2:XML;
            var _local_3:String;
            var _local_4:Boolean = false;
            var _local_5:Boolean = false;
            for each (_local_2 in _arg_1.children())
            {
                if (_local_2.nodeKind() != "element")
                {
                    continue;
                };
                if (_local_2.localName().toString() == "playername")
                {
                    this._playerName = _local_2.children().toString();
                    _local_4 = true;
                }
                else
                {
                    if (_local_2.localName().toString() == "playerid")
                    {
                        _local_3 = _local_2.children().toString();
                        if (_local_3 != GIMPLI_ID)
                        {
                            this._playerID = parseInt(_local_3);
                        }
                        else
                        {
                            this._playerID = -1;
                        };
                        _local_5 = true;
                    };
                };
            };
            if (!_local_4)
            {
                if (_arg_1.attribute("playername").length() > 0)
                {
                    this._playerName = _arg_1.attribute("playername").toString();
                }
                else
                {
                    this._playerName = null;
                };
            };
            if (!_local_5)
            {
                if (_arg_1.attribute("playerid").length() > 0)
                {
                    this._playerID = parseInt(_arg_1.attribute("playerid").toString());
                }
                else
                {
                    this._playerID = 0;
                };
            };
            if (_arg_1.attribute("playertag").length() > 0)
            {
                this._playerTag = _arg_1.attribute("playertag").toString();
            }
            else
            {
                this._playerTag = null;
            };
        }

        public static function enable():void
        {
            ExtensionClassRegistry.register(SWMMOChatMessage);
        }


        public function getNS():String
        {
            return (SWMMOChatMessage.NS);
        }

        public function serialize(_arg_1:XMLNode):Boolean
        {
            var _local_2:XMLNode;
            if (!exists(getNode().parentNode))
            {
                _local_2 = getNode().cloneNode(true);
                _local_2.attributes.playerid = this.mPlayerID;
                _local_2.attributes.playername = this.mPlayerName;
                _local_2.attributes.playertag = this.mPlayerTag;
                _arg_1.appendChild(_local_2);
            };
            return (true);
        }

        public function getElementName():String
        {
            return (SWMMOChatMessage.ELEMENT_NAME);
        }

        public function deserialize(_arg_1:XMLNode):Boolean
        {
            var _local_4:XMLNode;
            setNode(_arg_1);
            var _local_2:Boolean;
            var _local_3:Boolean;
            for each (_local_4 in _arg_1.childNodes)
            {
                if (_local_4.nodeName == "playername")
                {
                    this.mPlayerName = _local_4.firstChild.nodeValue;
                    _local_2 = true;
                }
                else
                {
                    if (_local_4.nodeName == "playerid")
                    {
                        if (_local_4.firstChild.nodeValue != GIMPLI_ID)
                        {
                            this.mPlayerID = parseInt(_local_4.nodeValue);
                        }
                        else
                        {
                            this.mPlayerID = -1;
                        };
                        _local_3 = true;
                    };
                };
            };
            if (!_local_2)
            {
                this.mPlayerName = _arg_1.attributes.playername;
            };
            if (!_local_3)
            {
                this.mPlayerID = _arg_1.attributes.playerid;
            };
            this.mPlayerTag = _arg_1.attributes.playertag;
            return (true);
        }


    }
}
