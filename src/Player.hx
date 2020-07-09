import hxd.Res;
import h2d.Anim;
import h2d.Tile;
class Player extends Anim
{
    var tile:Tile;
    public function new(parent)
    {
        tile = Res.images.player.sPlayerMaleAnimations.toTile();
        super(getTiles(64),8,parent);
    }
    private function getTiles(size:Int)
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