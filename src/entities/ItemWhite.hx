package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;
import components.item.ItemCollider;

import luxe.tween.Actuate;
import luxe.tween.easing.Sine;


class ItemWhite extends Item {


	public var shakeTime:Float = 0.5;

	var shakeVector:Vector;
	var shakeComplete:Bool = true;


	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/item_white.png');
		
		super(_options);
		collider.itemType = -1;


	}

	override function update(dt:Float):Void {

		if(shakeComplete){

			shakeVector = Luxe.utils.geometry.random_point_in_unit_circle().multiplyScalar(6);

			Actuate.tween(origin, shakeTime, { x:16 + shakeVector.x, y: 16 + shakeVector.y } )
			.ease( Sine.easeInOut )
			.onComplete( 
				function() {
					// shakeVector = Luxe.utils.geometry.random_point_in_unit_circle().multiplyScalar(16);
					shakeComplete = true;
					// trace(shakeVector);
					// ct.destroy();
				}
			);

			shakeComplete = false;
			
		}


	}


}