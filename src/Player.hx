import Person.State;
import hxd.Key;
import h2d.RenderContext;
import hxd.Res;
import h2d.Anim;
import h2d.Tile;

private enum State {
	Run;
	Walk;
	Dodge;
	Attack;
	Idle;
	None;
}

private enum Facing {
	Up;
	// UpLeft;
	// UpRight;
	Down;
	// DownLeft;
	// DownRight;
	Left;
	Right;
}

class Player extends Entity {
	var a:Array<Tile>;
	var anim:Anim;
	var animDone:Bool = true;
	var facing:Facing;
	var state:State;
	var oldState:State;
	var oldFacing:Facing;
	var animSpeed:Int = 0;

	private static inline var WALKSPEED:Float = 95;
	private static inline var RUNSPEED:Float = 200;
	private static inline var DODGESPEED:Float = 500;
	private static inline var BENDINGSPEED:Float = 850;

	public function new(parent, x:Float, y:Float) {
		facing = Down;
		state = None;
		oldState = state;
		oldFacing = facing;
		super(parent, {
			x: x,
			y: y,
			drag_x: 200,
			drag_y: 200,
			elasticity: 0.2,
			shape: {
				type: CIRCLE,
				radius: 16,
			}
		});
		a = Static.getTiles(Res.images.player.sPlayerMaleAnimations.toTile(), 64);
		anim = new Anim(null, 8, this);
		// anim.loop = false;
		anim.onAnimEnd = function() {
			animDone = true;
		}
	}

	var speed:Float = 0;
	var disabled:Bool = false;

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		var x = 0.0;
		var y = 0.0;
		speed = WALKSPEED;
		state = Walk;
		if (Key.isPressed(Key.X))
			disabled = !disabled;
		if (disabled)
			return;
		if (Key.isDown(Key.W) || Key.isDown(Key.UP))
			y--;
		if (Key.isDown(Key.S) || Key.isDown(Key.DOWN))
			y++;
		if (Key.isDown(Key.A) || Key.isDown(Key.LEFT))
			x--;
		if (Key.isDown(Key.D) || Key.isDown(Key.RIGHT))
			x++;
		// facing
		if (Math.abs(x) > 0) {
			facing = x > 0 ? Right : Left;
			scaleX = x > 0 ? -1 : 1;
		}
		if (Math.abs(y) > 0)
			facing = y > 0 ? Down : Up;
		// run
		if (Key.isDown(Key.SHIFT)) {
			if (oldState == state && oldFacing != facing) {
				if (body.velocity.x != 0)
					body.velocity.x /= 2;
				if (body.velocity.y != 0)
					body.velocity.y /= 2;
			}
			state = Run;
			speed = RUNSPEED;
		}
		if (y == 0 && x == 0) {
			if (oldState == Run) {
				if (body.velocity.x != 0)
					body.velocity.x /= 2;
				if (body.velocity.y != 0)
					body.velocity.y /= 2;
			}
			state = Idle;
		} else {
			if (x != 0 && y != 0)
				speed *= 0.7;

			body.velocity.x += 15 * x;
			body.velocity.y += 15 * y;

			if (Math.abs(body.velocity.x) > speed)
				body.velocity.x = x * speed;
			if (Math.abs(body.velocity.y) > speed)
				body.velocity.y = y * speed;
		}
		if (state != oldState || facing != oldFacing) {
			switch (state) {
				case Walk:
					walkAnimation();
				case Run:
					if (Math.abs(body.velocity.x) > WALKSPEED || Math.abs(body.velocity.y) > WALKSPEED) {
						runAnimation();
					} else {
						if (oldState != Walk)
							walkAnimation();
						state = Walk; // not fast enough revert to walk
					}
				case Idle:
					idleAnimation();
				case None: // nothing
				case Attack: // attack
				case Dodge:
					dodgeRollAnimation();
			}
			oldState = state;
			oldFacing = facing;
		}
		// sync speed to velocity
		if (state != Idle) {
			switch (facing) {
				case Left | Right:
					anim.speed = animSpeed * (Math.abs(body.velocity.x) / speed + 0.2);
				case Up | Down:
					anim.speed = animSpeed * (Math.abs(body.velocity.y) / speed + 0.2);
			}
		}
	}

	private function walkAnimation() {
		animSpeed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 7...14 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 39...46 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 55...62 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 23...30 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
	}

	private function idleAnimation() {
		anim.speed = 0.5;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 94...95 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 90...91 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 88...89 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 92...93 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 86...87 + 1) a[i]]);
		}
	}

	private function runAnimation() {
		animSpeed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 15...22 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 47...54 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 71...77 + 1) a[i]]);
				// Commented out 8d to 4d
				// case UpLeft, UpRight:
				// 	this.anim.play([for (i in 31...38 + 1) a[i]]);
				// case DownLeft, DownRight:
				// 	this.anim.play([for (i in 63...70 + 1) a[i]]);
		}
	}

	private function dodgeRollAnimation() {
		animSpeed = 8;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 96...99 + 1) a[i]]);
			// Commented out 8d to 4d
			// case DownLeft, DownRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			// 			case UpLeft, UpRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 103...108 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 109...112 + 1) a[i]]);
		}
	}
}
