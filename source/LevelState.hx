package;

import haxe.ds.Vector;
import flixel.*;
import flixel.text.*;
import flixel.ui.*;

typedef SelectedPlant = {
	var plant: Plant;
	var label: FlxText;
};

// This class represents the game state initialized at the game's startup.
// At the moment it holds the state for a level, but in the future this 
// code will be moved to another class.
class LevelState extends FlxState {
	var cursorSprite: FlxSprite;

	var isHoldingPlant: Bool = false;
	var heldSprite: String;
	var lawn: Vector<Bool>;
	var sunAmount: Int = 1000;
	var sunLabel: FlxText;

	var selectedPlants: Array<SelectedPlant>;


	// Loads the seedpacket of a plant.
	// May be inlined into the parent in the future
	function loadPlant(plant: Plant) {
		final factor = selectedPlants.length;

		final packet = new FlxButton(20, 150 + 120 * factor, () -> {
			if (this.updateSunCost(-plant.sunCost)) {
				this.isHoldingPlant = true;
				this.heldSprite = plant.sprite;

				// TODO: To fix this, load only the first frame x3
				// Too lazy to fix it rn
				//FlxG.mouse.load((new FlxSprite().loadGraphic(this.heldSprite, false, 80, 80)).pixels);
			}
		});
		packet.loadGraphic("assets/images/seedpacket.png");
		this.add(packet);

		final cost = new FlxText(130, 220 + 120 * factor, "" + plant.sunCost, 24);
		cost.setFormat("Brianne_s_hand.ttf", 30, 0xFFFFFF);
		this.add(cost);

		// TODO (kaiko): A way of doing this without animations?
		final display = new FlxText();
		display.x = 25;
		display.y = 160 + 120 * factor;
		display.loadGraphic("assets/images/plantpackets.png", true, 90, 90);
		display.animation.add("selected", [plant.ID]);
		display.animation.play("selected");
		this.add(display);

		this.selectedPlants.push({plant: plant, label: cost});
	}

	// Updates the sun cost. If suns are being spent, delta should be negative.
	// The boolean flag returned indicates if the update was successful.
	public function updateSunCost(delta: Int): Bool {
		this.sunAmount += delta;
		
		if (this.sunAmount < 0) {
			this.sunAmount -= delta;
			return false;
		}
		this.sunLabel.text = "" + this.sunAmount;

		// Check all the labels for the plant seed packets, and
		// update their color based on whether the player can select them or not
		for (p in this.selectedPlants) {
			p.label.setFormat(
				"Brianne_s_hand.ttf", 30, 
				if (p.plant.sunCost > this.sunAmount) 0xFF0000 else 0xFFFFFF
			);
		}
		return true;
	}

	override public function create(){
		super.create();

		// TEMPORARY! To slow down animations until we have smooth ones
		FlxG.drawFramerate = 30;

		// Load the cursor icon
		this.cursorSprite = (new FlxSprite()).loadGraphic("assets/images/cursor.png");
		FlxG.mouse.load(this.cursorSprite.pixels);

		// Load the lawn, and create the functional lawn.
		this.lawn = new Vector(45);
		for (i in 0...45) {
			this.lawn[i] = false;

			final x = 260 + (i % 9) * 85;
			final y = 195 + Math.floor(i / 9) * 90;

			final tile = new FlxButton(x, y, () -> {
				if (this.isHoldingPlant && !this.lawn[i]) {
					this.lawn[i] = true;
					this.isHoldingPlant = false;

					final plant = new FlxSprite();
					plant.loadGraphic(this.heldSprite, true, 80, 80);
					plant.animation.add("idle", [for (i in 0...15) i]);
					plant.animation.play("idle");

					plant.x = x;
					plant.y = y - 10;
					this.add(plant);

					FlxG.mouse.load(this.cursorSprite.pixels);
				}
			});
			tile.loadGraphic("assets/images/tile.png");
			this.add(tile);
		}
		this.add(new FlxSprite().loadGraphic("assets/images/lawn.png"));

		// Load the sun displayer, both image and label.
		final sunDisplayer = new FlxSprite().loadGraphic("assets/images/sundisplayer.png");
		sunDisplayer.x = sunDisplayer.y = 20;
		this.add(sunDisplayer);

		this.sunLabel = new FlxText(135, 50, "1000", 24);
		this.sunLabel.setFormat("Brianne_s_hand.ttf", 24, 0xFFFFFF);
		this.add(this.sunLabel);

		// At the moment the selected plants are hardcoded. 
		// In the future this array will be filled by seedselection or given plants.
		this.selectedPlants = new Array();
		this.loadPlant(new Plant(0, 100, "assets/images/peashooter.png"));
		this.loadPlant(new Plant(1, 50, "assets/images/sunflower.png"));

		// Initialize the timer used for sun spawning.
		this.add(new TimedAction(5.0, () -> {
			this.add(new Sun(this));
		}));
	}

	override public function update(elapsed: Float){
		super.update(elapsed);
	}
}