package;
import flixel.FlxG;
import flixel.FlxSprite;

class Sun extends FlxSprite {
    var state: LevelState;

    public function new(state: LevelState) {
        super(Math.floor(Math.random() * 1280), 0);
        this.loadGraphic("assets/images/sun.png");
        this.state = state;
    }

    override function update(elapsed: Float) {
        if (this.y < 420) this.y += 100 * elapsed;

        // Todo (Kaiko): Is there a builtin way of doing this?
        // Otherwise we could make a 'DerootedObject', which 
        // Extends FlxSprite with more functionalities
        if (FlxG.mouse.justPressed) {
            if (FlxG.mouse.x <= this.x || FlxG.mouse.x >= this.x + 50) return;
            if (FlxG.mouse.y <= this.y || FlxG.mouse.y >= this.y + 50) return;

            this.state.updateSunCost(50);
            this.kill();
        }
    }
}