package ;

class Vector {
    public var x:Float;
    public var y:Float;

    public function new(_x:Float, _y:Float) {
        x = _x;
        y = _y;
    }

    public function clone():Vector {
        return new Vector(x, y);
    }

    public function add(v:Vector):Vector {
        x += v.x;
        y += v.y;
        return this;
    }

    public function multiply_scalar(f:Float):Vector {
        x *= f;
        y *= f;
        return this;
    }
}