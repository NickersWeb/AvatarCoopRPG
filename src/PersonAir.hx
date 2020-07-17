import h2d.Object;
import h2d.Tile;
import hxd.Res;
import hxd.fs.FileEntry;
import hxd.res.Image;
import h2d.Anim;
import Person;
import echo.data.Options.BodyOptions;

class PersonAir extends Person {
	public override function new(?parent : h2d.Object, body_options:BodyOptions) {
		super(parent, body_options);
		this.name = "personair";
		this.movementTile = PersonUtils.GetPersonGraphic(this.gender);
		this.attackTile = PersonUtils.GetPersonAtkGraphicAnimations("air");
		//Commented out 8d to 4d
		this.facing = Down; //DownLeft;
		this.state = Idle;
		// this does not work, need to iterate the tile in the map.
	}
	override function attackStanceIdleAnimation(a:Array<Tile>) {
		//super.attackStanceIdleAnimation(a);
		this.anim.speed = 10;
		switch (facing) {
			case Up:
				this.anim.play([for (i in 0...0 + 1) a[i]]);
			// Commented out 8d to 4d
			// case DownLeft, DownRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			// 			case UpLeft, UpRight:
			// 	this.anim.play([for (i in 100...102 + 1) a[i]]);
			case Down:
				this.anim.play([for (i in 2...2 + 1) a[i]]);
			case Left, Right:
				this.anim.play([for (i in 4...4 + 1) a[i]]);
		}
	}
}
