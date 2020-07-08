import format.abc.Data.ABCData;
import haxe.ds.List;
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
import echo.util.Debug;
import hxd.Key;

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
			width: 800,
			height: 800,
			gravity_y: 0
		});
		var body = new Body({
			x: 50,
			y: 50,
			elasticity: 0.3,
			shape: {
				type: RECT,
				width: 50,
				height: 50
			}
		});
		body.velocity.x = 10;
		world.add(body);
		loadTileMap();
		#if debug
		echo_debug_drawer = new HeapsDebug(s2d);
		#end
	}

	override function onResize() {
		super.onResize();
		world.width = s2d.width;
		world.height = s2d.height;
	}

	private function loadTileMap() {
		var map = new ogmo.Project(Res.data.AvatarWorld_ogmo, true);
		var player:ogmo.Entity = null;
		var enemies:List<ogmo.Entity> = new List<ogmo.Entity>();
		for (level in map.levels) {
			for (layer in level.layers) {
				for (entity in layer.entities) {
					switch (entity.name) {
						case 'player':
							player = entity;
							case 'enemy':
								enemies.add(entity);
					}
				}
				layer.render(s2d);
			}
		}
		loadPlayer(player);
		loadLevelEnemies(enemies);
	}
	private function loadLevelEnemies(enemies:List<ogmo.Entity>){
		for(entity in enemies){
			loadEnemy(entity);
		}
	}
	private function loadEnemy(entity:ogmo.Entity) {
		// Need somewhere to store data.
		var enemy:PersonEnemy = new PersonEnemy(s2d, {
			x: entity.x,
			y: entity.y,
			drag_length: 20,
			elasticity: 0.2,
			shape: {
				type: CIRCLE,
				radius: 16,
			}
		});
		enemy.personAnimation();
	}

	private function loadPlayer(entity:ogmo.Entity) {
		// Need somewhere to store data.
		var player:Person = PersonUtils.GetPerson(s2d, {
			x: entity.x,
			y: entity.y,
			drag_length: 20,
			elasticity: 0.2,
			shape: {
				type: CIRCLE,
				radius: 16,
			}
		}, "air");
		player.name = "player";
		// player.setPosition(entity.x, entity.y);
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
		// if (Key.isPressed(Key.QWERTY_TILDE) || Key.isPressed(Key.TAB))
		//	echo_debug_drawer.canvas.visible = !echo_debug_drawer.canvas.visible;
		echo_debug_drawer.draw(world);
		#end
	}
}
