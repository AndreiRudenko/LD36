package components.block;

import luxe.Component;
import luxe.Vector;

import luxe.utils.Maths;
import utils.ShapeDrawer;

import physics.Contact;
import physics.AABB;
import physics.CollisionFaces;

import physics.collision.IntersectAABB;

import components.physics.Collider;
import components.physics.Gravity;


class BlockCollider extends Collider{


	var gravity:Gravity;

	var grounded:Bool = false;


	@:noCompletion public function new() {

		super();

	}

	override function init() {

	    super.init();

	    gravity = get("Gravity");
		if(gravity == null) {
			throw(entity.name + " must have Gravity component");
		}
	}

	override public function update(dt:Float) {

		if(gravity.gravityVector.x != 0){
			if(gravity.gravityVector.x > 0){
				grounded = isTouching(CollisionFaces.RIGHT);
			} else {
				grounded = isTouching(CollisionFaces.LEFT);
			}

			if(grounded){
				velocity.y *= 0.8;
			}
		} else if(gravity.gravityVector.y != 0){
			if(gravity.gravityVector.y > 0){
				grounded = isTouching(CollisionFaces.DOWN);
			} else {
				grounded = isTouching(CollisionFaces.UP);
			}

			if(grounded){
				velocity.x *= 0.8;
			}
		}

		super.update(dt);

	}

	override function velocitySolver(c:Contact) {

		if(c.otherCollider.isTrigger || isTrigger) {
			return;
		}
		
		// if(c.normal.x != 0) velocity.x *= -restitution;
		// if(c.normal.y != 0) velocity.y *= -restitution;

		var normImp:Float = (-(1 + restitution) * velocity.dot(c.normal));

		if(c.otherCollider.active && velocity.dot(c.otherCollider.velocity) < 0 && c.otherCollider.type != Collider.PLAYER) {
			var normImpOther:Float = (-(1 + c.otherCollider.restitution) * c.otherCollider.velocity.dot(c.normal));

			c.otherCollider.velocity.x += normImpOther * c.normal.x;
			c.otherCollider.velocity.y += normImpOther * c.normal.y;
		}

		velocity.x += normImp * c.normal.x;
		velocity.y += normImp * c.normal.y;

	}

	override function positionSolver(c:Contact) {

		if(c.otherCollider.isTrigger || isTrigger) {
			return;
		}

		position.x += c.separation * c.normal.x;
		position.y += c.separation * c.normal.y;

	}

}    
