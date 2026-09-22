package GUI
{
    import flash.filters.ColorMatrixFilter;

    public function greyFilter(_arg_1:Number=0.4):ColorMatrixFilter
    {
        return (new ColorMatrixFilter([_arg_1, _arg_1, _arg_1, 0, 0, _arg_1, _arg_1, _arg_1, 0, 0, _arg_1, _arg_1, _arg_1, 0, 0, 0, 0, 0, 1, 0]));
    }
}
