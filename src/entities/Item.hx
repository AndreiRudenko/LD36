package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;
import components.item.ItemCollider;


class Item extends Sprite {


	public var collider(default, null):ItemCollider;


	public function new(_options:SpriteOptions) {

		_options.size = def(_options.size, new Vector(32,32));
		_options.name_unique = true;

		super(_options);

		depth = Layers.ITEMS;

		collider = new ItemCollider();
		collider.type = Collider.ITEM;

		add(collider);

	}

	override public function ondestroy(){

		collider = null;

		super.ondestroy();

	}

	
}