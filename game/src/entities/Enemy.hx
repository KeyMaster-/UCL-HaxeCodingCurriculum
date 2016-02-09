package entities;
import Vector;

class Enemy extends Entity {
    var vertical_speed:Int = 200;
    var horizontal_speed:Int = 150;
    var direction:Int;
    var player:Player;

    var shot_speed:Float = 100;

    var min_shot_time:Float = 2;
    var added_shot_time_range:Float = 1;
    var shot_timer:Float;

    public function new(_x:Float, _y:Float, _player:Player) {
        tag = EntityTag.Enemy;
        player = _player;

        super(_x, _y, 50, 50);

            // Choose a random direction to go in first
        if(Math.random() >= 0.5) {
            direction = -1;
        }
        else {
            direction = 1;
        }

        shot_timer = min_shot_time + Math.random() * added_shot_time_range;
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
    }

    override public function update(dt:Float) {
            //While we're still to the right of our target x position, move left
        if(rect.x > Framework.vis.canvas_width * (2 / 3)) {
            rect.x -= dt * horizontal_speed;
        }

        shot_timer -= dt;
        if(shot_timer <= 0) {
            var shot_dir = new Vector(player.rect.x + player.rect.w / 2, player.rect.y + player.rect.h / 2);
            shot_dir.subtract(new Vector(rect.x, rect.y + rect.w / 2)); //:todo: Seriously consider making a rect just 2 vectors, would make this more sensible
            shot_dir.length = shot_speed;

            var bullet = new Bullet(rect.x, rect.y + rect.w / 2, shot_dir.x, shot_dir.y, false);
            Framework.game.addEntity(bullet);
            shot_timer = min_shot_time + Math.random() * added_shot_time_range;
        }
            //Scroll up and down
        rect.y += dt * vertical_speed * direction;
        if(rect.y <= 0 || rect.y >= Framework.vis.canvas_height - rect.h) {
            direction = -direction;
        }
    }

    override public function collided(other:Entity) {
        if(other.tag == EntityTag.PlayerBullet ) {
            dead = true;
        }
    }
}