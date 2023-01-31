package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SeedPacket extends LevelObject {
	public final data: PlantData;
	public final label: FlxText;
    var plant: FlxSprite;

	public function new(parent: LevelState, index: Int, data: PlantData) {
		super(parent, new FlxSprite(260 + 100 * index, 560).makeGraphic(90, 170, FlxColor.TRANSPARENT));
		this.data = data;

		// Add the pot sprite
		this.parent.add(new FlxSprite(260 + 100 * index, 610, "assets/images/pot.png"));

		// Add the label signaling the sun cost
		this.label = new FlxText(280 + 100 * index, 685, "" + this.data.sunCost, 24);
		this.label.setFormat("Brianne_s_hand.ttf", 30, 0xFFFFFF);
		this.parent.add(this.label);

        // Add the animated plant on the top
		this.plant = new FlxSprite(this.sprite.x + 15, 590);
        this.plant.loadGraphic(this.data.sprite, true, 80, 80);
        this.plant.animation.add("idle", [for (i in 0...15) i]);
        this.plant.animation.play("idle");
        this.parent.add(this.plant);

		this.onClick = () -> {
			if (this.parent.updateSunCost(-this.data.sunCost)) {
				this.parent.add(new PlaceablePlant(this.parent, this.data, this.plant.clone()));
			}
		};
	}
}

class PlaceablePlant extends LevelObject {
	final data:PlantData;

	public function new(parent: LevelState, data: PlantData, sprite: FlxSprite) {
		super(parent, sprite);
		this.data = data;

		this.onRelease = () -> {
			if (FlxG.mouse.x >= 260 && FlxG.mouse.x <= 1070 && FlxG.mouse.y >= 125 && FlxG.mouse.y <= 575) {
				final x = Math.floor((FlxG.mouse.x - 260) / 90);
				final y = Math.floor((FlxG.mouse.y - 125) / 90);

				final sprite = this.sprite.clone();
                sprite.x = 260 + x * 90;
                sprite.y = 125 + y * 90;
				this.parent.spawnPlant(new Plant(this.parent, this.data, sprite), x, y);
			} else {
				this.parent.updateSunCost(this.data.sunCost);
			}
			this.kill();
		};
	}

	public override function update(elapsed: Float) {
		super.update(elapsed);
		this.sprite.x = FlxG.mouse.x - 25;
		this.sprite.y = FlxG.mouse.y - 25;
	}
}