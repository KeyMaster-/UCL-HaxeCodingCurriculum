package entities;

class Player extends Entity {
    var speed:Int = 200;

    public function new(_x:Float, _y:Float) {
        super(_x, _y, 16, 16);
        color = '#75D974'; //Sets the color of the player. See this wikipedia section for more details: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
    }

    //:todo:lesson: Conditionals; Variables; Normalising vectors
    override public function update(dt:Float) {
            //new (next line, in the if statements and at the end, things are new/changed)
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
    }
}