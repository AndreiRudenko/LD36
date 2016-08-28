package entities;

import luxe.Input;
import luxe.Entity;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Log.*;
import luxe.options.SpriteOptions;

import components.physics.Collider;
import components.physics.Gravity;
import components.player.PlayerInput;
import components.player.PlayerCollider;
import components.movement.Move;
import components.movement.Jump;

import utils.ShapeDrawer;

import Settings.*;

import luxe.tween.Actuate;
import luxe.tween.easing.Quad;
import luxe.tween.easing.Cubic;
import luxe.tween.easing.Back;
import luxe.tween.easing.Elastic;
import luxe.tween.easing.Sine;


class Player extends Sprite {


	public var playerName:String = 'UnnamedPlayer';

	public var input:PlayerInput;
	public var gravity:Gravity;
	public var move:Move;
	public var jump:Jump;
	public var collider:PlayerCollider;

	public var collectedItems:Int = 0;

	var switchGravity_eid:String;

	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/player_01.png');

		super(_options);

		input = new PlayerInput();

		gravity = new Gravity(GRAVITY);

		move = new Move(UNIT * 6, UNIT * 6);

		jump = new Jump(UNIT * 16);


		collider = new PlayerCollider();
		collider.type = Collider.PLAYER;

		add(input);
		add(gravity);
		add(move);
		add(jump);
		add(collider);

		listen_events();

	}

	override public function ondestroy(){

		unlisten_events();

		playerName = null;
		input = null;
		move = null;
		jump = null;
		collider = null;

		super.ondestroy();

	}

	function switchGravity(dir:Int) {

		switch (dir) {
			case 0 : {
				gravity.gravityVector.set_xy(-1,0);
				Actuate.tween(this, 0.2, { rotation_z:90 } ).ease( Cubic.easeOut );

				// rotation_z = 90;
			}
			case 1 : {
				gravity.gravityVector.set_xy(0,-1);
				Actuate.tween(this, 0.2, { rotation_z:180 } ).ease( Cubic.easeOut );
				// rotation_z = 180;
			}
			case 2 : {
				gravity.gravityVector.set_xy(1,0);
				Actuate.tween(this, 0.2, { rotation_z:270 } ).ease( Cubic.easeOut );
				// rotation_z = 270;
			}
			case 3 : {
				gravity.gravityVector.set_xy(0,1);
				Actuate.tween(this, 0.2, { rotation_z:0 } ).ease( Cubic.easeOut );
				// rotation_z = 0;
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
