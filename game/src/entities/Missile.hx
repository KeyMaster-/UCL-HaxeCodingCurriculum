package entities;

class Missile extends Entity {
    var player:Player;
    var speed:Float = 300;
    var steering_impulse:Float = 800;
    var velocity:Vector;

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

            //If the bullet goes offscreen, move it back and make it bounce
        if(rect.x < 0 || rect.x > (Framework.vis.canvas_width - rect.w) || rect.y < 0 || rect.y > (Framework.vis.canvas_height - rect.h)) {
            rect.x = Util.clamp(rect.x, 0, Framework.vis.canvas_width - rect.w);
            rect.y = Util.clamp(rect.y, 0, Framework.vis.canvas_height - rect.h);
            velocity.multiply_scalar(-1);
        }
    }

    override public function collided(_other:Entity):Void {
        trace(_other);
        switch(_other.tag) {
            case EntityTag.Player:
                _other.dead = true;
                dead = true;

            case EntityTag.Target:
                _other.dead = true;
                Framework.game.addScore(1);
                
                    //Bounce away from targets
                velocity.multiply_scalar(-1);

            default:
                //Nothing to do for the other tags
        }
    }
}