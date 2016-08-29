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

	var setTexture_eid:String;


	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/item_0.png');
		
		super(_options);
		collider.itemType = -1;


	}

	override function init() {
		
		listen_events();

	}

	override function ondestroy() {

		unlisten_events();
		super.ondestroy();

	}


	override function update(dt:Float):Void {

		if(shakeComplete){


			shakeTime = 0.5 - Main.player.collectedItems * 0.1;

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


	function setTexture(texId:Int) {

		texture = Luxe.resources.texture('assets/item_' + texId + '.png');

	}

	function listen_events() {

		setTexture_eid = Luxe.events.listen("exitItem.setTexture", setTexture );
		// player_landing_eid = events.listen('player.landing', player_landing );

	}

	function unlisten_events() {

		Luxe.events.unlisten(setTexture_eid);
		// events.unlisten(player_landing_eid);
	}

}