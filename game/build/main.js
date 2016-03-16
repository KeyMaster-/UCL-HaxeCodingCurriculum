(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Framework = function() {
	this.last_time = 0;
	window.document.onreadystatechange = $bind(this,this.onready);
};
Framework.get_time = function() {
	return window.performance.now() / 1000.0 - Framework.start_time;
};
Framework.prototype = {
	onready: function(_) {
		if(window.document.readyState == "complete") {
			this.run = ($_=window,$bind($_,$_.requestAnimationFrame));
			Framework.start_time = Framework.get_time();
			Framework.vis = new systems_Vis();
			Framework.input = new systems_Input();
			Framework.game = new Game();
			this.run($bind(this,this.update));
		}
	}
	,update: function(t) {
		var dt = Framework.get_time() - this.last_time;
		this.last_time = Framework.get_time();
		Framework.game.update(dt);
		this.run($bind(this,this.update));
	}
};
var Game = function() {
	this.gameover = false;
	this.score = 0;
	this.player = new entities_Player(0,0);
	this.missile = new entities_Missile(0,0,this.player);
	this.reset();
};
Game.prototype = {
	update: function(dt) {
		Framework.vis.clear();
		if(this.gameover) {
			Framework.vis.text("Game over! Press enter to restart.",Framework.vis.get_canvas_width() / 2,Framework.vis.get_canvas_height() / 2,"#ffffff",20,"middle","center");
			if(Framework.input.keydown(13)) {
				this.reset();
				this.gameover = false;
			}
			return;
		}
		this.player.update(dt);
		this.missile.update(dt);
		if(this.player.rect.overlaps(this.missile.rect)) this.gameover = true;
		this.player.draw();
		this.missile.draw();
		var _g = 0;
		var _g1 = this.targets;
		while(_g < _g1.length) {
			var target = _g1[_g];
			++_g;
			target.update(dt);
			if(this.player.rect.overlaps(target.rect)) this.gameover = true;
			if(this.missile.rect.overlaps(target.rect)) {
				this.missile.bounce();
				this.score++;
				this.repositionTarget(target);
			}
			target.draw();
		}
		Framework.vis.text("Score: " + this.score,Framework.vis.get_canvas_width() / 2,30,"#ffffff",20,"center","center");
	}
	,reset: function() {
		this.resetPlayer();
		this.score = 0;
		if(this.targets != null) {
			var _g = 0;
			var _g1 = this.targets;
			while(_g < _g1.length) {
				var target1 = _g1[_g];
				++_g;
				target1.destroy();
			}
		}
		this.targets = [];
		var target = new entities_Target(0,0);
		this.repositionTarget(target);
		this.targets.push(target);
	}
	,repositionTarget: function(target) {
		target.rect.x = Math.random() * (Framework.vis.get_canvas_width() - target.rect.w);
		target.rect.y = Math.random() * (Framework.vis.get_canvas_height() - target.rect.h);
	}
	,resetPlayer: function() {
		this.player.rect.x = Framework.vis.get_canvas_width() / 2 - this.player.rect.w / 2;
		this.player.rect.y = Framework.vis.get_canvas_height() / 2 - this.player.rect.h / 2;
		this.missile.rect.x = Framework.vis.get_canvas_width() / 3;
		this.missile.rect.y = 0;
	}
};
var Main = function() { };
Main.main = function() {
	new Framework();
};
var Rect = function(_x,_y,_w,_h) {
	this.x = _x;
	this.y = _y;
	this.w = _w;
	this.h = _h;
};
Rect.prototype = {
	move: function(_x,_y) {
		this.x += _x;
		this.y += _y;
		return this;
	}
	,overlaps: function(other) {
		return other.x < this.x + this.w && this.x < other.x + other.w && other.y < this.y + this.h && this.y < other.y + other.h;
	}
};
var Util = function() { };
Util.clamp = function(_value,_min,_max) {
	if(_value < _min) return _min; else if(_value > _max) return _max; else return _value;
};
var Vector = function(_x,_y) {
	if(_y == null) _y = 0;
	if(_x == null) _x = 0;
	this.x = _x;
	this.y = _y;
};
Vector.prototype = {
	clone: function() {
		return new Vector(this.x,this.y);
	}
	,copy_from: function(v) {
		this.x = v.x;
		this.y = v.y;
		return this;
	}
	,set_xy: function(_x,_y) {
		this.x = _x;
		this.y = _y;
		return this;
	}
	,add: function(v) {
		this.x += v.x;
		this.y += v.y;
		return this;
	}
	,subtract: function(v) {
		this.x -= v.x;
		this.y -= v.y;
		return this;
	}
	,multiply_scalar: function(f) {
		this.x *= f;
		this.y *= f;
		return this;
	}
	,divide_scalar: function(f) {
		if(f == 0) {
			this.x = 0;
			this.y = 0;
			return this;
		} else {
			this.x = this.x / f;
			this.y = this.y / f;
			return this;
		}
	}
	,normalise: function() {
		return this.divide_scalar(Math.sqrt(this.x * this.x + this.y * this.y));
	}
	,get_angle: function() {
		return Math.atan2(this.y,this.x);
	}
	,set_angle: function(angle) {
		var len = Math.sqrt(this.x * this.x + this.y * this.y);
		this.set_xy(Math.cos(angle) * len,Math.sin(angle) * len);
		return angle;
	}
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,set_length: function(v) {
		this.normalise().multiply_scalar(v);
		return v;
	}
};
var entities_Entity = function(_x,_y,_w,_h) {
	this.rect = new Rect(_x,_y,_w,_h);
};
entities_Entity.prototype = {
	draw: function() {
		Framework.vis.box(this.rect.x,this.rect.y,this.rect.w,this.rect.h,this.color);
	}
	,update: function(dt) {
	}
	,destroy: function() {
		this.rect = null;
	}
};
var entities_Missile = function(_x,_y,_player) {
	this.steering_impulse = 800;
	this.speed = 300;
	entities_Entity.call(this,_x,_y,10,10);
	this.player = _player;
	this.velocity = new Vector(0,0);
};
entities_Missile.__super__ = entities_Entity;
entities_Missile.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.rect.x,this.rect.y,this.rect.w,this.rect.h,"#ffffff");
	}
	,update: function(dt) {
		var player_pos = new Vector(this.player.rect.x + this.player.rect.w / 2,this.player.rect.y + this.player.rect.h / 2);
		var our_pos = new Vector(this.rect.x,this.rect.y);
		var to_player = player_pos.subtract(our_pos);
		to_player.set_length(this.steering_impulse * dt);
		this.velocity.add(to_player);
		if(this.velocity.get_length() > this.speed) this.velocity.set_length(this.speed);
		this.rect.move(this.velocity.x * dt,this.velocity.y * dt);
		if(this.rect.x < 0 || this.rect.x > Framework.vis.get_canvas_width() - this.rect.w || this.rect.y < 0 || this.rect.y > Framework.vis.get_canvas_height() - this.rect.h) {
			this.rect.x = Util.clamp(this.rect.x,0,Framework.vis.get_canvas_width() - this.rect.w);
			this.rect.y = Util.clamp(this.rect.y,0,Framework.vis.get_canvas_height() - this.rect.h);
			this.bounce();
		}
	}
	,bounce: function() {
		this.velocity.multiply_scalar(-1);
	}
});
var entities_Player = function(_x,_y) {
	this.shot_delay = 0.2;
	this.last_shot_time = 0;
	this.speed = 200;
	entities_Entity.call(this,_x,_y,16,16);
	this.color = "#75D974";
};
entities_Player.__super__ = entities_Entity;
entities_Player.prototype = $extend(entities_Entity.prototype,{
	update: function(dt) {
		var move = new Vector(0,0);
		if(Framework.input.keydown(39)) move.x = 1; else if(Framework.input.keydown(37)) move.x = -1;
		if(Framework.input.keydown(38)) move.y = -1; else if(Framework.input.keydown(40)) move.y = 1;
		move.set_length(this.speed * dt);
		this.rect.move(move.x,move.y);
		this.rect.x = Util.clamp(this.rect.x,0,Framework.vis.get_canvas_width() - this.rect.w);
		this.rect.y = Util.clamp(this.rect.y,0,Framework.vis.get_canvas_height() - this.rect.h);
	}
});
var entities_Target = function(_x,_y) {
	entities_Entity.call(this,_x,_y,16,16);
	this.color = "#D94B41";
};
entities_Target.__super__ = entities_Entity;
entities_Target.prototype = $extend(entities_Entity.prototype,{
});
var haxe_IMap = function() { };
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
var systems_Input = function() {
	this.pressed = new haxe_ds_IntMap();
	window.document.onkeydown = $bind(this,this.onkeydown);
	window.document.onkeyup = $bind(this,this.onkeyup);
};
systems_Input.prototype = {
	onkeydown: function(event) {
		this.pressed.h[event.keyCode] = true;
	}
	,onkeyup: function(event) {
		this.pressed.h[event.keyCode] = false;
	}
	,keydown: function(keycode) {
		if(this.pressed.h.hasOwnProperty(keycode)) return this.pressed.h[keycode]; else return false;
	}
};
var systems_Vis = function() {
	this.scale_factor = 2;
	this.canvas = window.document.getElementById("gameview");
	this.canvas.style.backgroundColor = "#111111";
	this.ctx = this.canvas.getContext("2d");
	this.ctx.scale(this.scale_factor,this.scale_factor);
};
systems_Vis.prototype = {
	box: function(x,y,w,h,col) {
		if(col == null) col = "#ffffff";
		this.ctx.fillStyle = col;
		this.ctx.fillRect(x,y,w,h);
	}
	,text: function(text,x,y,col,size,baseline,align) {
		if(align == null) align = "left";
		if(baseline == null) baseline = "top";
		if(size == null) size = 20;
		if(col == null) col = "#ffffff";
		this.ctx.font = "" + size + "px Arial";
		this.ctx.fillStyle = col;
		this.ctx.textBaseline = baseline;
		this.ctx.textAlign = align;
		this.ctx.fillText(text,x,y);
	}
	,clear: function() {
		this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
	}
	,get_canvas_width: function() {
		return this.canvas.width / this.scale_factor;
	}
	,get_canvas_height: function() {
		return this.canvas.height / this.scale_factor;
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Framework.start_time = 0;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
