package entities;

class Entity {
    public var pos:Vector;

    public function new(_x:Float, _y:Float) {
        pos = new Vector(_x, _y);
    }

    public function draw() { }

    public function update(dt:Float) { }
}