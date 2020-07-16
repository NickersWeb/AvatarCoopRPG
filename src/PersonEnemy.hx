import h2d.RenderContext;
import hxd.Event;
import Person.State;
import echo.data.Options.BodyOptions;

class PersonEnemy extends Person 
{
	public override function new(?parent : h2d.Object, body_options:BodyOptions) {
		super(parent, body_options);
		this.name = "personenemy";
        this.tile = PersonUtils.GetPersonGraphic(this.gender, "air");
        //Commented out 8d to 4d
        this.facing = Down; //DownLeft;
        this.state = Idle;
        parent.getScene().removeEventListener(personEvent);
		// this does not work, need to iterate the tile in the map.
    }
    override function step(dt:Float) {
        //super.step(dt);
    }
}
