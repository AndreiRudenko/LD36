package components.player;

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


class PlayerCollider extends Collider{


	var gravity:Gravity;


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


	override function velocitySolver(c:Contact) {

		if(c.otherCollider.isTrigger || isTrigger) {
			return;
		}
		
		// if(c.normal.x != 0) velocity.x *= -restitution;
		// if(c.normal.y != 0) velocity.y *= -restitution;

		var normImp:Float = (-(1 + restitution) * velocity.dot(c.normal));

/*		if(c.otherCollider.active && velocity.dot(c.otherCollider.velocity) < 0) {
			var normImpOther:Float = (-(1 + c.otherCollider.restitution) * c.otherCollider.velocity.dot(c.normal));

			c.otherCollider.velocity.x += normImpOther * c.normal.x;
			c.otherCollider.velocity.y += normImpOther * c.normal.y;
		}*/

		if(c.otherCollider.type != Collider.MOVABLE){
			velocity.x += normImp * c.normal.x;
			velocity.y += normImp * c.normal.y;
		} else {
			if(gravity.gravityVector.x != 0){
				velocity.x += normImp * c.normal.x;

				if(c.otherCollider.isTouching(CollisionFaces.UP) && c.otherCollider.isTouching(CollisionFaces.DOWN)){
					velocity.y += normImp * c.normal.y;
				} else {
					velocity.y += normImp * c.normal.y * 0.25;
				}
			} else if(gravity.gravityVector.y != 0) {
				velocity.y += normImp * c.normal.y;

				if(c.otherCollider.isTouching(CollisionFaces.LEFT) && c.otherCollider.isTouching(CollisionFaces.RIGHT)){
					velocity.x += normImp * c.normal.x;
				} else {
					velocity.x += normImp * c.normal.x * 0.25;
				}
			}

		}


	}

	override function positionSolver(c:Contact) {

		if(c.otherCollider.isTrigger || isTrigger) {
			return;
		}

		if(c.otherCollider.type != Collider.MOVABLE){
			position.x += c.separation * c.normal.x;
			position.y += c.separation * c.normal.y;
		} else {
			if(gravity.gravityVector.x != 0){
				position.x += c.separation * c.normal.x;

				if(c.otherCollider.isTouching(CollisionFaces.UP) && c.otherCollider.isTouching(CollisionFaces.DOWN)){
					position.y += c.separation * c.normal.y;
				}
			} else if(gravity.gravityVector.y != 0) {
				position.y += c.separation * c.normal.y;

				if(c.otherCollider.isTouching(CollisionFaces.LEFT) && c.otherCollider.isTouching(CollisionFaces.RIGHT)){
					position.x += c.separation * c.normal.x;
				}
			}
		}


	}

}    
