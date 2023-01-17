package;
import flixel.FlxBasic;

// Executes an action every number of seconds.
// May be deleted in the future.
class TimedAction extends FlxBasic {
    var state: Float;
    var seconds: Float;
    var action: () -> Void;

    public function new(seconds: Float, action: () -> Void) {
        super();
        this.state = 0.0;
        this.seconds = seconds;
        this.action = action;
    }

    override public function update(elapsed: Float) {
        this.state += elapsed;

        if (this.state >= this.seconds) {
            this.state = 0.0;
            this.action();
        }
    }
}