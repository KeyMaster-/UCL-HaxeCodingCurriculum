package ;
import js.Browser;
import entities.Player;

class Game {
    var player:Player;

    public function new() {
        player = new Player(0, Framework.vis.canvas_height / 2);
        player.pos.y -= player.height / 2;
    }

    //:todo: Note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    //:todo:lesson: Conditionals, possibly vectors for normalised movement speed (set vector x/y on keydown, then normalise to speed)
    public function update(dt:Float) {
        player.update(dt);
        Framework.vis.clear();
        player.draw();
    }

    
}