// PlantSystem.hx
// Objects related to the plant system.
package;
import flixel.FlxSprite;

class Plant extends LevelObject {
    final data: PlantData;

    public function new(parent: LevelState, data: PlantData, sprite: FlxSprite) {
        super(parent, sprite);
        this.data = data;
    }
}