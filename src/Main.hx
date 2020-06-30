import h2d.Scene;
import h2d.Camera;
import ogmo.Entity;
import hxd.Pixels;
import h2d.Tile;
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
	var int:Int = 0;
	override function init()
	{
		super.init();
		Res.initEmbed();
		font = DefaultFont.get();
		loadTileMap();
		fps = new Text(font,s2d);
	}
	override function update(dt:Float) {
		super.update(dt);
		if (int++ % 100 == 0) fps.text = 'fps: ${Std.int(engine.fps + 0.5)} draws: ${engine.drawCalls}';
		player.personAnimation();
	}
	private function loadTileMap()
	{
		var map = new ogmo.Project(Res.data.AvatarWorld_ogmo,true);
		var player:Entity = null;
		for (level in map.levels)
		{
			for (layer in level.layers)
			{
				for (entity in layer.entities){
					switch (entity.name){
						case 'player':
						player = entity;
					}
				}
				layer.render(s2d);
				
			}
		}
		loadPlayer(player);
	}
	private function loadPlayer(entity:Entity) {
		player = PersonUtils.GetPerson(s2d, entity);
		player.setPosition(entity.x, entity.y);
	}
}
