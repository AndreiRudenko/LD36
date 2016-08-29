package components.movement;

import luxe.Input;
import luxe.Sprite;
import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.utils.Maths;

import utils.Mathf;
import utils.ShapeDrawer;

import components.physics.Collider;
import components.physics.Gravity;
import components.input.InputComponent;

import physics.CollisionFaces;


class Move extends Component{


	public var airMaxSpeed:Vector;
	public var maxSpeed:Vector;

	public var airAccel:Float;
	public var airFriction:Float;

	public var groundAccel:Float;
	public var groundFriction:Float;

	public var allowX:Bool = true;
	public var allowY:Bool = false;

	var accel:Float = 0;
	var friction:Float = 0;
	var mSpeed:Float = 0;

	var sprite:Sprite;
	var collider:Collider;
	var gravity:Gravity;
	var input:InputComponent;


	public function new(_x:Float = 0, _y:Float = 0){

		maxSpeed = new Vector(_x, _y);
		airMaxSpeed = new Vector(_x, _y);

		super({name : "MoveComponent"});
		var m:Float = 40; // 48

		airAccel = 0.75 * m;
		airFriction = 0.1 * m;
		groundAccel = 1 * m;
		groundFriction = 1.5 * m;

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

		sprite = cast entity;

	}    

	override public function onremoved() {

		collider = null;
		input = null;
		sprite = null;
		maxSpeed = null;
		airMaxSpeed = null;

	}

	override public function update(dt:Float) {


		var isTouchFloor:Bool = false;
		var gravVertical:Bool = false;

		var sign:Int = 1;
		var cvel:Float = 0;
		
		if(gravity.gravityVector.x != 0){

			cvel = collider.velocity.y;

			if(gravity.gravityVector.x < 0){
				isTouchFloor = collider.isTouching(CollisionFaces.LEFT);
			} else {
				sign = -1;
				isTouchFloor = collider.isTouching(CollisionFaces.RIGHT);
			}

			gravVertical = false;

		} else if(gravity.gravityVector.y != 0){

			cvel = collider.velocity.x;

			if(gravity.gravityVector.y < 0){
				sign = -1;
				isTouchFloor = collider.isTouching(CollisionFaces.UP);
			} else {
				isTouchFloor = collider.isTouching(CollisionFaces.DOWN);
			}

			gravVertical = true;
		}



		if(isTouchFloor){
			accel = groundAccel;
			friction = groundFriction;
			mSpeed = maxSpeed.x;
		} else {
			accel = airAccel;
			friction = airFriction;
			mSpeed = airMaxSpeed.x; // custom air maxspeed
		}

		if(allowX){
			if(input.right && cvel * sign <= mSpeed){

				if(sprite.flipx) {
					sprite.flipx = false;
				}
				
				if(cvel * sign < 0) {
					cvel = Mathf.ApValue(cvel, 0 , friction);
					// applyFrictionX();
				}
				
				cvel = Mathf.ApValue(cvel, mSpeed * sign, accel);
				// applyAccelX(mSpeed);
				// entity.events.fire('player.walk', true);

			} else if(input.left && cvel * sign >= -mSpeed){
				if(!sprite.flipx) {
					sprite.flipx = true;
				}

				if(cvel * sign > 0) {
					cvel = Mathf.ApValue(cvel, 0 , friction);
					// applyFrictionX();
				}

				cvel = Mathf.ApValue(cvel, -mSpeed * sign, accel);
				// applyAccelX(-mSpeed);
				// entity.events.fire('player.walk', true);

			} else {

				cvel = Mathf.ApValue(cvel, 0 , friction);
				// applyFrictionX();
				// entity.events.fire('player.walk', false);

			}
		}

/*		if(allowY){
			if(input.down && collider.velocity.y <= mSpeed){
				if(collider.velocity.y < 0) applyFrictionY();

				applyAccelY(mSpeed);
			} else if(input.up && collider.velocity.y >= -mSpeed){
				if(collider.velocity.y > 0) applyFrictionY();
				
				applyAccelY(-mSpeed);
			} else {
				applyFrictionY();
			}
		}*/

		if(gravVertical){
			collider.velocity.x = cvel;
		} else {
			collider.velocity.y = cvel;
		}

	}
/*
	inline function applyFrictionX() {

		collider.velocity.x = Mathf.ApValue(collider.velocity.x, 0 , friction);

	}

	inline function applyFrictionY() {

		collider.velocity.y = Mathf.ApValue(collider.velocity.y, 0 , friction);

	}

	inline function applyAccelX(_speed:Float) {

		collider.velocity.x = Mathf.ApValue(collider.velocity.x, _speed , accel);

	}

	inline function applyAccelY(_speed:Float) {

		collider.velocity.y = Mathf.ApValue(collider.velocity.y, _speed , accel);

	}
	*/

}

