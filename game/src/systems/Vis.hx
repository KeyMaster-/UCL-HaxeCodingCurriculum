package systems;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

import js.Browser;
class Vis {
    // :todo: Better solution for this?
    public var canvas_width(get, never):Float;
    public var canvas_height(get, never):Float;
    var canvas:CanvasElement;
    var ctx:js.html.CanvasRenderingContext2D;

    public function new () {
        canvas = cast Browser.document.getElementById('gameview');
        ctx = canvas.getContext('2d');

        onresize();

        //:todo: focus change
    }

    public function onresize() {
        canvas.width = Browser.window.innerWidth;
        canvas.height = Browser.window.innerHeight;
        // trace('on resize ${canvas.height} ${canvas.width}');
    }

    public function box(x:Float, y:Float, w:Float, h:Float, col = '#ffffff') {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, w, h);
    }

    public function clear() {
        ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
    }

    function get_canvas_width():Float {
        return canvas.width;
    }

    function get_canvas_height():Float {
        return canvas.height;
    }
}