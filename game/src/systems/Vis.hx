package systems;
import haxe.io.Path;
import js.html.CanvasElement;
import js.html.ImageElement;
import js.html.CanvasRenderingContext2D;

import js.Browser;
class Vis {
    // :todo: Better solution for this?
    public var canvas_width(get, never):Float;
    public var canvas_height(get, never):Float;
    var canvas:CanvasElement;
    var ctx:js.html.CanvasRenderingContext2D;

    var image_ids:Map<String, Int>;
    var images:Array<ImageElement>;

    public function new () {
        canvas = cast Browser.document.getElementById('gameview');
        ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false;

        onresize();

            //initialise images
        image_ids = new Map();
        images = cast Browser.document.getElementsByTagName('img');
        trace(images);
        for(i in 0...images.length) {
            var name = images[i].src;
            name = Path.withoutDirectory(name);
            name = Path.withoutExtension(name);
            image_ids.set(name, i);
        }

        //:todo: focus change
    }


    public function onresize() {

        canvas.width = Browser.window.innerWidth;
        canvas.height = Browser.window.innerHeight;
        // ctx.scale(canvas.width / 640, canvas.height / 480); //:todo: Fix virtual screen size?
    }

    public function box(x:Float, y:Float, w:Float, h:Float, col = '#ffffff') {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, w, h);
    }
        //draw image at a given position
    public function image(id:Int, x:Float, y:Float) {
        var img = images[id];
        // ctx.drawImage(img, x, y);
        ctx.drawImage(img, Math.floor(x), Math.floor(y));
    }

        //get the id for the image specified by name
    public function image_id(name:String):Int {
        return image_ids.get(name);
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