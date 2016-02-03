package entities;

class Bullet extends Entity {
    //:todo: The dead flag occurs in this and the enemy class already, and the player having it wouldn't be wrong - add it to Entity?
    public var size(default, null):Int = 10;

    var speed:Vector;
    
    public function new(_x:Float, _y:Float, _speed_x:Float, _speed_y:Float) {
        super(_x, _y, 10, 10);
        speed = new Vector(_speed_x, _speed_y);
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
    }

    override public function update(dt:Float) {
        rect.move(speed.x * dt, speed.y * dt);
        if(rect.x < -rect.w || rect.x > Framework.vis.canvas_width || rect.y < -rect.h || rect.y > Framework.vis.canvas_height) {
            dead = true;
        }
    }

    override public function destroy() {
        super.destroy();
        speed = null;
    }

}