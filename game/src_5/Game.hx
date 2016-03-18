package ;
import entities.Player; 
import entities.Missile;

class Game {

    var player:Player;
    var missile:Missile;

    var gameover:Bool = false; //new //lesson 5

    public function new() {
        player = new Player(Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2);
        missile = new Missile(0, 0, player);
        reset(); //new
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    public function update(dt:Float) {
        Framework.vis.clear();

            //new
        if(gameover) {
            Framework.vis.text("Game over! Press enter to restart.", Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2, '#ffffff', 20, 'middle', 'center');
            if(Framework.input.keydown(13)) { //On enter, Restart the game
                reset();
                gameover = false;
            }
            return;
        }

        player.update(dt);
        player.draw();

        missile.update(dt);
        missile.draw();

            //new
        if(player.rect.overlaps(missile.rect)) {
            gameover = true;
        }
    }

        //lesson 5
        //new
    function reset() {
        player.rect.x = Framework.vis.canvas_width / 2 - player.rect.w / 2;
        player.rect.y = Framework.vis.canvas_height / 2 - player.rect.h / 2;
        missile.rect.x = Framework.vis.canvas_width / 3;
        missile.rect.y = 0;
    }
}