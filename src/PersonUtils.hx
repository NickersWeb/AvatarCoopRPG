import h2d.Tile;
import h2d.Anim;
import hxd.Res;
import echo.data.Options.BodyOptions;

class PersonUtils {
	public static function GetPerson(parent:h2d.Scene, body_options:BodyOptions, bendingType:String):Person {
			switch (bendingType) {
				case "air":
					return new PersonAir(parent , body_options);
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

	public static function GetPersonGraphic(?gender:String = "m", ?bendingType:String = "air"):Tile {
		var tile:Tile = null;
		switch (bendingType) {
			case "air":
				switch (gender) {
					case "m":
						tile = Tile.fromTexture(Res.images.player.sPlayerMaleAnimations.toTexture());
					case "f":
						tile = Tile.fromTexture(Res.images.player.sPlayerFemaleAnimations.toTexture());
				}
		}
		return tile;
	}

	public static function GetPersonGraphicAnimations(?bendingType:String = "air", anims:Map<String, Array<Tile>>, tile:Tile):Map<String, Array<Tile>> {
		switch (bendingType) {
			case "air":
				// anims.set("airslicerunup", tile);
				// anims.set("airslicewalkup",tile);
				// anims.set("airsliceidleup",tile);
				// anims.set("airslicerunlr",tile);
				// anims.set("airslicewalklr",tile);
				// anims.set("airsliceidlelr",tile);
				// anims.set("rolllr",tile);
				// anims.set("rolld",tile);
				// anims.set("rolldlr",tile);
				// anims.set("rollu",tile);
				// anims.set("idleu",tile);
				// anims.set("idleulr",tile);
				// anims.set("idled",tile);
				// anims.set("idlelr",tile);
				// anims.set("idledlr",tile);
				// anims.set("walkdlr",tile);
				// anims.set("runlr",tile);
				// anims.set("rundlr",tile);
				// anims.set("walklr",tile);
				// anims.set("rund",tile);
				// anims.set("walkd",tile);
				// anims.set("runulr",tile);
				// anims.set("walkulr",tile);
				// anims.set("runu",tile);
				// anims.set("walku",tile);
				// "airslicerunup", [156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169], false);
				// "airslicewalkup", [150, 151, 152, 153, 154, 155], 10, false);
				// "airsliceidleup", [144, 145, 146, 147, 148, 149], 10, false);
				// "airslicerunlr", [131, 132, 133, 134, 135, 136, 137, 138, 139], 10, false);
				// "airslicewalklr", [123, 124, 125, 126, 127, 128, 129, 130], 10, false);
				// "airsliceidlelr", [114, 115, 116, 117, 118, 119, 120, 121, 122], 10, false);
				// "rolllr", [110, 111, 112, 113], 8, false);
				// "rolld", [103, 104, 105, 106, 107, 108], 8, false);
				// "rolldlr", [100, 101, 102], 8, false);
				// "rollu", [96, 97, 98, 99], 8, false);
				// "idleu", [94, 94, 95, 95], 1, false);
				// "idleulr", [92, 92, 93, 93], 1, false);
				// "idled", [90, 90, 91, 91], 1, false);
				// "idlelr", [88, 88, 89, 89], 1, false);
				// "idledlr", [86, 87, 86, 87], 1, false);
				// "walkdlr", [79, 80, 81, 82, 83, 84, 85], 5, false);
				// "runlr", [71, 72, 73, 74, 75, 76, 77], 5, false);
				// "rundlr", [63, 64, 65, 66, 67, 68, 69, 70], 8, false);
				// "walklr", [55, 56, 57, 58, 59, 60, 61, 62], 8, false);
				// "rund", [47, 48, 49, 50, 51, 52, 53, 54], 8, false);
				// "walkd", [39, 40, 41, 42, 43, 44, 45, 46], 8, false);
				// "runulr", [31, 32, 33, 34, 35, 36, 37, 38], 8, false);
				// "walkulr", [23, 24, 25, 26, 27, 28, 29, 30], 8, false);
				// "runu", [15, 16, 17, 18, 19, 20, 21, 22], 8, false);
				// "walku", [7, 8, 9, 10, 11, 12, 13, 14], 8, false);
		}
		return anims;
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

	public static function animCal(tile:Tile, height:Int, width:Int, size:Int, facing:String):Array<Tile> {
		var array:Array<Tile> = [];
		for (y in 0...Std.int(tile.height / height)) {
			for (x in 0...Std.int(tile.width / width)) {
				array.push(tile.sub(x * size, y * size, width, height,  -0.5 * width, -0.5 * height));
			}
		}
		switch (facing) {
			case "Right", "UpRight", "DownRight":
				for (i in 0...array.length){
				    array[i].flipX();
				}
		}
		return array;
	}
}
