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

class Person extends Object {
	var WALKSPEED:Float = 95;
	var RUNSPEED:Float = 150;
	var DODGESPEED:Float = 300;
	var BENDINGSPEED:Float = 850;

	var tile:Tile;
	var anim:Anim = new Anim();
	var atkIndex:Int = 0;
	var isAttacking:Bool = false;
	var isDodging:Bool = false;
	var isRunning:Bool = false;
	var gender:String = "m";

	public var anims:Map<String, Array<Tile>> = new Map<String, Array<Tile>>();

	public function new(parent:h2d.Scene, ?values:Null<Dynamic>) {
		super(parent);
		this.anim = new Anim(null, 10, this);
		loadPersonData();
		parent.addEventListener(personEvent);
	}

	private function personAnimation() {
        var a:Array<Tile> = PersonUtils.animCal(this.tile, 64, 64, 64);

                if (!isAttacking)
                {
                    if ((this.x != 0 ||  this.x != 0))
                    {
                        if (isDodging)
                        {
                            dodgeRollAnimation(a);
                        }
                        else
                        {
                            if (isRunning)
                            {
                                runAnimation(a);
                            }
                            else
                            {
                                walkAnimation(a);
                            }
                        }
                    }
                    else
                    {
                        idleAnimation(a);
                    }
                }
    }

	private function personEvent(event:Event) {
		var newAngle:Float = 0;
		var up:Bool = hxd.Key.isPressed(hxd.Key.UP);
		var down:Bool = hxd.Key.isPressed(hxd.Key.DOWN);
		var left:Bool = hxd.Key.isPressed(hxd.Key.LEFT);
		var right:Bool = hxd.Key.isPressed(hxd.Key.RIGHT);
		isRunning = hxd.Key.isPressed(hxd.Key.SHIFT);

		if (up && down) {
			up = down = false;
		}
		if (left && right) {
			left = right = false;
		}
		if (up || down || left || right) {
			if (up) {
				newAngle = -90;
				if (left) {
					newAngle -= 45;
				} else if (right) {
					newAngle += 45;
				}
			} else if (down) {
				newAngle = 90;
				if (left) {
					newAngle += 45;
				} else if (right) {
					newAngle -= 45;
				}
			} else if (left) {
				newAngle = 180;
			} else if (right) {
				newAngle = 0;
			}

			// determine our velocity based on angle and speed
			this.move(personSpeedCal(), 0);
			this.rotate(newAngle);
		}
	}

	private function personSpeedCal():Float {
		var playerSpeed:Float = WALKSPEED;
		if (isRunning) {
			playerSpeed = RUNSPEED;
		}
		if (isDodging) {
			playerSpeed = DODGESPEED;
		}
		return playerSpeed;
	}

	private function loadPersonData() {
		// for character setup, e.g. clothing, inventory etc.
	}
    private function walkAnimation(a:Array<Tile>) {
		switch (rotation) {
			// up
			case -90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// down
			case 90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// left
			case 180:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// right
			case 0:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			case 135:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
    }
    private function runAnimation(a:Array<Tile>) {
		switch (rotation) {
			// up
			case -90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// down
			case 90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// left
			case 180:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// right
			case 0:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			case 135:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
    }
    private function dodgeRollAnimation(a:Array<Tile>) {
		switch (rotation) {
			// up
			case -90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// down
			case 90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// left
			case 180:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// right
			case 0:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			case 135:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
	}
	private function idleAnimation(a:Array<Tile>) {
		switch (rotation) {
			// up
			case -90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// down
			case 90:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// left
			case 180:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			// right
			case 0:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
			case 135:
				this.anim.play([for (i in 79...85 + 1) a[i]]);
		}
	}
}
