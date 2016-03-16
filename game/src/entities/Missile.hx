package entities;

    //lesson 3
class Missile extends Entity {
    var player:Player;
    var speed:Float = 300;
    var steering_impulse:Float = 800;
    var velocity:Vector;

    public function new(_x:Float, _y:Float, _player:Player) {
        super(_x, _y, 10, 10);
        player = _player;
        velocity = new Vector(0, 0);
    }

    override public function draw() {
        Framework.vis.box(rect.x, rect.y, rect.w, rect.h, '#ffffff');
    }

    override public function update(dt:Float) {
            //:todo:lesson: 4 - vectors, velocity, homing movement
        var player_pos = new Vector(player.rect.x + player.rect.w / 2, player.rect.y + player.rect.h / 2);
        var our_pos = new Vector(rect.x, rect.y);
        var to_player = player_pos.subtract(our_pos);
        to_player.length = steering_impulse * dt;
        velocity.add(to_player);
        if(velocity.length > speed) velocity.length = speed;
        rect.move(velocity.x * dt, velocity.y * dt);
            //:todo:lesson 7
            //If the bullet goes offscreen, move it back and make it bounce
        if(rect.x < 0 || rect.x > (Framework.vis.canvas_width - rect.w) || rect.y < 0 || rect.y > (Framework.vis.canvas_height - rect.h)) {
            rect.x = Util.clamp(rect.x, 0, Framework.vis.canvas_width - rect.w);
            rect.y = Util.clamp(rect.y, 0, Framework.vis.canvas_height - rect.h);
            bounce();
        }
    }

    public function bounce():Void {
        velocity.multiply_scalar(-1);
    }
}