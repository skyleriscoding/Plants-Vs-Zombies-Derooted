package;

import flixel.*;
import flixel.text.*;
import flixel.ui.*;

// This class represents the game state initialized at the game's startup.
// At the moment it holds the state for a level, but in the future this 
// code will be moved to another class.
class PlayState extends FlxState {

	// Resources. At the moment they are hardcoded, but in the future they'll
	// probably be softcoded into data. 
	final peashooter = new Plant(100, "assets/images/peashooter.png");
	var cursorSprite: FlxSprite;

	var sunAmount: Int = 1000;
	var sunLabel: FlxText;
	var isHoldingPlant: Bool = false;
	var heldSprite: FlxSprite;

	// Updates the sun cost. If suns are being spent, delta should be negative.
	// The boolean flag returned indicates if the update was successful.
	function updateSunCost(delta: Int): Bool {
		this.sunAmount += delta;
		if (this.sunAmount < 0) {
			this.sunAmount -= delta;
			return false;
		}
		this.sunLabel.text = "" + this.sunAmount;
		return true;
	}

	override public function create(){
		super.create();
		this.cursorSprite = (new FlxSprite()).loadGraphic("assets/images/cursor.png");
		this.sunLabel = new FlxText(20, 20, "1000", 24);

		final peapacket = new FlxButton(100, 20, () -> {
			if (this.updateSunCost(-peashooter.sunCost)) {
				this.isHoldingPlant = true;
				this.heldSprite = new FlxSprite().loadGraphic(peashooter.sprite);
				FlxG.mouse.load(this.heldSprite.pixels);
			}
		});
		peapacket.loadGraphic("assets/images/seedpacket.png");

		FlxG.mouse.load(cursorSprite.pixels);
		this.add(this.sunLabel);
		this.add(peapacket);
	}

	override public function update(elapsed: Float){
		super.update(elapsed);

		if (FlxG.mouse.justPressed && this.isHoldingPlant) {
			this.isHoldingPlant = false;

			this.heldSprite.x = FlxG.mouse.x;
			this.heldSprite.y = FlxG.mouse.y;
			this.add(this.heldSprite);

			FlxG.mouse.load(this.cursorSprite.pixels);
		}
	}
}