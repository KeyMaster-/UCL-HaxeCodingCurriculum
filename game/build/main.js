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
	this.player = new entities_Player(0,Framework.vis.get_canvas_height() / 2);
	this.player.pos.y -= this.player.height / 2;
};
Game.prototype = {
	update: function(dt) {
		this.player.update(dt);
		Framework.vis.clear();
		this.player.draw();
	}
};
var HxOverrides = function() { };
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
var Main = function() { };
Main.main = function() {
	new Framework();
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
var entities_Entity = function(_x,_y) {
	this.pos = new Vector(_x,_y);
};
entities_Entity.prototype = {
	draw: function() {
	}
	,update: function(dt) {
	}
};
var entities_Bullet = function(_x,_y,_speed_x,_speed_y) {
	this.size = 10;
	this.dead = false;
	entities_Entity.call(this,_x,_y);
	this.speed = new Vector(_speed_x,_speed_y);
};
entities_Bullet.__super__ = entities_Entity;
entities_Bullet.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.pos.x,this.pos.y,this.size,this.size);
	}
	,update: function(dt) {
		this.pos.add(this.speed.clone().multiply_scalar(dt));
		if(this.pos.x - this.size < 0 || this.pos.x > Framework.vis.get_canvas_width() || this.pos.y - this.size < 0 || this.pos.y > Framework.vis.get_canvas_height()) {
			this.pos = null;
			this.speed = null;
			this.dead = true;
		}
	}
});
var entities_Player = function(_x,_y) {
	this.shot_delay = 0.1;
	this.last_shot_time = 0;
	this.speed = 200;
	this.height = 30;
	this.width = 100;
	entities_Entity.call(this,_x,_y);
	this.bullets = [];
};
entities_Player.__super__ = entities_Entity;
entities_Player.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.box(this.pos.x,this.pos.y,this.width,this.height);
		var i = 0;
		while(i < this.bullets.length) {
			var bullet = this.bullets[i];
			if(bullet.dead == true) {
				HxOverrides.remove(this.bullets,bullet);
				continue;
			}
			bullet.draw();
			i++;
		}
	}
	,update: function(dt) {
		if(Framework.input.keydown(39)) this.pos.x += this.speed * dt; else if(Framework.input.keydown(37)) this.pos.x -= this.speed * dt;
		if(Framework.input.keydown(38)) this.pos.y -= this.speed * dt; else if(Framework.input.keydown(40)) this.pos.y += this.speed * dt;
		this.pos.x = this.clamp(this.pos.x,0,Framework.vis.get_canvas_width() - this.width);
		this.pos.y = this.clamp(this.pos.y,0,Framework.vis.get_canvas_height() - this.height);
		if(Framework.input.keydown(32)) {
			if(Framework.get_time() - this.last_shot_time > this.shot_delay) {
				var bullet = new entities_Bullet(this.pos.x + this.width,this.pos.y + this.height / 2,500,0);
				bullet.pos.y -= bullet.size / 2;
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
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
Framework.start_time = 0;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
