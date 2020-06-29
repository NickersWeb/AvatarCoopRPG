import h2d.Text;
import h2d.Font;
import hxd.res.DefaultFont;
import h2d.Graphics;
import hxd.Res;

class Main extends hxd.App
{
	static function main() 
	{
		new Main();
	}
	var font:Font;
	var fps:Text;
	var player:Person;
	override function init()
	{
		super.init();
		Res.initEmbed();
		font = DefaultFont.get();
		loadTileMap();
		fps = new Text(font,s2d);
		player = new Person(s2d);
	}
	override function update(dt:Float) {
		super.update(dt);
		fps.text = 'fps: ${Std.int(engine.fps + 0.5)} draws: ${engine.drawCalls}';
	}
	private function loadTileMap()
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
	private function loadPlayer() {
		
	}
}
