package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;


class Solid extends Sprite {


	public var collider(default, null):Collider;


	public function new(_options:SpriteOptions) {

		_options.size = def(_options.size, new Vector(32,32));
		_options.name_unique = true;

		super(_options);

		collider = new Collider();
		collider.active = false;

		add(collider);

	}

	override public function ondestroy(){

		collider = null;

		super.ondestroy();

	}

	
}