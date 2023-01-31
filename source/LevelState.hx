// LevelState.hx
// Contains teh state representing a playable level.
package;
import haxe.ds.Vector;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// LevelState -> the state containing the 
//    !! The boolean flag returned by 'updateSunCost' indicates whether the update
//       was successful for not
class LevelState extends FlxState {
	var lawn: Vector<Null<Plant>>;
	var sunSystem: SunSystem;
	var packets: FlxTypedGroup<SeedPacket>;

	override public function create() {
		super.create();
		FlxG.mouse.load(new FlxSprite().loadGraphic("assets/images/cursor.png").pixels);

		// Load the lawn, and initialize the data for it.
		this.add(new FlxSprite().loadGraphic("assets/images/lawn.png"));
		this.lawn = new Vector(45);
		for (i in 0...45) {
			lawn[i] = null;
		}

		// Load the sun system
		this.sunSystem = new SunSystem(this);

		// Load the seed packets
		this.packets = new FlxTypedGroup(9);
		this.add(this.packets);
		this.packets.add(new SeedPacket(this, 0, new PlantData(100, "assets/images/peashooter.png")));
		this.packets.add(new SeedPacket(this, 1, new PlantData(50, "assets/images/sunflower.png")));
	}

	public function updateSunCost(delta: Int): Bool {
		if (!this.sunSystem.updateSunCost(delta)) return false;

		for (packet in this.packets) {
			packet.label.setFormat(
				"Brianne_s_hand.ttf", 30,
				if (packet.data.sunCost > this.sunSystem.amount) 0xFF0000 else 0xFFFFFF
			);
		}
		return true;
	}

	public function spawnPlant(p: Plant, x: Int, y: Int) {
		if (this.lawn[y * 9 + x] == null) {
			this.lawn[y * 9 + x] = p;
			this.add(p);
		}
	}
}