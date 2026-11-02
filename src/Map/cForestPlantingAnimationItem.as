package Map
{
    import GUI.Assets.ForestPlantingAnimation;

    public class cForestPlantingAnimationItem extends cGoSetListAnimationItem
    {
        override public function render(renderFlags:uint):void
        {
            ForestPlantingAnimation.RefreshScale();
            super.render(renderFlags);
        }
    }
}
