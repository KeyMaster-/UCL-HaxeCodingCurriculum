package entities;

class Player extends Entity {
    public var width(default, null):Int = 100;
    public var height(default, null):Int = 30;
    var speed:Float = 200;

    var last_shot_time:Float = 0;
    var shot_delay:Float = 0.1;
    var bullets:Array<Bullet>;


    public function new(_x:Float, _y:Float) {
        super(_x, _y);
        bullets = [];
    }

    override public function draw() {
        Framework.vis.box(pos.x, pos.y, width, height);
        var i:Int = 0;
        while(i < bullets.length) {
            var bullet = bullets[i];
            if(bullet.dead == true) {
                bullets.remove(bullet);
                continue;
            }
            bullet.draw();
            i++;
        }
    }

    override public function update(dt:Float) {
        if(Framework.input.keydown(39)) { //right
            pos.x += speed * dt;
        }
        else if(Framework.input.keydown(37)) { //left
            pos.x -= speed * dt;
        }

        if(Framework.input.keydown(38)) { //up
            pos.y -= speed * dt;
        }
        else if(Framework.input.keydown(40)) {
            pos.y += speed * dt;
        }

        pos.x = clamp(pos.x, 0, Framework.vis.canvas_width - width);
        pos.y = clamp(pos.y, 0, Framework.vis.canvas_height - height);

        if(Framework.input.keydown(32)) {
            if(Framework.time - last_shot_time > shot_delay) {
                var bullet = new Bullet(pos.x + width, pos.y + height / 2, 500, 0);
                bullet.pos.y -= bullet.size / 2;
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