package GUI
{
    import flash.filters.ColorMatrixFilter;

    public function coloringFilter(_arg_1:uint):ColorMatrixFilter
    {
        var _local_2:Number = ((_arg_1 >> 16) & 0xFF);
        var _local_3:Number = ((_arg_1 >> 8) & 0xFF);
        var _local_4:Number = (_arg_1 & 0xFF);
        _local_2 = (_local_2 / 0xFF);
        _local_3 = (_local_3 / 0xFF);
        _local_4 = (_local_4 / 0xFF);
        return (new ColorMatrixFilter([_local_2, 0, 0, 0, 0, 0, _local_3, 0, 0, 0, 0, 0, _local_4, 0, 0, 0, 0, 0, 1, 0]));
    }
}
