import h3d.scene.Scene;
import h2d.RenderContext;
import hxd.Event;
import h2d.Tile;
import h2d.Object;
import h2d.Anim;
import hxd.Key;
import echo.data.Options.BodyOptions;

enum State {
	Run;
	Walk;
	Dodge;
	Attack;
	AttackIdleStance;
	AttackWalkStance;
	Idle;
	None;
}

// Commented out 8d to 4d
enum Facing {
	Up;
	// UpLeft;
	// UpRight;
	Down;
	// DownLeft;
	// DownRight;
	Left;
	Right;
}

class Person extends Entity {
	var WALKSPEED:Float = 95;
	var RUNSPEED:Float = 200;
	var DODGESPEED:Float = 500;
	var BENDINGSPEED:Float = 850;

	var movementTile:Tile;
	var attackTile:Tile;
	var anim:Anim = new Anim();
	var atkIndex:Int = 0;
	var state(default, set):State = Idle;
	var speed:Float = 0;

	var gender:String = "m";
	// Commented out 8d to 4d
	var facing(default, set):Facing = Down; // DownLeft;

	public var anims:Map<String, Array<Tile>> = new Map<String, Array<Tile>>();

	public override function new(?parent:Object, body_options:BodyOptions) {
		super(parent, body_options);
		this.anim = new Anim(null, 10, this);
		loadPersonData();
		this.anim.onAnimEnd = onAnimEnd;
		this.parent.getScene().addEventListener(personEvent);
	}

	private function onAnimEnd() {
		// Needs more work.
		switch (this.state) {
			case Run:
			case Dodge:
				this.state = Run;
			case AttackIdleStance:
				this.state = AttackIdleStance;
			case AttackWalkStance:
				this.state = AttackWalkStance;
			case Idle, Walk, Attack, None:
				this.state = Idle;
		}
	}

	public function personAnimation() {
		var a:Array<Tile> = new Array<Tile>();
		switch (this.state) {
			case Run, Dodge, Walk, Idle, None:
				a = PersonUtils.animCal(this.movementTile, 64, 64, 64, this.facing);
			case Attack, AttackIdleStance, AttackWalkStance:
				a = PersonUtils.animCal(this.attackTile, 64, 64, 64, this.facing);
		}

		switch (this.state) {
			case Run:
				this.runAnimation(a);
			case Dodge:
				this.dodgeRollAnimation(a);
			case Walk:
				this.walkAnimation(a);
			case Idle:
				this.idleAnimation(a);
			case AttackIdleStance:
				this.attackStanceIdleAnimation(a);
			case AttackWalkStance:
				this.attackStanceWalkAnimation(a);
			case Attack, None:
				this.attackAnimation(a);
		}
	}

	private function personEvent(e:Event) {
		this.personActions();
	}

	private function personActions() {
		var up = Key.isDown(Key.W);
		var down = Key.isDown(Key.S);
		var left = Key.isDown(Key.A);
		var right = Key.isDown(Key.D);
		var lClickDown = Key.isDown(Key.MOUSE_LEFT);

		var shift = Key.isDown(Key.SHIFT);
		var rClick = Key.isPressed(Key.MOUSE_RIGHT);
		var lClick = Key.isPressed(Key.MOUSE_LEFT);

		if (up && down) {
			up = down = false;
			return;
		}
		if (left && right) {
			left = right = false;
			return;
		}
		if (rClick && lClick) {
			rClick = lClick = false;
			return;
		}
		if (!this.state.equals(Dodge)) {
			if (up || down || left || right) {
				if (shift) {
					this.state = Run;
				} else {
					if (lClickDown) {
						this.state = AttackWalkStance;
					} else {
						this.state = Walk;
					}
				}
			} else {
				if (lClickDown) {
					this.state = AttackIdleStance;
				} else {
					this.state = Idle;
				}
			}
			if (rClick) {
				if (!this.state.equals(Idle)) {
					this.state = Dodge;
				}
			} else if (lClick) {
				this.state = Attack;
			} else if (lClickDown) {
				var dir:Float = hxd.Math.atan2(parent.getScene().mouseY - this.body.y, parent.getScene().mouseX - this.body.x);
				dir = Math.round(dir * Math.pow(1, 2));
				// Commented out 8d to 4d - need 8d with this?
				// set dir switch.
				//Need to sort out when moving opposite direction
				switch (dir) {
					case 1, 2:
						up = left = right = false;
						down = true;
					case -1, -2, -3:
						down = left = right = false;
						up = true;
					case 0:
						down = up = left = false;
						right = true;
					case 3:
						down = up = right = false;
						left = true;
				}
			}
			if (up) {
				this.facing = Up;
				// Commented out 8d to 4d
				// if (left) {
				// 	this.facing = UpLeft;
				// } else if (right) {
				// 	this.facing = UpRight;
				// } else {
				// 	this.facing = Up;
				// }
			} else if (down) {
				// Commented out 8d to 4d
				// if (left) {
				// 	this.facing = DownLeft;
				// } else if (right) {
				// 	this.facing = DownRight;
				// } else {
				// 	this.facing = Down;
				// }
				this.facing = Down;
			} else if (left) {
				this.facing = Left;
			} else if (right) {
				this.facing = Right;
			}
		}
	}

	private function movePerson(dt:Float) {
		var newAngle:Float = 0;
		switch (this.facing) {
			case Up:
				newAngle = 270;
			// case UpLeft:
			// 	newAngle = 225;
			// case UpRight:
			// 	newAngle = 315;
			case Down:
				newAngle = 90;
			// case DownLeft:
			// 	newAngle = 135;
			// case DownRight:
			// 	newAngle = 45;
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
			case Walk, AttackWalkStance:
				speed = WALKSPEED;
			case Attack, AttackIdleStance, Idle, None:
				speed = 0;
		}
		return ((speed * dt) * 50);
	}

	private function loadPersonData() {
		// for character setup, e.g. clothing, inventory etc.
	}

	private function walkAnimation(a) {
		this.anim.speed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 0...7 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 16...23 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 32...39 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 23...30 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
	}

	private function runAnimation(a:Array<Tile>) {
		this.anim.speed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 8...15 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 24...31 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 40...47 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 31...38 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 63...70 + 1) a[i]]);
		}
	}

	private function dodgeRollAnimation(a:Array<Tile>) {
		this.anim.speed = 10;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 54...57 + 1) a[i]]);
			// Commented out 8d to 4d
			// case DownLeft, DownRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			// 			case UpLeft, UpRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 58...61 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 61...65 + 1) a[i]]);
		}
	}

	private function attackAnimation(a:Array<Tile>) {}

	private function attackStanceWalkAnimation(a:Array<Tile>) {}

	private function attackStanceIdleAnimation(a:Array<Tile>) {}

	private function idleAnimation(a:Array<Tile>) {
		this.anim.speed = 0.5;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 52...53 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 50...51 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 48...49 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 92...93 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 86...87 + 1) a[i]]);
		}
	}

	function set_facing(f) {
		if (f != this.facing) {
			this.facing = f;
			this.personAnimation();
		}

		return f;
	}

	function set_state(s) {
		if (s != this.state) {
			this.state = s;
			this.personAnimation();
		}

		return s;
	}

	// Overide echo update loop
	public override function step(dt:Float) {
		super.step(dt);
		this.movePerson(dt);
	}
}
