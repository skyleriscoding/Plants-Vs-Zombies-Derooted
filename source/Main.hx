// Main.hx
// Includes the code for the game's startup. Shouldn't be modified in any way.

package;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		this.addChild(new FlxGame(0, 0, MenuState));
	}
}