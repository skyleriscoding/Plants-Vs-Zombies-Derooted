package;

class Plant {
    // Id unique to the plant. Used for various reasons, like seed packet creation-
    public final ID: Int;

    // Sun cost of the plant. Always positive, negated when the plant is selected.
    public final sunCost: Int;

    // Path to the sprite animation of the plant.
    public final sprite: String;

    public function new(ID: Int, sunCost: Int, sprite: String) {
        this.ID = ID;
        this.sunCost = sunCost;
        this.sprite = sprite;
    }
}