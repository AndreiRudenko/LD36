package entities;

import luxe.Entity;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;


class Solid extends Entity {


	public var collider(default, null):Collider;


	public function new(_options:SolidOptions) {

		_options.name_unique = true;

		super(_options);

		collider = new Collider();
		collider.active = false;
		collider.type = Collider.SOLID;

		if(_options.size != null){
			collider.w = _options.size.x;
			collider.h = _options.size.y;
		}

		add(collider);

	}

	override public function ondestroy(){

		collider = null;

		super.ondestroy();

	}

	
}

typedef SolidOptions = {

	> luxe.options.EntityOptions,

	@:optional var size : Vector;

} //SolidOptions