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


class Player extends Sprite {


	public var playerName:String = 'UnnamedPlayer';

	public var input:PlayerInput;
	public var gravity:Gravity;
	public var move:Move;
	public var jump:Jump;
	public var collider:PlayerCollider;

	public function new(_options:SpriteOptions) {

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

	}

	override public function ondestroy(){

		playerName = null;
		input = null;
		move = null;
		jump = null;
		collider = null;

		super.ondestroy();

	}


}
