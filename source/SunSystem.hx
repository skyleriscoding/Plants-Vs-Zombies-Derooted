// Sun.hx
// Objects related to the sun system
package;
import flixel.FlxSprite;
import flixel.text.FlxText;

class Sun extends LevelObject {
	public function new(parent:LevelState) {
		super(parent, new FlxSprite(Math.floor(Math.random() * 1280), 0).loadGraphic("assets/images/sun.png"));

		this.onClick = () -> {
			this.parent.updateSunCost(50);
			this.kill();
		};
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (this.sprite.y < 420) this.sprite.y += 100 * elapsed;
	}
}

class SunSystem extends LevelObject {
    public var amount: Int;
	var spawnTimer:Float;
    var label: FlxText;

    public function new(parent: LevelState) {
		super(parent, new FlxSprite(20, 20).loadGraphic("assets/images/sundisplayer.png"));

        this.amount = 50;
        this.spawnTimer = 0.0;

		this.label = new FlxText(65, 165, Std.string(this.amount), 72);
		this.label.setFormat("Brianne_s_hand.ttf", 24, 0xFFFFFF);
		this.parent.add(this.label);
    }

    override public function update(elapsed: Float) {
        super.update(elapsed);

        this.spawnTimer += elapsed;
        if (this.spawnTimer > 5.0) {
            this.spawnTimer = 0.0;
            this.parent.add(new Sun(this.parent));
        }
    }

    public function updateSunCost(delta: Int): Bool {
		this.amount += delta;

		if (this.amount < 0) {
			this.amount -= delta;
			return false;
		}
		this.label.text = Std.string(this.amount);
        return true;
    }
}