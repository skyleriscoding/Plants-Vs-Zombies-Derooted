// LevelState.hx
// Contains teh state representing a playable level.
package;
import haxe.ds.Vector;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.Assets;

// Data representing a level. Should be loaded from a json.
typedef LevelData = {
	var name: String;
	var night: Bool;
};

// LevelState -> the state containing the 
//    !! The boolean flag returned by 'updateSunCost' indicates whether the update
//       was successful for not
class LevelState extends FlxState {
	public var lawn: Vector<Null<Plant>>;

	var data: LevelData;
	var sunSystem: SunSystem;
	var packets: FlxTypedGroup<SeedPacket>;

	override public function create() {
		super.create();
		FlxG.sound.playMusic("assets/music/chapter1.ogg");

		// Loading the level data
		this.data = Json.parse(Assets.getText("assets/data/levels/11.json"));

		// Load the lawn, and initialize the data for it.
		this.add(new FlxSprite().loadGraphic("assets/images/lawns/chapter1.png"));
		this.lawn = new Vector(45);
		for (i in 0...45) {
			lawn[i] = null;
		}
		this.add(new FlxText(200, 40, this.data.name).setFormat("Brianne_s_hand.ttf", 30));

		// Load the pause menu
		final pauseButton = 
			new FlxButton(1060, 20, () -> this.openSubState(new PauseMenu()))
			.loadGraphic("assets/images/ui/button.png");
	
		pauseButton.scale.set(0.25, 1);
		this.add(pauseButton);

		// Load the seed packets
		this.packets = new FlxTypedGroup(9);
		
		final plants: Array<PlantData> = Json.parse(Assets.getText("assets/data/plantdata.json")).plants;
		for (i in 0...plants.length) {
			this.packets.add(new SeedPacket(this, i, plants[i]));
		}
		this.add(this.packets);

		// Load the sun system
		this.sunSystem = new SunSystem(this, this.data.night);
		this.updateSunCost(50);
	}

	public function updateSunCost(delta: Int): Bool {
		if (!this.sunSystem.updateSunCost(delta)) return false;

		for (packet in this.packets) {
			packet.label.setFormat(
				"Brianne_s_hand.ttf", 30,
				if (packet.data.cost > this.sunSystem.amount) 0xFF0000 else 0xFFFFFF
			);
		}
		return true;
	}
}