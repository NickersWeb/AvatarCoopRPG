import hxd.Event;
import Person.State;
import echo.data.Options.BodyOptions;

class PersonEnemy extends Person 
{
	public override function new(?parent : h2d.Object, body_options:BodyOptions) {
		super(parent, body_options);
		this.name = "personenemy";
		this.tile = PersonUtils.GetPersonGraphic(this.gender, "air");
        this.facing = DownLeft;
        this.state = Idle;
        parent.getScene().removeEventListener(personEvent);
		// this does not work, need to iterate the tile in the map.
    }
    override function movePerson(dt:Float) {
        //super.movePerson(dt);
        //move enemy randomly 
        //need raycasting or something to see enemy.
    }
    override function step(dt:Float) {
        super.step(dt);
    }
}
