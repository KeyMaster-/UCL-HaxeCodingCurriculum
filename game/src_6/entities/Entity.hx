package entities;

class Entity {
        //The dimensions of this Entity, used for collision detection
    public var rect:Rect;

        //The color of the rectangle drawn for this entity
    var color:String;

    public function new(_x:Float, _y:Float, _w:Float, _h:Float) {
        rect = new Rect(_x, _y, _w, _h);
    }

    public function draw():Void {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h, color);
    }

    public function update(dt:Float):Void { }

    public function destroy() {
        rect = null;
    }
}