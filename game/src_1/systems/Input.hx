package systems;
import js.Browser;
import js.html.KeyboardEvent;

class Input {
    var pressed:Map<Int, Bool>;
    public function new() {
        pressed = new Map();
        Browser.document.onkeydown = onkeydown;
        Browser.document.onkeyup = onkeyup;
    }

    function onkeydown(event:KeyboardEvent) {
        pressed.set(event.keyCode, true);
    }

    function onkeyup(event:KeyboardEvent) {
        pressed.set(event.keyCode, false);
    }

    public function keydown(keycode:Int):Bool {
        return pressed.exists(keycode) ? pressed.get(keycode) : false;
    }
}