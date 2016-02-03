package ;
import js.Browser;
import entities.Player;
import entities.Enemy;
import entities.Bullet;

class Game {
    var player:Player;
    var enemies:Array<Enemy>;
    var bullets:Array<Bullet>;

    var enemy_timer:Float = 0;
    var enemy_spawn_interval:Float = 2.0;

    public function new() {
        bullets = [];
        player = new Player(0, Framework.vis.canvas_height / 2, bullets);
        player.rect.y -= player.rect.h / 2;
        enemies = [];
    }

    //:todo: Note: Useful website for finding keycodes: http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

    //:todo:lesson: Conditionals, possibly vectors for normalised movement speed (set vector x/y on keydown, then normalise to speed)
    public function update(dt:Float) {
        Framework.vis.clear();

        player.update(dt);
        player.draw();

            //Spawn new enemies
        enemy_timer -= dt;
        if(enemy_timer <= 0) {
            var enemy = new Enemy(Framework.vis.canvas_width, 0);
            enemy.rect.y = Math.random() * (Framework.vis.canvas_height - enemy.rect.h);
            enemies.push(enemy);
            enemy_timer = enemy_spawn_interval;
        }

        var i:Int = bullets.length;
        while(i > 0) {
            i--;
            var bullet = bullets[i];
            bullet.update(dt);
            if(bullet.dead) {
                bullet.destroy();
                bullets.splice(i, 1); //Removes the bullet from the array
                continue;
            }
            bullet.draw();
        }
        i = enemies.length;
        while(i > 0) {
            i--;
            var enemy = enemies[i];
            enemy.update(dt);
            for(bullet in bullets) {
                if(!bullet.dead && enemy.rect.overlaps(bullet.rect)) { //Don't interact with dead bullets that wasn't cleaned up yet
                    bullet.dead = true;
                    enemy.dead = true;
                }
            }
            if(enemy.dead) {
                enemies.splice(i, 1);
                continue; //:todo: Using continue here (and in the player class for the same thing) could be a good teaching way, but also be a bit difficult to understand? Just if/else may be clearer
            }
            enemy.draw();
        }
    }

    
}