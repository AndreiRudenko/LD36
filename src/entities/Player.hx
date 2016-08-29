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
import components.player.PlayerComponent;
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

import luxe.resource.Resource.AudioResource;

import luxe.components.sprite.SpriteAnimation;


class Player extends Sprite {


	public var playerName:String = 'UnnamedPlayer';

	public var input:PlayerInput;
	public var gravity:Gravity;
	public var move:Move;
	public var jump:Jump;
	public var collider:PlayerCollider;
	public var pComp:PlayerComponent;

	public var collectedItems:Int = 0;
	public var itemsHash:Int = 0;
	public var anim:SpriteAnimation;

	var switchGravity_eid:String;
	var playerJump_eid:String;
	var playerLand_eid:String;
	var playerWalk_eid:String;
	var playerOnAir_eid:String;

	var jump_sound: AudioResource;
	var land_sound: AudioResource;
	var step1_sound: AudioResource;
	var step2_sound: AudioResource;

	var item_01_sound: AudioResource;
	var item_02_sound: AudioResource;
	var item_03_sound: AudioResource;
	var item_04_sound: AudioResource;
	var item_05_sound: AudioResource;


	public function new(_options:SpriteOptions) {

		_options.texture = Luxe.resources.texture('assets/player_01.png');

		super(_options);

		depth = Layers.PLAYER;

		input = new PlayerInput();

		gravity = new Gravity(GRAVITY);

		move = new Move(UNIT * 6, UNIT * 6);

		jump = new Jump(UNIT * 16);

		pComp = new PlayerComponent();


		collider = new PlayerCollider();
		collider.type = Collider.PLAYER;

		add(input);
		add(pComp);
		add(gravity);
		add(move);
		add(jump);
		add(collider);

		listen_events();

		jump_sound = Luxe.resources.audio('assets/jump.ogg');
		land_sound = Luxe.resources.audio('assets/land.ogg');

		step1_sound = Luxe.resources.audio('assets/step_01.ogg');
		step2_sound = Luxe.resources.audio('assets/step_02.ogg');

		item_01_sound = Luxe.resources.audio('assets/item_01.ogg');
		item_02_sound = Luxe.resources.audio('assets/item_02.ogg');
		item_03_sound = Luxe.resources.audio('assets/item_03.ogg');
		item_04_sound = Luxe.resources.audio('assets/item_04.ogg');
		item_05_sound = Luxe.resources.audio('assets/item_05.ogg');

		active = false;

	}

	override public function init(){

		scale.set_xy(0,0);
		Actuate.tween(scale, 0.4, { x:1, y:1 } ).ease( Cubic.easeOut ).onComplete(loadAnim);

	}

	function loadAnim() {

		active = true;
		texture = Luxe.resources.texture('assets/player_anim.png');

		anim = new SpriteAnimation({ name:'anim' });
		add( anim );
		var animation_json = '
			{
				"walk" : {
					"frame_size":{ "x":"64", "y":"64" },
					"frameset": ["1-16"],
					"events" : [{"frame":8, "event":"foot.1"}, {"frame":1, "event":"foot.2"}, { "frame": 6 }],
					"pingpong":"false",
					"loop": "true",
					"speed": "30"
				},
				"jump" : {
					"frame_size":{ "x":"64", "y":"64" },
					"frameset": ["17-24","1"],
					"pingpong":"false",
					"loop": "false",
					"speed": "30"
				},
				"idle" : {
					"frame_size":{ "x":"64", "y":"64" },
					"frameset": ["25-32","1"],
					"pingpong":"false",
					"loop": "true",
					"speed": "10"
				}
			}
		';

		anim.add_from_json( animation_json );
		anim.animation = 'idle';
		anim.play();

        events.listen('foot.1', function(e){

            var handle = Luxe.audio.play(step1_sound.source);

			Luxe.audio.volume(handle, 0.8);

        });

        events.listen('foot.2', function(e){

            var handle = Luxe.audio.play(step2_sound.source);

			Luxe.audio.volume(handle, 0.8);

		});


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

	function playerJump(_) {

		// trace("jump");

		Luxe.audio.play(jump_sound.source);
		// anim.animation = 'jump';
		// anim.play();

	}

	function playerLand(_) {

		// trace("land");

		var handle = Luxe.audio.play(land_sound.source);

		Luxe.audio.volume(handle, 0.5);

	}

	function playerOnAir(_) {

		if(anim.animation != 'jump'){
			anim.animation = 'jump';
			anim.play();
		}

	}

	function playerWalk(walk:Bool) {
		// trace("walk: " + walk);
		if(walk){
			if( anim.animation != 'walk'){
				anim.animation = 'walk';
				anim.play();
			}
		} else if(anim.animation != 'idle'){
			anim.animation = 'idle';
			anim.play();
		}

	}


	function switchGravity(dir:Int) {

		switch (dir) {
			case -1 : {
				var handle = Luxe.audio.play(item_05_sound.source);
				Luxe.audio.volume(handle, 0.5);
				anim.stop();
				texture = Luxe.resources.texture('assets/player_01.png');
				Actuate.tween(scale, 0.4, { x:0, y:0 } ).ease( Cubic.easeOut );
				active = false;

			}
			case 0 : {
				gravity.gravityVector.set_xy(-1,0);
				Actuate.tween(this, 0.2, { rotation_z:90 } ).ease( Cubic.easeOut );
				var handle = Luxe.audio.play(item_01_sound.source);
				Luxe.audio.volume(handle, 0.5);
				collectedItems++;
				itemsHash |= (1 << 2);
				Luxe.events.fire("exitItem.setTexture", itemsHash);
			}
			case 1 : {
				gravity.gravityVector.set_xy(0,-1);
				Actuate.tween(this, 0.2, { rotation_z:180 } ).ease( Cubic.easeOut );
				var handle = Luxe.audio.play(item_02_sound.source);
				Luxe.audio.volume(handle, 0.5);
				collectedItems++;
				itemsHash |= 1;
				Luxe.events.fire("exitItem.setTexture", itemsHash);
			}
			case 2 : {
				gravity.gravityVector.set_xy(1,0);
				Actuate.tween(this, 0.2, { rotation_z:270 } ).ease( Cubic.easeOut );
				var handle = Luxe.audio.play(item_03_sound.source);
				Luxe.audio.volume(handle, 0.5);
				collectedItems++;
				itemsHash |= (1 << 1);
				Luxe.events.fire("exitItem.setTexture", itemsHash);
			}
			case 3 : {
				gravity.gravityVector.set_xy(0,1);
				Actuate.tween(this, 0.2, { rotation_z:0 } ).ease( Cubic.easeOut );
				var handle = Luxe.audio.play(item_04_sound.source);
				Luxe.audio.volume(handle, 0.5);
				collectedItems++;
				itemsHash |= (1 << 3);
				Luxe.events.fire("exitItem.setTexture", itemsHash);
			}
		}

	}

	function listen_events() {

		switchGravity_eid = Luxe.events.listen('global.switchGravity', switchGravity );

		playerOnAir_eid = events.listen('player.onair', playerOnAir );
		playerJump_eid = events.listen('player.jump', playerJump );
		playerLand_eid = events.listen('player.land', playerLand );
		playerWalk_eid = events.listen('player.walk', playerWalk );

	}

	function unlisten_events() {

		Luxe.events.unlisten(switchGravity_eid);
		events.unlisten(playerOnAir_eid);
		events.unlisten(playerJump_eid);
		events.unlisten(playerLand_eid);
		events.unlisten(playerWalk_eid);

	}


}
