package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.block.BlockCollider;
import components.physics.Gravity;
import components.physics.Collider;

import Settings.*;


class Block extends Sprite {


	public var collider(default, null):BlockCollider;
	public var gravity(default, null):Gravity;


	public function new(_options:SpriteOptions) {

		_options.size = def(_options.size, new Vector(32,32));
		_options.name_unique = true;

		super(_options);

		gravity = new Gravity(GRAVITY);

		collider = new BlockCollider();
		collider.type = Collider.MOVABLE;
		// collider.restitution = 0.9;

		add(gravity);
		add(collider);

	}

	override public function ondestroy(){

		collider = null;

		super.ondestroy();

	}

	
}