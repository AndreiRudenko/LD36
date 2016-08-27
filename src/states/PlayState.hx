package states;

import luxe.States;
import luxe.Vector;
import luxe.Input;
import luxe.Color;
import luxe.Scene;
import luxe.Sprite;
import luxe.Text;

import physics.Space;
import utils.ShapeDrawer;

// import luxe.tween.Actuate;

// import entities.Movable;
import entities.Solid;
import entities.Player;
import entities.Block;
import utils.Timer;

class PlayState extends State {

	// var player:Player;
	var block:Block;

	var lastStateScene:Scene;
	// var stateScene:Scene;


	public function new() {
		super({ name: 'PlayState' });
		// stateScene = new Scene('Play');
	}

	override function onenter<T>(_:T) {
		lastStateScene = Luxe.scene;
		Luxe.scene = Main.playScene;

		Physics.init();
		
		// Luxe.renderer.clear_color = new Color( 0.38, 0.38, 0.38);
		Luxe.renderer.clear_color = new Color( 0.18, 0.18, 0.18);

		createWalls();

	}
 
	function createWalls() {

		var up:Solid = new Solid({
			name : "up wall",
			color : new Color(0.5, 0.5, 0.5, 1),
			size : new Vector(512,32),
			pos : new Vector(Luxe.screen.mid.x, 16)
		});

		var down:Solid = new Solid({
			name : "down wall",
			color : new Color(0.5, 0.5, 0.5, 1),
			size : new Vector(512,32),
			pos : new Vector(Luxe.screen.mid.x, Luxe.screen.size.y - 16)
		});

		var left:Solid = new Solid({
			name : "left wall",
			color : new Color(0.5, 0.5, 0.5, 1),
			size : new Vector(32,512),
			pos : new Vector(16, Luxe.screen.mid.y)
		});

		var right:Solid = new Solid({
			name : "right wall",
			color : new Color(0.5, 0.5, 0.5, 1),
			size : new Vector(32,512),
			pos : new Vector(Luxe.screen.size.x - 16, Luxe.screen.mid.y)
		});

		var floor1:Solid = new Solid({
			name : "floor1",
			color : new Color(0.5, 0.5, 0.5, 1),
			size : new Vector(64,32),
			pos : new Vector(32 + 64, Luxe.screen.size.y - 16 - 64 - 32)
		});


		block = new Block({
			name : "block",
			color : new Color(0.6, 0.6, 0.6, 1),
			size : new Vector(32,32),
			pos : Luxe.screen.mid.clone()
		});

		Main.player = new Player({
			name : "player",
			size : new Vector(30,30),
			color : new Color(0.7, 0.7, 0.7, 1),
			pos : new Vector(Luxe.screen.mid.x- 128, Luxe.screen.mid.y)
		});

	}


	override function onleave<T>(_:T) {

		// Luxe.timer.reset();
		Timer.empty();

		Luxe.scene.empty();

		Physics.destroy();

		Luxe.scene = lastStateScene;
		
		Main.player = null;

	}

	override function onkeydown( e:KeyEvent ) {
	}

	override function onkeyup( e:KeyEvent ) {

		if(e.keycode == Key.left) {
			Main.player.gravity.gravityVector.set_xy(-1, 0);
			block.gravity.gravityVector.set_xy(-1, 0);
		}

		if(e.keycode == Key.right) {
			Main.player.gravity.gravityVector.set_xy(1, 0);
			block.gravity.gravityVector.set_xy(1, 0);
		}

		if(e.keycode == Key.up) {
			Main.player.gravity.gravityVector.set_xy(0, -1);
			block.gravity.gravityVector.set_xy(0, -1);
		}

		if(e.keycode == Key.down) {
			Main.player.gravity.gravityVector.set_xy(0, 1);
			block.gravity.gravityVector.set_xy(0, 1);
		}

	}

	override function onmousemove(e:MouseEvent) {
	}

	override function onmousedown(e:MouseEvent) {
	}

	override function onmouseup(e:MouseEvent) {
	}

	override function update(dt:Float) {

		Physics.debugUpdate();

	}

	override function onrender() {

		// Physics.draw();
	}

}
