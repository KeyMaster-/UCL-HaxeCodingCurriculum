package entities;

class Player extends Entity {
    var speed:Float = 200;

    var last_shot_time:Float = 0;
    var shot_delay:Float = 0.2;
    var bullets:Array<Bullet>;

    var image:Int;


    public function new(_x:Float, _y:Float, _bullets:Array<Bullet>) {
        super(_x, _y, 100, 30);
        bullets = _bullets;
        image = Framework.vis.image_id('player_ship');
    }

    override public function draw() {
        // Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
        Framework.vis.image(image, rect.x, rect.y);
    }

    override public function update(dt:Float) {
        if(Framework.input.keydown(39)) { //right
            rect.x += speed * dt;
        }
        else if(Framework.input.keydown(37)) { //left
            rect.x -= speed * dt;
        }

        if(Framework.input.keydown(38)) { //up
            rect.y -= speed * dt;
        }
        else if(Framework.input.keydown(40)) {
            rect.y += speed * dt;
        }

        rect.x = clamp(rect.x, 0, Framework.vis.canvas_width - rect.w);
        rect.y = clamp(rect.y, 0, Framework.vis.canvas_height - rect.h);

        if(Framework.input.keydown(32)) {
            if(Framework.time - last_shot_time > shot_delay) {
                var bullet = new Bullet(rect.x + rect.w, rect.y + rect.h / 2, 500, 0);
                bullet.rect.y -= bullet.size / 2;
                bullets.push(bullet);
                last_shot_time = Framework.time;
            }
        }

        for(bullet in bullets) {
            bullet.update(dt);
        }

    }

    //:todo: potentially move to different class
    function clamp(value:Float, lower:Float, upper:Float):Float {
        return value < lower ? lower : (value > upper ? upper : value);
    }
}