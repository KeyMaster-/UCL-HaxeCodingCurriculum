package entities;

    //lesson 3
    //new
class Missile extends Entity {
    var player:Player;

    public function new(_x:Float, _y:Float, _player:Player) {
        super(_x, _y, 10, 10);
        color = '#ffffff';
        player = _player;
    }

    override public function update(dt:Float) {

    }
}