package entities;

class Player extends Entity {

    public function new(_x:Float, _y:Float) {
        super(_x, _y, 16, 16);
        color = '#75D974'; //Sets the color of the player. See this wikipedia section for more details: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
    }

    //:todo:lesson: Conditionals; Variables; Normalising vectors
    override public function update(dt:Float) {

    }
}