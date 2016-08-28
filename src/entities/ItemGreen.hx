package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.physics.Collider;
import components.item.ItemCollider;

import luxe.tween.Actuate;
import luxe.tween.easing.Sine;


class ItemGreen extends Item {


	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/item_green.png');

		super(_options);
		collider.itemType = 2;

		Actuate.tween(origin, 0.9, { x:16 + 4 } )
		.ease( Sine.easeInOut )
		.repeat()
		.reflect();

	}


}