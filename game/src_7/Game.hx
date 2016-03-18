package ;
import entities.Player; 
import entities.Missile;
import entities.Target;

class Game {
    var targets:Array<Target>; //lesson 6
    var player:Player;
    var missile:Missile;

    var score:Int = 0; //new //lesson 7

    var gameover:Bool = false; //lesson 5

    public function new() {
        player = new Player(Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2);
        missile = new Missile(0, 0, player);
        reset();
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    public function update(dt:Float) {
        Framework.vis.clear();

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

        if(player.rect.overlaps(missile.rect)) {
            gameover = true;
        }

        for(target in targets) {
            if(player.rect.overlaps(target.rect)) {
                gameover = true;
            }

            if(missile.rect.overlaps(target.rect)) {
                repositionTarget(target); //lesson 6
                    //new
                missile.bounce();
                score++; //lesson 7
                if(score % 3 == 0) { // lesson 7
                    var new_target = new Target(0,0);
                    repositionTarget(new_target);
                    targets.push(new_target);
                }
            }

            target.draw();
        }
        
            //new
        Framework.vis.text('Score: $score', Framework.vis.canvas_width / 2, 30, '#ffffff', 20, 'center', 'center'); //lesson 7
    }

        //lesson 5
    function reset() {
        resetPlayer();
        score = 0; //lesson 7

        if(targets != null) {
            for(target in targets) {
                target.destroy();
            }
        }
        targets = [];
        var target = new Target(0, 0);
        repositionTarget(target); //lesson 6
        targets.push(target);
    }

        //lesson 6
    function repositionTarget(target:Target) {
            //Randomly placing the target has a chance to place it on the player, which would instantly kill them
            //To prevent this, we roll a new position if the target happens to be on top of the player
        do {
            target.rect.x = Math.random() * (Framework.vis.canvas_width - target.rect.w);
            target.rect.y = Math.random() * (Framework.vis.canvas_height - target.rect.h);
        } while(target.rect.overlaps(player.rect));
    }

        //lesson 6
    function resetPlayer() {
        player.rect.x = Framework.vis.canvas_width / 2 - player.rect.w / 2;
        player.rect.y = Framework.vis.canvas_height / 2 - player.rect.h / 2;
        missile.rect.x = Framework.vis.canvas_width / 3;
        missile.rect.y = 0;
    }
}