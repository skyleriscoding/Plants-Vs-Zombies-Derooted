// LevelObject.hx
// Contains the base class for all level objects
package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

// LevelObject -> utility base class for all level objects
//    !! All the properties of 'sprite' should be set before passing it to the constructor
//    !! To add functionality, onClick and onRelease should be set to closures containing 
//       the desired action
class LevelObject extends FlxBasic {
	var parent: LevelState;
	var sprite: FlxSprite;
	var onClick: Null<() -> Void> = null;
	var onRelease: Null<() -> Void> = null;

	public function new(parent: LevelState, sprite: FlxSprite) {
		super();
		this.parent = parent;
		this.sprite = sprite;
		this.parent.add(this.sprite);
		this.parent.add(this);
	}

	public override function update(elapsed: Float) {
		if (this.onClick != null && FlxG.mouse.justPressed) {
			final x = FlxG.mouse.x;
			final y = FlxG.mouse.y;

			if (x < this.sprite.x || x > this.sprite.x + this.sprite.width) return;
			if (y < this.sprite.y || y > this.sprite.y + this.sprite.height) return;
			this.onClick();
		}
		if (this.onRelease != null && FlxG.mouse.justReleased) this.onRelease();
	}

	public override function kill() {
		this.sprite.kill();
		super.kill();
	}
}
