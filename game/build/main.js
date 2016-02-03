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
			window.onresize = $bind(this,this.onresize);
			this.run = ($_=window,$bind($_,$_.requestAnimationFrame));
			Framework.start_time = Framework.get_time();
			Framework.vis = new systems_Vis();
			Framework.input = new systems_Input();
			this.game = new Game();
			this.run($bind(this,this.update));
		}
	}
	,update: function(t) {
		var dt = Framework.get_time() - this.last_time;
		this.last_time = Framework.get_time();
		this.game.update(dt);
		this.run($bind(this,this.update));
	}
	,onresize: function(_) {
		Framework.vis.onresize();
	}
};
var Game = function() {
	this.enemy_spawn_interval = 2.0;
	this.enemy_timer = 0;
	this.bullets = [];
	this.player = new entities_Player(0,Framework.vis.get_canvas_height() / 2,this.bullets);
	this.player.rect.y -= this.player.rect.h / 2;
	this.enemies = [];
};
Game.prototype = {
	update: function(dt) {
		Framework.vis.clear();
		this.player.update(dt);
		this.player.draw();
		this.enemy_timer -= dt;
		if(this.enemy_timer <= 0) {
			var enemy = new entities_Enemy(Framework.vis.get_canvas_width(),0);
			enemy.rect.y = Math.random() * (Framework.vis.get_canvas_height() - enemy.rect.h);
			this.enemies.push(enemy);
			this.enemy_timer = this.enemy_spawn_interval;
		}
		var i = this.bullets.length;
		while(i > 0) {
			i--;
			var bullet = this.bullets[i];
			bullet.update(dt);
			if(bullet.dead) {
				bullet.destroy();
				this.bullets.splice(i,1);
				continue;
			}
			bullet.draw();
		}
		i = this.enemies.length;
		while(i > 0) {
			i--;
			var enemy1 = this.enemies[i];
			enemy1.update(dt);
			var _g = 0;
			var _g1 = this.bullets;
			while(_g < _g1.length) {
				var bullet1 = _g1[_g];
				++_g;
				if(!bullet1.dead && enemy1.rect.overlaps(bullet1.rect)) {
					bullet1.dead = true;
					enemy1.dead = true;
				}
			}
			if(enemy1.dead) {
				this.enemies.splice(i,1);
				continue;
			}
			enemy1.draw();
		}
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
var Vector = function(_x,_y) {
	this.x = _x;
	this.y = _y;
};
Vector.prototype = {
	clone: function() {
		return new Vector(this.x,this.y);
	}
	,add: function(v) {
		this.x += v.x;
		this.y += v.y;
		return this;
	}
	,multiply_scalar: function(f) {
		this.x *= f;
		this.y *= f;
		return this;
	}
};
var entities_Entity = function(_x,_y,_w,_h) {
	this.dead = false;
	this.rect = new Rect(_x,_y,_w,_h);
};
entities_Entity.prototype = {
	draw: function() {
	}
	,update: function(dt) {
	}
	,destroy: function() {
		this.rect = null;
	}
};
var entities_Bullet = function(_x,_y,_speed_x,_speed_y) {
	this.size = 10;
	entities_Entity.call(this,_x,_y,10,10);
	this.speed = new Vector(_speed_x,_speed_y);
};
entities_Bullet.__super__ = entities_Entity;
entities_Bullet.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.rect.x,this.rect.y,this.rect.w,this.rect.h);
	}
	,update: function(dt) {
		this.rect.move(this.speed.x * dt,this.speed.y * dt);
		if(this.rect.x < -this.rect.w || this.rect.x > Framework.vis.get_canvas_width() || this.rect.y < -this.rect.h || this.rect.y > Framework.vis.get_canvas_height()) this.dead = true;
	}
	,destroy: function() {
		entities_Entity.prototype.destroy.call(this);
		this.speed = null;
	}
});
var entities_Enemy = function(_x,_y) {
	this.speed = 200;
	entities_Entity.call(this,_x,_y,100,30);
};
entities_Enemy.__super__ = entities_Entity;
entities_Enemy.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.rect.x,this.rect.y,this.rect.w,this.rect.h);
	}
	,update: function(dt) {
		this.rect.x -= dt * this.speed;
		if(this.rect.x < -this.rect.w) this.dead = true;
	}
});
var entities_Player = function(_x,_y,_bullets) {
	this.shot_delay = 0.2;
	this.last_shot_time = 0;
	this.speed = 200;
	entities_Entity.call(this,_x,_y,100,30);
	this.bullets = _bullets;
};
entities_Player.__super__ = entities_Entity;
entities_Player.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.rect.x,this.rect.y,this.rect.w,this.rect.h);
	}
	,update: function(dt) {
		if(Framework.input.keydown(39)) this.rect.x += this.speed * dt; else if(Framework.input.keydown(37)) this.rect.x -= this.speed * dt;
		if(Framework.input.keydown(38)) this.rect.y -= this.speed * dt; else if(Framework.input.keydown(40)) this.rect.y += this.speed * dt;
		this.rect.x = this.clamp(this.rect.x,0,Framework.vis.get_canvas_width() - this.rect.w);
		this.rect.y = this.clamp(this.rect.y,0,Framework.vis.get_canvas_height() - this.rect.h);
		if(Framework.input.keydown(32)) {
			if(Framework.get_time() - this.last_shot_time > this.shot_delay) {
				var bullet = new entities_Bullet(this.rect.x + this.rect.w,this.rect.y + this.rect.h / 2,500,0);
				bullet.rect.y -= bullet.size / 2;
				this.bullets.push(bullet);
				this.last_shot_time = Framework.get_time();
			}
		}
		var _g = 0;
		var _g1 = this.bullets;
		while(_g < _g1.length) {
			var bullet1 = _g1[_g];
			++_g;
			bullet1.update(dt);
		}
	}
	,clamp: function(value,lower,upper) {
		if(value < lower) return lower; else if(value > upper) return upper; else return value;
	}
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
	this.canvas = window.document.getElementById("gameview");
	this.ctx = this.canvas.getContext("2d");
	this.onresize();
};
systems_Vis.prototype = {
	onresize: function() {
		this.canvas.width = window.innerWidth;
		this.canvas.height = window.innerHeight;
	}
	,box: function(x,y,w,h,col) {
		if(col == null) col = "#ffffff";
		this.ctx.fillStyle = col;
		this.ctx.fillRect(x,y,w,h);
	}
	,clear: function() {
		this.ctx.clearRect(0,0,this.ctx.canvas.width,this.ctx.canvas.height);
	}
	,get_canvas_width: function() {
		return this.canvas.width;
	}
	,get_canvas_height: function() {
		return this.canvas.height;
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Framework.start_time = 0;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
