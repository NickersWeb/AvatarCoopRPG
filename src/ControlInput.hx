import hxd.Key;
/**
 * Handle Input, binding will be based on cached player bindings in settings
 */
class ControlInput {
	public function new() {
		Up = Key.isDown(Key.W);
		Down = Key.isDown(Key.S);
		Left = Key.isDown(Key.A);
		Right = Key.isDown(Key.D);
		InputRun = Key.isDown(Key.SHIFT);
		InputDodge = Key.isPressed(Key.MOUSE_RIGHT);
		InputAtk = Key.isPressed(Key.MOUSE_LEFT);
		InputAtkHold = Key.isDown(Key.MOUSE_LEFT);
    }
    public function IsInputMovement():Bool {
        return Up || Down || Left || Right ? true : false;
    }
	public var Up:Bool;
	public var Down:Bool;
	public var Left:Bool;
	public var Right:Bool;
	public var InputDodge:Bool;
	public var InputAtk:Bool;
	public var InputAtkHold:Bool;
	public var InputRun:Bool;
}
