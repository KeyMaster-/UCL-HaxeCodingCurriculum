package entities;
import systems.Vis.Image;

class Player extends Entity {
    var speed:Float = 200;

    var last_shot_time:Float = 0;
    var shot_delay:Float = 0.2;

    var image:Image;

    public function new(_x:Float, _y:Float) {
        tag = EntityTag.Player;
        image = Framework.vis.get_image('player_ship');
        super(_x, _y, image.width, image.height);
    }

    override public function draw() {
        Framework.vis.image(image, rect.x, rect.y);
    }

    //:todo:lesson: Conditionals; Variables; Normalising vectors
    override public function update(dt:Float) {
        var move = new Vector(0, 0);
        if(Framework.input.keydown(39)) { //right
            move.x = 1;
        }
        else if(Framework.input.keydown(37)) { //left
            move.x = -1;
        }

        if(Framework.input.keydown(38)) { //up
            move.y = -1;
        }
        else if(Framework.input.keydown(40)) { //down
            move.y = 1;
        }

        move.length = speed * dt; //Make sure we always move at the same speed, even when moving diagonally
        rect.move(move.x, move.y);

        rect.x = clamp(rect.x, 0, Framework.vis.canvas_width - rect.w);
        rect.y = clamp(rect.y, 0, Framework.vis.canvas_height - rect.h);

        if(Framework.input.keydown(32)) {
            if(Framework.time - last_shot_time > shot_delay) {
                var bullet = new Bullet(rect.x + rect.w, rect.y + rect.h / 2, 500, 0, true);
                bullet.rect.y -= bullet.rect.h / 2;
                Framework.game.addEntity(bullet);
                last_shot_time = Framework.time;
            }
        }
    }

        //:todo: potentially move to different class
    function clamp(value:Float, lower:Float, upper:Float):Float {
        return value < lower ? lower : (value > upper ? upper : value);
    }
}