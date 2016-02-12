package ;
import js.Browser;
import entities.Entity;
import entities.Player;
import entities.Enemy;
import entities.Bullet;
import entities.Missile;

class Game {
    var entities:Array<Entity>;
    var player:Player;

    var enemy_timer:Float = 0;
    var enemy_spawn_interval:Float = 2.0;

    var gameover:Bool = false;

    public function new() {
        reset();
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    //:todo:lesson: Loops;
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
            //Spawn new enemies
        enemy_timer -= dt;
        if(enemy_timer <= 0) {
            var enemy = new Enemy(Framework.vis.canvas_width, 0, player);
            enemy.rect.y = Math.random() * (Framework.vis.canvas_height - enemy.rect.h);
            entities.push(enemy);
            enemy_timer = enemy_spawn_interval;
        }

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
                if(other_entity == entity) continue; //Skip over the entity we're currently at
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
    }

    function reset() {
        if(entities != null) {
            for(entity in entities) {
                entity.destroy();
            }    
        }
        entities = [];
        initPlayer();
    }

    function initPlayer() {
        player = new Player(0, Framework.vis.canvas_height / 2);
        player.rect.y -= player.rect.h / 2;
        addEntity(player); //Add the player so it receives updates and collides with enemy bullets
    }

    public function addEntity(_entity:Entity) {
        entities.push(_entity);
    }
}