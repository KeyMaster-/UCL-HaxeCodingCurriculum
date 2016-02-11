(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
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
Framework.__name__ = true;
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
	,__class__: Framework
};
var Game = function() {
	this.gameover = false;
	this.enemy_spawn_interval = 2.0;
	this.enemy_timer = 0;
	this.entities = [];
	this.player = new entities_Player(0,Framework.vis.canvas.height / 2);
	this.player.rect.y -= this.player.rect.h / 2;
	this.addEntity(this.player);
};
Game.__name__ = true;
Game.prototype = {
	update: function(dt) {
		Framework.vis.clear();
		if(this.gameover) {
			Framework.vis.text("Game over!",Framework.vis.canvas.width / 2,Framework.vis.canvas.height / 2,"#ffffff",20,"middle","center");
			return;
		}
		this.enemy_timer -= dt;
		if(this.enemy_timer <= 0) {
			var enemy = new entities_Enemy(Framework.vis.canvas.width,0,this.player);
			enemy.rect.y = Math.random() * (Framework.vis.canvas.height - enemy.rect.h);
			this.entities.push(enemy);
			this.enemy_timer = this.enemy_spawn_interval;
		}
		var i = this.entities.length;
		while(i > 0) {
			i--;
			var entity = this.entities[i];
			entity.update(dt);
			entity.draw();
			if(entity.dead) {
				entity.destroy();
				this.entities.splice(i,1);
				continue;
			}
			var _g = 0;
			var _g1 = this.entities;
			while(_g < _g1.length) {
				var other_entity = _g1[_g];
				++_g;
				if(other_entity == entity) continue;
				if(!other_entity.dead && other_entity.rect.overlaps(entity.rect)) {
					other_entity.collided(entity);
					entity.collided(other_entity);
				}
			}
		}
		if(this.player.dead) this.gameover = true;
	}
	,addEntity: function(_entity) {
		this.entities.push(_entity);
	}
	,__class__: Game
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	new Framework();
};
Math.__name__ = true;
var Rect = function(_x,_y,_w,_h) {
	this.x = _x;
	this.y = _y;
	this.w = _w;
	this.h = _h;
};
Rect.__name__ = true;
Rect.prototype = {
	move: function(_x,_y) {
		this.x += _x;
		this.y += _y;
		return this;
	}
	,overlaps: function(other) {
		return other.x < this.x + this.w && this.x < other.x + other.w && other.y < this.y + this.h && this.y < other.y + other.h;
	}
	,__class__: Rect
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var Vector = function(_x,_y) {
	if(_y == null) _y = 0;
	if(_x == null) _x = 0;
	this.x = _x;
	this.y = _y;
};
Vector.__name__ = true;
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
	,get_length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,set_length: function(v) {
		this.normalise().multiply_scalar(v);
		return v;
	}
	,__class__: Vector
};
var entities_Entity = function(_x,_y,_w,_h) {
	this.dead = false;
	this.rect = new Rect(_x,_y,_w,_h);
};
entities_Entity.__name__ = true;
entities_Entity.prototype = {
	draw: function() {
	}
	,update: function(dt) {
	}
	,collided: function(other) {
	}
	,destroy: function() {
		this.rect = null;
	}
	,__class__: entities_Entity
};
var entities_Bullet = function(_x,_y,_speed_x,_speed_y,_friendly) {
	this.damage = 1;
	var image_name = "";
	if(_friendly) {
		this.tag = entities_EntityTag.PlayerBullet;
		image_name = "player_bullet";
	} else {
		this.tag = entities_EntityTag.EnemyBullet;
		image_name = "enemy_bullet";
	}
	this.image = Framework.vis.get_image(image_name);
	entities_Entity.call(this,_x,_y,this.image.image_element.width,this.image.image_element.height);
	this.speed = new Vector(_speed_x,_speed_y);
};
entities_Bullet.__name__ = true;
entities_Bullet.__super__ = entities_Entity;
entities_Bullet.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.image(this.image,this.rect.x,this.rect.y);
	}
	,update: function(dt) {
		this.rect.move(this.speed.x * dt,this.speed.y * dt);
		if(this.rect.x < -this.rect.w || this.rect.x > Framework.vis.canvas.width || this.rect.y < -this.rect.h || this.rect.y > Framework.vis.canvas.height) this.dead = true;
	}
	,collided: function(other) {
		if(this.tag == entities_EntityTag.PlayerBullet && other.tag == entities_EntityTag.Enemy) {
			var enemy;
			enemy = js_Boot.__cast(other , entities_Enemy);
			enemy.health -= this.damage;
			this.dead = true;
		} else if(this.tag == entities_EntityTag.EnemyBullet && other.tag == entities_EntityTag.Player) {
			var player;
			player = js_Boot.__cast(other , entities_Player);
			player.health -= this.damage;
			this.dead = true;
		}
	}
	,destroy: function() {
		entities_Entity.prototype.destroy.call(this);
		this.speed = null;
	}
	,__class__: entities_Bullet
});
var entities_Enemy = function(_x,_y,_player) {
	this.added_shot_time_range = 1;
	this.min_shot_time = 2;
	this.shot_speed = 100;
	this.speed = 100;
	this.health = 4;
	this.tag = entities_EntityTag.Enemy;
	this.player = _player;
	this.image = Framework.vis.get_image("enemy_ship");
	entities_Entity.call(this,_x,_y,this.image.image_element.width,this.image.image_element.height);
	this.shot_timer = this.min_shot_time + Math.random() * this.added_shot_time_range;
	this.move_direction = new Vector();
	this.target_position = new Vector(0,0);
	this.minimum_x = Framework.vis.canvas.width * 0.66666666666666663;
	this.target_range_x = Framework.vis.canvas.width - this.minimum_x - this.rect.w;
};
entities_Enemy.__name__ = true;
entities_Enemy.__super__ = entities_Entity;
entities_Enemy.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.image(this.image,this.rect.x,this.rect.y);
	}
	,update: function(dt) {
		if(this.health <= 0) {
			this.dead = true;
			return;
		}
		this.shot_timer -= dt;
		if(this.shot_timer <= 0) {
			var shot_dir = new Vector(this.player.rect.x + this.player.rect.w / 2,this.player.rect.y + this.player.rect.h / 2);
			shot_dir.subtract(new Vector(this.rect.x,this.rect.y + this.rect.w / 2));
			shot_dir.set_length(this.shot_speed);
			var bullet = new entities_Bullet(this.rect.x + this.rect.w / 2,this.rect.y + this.rect.h / 2,shot_dir.x,shot_dir.y,false);
			Framework.game.addEntity(bullet);
			this.shot_timer = this.min_shot_time + Math.random() * this.added_shot_time_range;
		}
		this.rect.x += dt * this.move_direction.x;
		this.rect.y += dt * this.move_direction.y;
		var difference = this.target_position.clone();
		difference.subtract(new Vector(this.rect.x,this.rect.y));
		if(Math.sqrt(difference.x * difference.x + difference.y * difference.y) < 5 || this.move_direction.x == 0 && this.move_direction.y == 0) {
			this.target_position.set_xy(Math.random() * this.target_range_x + this.minimum_x,Math.random() * (Framework.vis.canvas.height - this.rect.h));
			this.move_direction.copy_from(this.target_position);
			this.move_direction.subtract(new Vector(this.rect.x,this.rect.y));
			this.move_direction.set_length(this.speed);
		}
	}
	,__class__: entities_Enemy
});
var entities_EntityTag = { __ename__ : true, __constructs__ : ["Player","Enemy","PlayerBullet","EnemyBullet"] };
entities_EntityTag.Player = ["Player",0];
entities_EntityTag.Player.toString = $estr;
entities_EntityTag.Player.__enum__ = entities_EntityTag;
entities_EntityTag.Enemy = ["Enemy",1];
entities_EntityTag.Enemy.toString = $estr;
entities_EntityTag.Enemy.__enum__ = entities_EntityTag;
entities_EntityTag.PlayerBullet = ["PlayerBullet",2];
entities_EntityTag.PlayerBullet.toString = $estr;
entities_EntityTag.PlayerBullet.__enum__ = entities_EntityTag;
entities_EntityTag.EnemyBullet = ["EnemyBullet",3];
entities_EntityTag.EnemyBullet.toString = $estr;
entities_EntityTag.EnemyBullet.__enum__ = entities_EntityTag;
var entities_Player = function(_x,_y) {
	this.health = 10;
	this.shot_delay = 0.2;
	this.last_shot_time = 0;
	this.speed = 200;
	this.tag = entities_EntityTag.Player;
	this.image = Framework.vis.get_image("player_ship");
	entities_Entity.call(this,_x,_y,this.image.image_element.width,this.image.image_element.height);
};
entities_Player.__name__ = true;
entities_Player.__super__ = entities_Entity;
entities_Player.prototype = $extend(entities_Entity.prototype,{
	draw: function() {
		Framework.vis.image(this.image,this.rect.x,this.rect.y);
		Framework.vis.text("Health: " + this.health,10,10);
	}
	,update: function(dt) {
		if(this.health <= 0) {
			this.dead = true;
			return;
		}
		var move = new Vector(0,0);
		if(Framework.input.keydown(39)) move.x = 1; else if(Framework.input.keydown(37)) move.x = -1;
		if(Framework.input.keydown(38)) move.y = -1; else if(Framework.input.keydown(40)) move.y = 1;
		move.set_length(this.speed * dt);
		this.rect.move(move.x,move.y);
		this.rect.x = this.clamp(this.rect.x,0,Framework.vis.canvas.width - this.rect.w);
		this.rect.y = this.clamp(this.rect.y,0,Framework.vis.canvas.height - this.rect.h);
		if(Framework.input.keydown(32)) {
			if(Framework.get_time() - this.last_shot_time > this.shot_delay) {
				var bullet = new entities_Bullet(this.rect.x + this.rect.w,this.rect.y + this.rect.h / 2,500,0,true);
				bullet.rect.y -= bullet.rect.h / 2;
				Framework.game.addEntity(bullet);
				this.last_shot_time = Framework.get_time();
			}
		}
	}
	,clamp: function(value,lower,upper) {
		if(value < lower) return lower; else if(value > upper) return upper; else return value;
	}
	,__class__: entities_Player
});
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	__class__: haxe_ds_IntMap
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Path = function(path) {
	switch(path) {
	case ".":case "..":
		this.dir = path;
		this.file = "";
		return;
	}
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		this.dir = HxOverrides.substr(path,0,c2);
		path = HxOverrides.substr(path,c2 + 1,null);
		this.backslash = true;
	} else if(c2 < c1) {
		this.dir = HxOverrides.substr(path,0,c1);
		path = HxOverrides.substr(path,c1 + 1,null);
	} else this.dir = null;
	var cp = path.lastIndexOf(".");
	if(cp != -1) {
		this.ext = HxOverrides.substr(path,cp + 1,null);
		this.file = HxOverrides.substr(path,0,cp);
	} else {
		this.ext = null;
		this.file = path;
	}
};
haxe_io_Path.__name__ = true;
haxe_io_Path.withoutExtension = function(path) {
	var s = new haxe_io_Path(path);
	s.ext = null;
	return s.toString();
};
haxe_io_Path.withoutDirectory = function(path) {
	var s = new haxe_io_Path(path);
	s.dir = null;
	return s.toString();
};
haxe_io_Path.prototype = {
	toString: function() {
		return (this.dir == null?"":this.dir + (this.backslash?"\\":"/")) + this.file + (this.ext == null?"":"." + this.ext);
	}
	,__class__: haxe_io_Path
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var systems_Input = function() {
	this.pressed = new haxe_ds_IntMap();
	window.document.onkeydown = $bind(this,this.onkeydown);
	window.document.onkeyup = $bind(this,this.onkeyup);
};
systems_Input.__name__ = true;
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
	,__class__: systems_Input
};
var systems_Vis = function() {
	this.canvas = window.document.getElementById("gameview");
	this.canvas.style.backgroundColor = "#111111";
	this.ctx = this.canvas.getContext("2d");
	this.images = new haxe_ds_StringMap();
	var img_elements = window.document.getElementsByTagName("img");
	var _g = 0;
	while(_g < img_elements.length) {
		var element = img_elements[_g];
		++_g;
		var name = element.src;
		name = haxe_io_Path.withoutDirectory(name);
		name = haxe_io_Path.withoutExtension(name);
		var value = new systems_Image(element);
		this.images.set(name,value);
	}
};
systems_Vis.__name__ = true;
systems_Vis.prototype = {
	box: function(x,y,w,h,col) {
		if(col == null) col = "#ffffff";
		this.ctx.fillStyle = col;
		this.ctx.fillRect(x,y,w,h);
	}
	,image: function(image,x,y) {
		this.ctx.drawImage(image.image_element,Math.floor(x),Math.floor(y));
	}
	,get_image: function(name) {
		return this.images.get(name);
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
		return this.canvas.width;
	}
	,get_canvas_height: function() {
		return this.canvas.height;
	}
	,__class__: systems_Vis
};
var systems_Image = function(_image_element) {
	this.image_element = _image_element;
};
systems_Image.__name__ = true;
systems_Image.prototype = {
	get_width: function() {
		return this.image_element.width;
	}
	,get_height: function() {
		return this.image_element.height;
	}
	,__class__: systems_Image
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
Framework.start_time = 0;
js_Boot.__toStr = {}.toString;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
