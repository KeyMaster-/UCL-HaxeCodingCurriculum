package entities;

class Target extends Entity {
    public function new(_x:Float, _y:Float) {
        super(_x, _y, 16, 16);
        tag = EntityTag.Target;
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h, '#D94B41');
    }
}