import h2d.Graphics;
import hxd.Res;
import h2d.Tile;
import h2d.Object;
import h2d.Anim;
import h2d.Drawable;
import hxd.fmt.blend.Data.Handle;

class Person extends Anim{
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
    
    public function new(parent:h2d.Scene,?values:Null<Dynamic>) {
        super(null,null,parent);
        anim = new Anim(null,10,this);
        updateMovement();
    }
    var tile:Tile;
    private function updateMovement() {
        // tile = Res.images.player.sPlayerAnimations.toTile();
        // var a = sub(64);
        // play([for (i in 79...85 + 1) a[i]]);
    }
    private function loadPersonData(){
        //for character setup, e.g. clothing, inventory etc.
    }
    private function sub(size:Int):Array<Tile>
    {
        var array:Array<Tile> = [];
        for (y in 0...Std.int(tile.height/size))
        {
            for (x in 0...Std.int(tile.width/size))
            {
                array.push(tile.sub(x * size,y * size,size,size));
            }
        }
        return array;
    }
}