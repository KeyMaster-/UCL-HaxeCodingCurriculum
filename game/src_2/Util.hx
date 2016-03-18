package ;

class Util {
    public static inline function clamp(_value:Float, _min:Float, _max:Float):Float {
        if(_value < _min) {
            return _min;
        }
        else if(_value > _max) {
            return _max;
        }
        else {
            return _value;
        }
    }
}