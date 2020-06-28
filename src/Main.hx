import h2d.Graphics;
import hxd.Res;

class Main extends hxd.App
{
	static function main() 
	{
		new Main();
	}
	override function init()
	{
		super.init();
		Res.initEmbed();
		loadTileMap();
	}
	public function loadTileMap()
	{
		var map = new ogmo.Project(Res.data.AvatarWorld_ogmo,true);
		for (level in map.levels)
		{
			for (layer in level.layers)
			{
				var obj = layer.render(s2d);
			}
		}
	}
}
