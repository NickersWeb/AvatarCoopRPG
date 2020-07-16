import Person.Facing;
import h2d.Tile;
import h2d.Anim;
import hxd.Res;
import echo.data.Options.BodyOptions;

class PersonUtils {
	public static function GetPerson(parent:h2d.Scene, body_options:BodyOptions, bendingType:String):Person {
		switch (bendingType) {
			case "air":
				return new PersonAir(parent, body_options);
			case "earth":
				return new PersonAir(parent, body_options);
			case "fire":
				return new PersonAir(parent, body_options);
			case "water":
				return new PersonAir(parent, body_options);
			case "avatar":
				return new PersonAir(parent, body_options);
			default:
				return new PersonAir(parent, body_options);
		}
	}

	public static function GetPersonGraphic(?gender:String = "m"):Tile {
		var tile:Tile = null;

		switch (gender) {
			case "m":
				tile = Tile.fromTexture(Res.images.player.sPlayerMaleAnimations.toTexture());
			case "f":
				tile = Tile.fromTexture(Res.images.player.sPlayerFemaleAnimations.toTexture());
		}

		return tile;
	}

	public static function GetPersonAtkGraphicAnimations(?bendingType:String = "air"):Tile {
		var tile:Tile = null;
		switch (bendingType) {
			case "air":
				tile = Tile.fromTexture(Res.images.player.air.airbending.toTexture());
		}
		return tile;
	}

	// private static function selAtkElementAir(proj:Projectile, bendingAttack:String):Tile {
	// 	var pAnim:FlxAnimation = null;
	// 	switch (bendingAttack) {
	// 		case "airslice":
	// 			pAnim = new FlxAnimation(proj.animation, "airslice", [2, 1, 1, 1, 1, 0], 5, false);
	// 	}
	// 	return pAnim;
	// }
	// public static function selAtkElement(proj:Projectile, bendingType:String, bendingAttack:String):Tile {
	// 	var pAnim:FlxAnimation = null;
	// 	switch (bendingType) {
	// 		case "air":
	// 			pAnim = selAtkElementAir(proj, bendingAttack);
	// 	}
	// 	return pAnim;
	// }

	public static function selBendTypeImg(bendingType:String):Tile {
		var tile:Tile = null;
		switch (bendingType) {
			case "air":
				tile = Tile.fromTexture(Res.images.bending.air.toTexture());
		}
		return tile;
	}

	public static function animCal(tile:Tile, height:Int, width:Int, size:Int, facing:Facing):Array<Tile> {
		var array:Array<Tile> = [];
		for (y in 0...Std.int(tile.height / height)) {
			for (x in 0...Std.int(tile.width / width)) {
				array.push(tile.sub(x * size, y * size, width, height, -0.5 * width, -0.5 * height));
			}
		}
		switch (facing) {
			case Right:
				// Commented out 8d to 4d
				// , UpRight, DownRight:
				for (i in 0...array.length) {
					array[i].flipX();
				}
			default:
		}
		return array;
	}
}
