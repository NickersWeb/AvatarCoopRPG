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

class Main extends hxd.App {
	static function main() {
		new Main();
	}

	//var world:World;
	var font:Font;
	var fps:Text;
	//var playerB:Body;
	var int:Int = 0;
	public static var world:World;

	override function init() {
		super.init();
		Res.initEmbed();
		// Create a World to hold all the Physics Bodies
		// Worlds, Bodies, and Listeners are all created with optional configuration objects.
		// This makes it easy to construct object configurations, reuse them, and even easily load them from JSON!
		// world = Echo.start({
		// 	width: 64, // Affects the bounds for collision checks.
		// 	height: 64, // Affects the bounds for collision checks.
		// 	gravity_y: 20, // Force of Gravity on the Y axis. Also available for the X axis.
		// 	iterations: 2 // Sets the number of Physics iterations that will occur each time the World steps.
		// });
		world = Echo.start({
			width: s2d.width, // Affects the bounds for collision checks.
			height: s2d.height, // Affects the bounds for collision checks.
			iterations: 1 // Sets the number of Physics iterations that will occur each time the World steps.
		});
		loadTileMap();
		fps = new Text(DefaultFont.get(), s2d);
	}
	override function onResize() {
		super.onResize();
		world.width = s2d.width;
		world.height = s2d.height;
	}
	private function debug() {
		if (int++ % 100 == 0) {
			fps.text = 'fps: ${Std.int(engine.fps + 0.5)} draws: ${engine.drawCalls}';
		}
	}

	override function update(dt:Float) {
		super.update(dt);
		debug();
		world.step(dt);
	}

	private function loadTileMap() {
		var map = new ogmo.Project(Res.data.AvatarWorld_ogmo, true);
		var player:Entity = null;
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

	private function loadPlayer(entity:Entity) {
		var player:Person = PersonUtils.GetPerson(s2d, entity);
		player.setPosition(entity.x, entity.y);
		player.personAnimation();
		// playerB = world.make({
		// 	mass: 45, // Setting this to zero makes the body unmovable by forces and collisions
		// 	y: 48, // Set the object's Y position below the Circle, so that gravity makes them collide
		// 	elasticity: 0.2,
		// 	shape: {
		// 		type: RECT,
		// 		width: 10,
		// 		height: 10
		// 	}
		// });
		//playerB.data = player;
		//world.add(playerB);
	}
}
