// TimedAction.hx
// An utility class which executes a fixed action every number of seconds.
// May be removed in the future if turns out to be unecessary.

package;
import flixel.FlxBasic;

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