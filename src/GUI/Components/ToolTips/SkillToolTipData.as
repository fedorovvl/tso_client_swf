package GUI.Components.ToolTips
{
    import mx.collections.ArrayCollection;
    import flash.display.Bitmap;

    public final class SkillToolTipData 
    {

        public var requirements:String;
        public var skills:ArrayCollection = new ArrayCollection();
        public var additionalText:String;
        public var resourceIcon:Bitmap;


        public function Clone():SkillToolTipData
        {
            var _local_1:SkillToolTipData = new SkillToolTipData();
            _local_1.additionalText = this.additionalText;
            _local_1.requirements = this.requirements;
            _local_1.resourceIcon = new Bitmap(this.resourceIcon.bitmapData);
            _local_1.skills = this.skills;
            return (_local_1);
        }


    }
}
