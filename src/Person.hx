import haxe.macro.Expr.Case;
import h3d.pass.Default;
import hxmath.math.Vector2;
import hxd.Window;
import sys.ssl.Key;
import hxd.Event;
import h2d.Interactive;
import h2d.Graphics;
import hxd.Res;
import h2d.Tile;
import h2d.Object;
import h2d.Anim;
import h2d.Drawable;
import hxd.fmt.blend.Data.Handle;
import echo.data.Options.BodyOptions;

enum State {
	Run;
	Walk;
	Dodge;
	Attack;
	Idle;
	None;
}

enum Facing {
	Up;
	UpLeft;
	UpRight;
	Down;
	DownLeft;
	DownRight;
	Left;
	Right;
}

class Person extends Entity {
	var WALKSPEED:Float = 95;
	var RUNSPEED:Float = 200;
	var DODGESPEED:Float = 500;
	var BENDINGSPEED:Float = 850;

	var tile:Tile;
	var anim:Anim = new Anim();
	var atkIndex:Int = 0;
	var state(default, set):State = Idle;

	var gender:String = "m";
	var facing(default, set):Facing = DownLeft;
	var interaction:Interactive;

	public var anims:Map<String, Array<Tile>> = new Map<String, Array<Tile>>();

	public override function new(?parent:Object, body_options:BodyOptions) {
		super(parent, body_options);
		this.anim = new Anim(null, 10, this);
		loadPersonData();
		interaction = new h2d.Interactive(Main.world.width, Main.world.height, this);
		interaction.onClick = personClickEvent;
		interaction.onKeyDown = personEvent;
	}

	private function onAnimEnd() {
		switch (this.state) {
			case Run:
			case Dodge:
				this.state = Run;
			case Walk:
				this.state = Walk;
			case Idle, Attack, None:
				this.state = Idle;
		}
	}

	public function personAnimation() {
		var a:Array<Tile> = PersonUtils.animCal(this.tile, 64, 64, 64, this.facing);
		switch (this.state) {
			case Run:
				this.runAnimation(a);
			case Dodge:
				this.dodgeRollAnimation(a);
			case Walk:
				this.walkAnimation(a);
			case Idle:
				this.idleAnimation(a);
			case Attack, None:
		}
	}

	private function personClickEvent(event:Event) {
		var rClick = hxd.Key.isDown(hxd.Key.MOUSE_RIGHT);
		var lClick = hxd.Key.isDown(hxd.Key.MOUSE_LEFT);
		trace('$event.keyCode personClickEvent');
		if (rClick) {
			if (!this.state.equals(Idle)) {
				this.state = Dodge;
			}
		} else if (lClick) {
			this.state = Attack;
		}
	}

	private function personEvent(event:Event) {
		var up = hxd.Key.isDown(hxd.Key.W);
		var down = hxd.Key.isDown(hxd.Key.S);
		var left = hxd.Key.isDown(hxd.Key.A);
		var right = hxd.Key.isDown(hxd.Key.D);
		var shift = hxd.Key.isDown(hxd.Key.SHIFT);
		trace('$event.keyCode personEvent');
		if (up && down) {
			up = down = false;
			return;
		}
		if (left && right) {
			left = right = false;
			return;
		}

		if (up || down || left || right) {
			if (shift) {
				this.state = Run;
			} else {
				this.state = Walk;
			}

			if (up) {
				if (left) {
					this.facing = UpLeft;
				} else if (right) {
					this.facing = UpRight;
				} else {
					this.facing = Up;
				}
			} else if (down) {
				if (left) {
					this.facing = DownLeft;
				} else if (right) {
					this.facing = DownRight;
				} else {
					this.facing = Down;
				}
			} else if (left) {
				this.facing = Left;
			} else if (right) {
				this.facing = Right;
			}
		} else {
			this.state = Idle;
		}
	}

	private function movePerson(dt:Float) {
		var newAngle:Float = 0;
		switch (this.facing) {
			case Up:
				newAngle = 270;
			case UpLeft:
				newAngle = 225;
			case UpRight:
				newAngle = 315;
			case Down:
				newAngle = 90;
			case DownLeft:
				newAngle = 135;
			case DownRight:
				newAngle = 45;
			case Left:
				newAngle = 180;
			case Right:
				newAngle = 0;
		}
		var angle = hxd.Math.degToRad(newAngle);
		var spd = this.personSpeedCal(dt);
		this.body.velocity.set(Math.cos(angle) * spd, Math.sin(angle) * spd);
	}

	private function personSpeedCal(dt:Float):Float {
		var speed:Float = 0;
		switch (this.state) {
			case Run:
				speed = RUNSPEED;
			case Dodge:
				speed = DODGESPEED;
			case Walk:
				speed = WALKSPEED;
			case Attack, Idle, None:
				speed = 0;
		}
		return ((speed * dt) * 50);
	}

	private function loadPersonData() {
		// for character setup, e.g. clothing, inventory etc.
	}

	private function walkAnimation(a:Array<Tile>) {
		this.anim.speed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 7...14 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 39...46 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 55...62 + 1) a[i]]);
			case UpLeft, UpRight:
				this.anim.play([for (i in 23...30 + 1) a[i]]);
			case DownLeft, DownRight:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
	}

	private function runAnimation(a:Array<Tile>) {
		this.anim.speed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 15...22 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 47...54 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 71...77 + 1) a[i]]);
			case UpLeft, UpRight:
				this.anim.play([for (i in 31...38 + 1) a[i]]);
			case DownLeft, DownRight:
				this.anim.play([for (i in 63...70 + 1) a[i]]);
		}
	}

	private function dodgeRollAnimation(a:Array<Tile>) {
		this.anim.speed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 96...99 + 1) a[i]]);
			case DownLeft, DownRight:
				this.anim.play([for (i in 100...102 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 103...108 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 109...112 + 1) a[i]]);
			case UpLeft, UpRight:
				this.anim.play([for (i in 100...102 + 1) a[i]]);
		}
		this.anim.onAnimEnd = onAnimEnd;
	}

	private function idleAnimation(a:Array<Tile>) {
		this.anim.speed = 0.5;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 94...95 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 90...91 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 88...89 + 1) a[i]]);
			case UpLeft, UpRight:
				this.anim.play([for (i in 92...93 + 1) a[i]]);
			case DownLeft, DownRight:
				this.anim.play([for (i in 86...87 + 1) a[i]]);
		}
	}

	function set_facing(f) {
		if (f != this.facing) {
			this.facing = f;
			var a:Array<Tile> = PersonUtils.animCal(this.tile, 64, 64, 64, this.facing);
			switch (this.state) {
				case Run:
					this.runAnimation(a);
				case Walk:
					this.walkAnimation(a);
				case Dodge:
					this.dodgeRollAnimation(a);
				case Attack:
				case Idle:
					this.idleAnimation(a);
				case None:
			}
		}

		return f;
	}

	function set_state(s) {
		if (s != this.state) {
			this.state = s;
			var a:Array<Tile> = PersonUtils.animCal(this.tile, 64, 64, 64, this.facing);
			switch (this.state) {
				case Run:
					this.runAnimation(a);
				case Walk:
					this.walkAnimation(a);
				case Dodge:
					this.dodgeRollAnimation(a);
				case Attack:
				case Idle:
					this.idleAnimation(a);
				case None:
			}
		}

		return s;
	}

	// Overide echo update loop
	public override function step(dt:Float) {
		super.step(dt);
		this.movePerson(dt);
	}
}
