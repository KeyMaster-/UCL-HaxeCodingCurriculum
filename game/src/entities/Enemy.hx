package entities;
import Vector;
import systems.Vis.Image;

class Enemy extends Entity {
    public var health:Int = 4;

    var image:Image;

    var speed:Int = 100;
    var move_direction:Vector;
    var target_position:Vector;
    var player:Player;

    var minimum_x:Float;
    var target_range_x:Float;

    var shot_speed:Float = 100;
    var min_shot_time:Float = 2;
    var added_shot_time_range:Float = 1;
    var shot_timer:Float;

    public function new(_x:Float, _y:Float, _player:Player) {
        tag = EntityTag.Enemy;
        player = _player;

        image = Framework.vis.get_image('enemy_ship');

        super(_x, _y, image.width, image.height);

        shot_timer = min_shot_time + Math.random() * added_shot_time_range;

        move_direction = new Vector();
        target_position = new Vector(0, 0);

        minimum_x = Framework.vis.canvas_width * (2/3); //Only let an enemy choose a target on the right third of the screen
        target_range_x = Framework.vis.canvas_width - minimum_x - rect.w; //This is the range on the x-axis in which the target position can lie. We subtract rect.w to make sure the enemy doesn't go off-screen
    }

    override public function draw() {
        Framework.vis.image(image, rect.x, rect.y);
    }

    override public function update(dt:Float) {
        if(health <= 0) {
            dead = true;
            return;
        }
        shot_timer -= dt;
        if(shot_timer <= 0) {
            var shot_dir = new Vector(player.rect.x + player.rect.w / 2, player.rect.y + player.rect.h / 2);
            shot_dir.subtract(new Vector(rect.x, rect.y + rect.w / 2)); //:todo: Seriously consider making a rect just 2 vectors, would make this more sensible
            shot_dir.length = shot_speed;

            var bullet = new Bullet(rect.x + rect.w / 2, rect.y + rect.h / 2, shot_dir.x, shot_dir.y, false);
            Framework.game.addEntity(bullet);
            shot_timer = min_shot_time + Math.random() * added_shot_time_range;
        }

        rect.x += dt * move_direction.x;
        rect.y += dt * move_direction.y;

        var difference = target_position.clone();
        difference.subtract(new Vector(rect.x, rect.y));
        if(difference.length < 5 || (move_direction.x == 0 && move_direction.y == 0)) { //Check if we're close enough to the target point
            target_position.set_xy(Math.random() * target_range_x + minimum_x, Math.random() * (Framework.vis.canvas_height - rect.h));
            move_direction.copy_from(target_position);
            move_direction.subtract(new Vector(rect.x, rect.y));
            move_direction.length = speed;
        }
    }
}