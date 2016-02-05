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


    public function new () {
        canvas = cast Browser.document.getElementById('gameview');
        canvas.style.backgroundColor = '#111111';
        ctx = canvas.getContext('2d');
        ctx.imageSmoothingEnabled = false;

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

    public function box(x:Float, y:Float, w:Float, h:Float, col = '#ffffff') {
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

    public function clear() {
        ctx.clearRect(0, 0, canvas_width, canvas_height);
    }

    inline function get_canvas_width():Float {
        return canvas.width;
    }

    inline function get_canvas_height():Float {
        return canvas.height;
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