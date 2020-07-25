import haxe.ds.List;
import haxe.macro.Expr.Case;
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
	IdleAtkStance;
	WalkAtkStance;
	Idle;
	None;
}

/**
	Commented out 8d to 4d. Animation person facing e.g. direction right, facing left.
 */
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

/**
	Commented out 8d to 4d. Direction person moves
**/
enum Direction {
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
	var atkSelection:Array<String> = new Array<String>();
	var state(default, set):State = Idle;
	var speed:Float = 0;
	var totalDodgeCount:Int = 0;

	var gender:String = "m";

	// Commented out 8d to 4d
	var facing(default, set):Facing = Down; // DownLeft;
	var direction(default, set):Direction = Down;

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
			case IdleAtkStance:
			case WalkAtkStance:
			case Walk:
			case Idle, Attack, None:
				trace('Current attack is ... '+ this.atkSelection[this.atkIndex]);
		}
	}

	public function personAnimation() {
		var a:Array<Tile> = new Array<Tile>();
		switch (this.state) {
			case Run, Dodge, Walk, Idle, None:
				a = PersonUtils.animCal(this.movementTile, 64, 64, 64, this.facing);
			case Attack, IdleAtkStance, WalkAtkStance:
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
			case IdleAtkStance:
				this.attackStanceIdleAnimation(a);
			case WalkAtkStance:
				this.attackStanceWalkAnimation(a);
			case Attack, None:
				this.attackAnimation(a);
		}
	}

	private function personEvent(e:Event) {
		this.personActions();
	}

	private function personActions() {
		var cInput:ControlInput = new ControlInput();

		if (cInput.Up && cInput.Down) {
			cInput.Up = cInput.Down = false;
			return;
		}
		if (cInput.Left && cInput.Right) {
			cInput.Left = cInput.Right = false;
			return;
		}
		if (cInput.InputDodge && cInput.InputAtk) {
			cInput.InputDodge = cInput.InputAtk = false;
			return;
		}
		
		this.atkSelectHandler(cInput);

		if (!this.state.equals(Dodge)) {
			// Set person direction
			this.setPersonFacingDirection(cInput);
			this.setInputState(cInput);
		}
	}
	private function atkSelectHandler(cInput:ControlInput){
		if(cInput.InputAtkChangeUp){
				this.atkIndex += 1;
		}else if(cInput.InputAtkChangeDown){
				this.atkIndex += -1;
		}
		if(this.atkIndex < 0){
			this.atkIndex = this.atkSelection.length;
		}
		if(this.atkIndex > this.atkSelection.length){
			this.atkIndex = 0;
		}
	}
	private function setInputState(cInput:ControlInput) {
		if (cInput.IsInputMovement()) {
			if (cInput.InputRun && !cInput.InputAtkHold) {
				this.state = Run;
			} else {
				if (cInput.InputAtkHold) {
					this.state = WalkAtkStance;
				} else {
					this.state = Walk;
				}
			}
		} else {
			if (cInput.InputAtkHold) {
				this.state = IdleAtkStance;
			} else {
				this.state = Idle;
			}
		}
		if (cInput.InputDodge) {
			if (!this.state.equals(Idle)) {
				this.state = Dodge;
				//handle dodgespam
				// if(this.totalDodgeCount <= 3){
				// 	this.state = Dodge;
				// 	this.totalDodgeCount ++;
				// }else if(this.totalDodgeCount >= 20){
				// 	this.totalDodgeCount = 0;
				// }else{
				// 	this.totalDodgeCount ++;
				// }
				
			}
		} else if (cInput.InputAtk) {
			this.state = Attack;
		}
	}
	private function setPersonFacingDirection(cInput:ControlInput) {
		if (cInput.Up) {
			this.direction = Up;
			// Commented out 8d to 4d
			// if (left) {
			// 	this.facing = UpLeft;
			// } else if (right) {
			// 	this.facing = UpRight;
			// } else {
			// 	this.facing = Up;
			// }
		} else if (cInput.Down) {
			// Commented out 8d to 4d
			// if (left) {
			// 	this.facing = DownLeft;
			// } else if (right) {
			// 	this.facing = DownRight;
			// } else {
			// 	this.facing = Down;
			// }
			this.direction = Down;
		} else if (cInput.Left) {
			this.direction = Left;
		} else if (cInput.Right) {
			this.direction = Right;
		}
		// this will be set later.
		if (!cInput.InputAtkHold) {
			switch (this.direction) {
				case Up:
					this.facing = Up;
				case Down:
					this.facing = Down;
				case Left:
					this.facing = Left;
				case Right:
					this.facing = Right;
			}
		} else {
			this.setAtkHoldFacing();
		}
	}
	private function setAtkHoldFacing(){
		var mFacing:Float = hxd.Math.atan2(parent.getScene().mouseY - this.body.y, parent.getScene().mouseX - this.body.x);
			mFacing = Math.round(mFacing * Math.pow(1, 2));
			// Commented out 8d to 4d - need 8d with this?
			// set dir switch.
			// Need to sort out when moving opposite direction
			switch (mFacing) {
				case 1, 2:
					this.facing = Down;
				case -1, -2, -3:
					this.facing = Up;
				case 0:
					this.facing = Right;
				case 3:
					this.facing = Left;
			}
	}
	private function movePerson(dt:Float) {
		var newAngle:Float = 0;
		switch (this.direction) {
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
			case Walk, WalkAtkStance:
				speed = WALKSPEED;
			case Attack, IdleAtkStance, Idle, None:
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

	private function attackStanceWalkAnimation(a:Array<Tile>) {
		// handle person facing one way but direction in another.
	}

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

	function set_state(s:State) {
		if (s != this.state) {
			this.state = s;
			this.personAnimation();
		}

		return s;
	}

	function set_direction(d) {
		if (d != this.direction) {
			this.direction = d;
		}

		return d;
	}

	// Overide echo update loop
	public override function step(dt:Float) {
		super.step(dt);
		this.movePerson(dt);
	}
}
