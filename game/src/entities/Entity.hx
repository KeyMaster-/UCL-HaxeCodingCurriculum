package entities;

class Entity {
        //The dimensions of this Entity, used for collision detection
    public var rect:Rect;
        //Indicates if the entity has died and should be removed from the game
    public var dead:Bool = false;
        //The tag of the entity, used to determine what kind of entity we are handling
    public var tag:EntityTag;

    //:todo: maybe use a Vector object here?
    public function new(_x:Float, _y:Float, _w:Float, _h:Float) {
        rect = new Rect(_x, _y, _w, _h);
    }

    public function draw():Void { }

    public function update(dt:Float):Void { }

    public function collided(other:Entity):Void { }

    public function destroy() {
        rect = null;
    }
}