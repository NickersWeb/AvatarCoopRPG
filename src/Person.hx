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
    public var anims:Map<String, Array<Tile>> = new Map<String, Array<Tile>>();
    var anim:Anim;
    var atkIndex:Int = 0;

    var isAttacking:Bool = false;
	var isDodging:Bool = false;
	var isRunning:Bool = false;
    var gender:String = "m";
    
    public function new(parent) {
        super(parent);
        loadPersonData();
    }
    private function loadPersonData(){
        anim = new Anim();
    }
}