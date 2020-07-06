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
		this.tile = PersonUtils.GetPersonGraphic(this.gender, "air");
		this.anims = PersonUtils.GetPersonGraphicAnimations("air", this.anims, this.tile);
		// this does not work, need to iterate the tile in the map.
	}
}
