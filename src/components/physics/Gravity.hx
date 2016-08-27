package components.physics;

import luxe.Component;
import luxe.Vector;

import components.physics.Collider;


class Gravity extends Component{


	public var active:Bool = true;

	public var gravityScale:Float = 1;
	public var force:Float;
	public var gravityVector:Vector;

	var collider:Collider;


	public function new(_force:Float){

		super({name : "Gravity"});

		force = _force;

		gravityVector = new Vector(0,1);

	}

	override public function init() {

		collider = get("Collider");

		if(collider == null) {
			throw(entity.name + " must have Collider component");
		}

	}    

	override public function onremoved() {

		collider = null;

	}

	override public function update(dt:Float) {
		
		if(!active){
			return;
		}

		collider.velocity.x += gravityScale * force * gravityVector.x * dt;
		collider.velocity.y += gravityScale * force * gravityVector.y * dt;

	}


}
