package ;
import entities.Player; 
import entities.Missile;

class Game {

    var player:Player;
    var missile:Missile;

    public function new() {
        player = new Player(Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2);
        missile = new Missile(0, 0, player);
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    public function update(dt:Float) {
        Framework.vis.clear();

        player.update(dt);
        player.draw();

        missile.update(dt);
        missile.draw();
    }
}