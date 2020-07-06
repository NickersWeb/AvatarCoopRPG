import echo.Body;
import echo.World;
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
import echo.Echo;
import Entity;

class Main extends hxd.App {
	public static var world:World;

	#if debug
	public var echo_debug_drawer:HeapsDebug;
	#end

	static function main() {
		Res.initEmbed();
		new Main();
	}

	override function init() {
		super.init();

		// Create a new echo World, set to the size of the heaps engine
		world = new World({
			width: engine.width,
			height: engine.height,
			gravity_y: 0
		});
		#if debug
		echo_debug_drawer = new HeapsDebug(s2d);
		#end
		loadTileMap();
	}

	override function onResize() {
		super.onResize();
		world.width = s2d.width;
		world.height = s2d.height;
	}

	private function loadTileMap() {
		var map = new ogmo.Project(Res.data.AvatarWorld_ogmo, true);
		var player:ogmo.Entity = null;
		for (level in map.levels) {
			for (layer in level.layers) {
				for (entity in layer.entities) {
					switch (entity.name) {
						case 'player':
							player = entity;
							
					}
				}
				layer.render(s2d);
			}
		}
		loadPlayer(player);
	}

	private function loadPlayer(entity:ogmo.Entity) {
		// Need somewhere to store data.
		var player:Person = PersonUtils.GetPerson(s2d, {
			x: entity.x,
			y: entity.y,
			elasticity: 0.2,
			shape: {
			  type: CIRCLE,
			  radius: 16,
			}
		  }, "air");
		player.name = "player";
		//player.setPosition(entity.x, entity.y);
		player.personAnimation();
	}

	override function update(dt:Float) {
		super.update(dt);

		// step all the entities
		for (entity in Entity.all)
			entity.step(dt);

		// step the world
		world.step(dt);

		#if debug
		if (Key.isPressed(Key.QWERTY_TILDE))
			echo_debug_drawer.canvas.visible = !echo_debug_drawer.canvas.visible;
		echo_debug_drawer.draw(world);
		#end
	}
}
