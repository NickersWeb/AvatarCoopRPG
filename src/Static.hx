import h2d.Tile;
class Static
{
    public static inline function getTiles(tile:Tile,size:Int):Array<Tile>
    {
        var array:Array<Tile> = [];
        for (y in 0...Std.int(tile.height / size)) {
            for (x in 0...Std.int(tile.width / size)) {
                array.push(tile.sub(x * size, y * size, size, size, -0.5 * size, -0.5 * size));
            }
        }
        return array;
    }
}