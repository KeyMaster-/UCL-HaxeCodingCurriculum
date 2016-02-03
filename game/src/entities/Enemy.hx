package entities;

class Enemy extends Entity {
    var speed:Int = 200;

    public function new(_x:Float, _y:Float) {
        super(_x, _y, 100, 30);
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
    }

    override public function update(dt:Float) {
        rect.x -= dt * speed;
        if(rect.x < -rect.w) {
            dead = true;
        }
    }
}