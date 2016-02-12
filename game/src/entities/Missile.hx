package entities;

class Missile extends Entity {
    var player:Player;
    var speed:Float = 250;
    var velocity:Vector;
    var steering_impulse:Float = 600;
    public function new(_x:Float, _y:Float, _player:Player) {
        super(_x, _y, 10, 10);
        player = _player;
        velocity = new Vector(-speed, 0);
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h);
    }

    override public function update(dt:Float) {
        var player_pos = new Vector(player.rect.x + player.rect.w / 2, player.rect.y + player.rect.h / 2);
        var our_pos = new Vector(rect.x, rect.y);
        var to_player = player_pos.subtract(our_pos);
        to_player.length = steering_impulse * dt;
        velocity.add(to_player);
        if(velocity.length > speed) velocity.length = speed;
        rect.move(velocity.x * dt, velocity.y * dt);
    }
}