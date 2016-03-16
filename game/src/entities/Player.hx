package entities;

class Player extends Entity {
    var speed:Float = 200;

    var last_shot_time:Float = 0;
    var shot_delay:Float = 0.2;

    public function new(_x:Float, _y:Float) {
        super(_x, _y, 16, 16);
        color = '#75D974';
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
            //:todo:lesson: polish
        rect.x = Util.clamp(rect.x, 0, Framework.vis.canvas_width - rect.w);
        rect.y = Util.clamp(rect.y, 0, Framework.vis.canvas_height - rect.h);
    }
}