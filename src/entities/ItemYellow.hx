package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;
import components.item.ItemCollider;

import luxe.tween.Actuate;
import luxe.tween.easing.Sine;


class ItemYellow extends Item {


	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/item_yellow.png');
		
		super(_options);
		collider.itemType = 0;

		Actuate.tween(origin, 0.9, { x:16 - 4 } )
		.ease( Sine.easeInOut )
		.repeat()
		.reflect();

	}


}