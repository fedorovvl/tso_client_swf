package converted.bluebyte.tso.reaction
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import Communication.VO.ReactionVO;
    import Interface.cGameInterface;
    import Communication.VO.ReactionListVO;
    import __AS3__.vec.*;

    public class ReactionList implements Disposable 
    {

        private var reactions_vector:Vector.<Reaction> = null;

        public function ReactionList(_arg_1:cGameInterface, _arg_2:ReactionListVO)
        {
            var _local_3:ReactionVO;
            super();
            if (_arg_2 != null)
            {
                this.reactions_vector = new Vector.<Reaction>();
                for each (_local_3 in _arg_2.list)
                {
                    this.reactions_vector.push(new Reaction(_arg_1, _local_3));
                };
            };
        }

        public function dispose():void
        {
            var _local_1:Reaction;
            if (this.reactions_vector != null)
            {
                for each (_local_1 in this.reactions_vector)
                {
                    _local_1.dispose();
                };
                this.reactions_vector = null;
            };
        }


    }
}
