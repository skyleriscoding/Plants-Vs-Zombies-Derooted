// PlantSystem.hx
// Objects related to the plant system.
package;
import haxe.Exception;
import flixel.FlxSprite;

class Plant extends LevelObject {
    static final FIRST : Array<Int> = [for (i in 0...30) i];
    static final SECOND: Array<Int> = [for (i in 31...60) i];

    final data: PlantData;

    public function new(parent: LevelState, data: PlantData, x: Int, y: Int) {
		final plantSprite = 
            new FlxSprite(260 + x * 90, 125 + y * 90)
            .loadGraphic(data.sprite, true, 80, 80);

        plantSprite.animation.add("idle", FIRST);
        plantSprite.animation.play("idle");

        switch (data.kind) {
            case "shooter":  /*plantSprite.animation.add("shoot", SECOND)*/{}
            case "producer": /*plantSprite.animation.add("produce", SECOND)*/{}
            default: throw new Exception("Corrupted plantdata.json");
        }

        super(parent, plantSprite);
        this.data = data;
    }
}