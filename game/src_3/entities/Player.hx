package entities;

class Player extends Entity {
    var speed:Int = 200;

    public function new(_x:Float, _y:Float) {
        super(_x, _y, 16, 16);
        color = '#75D974'; //Sets the color of the player. See this wikipedia section for more details: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
    }

    //:todo:lesson: Conditionals; Variables; Normalising vectors
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
        else if(Framework.input.keydown(40)) { //down
            rect.y += speed * dt;
        }
    }
}