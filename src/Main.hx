import hxd.fmt.grd.Data.Color;
import h2d.Bitmap;
import hxd.Window;
import h2d.Drawable;
import hxd.Event;
import echo.Line;
import hxd.Cursor;
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
	private static var cursor:Body;
	private static var line:Line;
	private static var player:Person;

	public var camera:Camera;
	#if debug
	public var echo_debug_drawer:HeapsDebug;
	#end

	static function main() {
		Res.initEmbed();
		new Main();
	}

	// avatar game
	// run and walk
	// move character facing direction
	// mouse on left click, "aim". Only allow walking attack speeds.
	// character will face mouse direction
	// dodge on right
	override function init() {
		super.init();
		// Create a new echo World, set to the size of the heaps engine
		world = new World({
			width: s2d.width,
			height: s2d.height,
			gravity_y: 0
		});
		camera = new Camera(s2d);
		loadCursor();
		loadTileMap();
		loadLine();
		new Fps(150, s2d);
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
		loadLevelEnemies(enemies, loadPlayer(player));
	}

	private function loadLevelEnemies(enemies:List<ogmo.Entity>, player:Person) {
		for (entity in enemies) {
			loadEnemy(entity, player);
		}
	}

	private function loadEnemy(entity:ogmo.Entity, player:Person) {
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

		world.listeners.add(enemy.body, player.body, {
			separate: true, // Setting this to true will cause the Bodies to separate on Collision. This defaults to true
			enter: (a, b, c) -> enemyPlayerEnterCollide(a.entity, b.entity, c), // This callback is called on the first frame that a collision starts
			stay: (a, b,
				c) -> enemyPlayerStayCollide(a.entity, b.entity, c), // This callback is called on frames when the two Bodies are continuing to collide
			exit: (a, b) -> enemyPlayerExitCollide(a.entity, b.entity), // This callback is called when a collision between the two Bodies ends
		});
	}

	private function enemyPlayerEnterCollide(enemy:Entity, player:Entity, cData:Array<echo.data.Data.CollisionData>) {
		trace('start collision $enemy.name and $player.name');
	}

	private function enemyPlayerStayCollide(enemy:Entity, player:Entity, cData:Array<echo.data.Data.CollisionData>) {
		trace('stay collision $enemy.name and $player.name');
	}

	private function enemyPlayerExitCollide(enemy:Entity, player:Entity) {
		trace('end collision $enemy.name and $player.name');
	}

	private function loadPlayer(entity:ogmo.Entity):Person {
		// var player = new Player(s2d,entity.x,entity.y);
		// return; //remove this to test both charachters out
		// Need somewhere to store data.
		var player = PersonUtils.GetPerson(s2d, {
			x: entity.x,
			y: entity.y,
			drag_x: 200,
			drag_y: 200,
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
		player.parent.getScene().addEventListener(function(event:hxd.Event) {
			this.camera.viewY = player.body.last_y;
			this.camera.viewX = player.body.last_x;
		});
		var selItem:Graphics = new Graphics(s2d);
		selItem.lineStyle(1, 0xFFFFFF, 1);
		selItem.drawRect(world.width, world.height, 100, 100);
		selItem.color = new h3d.Vector(255, 255, 255, 1);
		// player.parent.getScene().addEventListener(function(event:hxd.Event) {
		// 	// Update for the bending move selected.
		// });
		return player;
	}

	private function updateMousePlayer(dt:Float) {
		// line.start.set(player.body.x, player.body.y);
		// step cursor
		cursor.velocity.set(s2d.mouseX - cursor.x, s2d.mouseY - cursor.y);
		cursor.velocity *= 100;
		line.end.set(cursor.velocity.x, cursor.velocity.y);
		echo_debug_drawer.draw_line(line.start.x, line.start.y, line.end.x, line.end.y, echo_debug_drawer.intersection_color);
	}

	private function loadLine() {
		line = Line.get(world.width / 2, world.height / 2, world.width / 2, world.height / 2);
		// Line.get(player.body.x, player.body.y);
	}

	private function loadCursor() {
		cursor = new Body({
			x: world.width * 0.5,
			y: world.height * 0.5,
			shape: {
				type: CIRCLE,
				radius: 16
			}
		});
		world.add(cursor);
		#if hlsdl
		sdl.Cursor.show(false);
		#elseif hldx
		dx.Cursor.show(false);
		#end
	}

	override function update(dt:Float) {
		super.update(dt);
		updateMousePlayer(dt);
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
