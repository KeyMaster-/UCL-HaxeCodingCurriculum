package entities;

class Entity {
    public var rect:Rect;

    public var dead:Bool = false;

    //:todo: maybe use a Vector object here?
    public function new(_x:Float, _y:Float, _w:Float, _h:Float) {
        rect = new Rect(_x, _y, _w, _h);
    }

    public function draw():Void { }

    public function update(dt:Float):Void { }

    public function destroy() {
        rect = null;
    }
}