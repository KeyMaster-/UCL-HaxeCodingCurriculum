package systems;
import haxe.io.Path;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser;

class Vis {
    public var canvas_width(get, never):Float;
    public var canvas_height(get, never):Float;
    var canvas:CanvasElement;
    var ctx:js.html.CanvasRenderingContext2D;

        //A factor by which we multiply the size of the game area to get to the size of the render area
    var scale_factor:Float = 2; //:todo: maybe avoid all of the scaling logic? Depends on whether we want graphics back at some point

    public function new () {
        canvas = cast Browser.document.getElementById('gameview');
        canvas.style.backgroundColor = '#111111';
        ctx = canvas.getContext('2d');

            //Apply a base scale factor to everything
        ctx.scale(scale_factor, scale_factor);
    }

    public function box(x:Float, y:Float, w:Float, h:Float, col:String = '#ffffff') {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, w, h);
    }

    public function text(text:String, x:Float, y:Float, col:String = '#ffffff', size:Int = 20, baseline:String = 'top', align:String = 'left') {
        ctx.font = '${size}px Arial';
        ctx.fillStyle = col;
        ctx.textBaseline = baseline;
        ctx.textAlign = align;
        ctx.fillText(text, x, y);
    }

    public function clear() {
        ctx.clearRect(0, 0, canvas.width, canvas.height); //Using canvas attributes directly since we want actual render size, not game area size
    }

    inline function get_canvas_width():Float {
        return canvas.width / scale_factor;
    }

    inline function get_canvas_height():Float {
        return canvas.height / scale_factor;
    }
}