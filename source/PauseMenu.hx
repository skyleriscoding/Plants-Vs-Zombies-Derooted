package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class PauseMenu extends FlxSubState {
    override public function create() {
        super.create();

		FlxG.sound.pause();

		this.add(new FlxSprite(0, 0).loadGraphic("assets/images/ui/pausemenu.png").screenCenter());

        // The 'resume' button
        this.add(
            new FlxButton(115, 560, () -> {
                FlxG.sound.resume();
                this.close();
            })
            .makeGraphic(225, 55, FlxColor.TRANSPARENT)
        );

		// The 'restart' button
		this.add(
            new FlxButton(410, 560, () -> FlxG.switchState(new LevelState()))
            .makeGraphic(225, 55, FlxColor.TRANSPARENT)
        );

        // The 'exit' button
        this.add(
            new FlxButton(730, 560, () -> FlxG.switchState(new MenuState()))
		    .makeGraphic(225, 55, FlxColor.TRANSPARENT)
        );
    }
}