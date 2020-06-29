import h2d.Tile;
import hxd.Res;
import hxd.fs.FileEntry;
import hxd.res.Image;
import h2d.Anim;
import Person;

class PersonAir extends Person {
	public override function new(?values:Null<Dynamic>) {
		super();

    this.anims = PersonUtils.GetPersonGraphicAnimations(values.bendingType, this.anims, this.tile);
    //this does not work, need to iterate the tile in the map.
		personG = new h2d.Anim(this.anims);
	}
}
