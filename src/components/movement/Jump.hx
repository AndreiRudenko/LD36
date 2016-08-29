package components.movement;

import luxe.Input;
import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.utils.Maths;

import utils.Mathf;
import utils.ShapeDrawer;

import physics.CollisionFaces;

import components.physics.Gravity;
import components.physics.Collider;
import components.input.InputComponent;


class Jump extends Component{


	public static inline var START:Int = 0;
	public static inline var UP:Int = 1;
	public static inline var FALLING:Int = 2;
	public static inline var END:Int = 3;


	public var jumpState:Int = 0;

	public var jumpVelocity:Float = 0;

	public var jumpTime:Float = 0;
	public var factor:Float = 1;

	public var dropJumpVel:Bool = true;
	public var ghostJumpTime:Float = 0.08;

	var gJumpTimer:Float = 0;
	var jumpStartPos:Float = 0;
	var jumpHeight:Float = 0;
	var minJumpHeight:Float = 8; // 64
	
	var gravity:Gravity;
	var collider:Collider;
	var inputComp:InputComponent;


	public function new(_jumpVel:Float){

		super({name : "Jump"});

		jumpVelocity = _jumpVel;

	}

	override public function init() {

		inputComp = get("InputComponent");
		if(inputComp == null) {
			throw(entity.name + " must have Input component");
		}

		collider = get("Collider");
		if(collider == null) {
			throw(entity.name + " must have Collider component");
		}

		gravity = get("Gravity");
		if(gravity == null) {
			throw(entity.name + " must have Gravity component");
		}
		
	}    


	override public function onremoved() {

		collider = null;
		inputComp = null;

	}


	override public function update(dt:Float) {

		var isTouchFloor:Bool = false;
		var jumpVertical:Bool = false;

		var sign:Int = 1;
		var cvel:Float = 0;
		var cpos:Float = 0;

		if(gravity.gravityVector.x != 0){

			cvel = collider.velocity.x;
			cpos = collider.position.x;

			if(gravity.gravityVector.x < 0){
				sign = -1;
				isTouchFloor = collider.isTouching(CollisionFaces.LEFT);
			} else {
				isTouchFloor = collider.isTouching(CollisionFaces.RIGHT);
			}

			jumpVertical = false;

		} else if(gravity.gravityVector.y != 0){

			cvel = collider.velocity.y;
			cpos = collider.position.y;

			if(gravity.gravityVector.y < 0){
				sign = -1;
				isTouchFloor = collider.isTouching(CollisionFaces.UP);
			} else {
				isTouchFloor = collider.isTouching(CollisionFaces.DOWN);
			}

			jumpVertical = true;
		}

		if(!isTouchFloor) {
			gJumpTimer += dt;
		} else {
			gJumpTimer = 0;
		}

		switch (jumpState) {

			case 0 : { // START
				if((inputComp.jump && isTouchFloor) || (inputComp.jump && gJumpTimer < ghostJumpTime)) {
					entity.events.fire('player.jump');
					
					cvel = -jumpVelocity * factor * sign;
					jumpTime = 0;
					gJumpTimer = ghostJumpTime;
					jumpState = UP;

					jumpStartPos = cpos;
					jumpHeight = 0;
				}
			} // case 0

			case 1 : { // UP
				if((cvel * sign) < 0){
					jumpHeight = jumpStartPos - cpos * sign;

					jumpTime += dt;
					if(inputComp.jump){
						gravity.gravityScale = 1;
					// } else if(jumpHeight >= minJumpHeight){
					} else {
						if(dropJumpVel) {
							cvel *= 0.5;
						} else {
							gravity.gravityScale = 1;
						}

						jumpState = FALLING;
					}
				} else {
					jumpState = FALLING;
				}
			} // case 1

			case 2 : { // FALLING
				gravity.gravityScale = 1;

				if(!inputComp.jump){
					jumpState = START;
				}

				if(collider.isTouching(CollisionFaces.FLOOR)){
					jumpState = END;
				}
			} // case 2

			case 3 : { // END
				if(!inputComp.jump){
					jumpState = START;
				}
			} // case 3

		} // switch

		if(jumpVertical){
			collider.velocity.y = cvel;
		} else {
			collider.velocity.x = cvel;
		}
		
	}


}

