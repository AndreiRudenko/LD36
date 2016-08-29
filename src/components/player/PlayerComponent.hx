package components.player;

import luxe.Component;

import components.physics.Collider;
import components.physics.Gravity;
import components.input.InputComponent;

import physics.CollisionFaces;


class PlayerComponent extends Component {


	public var playerName:String = 'UnnamedPlayer';
	public var team:Int = 0;

	public var isWasGrounded (default, null) :Bool = false;
	public var isGrounded (default, null) :Bool = false;

	var collider:Collider;
	var gravity:Gravity;
	var input:InputComponent;


	public function new() {

		super({name : 'PlayerComponent'});

	}

	override public function init() {

		collider = get("Collider");
		if(collider == null) throw(entity.name + " must have Collider component");

		input = get("InputComponent");
		if(input == null) throw(entity.name + " must have Input component");

		gravity = get("Gravity");
		if(gravity == null) {
			throw(entity.name + " must have Gravity component");
		}

	}  

	override function update(dt:Float) {

	    if(gravity.gravityVector.x != 0){

			if(gravity.gravityVector.x < 0){
				isWasGrounded = collider.isWasTouching(CollisionFaces.LEFT);
				isGrounded = collider.isTouching(CollisionFaces.LEFT);
			} else {
				isWasGrounded = collider.isWasTouching(CollisionFaces.RIGHT);
				isGrounded = collider.isTouching(CollisionFaces.RIGHT);
			}

		} else if(gravity.gravityVector.y != 0){

			if(gravity.gravityVector.y < 0){
				isWasGrounded = collider.isWasTouching(CollisionFaces.UP);
				isGrounded = collider.isTouching(CollisionFaces.UP);
			} else {
				isWasGrounded = collider.isWasTouching(CollisionFaces.DOWN);
				isGrounded = collider.isTouching(CollisionFaces.DOWN);
			}

		}

		if(isGrounded){
			if(input.left || input.right){
				entity.events.fire('player.walk', true);
			} else {
				entity.events.fire('player.walk', false);
			}

			if(!isWasGrounded){
				entity.events.fire('player.land');
			}
		} else {
			if(isWasGrounded){
				entity.events.fire('player.onair');
			}
		}

		// if(input.jump && isGrounded){
		// 	entity.events.fire('player.jump');
		// }




				// entity.events.fire('player.walk', false);





	}

}
