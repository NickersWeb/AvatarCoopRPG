import h2d.Object;
import h2d.Tile;
import hxd.Res;
import hxd.fs.FileEntry;
import hxd.res.Image;
import h2d.Anim;
import Person;

class PersonAir extends Person {
	public override function new(parent:h2d.Scene, ?values:Null<Dynamic>) {
		super(parent);
		this.tile = PersonUtils.GetPersonGraphic(this.gender, "air");
		this.anims = PersonUtils.GetPersonGraphicAnimations("air", this.anims, this.tile);
		this.personAnimation();
		// this does not work, need to iterate the tile in the map.
	}
}
