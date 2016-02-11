package entities;
import systems.Vis.Image;

class Bullet extends Entity {
    public var damage:Int = 1;
    var image:Image;
    var speed:Vector;

    public function new(_x:Float, _y:Float, _speed_x:Float, _speed_y:Float, _friendly:Bool) {
        var image_name = '';
        if(_friendly) {
            tag = PlayerBullet;
            image_name = 'player_bullet';
        }
        else {
            tag = EnemyBullet;
            image_name = 'enemy_bullet';
        }
        image = Framework.vis.get_image(image_name);
        super(_x, _y, image.width, image.height); //Call the super constructor before setting the speed, since the speed vector doesn't exist before that
        speed = new Vector(_speed_x, _speed_y);
    }

    override public function draw() {
        Framework.vis.image(image, rect.x, rect.y);
    }

    override public function update(dt:Float) {
        rect.move(speed.x * dt, speed.y * dt);
        if(rect.x < -rect.w || rect.x > Framework.vis.canvas_width || rect.y < -rect.h || rect.y > Framework.vis.canvas_height) {
            dead = true;
        }
    }

    override public function collided(other:Entity) {
        if(tag == EntityTag.PlayerBullet && other.tag == EntityTag.Enemy){
            var enemy = cast(other, Enemy);
            enemy.health -= damage;
            dead = true;
        }
        else if(tag == EntityTag.EnemyBullet && other.tag == EntityTag.Player) {
            var player = cast(other, Player);
            player.health -= damage;
            dead = true;
        }
    }

    override public function destroy() {
        super.destroy();
        speed = null;
    }
}