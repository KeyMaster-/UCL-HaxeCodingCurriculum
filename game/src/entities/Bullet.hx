package entities;
import systems.Vis.Image;

class Bullet extends Entity {
    var image:Image;
    var speed:Vector;
    
    public function new(_x:Float, _y:Float, _speed_x:Float, _speed_y:Float) {
        image = Framework.vis.get_image('bullet');
        super(_x, _y, image.width, image.height);
        speed = new Vector(_speed_x, _speed_y);
    }

    override public function draw() {
        Framework.vis.image(image, rect.x, rect.y);
    }

    override public function update(dt:Float) {
        rect.move(speed.x * dt, speed.y * dt);
        if(rect.x < -rect.w || rect.x > Framework.vis.canvas_width || rect.y < -rect.h || rect.y > Framework.vis.canvas_height) {
            dead = true;
        }
    }

    override public function destroy() {
        super.destroy();
        speed = null;
    }

}