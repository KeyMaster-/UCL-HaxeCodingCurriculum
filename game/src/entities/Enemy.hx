package entities;

class Enemy extends Entity {
    var vertical_speed:Int = 200;
    var horizontal_speed:Int = 150;
    var direction:Int;

    public function new(_x:Float, _y:Float) {
        tag = EntityTag.Enemy;

        super(_x, _y, 50, 50);

            // Choose a random direction to go in first
        if(Math.random() >= 0.5) {
            direction = -1;
        }
        else {
            direction = 1;
        }
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
    }

    override public function update(dt:Float) {
            //While we're still to the right of our target x position, move left
        if(rect.x > Framework.vis.canvas_width * (2 / 3)) {
            rect.x -= dt * horizontal_speed;
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