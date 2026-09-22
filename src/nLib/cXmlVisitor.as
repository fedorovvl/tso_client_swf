package nLib
{
    import flash.xml.XMLNode;

    public interface cXmlVisitor 
    {

        function visitChild(_arg_1:XMLNode):void;
        function done():void;

    }
}
