package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState {
    override public function create() {
        super.create();
		FlxG.mouse.load(new FlxSprite().loadGraphic("assets/images/ui/cursor.png").pixels);

        this.add(
            new FlxButton(460, 516, () -> FlxG.switchState(new LevelState()))
            .loadGraphic("assets/images/ui/button.png")
        );
		this.add(new FlxSprite(179, 23).loadGraphic("assets/images/ui/logo.png"));
    }
}