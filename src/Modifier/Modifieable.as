package Modifier
{
    public interface Modifieable 
    {

        function setModified(_arg_1:Modifier):void;
        function isModified():Boolean;
        function isModifierApplyable(_arg_1:ModifierVO):Boolean;

    }
}
