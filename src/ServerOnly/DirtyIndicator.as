package ServerOnly
{
    import Enums.DIRTY_INDICATOR;

    public class DirtyIndicator 
    {

        public var value:int = 0;


        public function strongModified():void
        {
            this.value = (this.value | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function weakModified():void
        {
            this.value = (this.value | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
        }

        public function isDataDeleted():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.DATA_DELETED_BIT) > 0);
        }

        public function isDeleted():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.DELETED_BIT) > 0);
        }

        public function created():void
        {
            this.value = (this.value | DIRTY_INDICATOR.CREATED_BIT);
        }

        public function clean():void
        {
            this.value = DIRTY_INDICATOR.CLEAN;
        }

        public function isStrongModified():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.MODIFIED_BIT) > 0);
        }

        public function dataModified():void
        {
            this.value = (this.value | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
        }

        public function isDataAdded():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.DATA_ADDED_BIT) > 0);
        }

        public function dataDeleted():void
        {
            this.value = (this.value | DIRTY_INDICATOR.DATA_DELETED_BIT);
        }

        public function isWeakModified():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.WEAK_MODIFICATION_BIT) > 0);
        }

        public function dataAdded():void
        {
            this.value = (this.value | DIRTY_INDICATOR.DATA_ADDED_BIT);
        }

        public function deleted():void
        {
            this.value = DIRTY_INDICATOR.DELETED_BIT;
        }

        public function isModified():Boolean
        {
            return ((this.isWeakModified()) || (this.isStrongModified()));
        }

        public function isDataMofified():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.DATA_MODIFIED_BIT) > 0);
        }

        public function isCreated():Boolean
        {
            return ((this.value & DIRTY_INDICATOR.CREATED_BIT) > 0);
        }

        public function isClean():Boolean
        {
            return (this.value == DIRTY_INDICATOR.CLEAN);
        }


    }
}
