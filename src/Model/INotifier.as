package Model
{
    import Utils.Disposable;

    public interface INotifier extends Disposable 
    {

        function removeAllObservers():void;
        function notifyPropertyObserver(_arg_1:String, _arg_2:Object):void;
        function mapTo(_arg_1:ChannelMap, _arg_2:String):void;
        function addPropertyObserver(_arg_1:String, _arg_2:Observer):void;
        function removePropertyObserver(_arg_1:String, _arg_2:Observer):void;

    }
}
