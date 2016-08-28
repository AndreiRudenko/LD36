package components.item;

import luxe.Component;
import luxe.Vector;

import luxe.utils.Maths;
import utils.ShapeDrawer;

import physics.Contact;

import components.physics.Collider;
import components.physics.Gravity;


class ItemCollider extends Collider{


	public var itemType:Int = 0;


	@:noCompletion public function new() {

		super();

		isTrigger = true;
		
	}

	override function onCollision(other:Collider) {

		if(other.active && other.type == Collider.PLAYER) {


/*			var otherGravity:Gravity = other.get("Gravity");
			switch (itemType) {
				case 0 :{
					otherGravity.gravityVector.set_xy(-1,0);
				}
				case 1 :{
					otherGravity.gravityVector.set_xy(0,-1);
				}
				case 2 :{
					otherGravity.gravityVector.set_xy(1,0);
				}
				case 3 :{
					otherGravity.gravityVector.set_xy(0,1);
				}
			}*/

			if(itemType != -1){

				Main.player.collectedItems++;

				Luxe.events.fire('global.switchGravity', itemType);

				entity.destroy();

			} else if (Main.player.collectedItems == 4){

				Luxe.events.fire('global.switchGravity', itemType);
				entity.destroy();
				Main.state.set( 'PlayState' );
				
			}
		}

	}

}    
