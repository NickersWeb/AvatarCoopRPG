import haxe.ds.Vector;

class BinPack
{
    public var spaces:Array<Vector<Int>> = [];
    public function new(width:Int,height:Int)
    {
        spaces.push(Vector.fromArrayCopy([width,height,0,0]));
    }
    /**
        size = width, height
    **/
    public function pack(size:Vector<Int>):Vector<Int>
    {
        //width, height, x, y
        //if (size.length != 2) return null;
        spaces.sort(function(a:Vector<Int>,b:Vector<Int>)
        {
            return a[0] * a[1] > b[0] * b[1] ? 1 : -1;
        });
        for (space in spaces)
        {
            //2 = width, height = 3, image is bigger than space
            if (space[0] < size[0] || space[1] < size[1]) continue;
            //size fits exactly
            if (space[0] == size[0] && space[1] == size[1])
            {
                spaces.remove(space);
                return space;
            }
            if (space[0] == size[0] && space[1] > size[1])
            {
                //width fits exactly, height does not
                spaces.push(Vector.fromArrayCopy([
                    space[0], //width
                    space[1] - size[1], //height
                    space[2], //x
                    space[3] + size[1], //y
                ]));
                spaces.remove(space);
                //width, height, x, y
                return Vector.fromArrayCopy([size[0],size[1],space[2],space[3]]);
            }
            if (space[1] == size[1] && space[0] > size[0])
            {
                //height fits exactly, width does not
                spaces.push(Vector.fromArrayCopy([
                    space[0] - size[0], //width
                    space[1], //height
                    space[2] + size[0], //x
                    space[3], //y
                ]));
                spaces.remove(space);
                return Vector.fromArrayCopy([size[0],size[1],space[2],space[3]]);
            }
            //every other option gone, size is strictly smaller than space both width and height
            if (space[0] - size[0] > space[1] - size[1])
            {
                //width has more space
                spaces.push(Vector.fromArrayCopy([
                    space[0] - size[0], //space.width - size.width = width
                    space[1], //space.height = height
                    space[2] + size[0], //space.x + size.width = x
                    space[3] //space.y = y
                ]));
                spaces.push(Vector.fromArrayCopy([
                    size[0], //width
                    space[1] - size[1], //height
                    space[2], //x 
                    space[3] + size[1] //y
                ]));
            }else{
                //height has more space
                spaces.push(Vector.fromArrayCopy([
                    space[0], //width
                    space[1] - size[1], //height
                    space[2], //x 
                    space[3] + size[1] //y
                ]));
                spaces.push(Vector.fromArrayCopy([
                    space[0] - size[0], //space.width - size.width = width
                    size[1], //space.height = height
                    space[2] + size[0], //space.x + size.width = x
                    space[3] //space.y = y
                ]));
            }
            spaces.remove(space);
            return Vector.fromArrayCopy([size[0],size[1],space[2],space[3]]);
        }
        return null;
    }
}