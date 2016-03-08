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

    var images:Map<String, Image>;

        //A factor by which we multiply the size of the game area to get to the size of the render area
    var scale_factor:Float = 2; //:todo: maybe avoid all of the scaling logic? Depends on whether we want graphics back at some point

    public function new () {
        canvas = cast Browser.document.getElementById('gameview');
        canvas.style.backgroundColor = '#111111';
        ctx = canvas.getContext('2d');

            //Apply a base scale factor to everything
        ctx.scale(scale_factor, scale_factor);

            //initialise images
        images = new Map();
        var img_elements:Array<ImageElement> = cast Browser.document.getElementsByTagName('img');
        for(element in img_elements) {
            var name = element.src;
            name = Path.withoutDirectory(name);
            name = Path.withoutExtension(name);
            images.set(name, new Image(element));
        }

        //:todo: focus change
    }

    public function box(x:Float, y:Float, w:Float, h:Float, col:String = '#ffffff') {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, w, h);
    }
        //draw image at a given position
    public function image(image:Image, x:Float, y:Float) {
        ctx.drawImage(image.image_element, Math.floor(x), Math.floor(y));
    }

    public function get_image(name:String):Image {
        return images.get(name);
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

class Image {
    @:allow(systems.Vis) //This allows the Vis class to access the image element for drawing, while it remains hidden for everything else
    var image_element:ImageElement;
    public var width(get, never):Float;
    public var height(get, never):Float;

    public function new(_image_element:ImageElement) {
        image_element = _image_element;
    }

    inline function get_width():Float {
        return image_element.width;
    }

    inline function get_height():Float {
        return image_element.height;
    }

}