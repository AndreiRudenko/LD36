package entities;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Log.*;

import components.block.BlockCollider;
import components.physics.Gravity;
import components.physics.Collider;

import Settings.*;


class Block extends Sprite {


	public var collider(default, null):BlockCollider;
	public var gravity(default, null):Gravity;

	var switchGravity_eid:String;

	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/block_01.png');
		
		_options.size = def(_options.size, new Vector(32,32));
		_options.name_unique = true;

		super(_options);

		gravity = new Gravity(GRAVITY);

		collider = new BlockCollider();
		collider.type = Collider.MOVABLE;
		// collider.restitution = 0.9;

		add(gravity);
		add(collider);

		listen_events();

	}

	override public function ondestroy(){

		unlisten_events();
		
		collider = null;

		super.ondestroy();

	}

	function switchGravity(dir:Int) {

		switch (dir) {
			case 0 : {
				gravity.gravityVector.set_xy(-1,0);
			}
			case 1 : {
				gravity.gravityVector.set_xy(0,-1);
			}
			case 2 : {
				gravity.gravityVector.set_xy(1,0);
			}
			case 3 : {
				gravity.gravityVector.set_xy(0,1);
			}
		}

	}

	function listen_events() {

		switchGravity_eid = Luxe.events.listen('global.switchGravity', switchGravity );
		// player_landing_eid = events.listen('player.landing', player_landing );

	}

	function unlisten_events() {

		Luxe.events.unlisten(switchGravity_eid);
		// events.unlisten(player_landing_eid);
	}
	
}