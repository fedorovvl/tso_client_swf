package Economy
{
    import Interface.cGeneralInterface;
    import GO.cBuilding;

    public interface BuildingVisitorInterface 
    {

        function visitBuilding(_arg_1:cGeneralInterface, _arg_2:cBuilding, _arg_3:String):Boolean;

    }
}
