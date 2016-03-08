package ;
import js.Browser;
import entities.Entity;
import entities.Player;
import entities.Missile;
import entities.Target;

class Game {
    var entities:Array<Entity>;
    var player:Player;
    var score:Int = 0;

    var enemy_timer:Float = 0;
    var enemy_spawn_interval:Float = 2.0;

    var gameover:Bool = false;

    var target:Target;

    public function new() {
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

        if(target.dead) {
            renewTarget();
        }

            //:todo:lesson: Loops;
        var i:Int = entities.length;
        while(i > 0) {
            i--;
            var entity = entities[i];
            
            entity.update(dt);
            entity.draw();

            if(entity.dead) {
                entity.destroy();
                entities.splice(i, 1);
                continue;
            }

            for(other_entity in entities) {
                if(other_entity == entity) continue; //Skip over the entity we're currently at, an entity colliding with itself doesn't make sense
                if(!other_entity.dead && other_entity.rect.overlaps(entity.rect)) {
                        //Notify both entities of their collision
                    other_entity.collided(entity);
                    entity.collided(other_entity);
                }
            }
        }

        if(player.dead) {
            gameover = true;
        }

        Framework.vis.text('Score: $score', Framework.vis.canvas_width / 2, 30, '#ffffff', 20, 'center', 'center');
    }

    function reset() {
        if(entities != null) {
            for(entity in entities) {
                entity.destroy();
            }    
        }
        entities = [];
        initPlayer();
        score = 0;

        renewTarget();

    }

    function renewTarget() {
                //lesson note: This has the chance of spawning a target on top of the player, instantly killing them. 
                //We won't fix it here, but it's an extension the learner could do.
        target =  new Target(0, 0);
        target.rect.x = Math.random() * (Framework.vis.canvas_width - target.rect.w);
        target.rect.y = Math.random() * (Framework.vis.canvas_height - target.rect.h);
        addEntity(target);
    }

    function initPlayer() {
        player = new Player(Framework.vis.canvas_width / 2, Framework.vis.canvas_height / 2);
        player.rect.y -= player.rect.h / 2;
        player.rect.x -= player.rect.w / 2;
        addEntity(player); //Add the player so it receives updates and collides with enemy bullets
        var missile = new Missile(Framework.vis.canvas_width / 2, 0, player);
        addEntity(missile);
    }

    public function addEntity(_entity:Entity) {
        entities.push(_entity);
    }

    public function addScore(_amount:Int) {
        score += _amount;
    }
}