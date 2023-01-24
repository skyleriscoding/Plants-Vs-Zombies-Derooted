// LevelObject.hx
// A sink class for all the utilities level objects need, like being clicked and dragged
// ECS-oriented, subclasses mostly shouldn't need to override the 'update' method.
package;

import flixel.*;

class LevelObject extends FlxSprite {
	var parent: LevelState;
	var onClick: Null<() -> Void> = null;
	var onRelease: Null<() -> Void> = null;

	public function new(parent: LevelState, x: Int, y: Int, sprite: String) {
		super(x, y);
		this.loadGraphic(sprite);

		this.parent = parent;
		this.parent.add(this);
	}

	public override function update(elapsed: Float) {
		if (this.onClick != null && FlxG.mouse.justPressed) {
			final x = FlxG.mouse.x;
			final y = FlxG.mouse.y;

			if (x < this.x || x > this.x + this.width) return;
			if (y < this.y || y > this.y + this.height) return;
			this.onClick();
		}

		if (this.onRelease != null && FlxG.mouse.justReleased) {
			this.onRelease();
		}
	}
}
