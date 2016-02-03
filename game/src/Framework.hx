package ;
import systems.Vis;
import systems.Input;
import js.Browser;

class Framework {
    public static var vis:Vis;
    public static var input:Input;
    
    var game:Game;
    var run:(Float->Void)->Void;

    public static var time(get, never):Float;
    static var start_time:Float = 0;
    var last_time:Float = 0;

    @:allow(Main.main)
    function new() {
        Browser.document.onreadystatechange = onready;
    }

    function onready(_) {
        if(Browser.document.readyState == 'complete') {
            Browser.window.onresize = onresize;
            run = Browser.window.requestAnimationFrame;

            start_time = time;

            vis = new Vis();
            input = new Input();
            game = new Game();

                //:todo: requestAnimationFrame may not exist. If so, display a proper message;
            run(update);
        }
    }

    function update(t:Float) {
        var dt = time - last_time;
        last_time = time;
        game.update(dt);
        run(update);
    }

    function onresize(_) {
        vis.onresize();
    }
    
    static function get_time():Float {
        return (Browser.window.performance.now() / 1000.0) - start_time;
    }
}