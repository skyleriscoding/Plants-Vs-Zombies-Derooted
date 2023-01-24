// LevelState.hx
// Contains the logic for the gameplay, and all the classes
// representing the level objects users can interact with.
package;

import flixel.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import haxe.ds.Vector;

class Plant extends LevelObject {
	public var data: PlantData;
	var planted: Bool;

	public function new(parent: LevelState, data: PlantData) {
		super(parent, FlxG.mouse.x - 25, FlxG.mouse.y - 25, "assets/images/sun.png");
	
		this.data = data;
		this.planted = false;
		
		this.loadGraphic(data.sprite, true, 80, 80);
		this.animation.add("idle", [for (i in 0...15) i]);
		this.animation.play("idle");

		this.onRelease = () -> {
			if (!this.planted) {
				if (
					FlxG.mouse.x >= 260 && FlxG.mouse.x <= 1070 &&
					FlxG.mouse.y >= 195 && FlxG.mouse.y <= 645
				) {
					final x = Math.floor((FlxG.mouse.x - 260) / 90);
					final y = Math.floor((FlxG.mouse.y - 195) / 90);

					if (this.parent.lawn[y * 9 + x] == null) {
						this.planted = true;
						this.x = 260 + x * 90;
						this.y = 195 + y * 90;

						this.parent.lawn[y * 9 + x] = this;
						this.parent.updateSunCost(-this.data.sunCost);
						return;
					}
				}
				this.kill();
			}
		};
	}

	public override function update(elapsed: Float) {
		super.update(elapsed);

		if (!this.planted) {
			this.x = FlxG.mouse.x - 25;
			this.y = FlxG.mouse.y - 25;
		}
	}
}

class SeedPacket extends LevelObject {
	public var plant: PlantData;
	public var label: FlxText;

	public function new(parent: LevelState, index: Int, plant: PlantData) {
		super(parent, 20, 150 + 120 * index, "assets/images/seedpacket.png");
		this.plant = plant;

		this.onClick = () -> {
			this.parent.add(new Plant(this.parent, this.plant));
		};

		this.label = new FlxText(130, 220 + 120 * index, "" + plant.sunCost, 24);
		this.label.setFormat("Brianne_s_hand.ttf", 30, 0xFFFFFF);
		this.parent.add(this.label);

		final display = new FlxSprite();
		display.x = 25;
		display.y = 160 + 120 * index;
		display.loadGraphic("assets/images/plantpackets.png", true, 90, 90);
		display.animation.add("selected", [plant.ID]);
		display.animation.play("selected");
		this.parent.add(display);
	}
}

class Sun extends LevelObject {
	public function new(parent: LevelState) {
		super(parent, Math.floor(Math.random() * 1280), 0, "assets/images/sun.png"); 
		
		this.onClick = () -> {
			this.parent.updateSunCost(50);
			this.kill();
		};
	}

	public override function update(elapsed: Float) {
		super.update(elapsed);
		if (this.y < 420) this.y += 100 * elapsed;
	}
}

class LevelState extends FlxState {

	public var sunAmount: Int;
	public var lawn: Vector<Null<Plant>>;

	var sunLabel: FlxText;
	var packets: FlxTypedGroup<SeedPacket>;

	// The boolean flag returned indicates whether the update was successful or not.
	public function updateSunCost(delta: Int): Bool {
		this.sunAmount += delta;

		if (this.sunAmount < 0) {
			this.sunAmount -= delta;
			return false;
		}
		this.sunLabel.text = "" + this.sunAmount;

		for (packet in this.packets) {
			packet.label.setFormat(
				"Brianne_s_hand.ttf", 30,
				if (packet.plant.sunCost > this.sunAmount) 0xFF0000 else 0xFFFFFF
			);
		}
		return true;
	}

	override public function create() {
		super.create();

		this.packets = new FlxTypedGroup(9);
		this.add(this.packets);

		FlxG.mouse.load(new FlxSprite().loadGraphic("assets/images/cursor.png").pixels);

		// Load the lawn, and create the functional lawn.
		this.add(new FlxSprite().loadGraphic("assets/images/lawn.png"));

		this.lawn = new Vector(45);
		for (i in 0...45) {
			lawn[i] = null;
		}

		// Load the sun displayer, both image and label.
		final sunDisplayer = new FlxSprite().loadGraphic("assets/images/sundisplayer.png");
		sunDisplayer.x = sunDisplayer.y = 20;
		this.add(sunDisplayer);

		this.sunAmount = 1000;

		this.sunLabel = new FlxText(135, 50, "1000", 24);
		this.sunLabel.setFormat("Brianne_s_hand.ttf", 24, 0xFFFFFF);
		this.add(this.sunLabel);

		// Hardcoded selected plants
		this.packets.add(new SeedPacket(this, 0, new PlantData(0, 100, "assets/images/peashooter.png")));
		this.packets.add(new SeedPacket(this, 1, new PlantData(1, 50, "assets/images/sunflower.png")));

		// Initialize the timer used for sun spawning.
		this.add(new TimedAction(5.0, () -> {
			this.add(new Sun(this));
		}));
	}
}
