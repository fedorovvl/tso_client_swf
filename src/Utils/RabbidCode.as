package Utils
{
    import mx.core.UIComponent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    public class RabbidCode 
    {

        private var sequence:Array;

        public function RabbidCode()
        {
            super();
            this.reset();
            (global.getApplication() as UIComponent).stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
        }

        private function handleKeyUp(_arg_1:KeyboardEvent):void
        {
            var _local_2:int = this.sequence.shift();
            if (_arg_1.keyCode == _local_2)
            {
                if (this.sequence.length == 0)
                {
                    this.action();
                }
                else
                {
                    return;
                };
            };
            this.reset();
        }

        private function action():void
        {
            var _local_1:Array = ["Alexander", "Ally", "Andreas", "Andrey", "Angel", "Anna", "Anton", "Arvind", "Axel", "Bianca", "Brandon", "Clara", "Claude", "Cyra", "David", "Denis", "Dmitry", "Elena", "Erkan", "Ernst", "Fabien", "Federico", "Ferhat", "Georgi", "Hana", "Holger", "Iann", "Jakub", "Jamie", "Jenni", "Jeremy", "John", "Jorge", "Linda", "Magdalena", "Marianne", "Marius", "Markus", "Mehdi", "Nick", "Oliver", "Patricia", "Patrick", "Paul", "Paul", "Peter", "Philipp", "Robert", "Sebastian ", "Stefan", "Stefan ", "Sven ", "Violeta ", "Wendy", "Zaneta", "Zoltan"];
            global.ui.mCurrentPlayerZone.mSettlerKIManager.setNameList(_local_1);
        }

        private function reset():void
        {
            this.sequence = [Keyboard.UP, Keyboard.UP, Keyboard.DOWN, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.RIGHT, "B".charCodeAt(0), "A".charCodeAt(0)];
        }


    }
}
