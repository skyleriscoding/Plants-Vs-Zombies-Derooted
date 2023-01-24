// Plant.hx
// Small data class for storing the unique data representing a plant.
// Probably edited in the future.
package;

class PlantData {
    public final ID: Int;
    public final sunCost: Int;
    public final sprite: String;

    public function new(ID: Int, sunCost: Int, sprite: String) {
        this.ID = ID;
        this.sunCost = sunCost;
        this.sprite = sprite;
    }
}

