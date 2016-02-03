package entities;

class Bullet extends Entity {
    public var dead:Bool = false;
    public var size(default, null):Int = 10;

    var speed:Vector;
    

    public function new(_x:Float, _y:Float, _speed_x:Float, _speed_y:Float) {
        super(_x, _y);
        speed = new Vector(_speed_x, _speed_y);
    }

    override public function draw() {
        Framework.vis.box(pos.x, pos.y, size, size);
    }

    override public function update(dt:Float) {
        pos.add(speed.clone().multiply_scalar(dt));
        if(pos.x - size < 0 || pos.x > Framework.vis.canvas_width || pos.y - size < 0 || pos.y > Framework.vis.canvas_height) {
            pos = null;
            speed = null;
            dead = true;
        }
    }
}