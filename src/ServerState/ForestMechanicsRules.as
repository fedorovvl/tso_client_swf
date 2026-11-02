package ServerState
{
    import __AS3__.vec.Vector;

    public class ForestMechanicsRules
    {
        private static const RADIUS_CELLS:int = 5;
        private static const WOOD_RESOURCES:Object = {Wood: true, RealWood: true, ExoticWood: true};

        public static function IsWoodHarvester(definition:dResourceCreationDefinition, version:int):Boolean
        {
            if (version != 1 || definition == null || definition.amountRemoved <= 0)
            {
                return (false);
            }
            return (WOOD_RESOURCES[definition.externalResource_string] === true);
        }

        public static function WithinRadius(width:int, origin:int, target:int):Boolean
        {
            // Same doubled staggered-grid coordinates as ForestPlanting.withinRadius.
            var originRow:int = int(origin / width);
            var targetRow:int = int(target / width);
            var dx:Number = 2 * (target % width - origin % width)
                - ((targetRow & 1) == 0 ? 1 : 0) + ((originRow & 1) == 0 ? 1 : 0);
            var dy:Number = targetRow - originRow;
            return ((dy - dx) * (dy - dx) + (dy + dx) * (dy + dx) <= 4 * RADIUS_CELLS * RADIUS_CELLS);
        }

        public static function FilterDestinations(width:int, origin:int, destinations:Vector.<int>):Vector.<int>
        {
            var filtered:Vector.<int> = new Vector.<int>();
            if (destinations != null)
            {
                for each (var destination:int in destinations)
                {
                    if (WithinRadius(width, origin, destination))
                    {
                        filtered.push(destination);
                    }
                }
            }
            return (filtered);
        }
    }
}
