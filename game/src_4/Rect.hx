package ;

class Rect {
    public var x:Float; //Position along x-axis
    public var y:Float; //Position along y-axis
    public var w:Float; //Width
    public var h:Float; //Height

    public function new(_x:Float, _y:Float, _w:Float, _h:Float) {
        x = _x;
        y = _y;
        w = _w;
        h = _h;
    }

    public function move(_x:Float, _y:Float):Rect {
        x += _x;
        y += _y;
        return this;
    }

    public function overlaps(other:Rect):Bool {
        return (other.x < (x + w) && 
                x < (other.x + other.w) &&
                other.y < (y + h) &&
                y < (other.y + other.h));
    }
}