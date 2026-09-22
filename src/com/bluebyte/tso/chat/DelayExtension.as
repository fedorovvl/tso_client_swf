package com.bluebyte.tso.chat
{
    import org.igniterealtime.xiff.data.Extension;
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;
    import org.igniterealtime.xiff.data.ISerializable;
    import flash.xml.XMLNode;
    import org.igniterealtime.xiff.data.ExtensionClassRegistry;

    public class DelayExtension extends Extension implements IMessageExtension, ISerializable 
    {

        public static var NS:String = "urn:xmpp:delay";
        public static var ELEMENT_NAME:String = "delay";

        public var mSendDate:Date;
        private var exp:RegExp = /(\d\d\d\d)([- \/.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])T([0-2][0-9]):([0-5][0-9]):([0-5][0-9]).([0-9]{3})Z/i;

        public function DelayExtension(_arg_1:XMLNode=null)
        {
            super(null);
        }

        override public function set xml(_arg_1:XML):void
        {
            super.xml = _arg_1;
            var _local_2:XMLList = _arg_1.attribute("stamp");
            if (_local_2.length() > 0 && _local_2.toString() != "")
            {
                var _local_3:Object = this.exp.exec(_local_2.toString());
                if (_local_3 != null)
                {
                    this.mSendDate = new Date(_local_3[1], (_local_3[3] - 1), _local_3[4], _local_3[5], _local_3[6], _local_3[7], _local_3[8]);
                    this.mSendDate.minutesUTC = (this.mSendDate.minutesUTC - this.mSendDate.getTimezoneOffset());
                };
            };
        }

        public static function enable():void
        {
            ExtensionClassRegistry.register(DelayExtension);
        }


        public function serialize(_arg_1:XMLNode):Boolean
        {
            return (true);
        }

        public function getNS():String
        {
            return (DelayExtension.NS);
        }

        public function getElementName():String
        {
            return (DelayExtension.ELEMENT_NAME);
        }

        public function deserialize(_arg_1:XMLNode):Boolean
        {
            var _local_2:Object;
            setNode(_arg_1);
            if (_arg_1.attributes.stamp)
            {
                _local_2 = this.exp.exec(_arg_1.attributes.stamp);
                this.mSendDate = new Date(_local_2[1], (_local_2[3] - 1), _local_2[4], _local_2[5], _local_2[6], _local_2[7], _local_2[8]);
                this.mSendDate.minutesUTC = (this.mSendDate.minutesUTC - this.mSendDate.getTimezoneOffset());
            };
            return (true);
        }


    }
}
