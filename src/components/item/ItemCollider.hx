package components.item;

import luxe.Component;
import luxe.Vector;

import luxe.utils.Maths;
import utils.ShapeDrawer;

import physics.Contact;

import components.physics.Collider;
import components.physics.Gravity;

import luxe.tween.Actuate;
import luxe.tween.easing.Sine;


class ItemCollider extends Collider{


	public var itemType:Int = 0;
	public var picked:Bool = false;


	@:noCompletion public function new() {

		super();

		isTrigger = true;
		
	}

	override function onCollision(other:Collider) {

		if(other.active && other.type == Collider.PLAYER && !picked) {

			if(itemType != -1 || Main.player.collectedItems == 4){

				picked = true;

				Luxe.events.fire('global.switchGravity', itemType);

				Actuate.tween(scale, 0.2, { x:0, y:0 } )
				.ease( Sine.easeInOut )
				.onComplete(function() {entity.destroy();});

			}
		}

	}

}    
