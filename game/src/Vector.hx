package ;

class Vector {
    public var x:Float;
    public var y:Float;

    public var length(get, set):Float;

    public function new(_x:Float = 0, _y:Float = 0) {
        x = _x;
        y = _y;
    }

    public function clone():Vector {
        return new Vector(x, y);
    }

    public function copy_from(v:Vector):Vector {
        x = v.x;
        y = v.y;
        return this;
    }

    inline public function set_xy(_x:Float, _y:Float) {
        x = _x;
        y = _y;
        return this;
    }

    public function add(v:Vector):Vector {
        x += v.x;
        y += v.y;
        return this;
    }

    public function subtract(v:Vector):Vector {
        x -= v.x;
        y -= v.y;
        return this;
    }

    public function multiply_scalar(f:Float):Vector {
        x *= f;
        y *= f;
        return this;
    }

    public function divide_scalar(f:Float):Vector {
        if(f == 0) {
            return set_xy(0, 0); //Division by 0 would lead to NaN (Not a Number) results, we want to prevent that here
        }
        else {
            return set_xy(x / f, y / f);
        }
    }

    public function normalise():Vector {
        return divide_scalar(length);
    }

    inline function get_length():Float {
        return Math.sqrt(x * x + y * y);
    }

    inline function set_length(v:Float):Float {
        normalise().multiply_scalar(v);
        return v;
    }
}