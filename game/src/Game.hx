package ;
import js.Browser;
import entities.Entity;
import entities.Player;
import entities.Enemy;
import entities.Bullet;

class Game {
    var entities:Array<Entity>;
    var player:Player;

    var enemy_timer:Float = 0;
    var enemy_spawn_interval:Float = 2.0;

    public function new() {
        entities = [];
        player = new Player(0, Framework.vis.canvas_height / 2);
        player.rect.y -= player.rect.h / 2;
        addEntity(player); //Add the player so it receives updates and collides with enemy bullets
    }

    //:todo:note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    //:todo:lesson: Loops;
    public function update(dt:Float) {
        Framework.vis.clear();

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

        // var i:Int = bullets.length;
        // while(i > 0) {
        //     i--;
        //     var bullet = bullets[i];
        //     bullet.update(dt);
        //     if(bullet.dead) {
        //         bullet.destroy();
        //         bullets.splice(i, 1); //Removes the bullet from the array
        //         continue;
        //     }
        //     bullet.draw();
        // }
        // i = enemies.length;
        // while(i > 0) {
        //     i--;
        //     var enemy = enemies[i];
        //     enemy.update(dt);
        //     for(bullet in bullets) {
        //         if(!bullet.dead && enemy.rect.overlaps(bullet.rect)) { //Don't interact with dead bullets that wasn't cleaned up yet
        //             bullet.dead = true;
        //             enemy.dead = true;
        //         }
        //     }
        //     if(enemy.dead) {
        //         enemies.splice(i, 1);
        //         continue; //:todo: Using continue here (and in the player class for the same thing) could be a good teaching way, but also be a bit difficult to understand? Just if/else may be clearer
        //     }
        //     enemy.draw();
        // }
    }

    public function addEntity(_entity:Entity) {
        entities.push(_entity);
    }
}