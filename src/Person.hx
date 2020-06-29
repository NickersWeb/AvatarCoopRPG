import h2d.Tile;
import h2d.Object;
import h2d.Anim;
import h2d.Drawable;
import hxd.fmt.blend.Data.Handle;

class Person extends Object{
    var WALKSPEED:Float = 95;
	var RUNSPEED:Float = 150;
	var DODGESPEED:Float = 300;
    var BENDINGSPEED:Float = 850;
    public var anims:Map<String, h2d.Tile>  = new Map<String, h2d.Tile>();
    public var tile:h2d.Tile =  null;
    public var personG:Anim = new Anim();

    var attacks:Array<String> = [];
    var atkIndex:Int = 0;

    var isAttacking:Bool = false;
	var isDodging:Bool = false;
	var isRunning:Bool = false;
    var gender:String = "m";
    
    public function new() {
        super();
        loadPersonData();
    }
    private function loadPersonData(){

    }
}