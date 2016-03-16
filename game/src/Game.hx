package ;
import js.Browser;
import entities.Entity;
import entities.Player;
import entities.Missile;
import entities.Target;

class Game {
    var targets:Array<Target>; //to be changed, lesson 6
    var player:Player; //lesson 1
    var missile:Missile; //lesson 3

    var score:Int = 0; //lesson 7

    var gameover:Bool = false; //lesson 5

    public function new() {
        player = new Player(0, 0);
        missile = new Missile(0, 0, player);
        reset();
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    public function update(dt:Float) {
        Framework.vis.clear();
            //lesson 5
        if(gameover) {
            Framework.vis.text("Game over! Press enter to restart.", Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2, '#ffffff', 20, 'middle', 'center');
            if(Framework.input.keydown(13)) { //On enter, Restart the game
                reset();
                gameover = false;
            }
            return;
        }
        player.update(dt);
        missile.update(dt);

        if(player.rect.overlaps(missile.rect)) {
            gameover = true;
        }

        player.draw();
        missile.draw();

        for(target in targets) {
            target.update(dt);
            if(player.rect.overlaps(target.rect)) {
                gameover = true;
            }

            if(missile.rect.overlaps(target.rect)) {
                missile.bounce();
                score++; //lesson 7
                repositionTarget(target); //lesson 6
            }

            target.draw();
        }

        Framework.vis.text('Score: $score', Framework.vis.canvas_width / 2, 30, '#ffffff', 20, 'center', 'center');
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
            //lesson note: This has the chance of spawning a target on top of the player, which would instantly kill them. 
            //We won't fix it here, but it's an extension the learner could do.
        target.rect.x = Math.random() * (Framework.vis.canvas_width - target.rect.w);
        target.rect.y = Math.random() * (Framework.vis.canvas_height - target.rect.h);
        
    }
        //lesson 5
    function resetPlayer() {
        player.rect.x = Framework.vis.canvas_width / 2 - player.rect.w / 2;
        player.rect.y = Framework.vis.canvas_height / 2 - player.rect.h / 2;
        missile.rect.x = Framework.vis.canvas_width / 3;
        missile.rect.y = 0;
    }
}