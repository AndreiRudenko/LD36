package states;

import luxe.States;
import luxe.Vector;
import luxe.Input;
import luxe.Color;
import luxe.Scene;
import luxe.Sprite;

import luxe.Text;

import entities.Solid;
import entities.Player;


class MenuState extends State {

	var lastStateScene:Scene;
	var stateScene:Scene;

	// var title: Text;
	// var play: Text;
	var levelText: Text;
	var title: Sprite;


	public function new() {
		super({ name: 'menu' });
		stateScene = new Scene('menu');
	}

	override function onenter<T>(_:T) {
		lastStateScene = Luxe.scene;
		Luxe.scene = stateScene;

		Luxe.renderer.clear_color = new Color(0.5, 0.5, 0.5, 1);



		title = new Sprite({
			size: Luxe.screen.size,
			centered: false,
			texture : Luxe.resources.texture('assets/title.png')
		});

		Physics.init();

		Main.player = new Player({
			name : "player",
			size : new Vector(28,28),
			pos : new Vector(512-128, 512-64)
		});

		var solid_l:Solid = new Solid({
			name : "solid",
			size : new Vector(32, 512),
			pos : new Vector(16, Luxe.screen.mid.y)
		});

		var solid_r:Solid = new Solid({
			name : "solid",
			size : new Vector(32, 512),
			pos : new Vector(Luxe.screen.width - 16, Luxe.screen.mid.y)
		});

		var solid_u:Solid = new Solid({
			name : "solid",
			size : new Vector(512, 32),
			pos : new Vector(Luxe.screen.mid.x, 16)
		});

		var solid_d:Solid = new Solid({
			name : "solid",
			size : new Vector(512, 32),
			pos : new Vector(Luxe.screen.mid.x, Luxe.screen.height - 16)
		});


/*		title = new Text({
			text: 'select level',
			depth: 20,
			align: center,
			align_vertical: center,
			// point_size: 96,
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y - 32),
			color: new Color(1,1,1,1),
		});

		play = new Text({
			text: 'SPACE / play\nESC / exit',
			depth: 20,
			align: center,
			align_vertical: center,
			point_size: 24,
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y + 64),
			color: new Color(1,1,1,1),
		});*/
		
		levelText = new Text({
			text: '',
			depth: 20,
			align: center,
			align_vertical: center,
			// point_size: 96,
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y + 100),
			color: new Color(0.25,0.25,0.25,1),
		});


	}
 
	override function onleave<T>(_:T) {
		stateScene.empty();
		Luxe.scene = lastStateScene;
		Physics.destroy();

	} //onleave


	override public function onreset() {
		Luxe.scene.reset();
	}

	override function onkeydown( e:KeyEvent ) {

	}

	override function onkeyup( e:KeyEvent ) {

		if(e.keycode == Key.key_q) {
			Main.selectedLevel--;
		}

		if(e.keycode == Key.key_e) {
			Main.selectedLevel++;
		}

		if(e.keycode == Key.enter) {
			Main.state.set('play');
		}

		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}
	}

	override function onmousemove(e:MouseEvent) {

	} //onmousemove


	override function onmouseup(e:MouseEvent) {
	} //onmousemove

	override function update(dt:Float) {
		levelText.text = Std.string(Main.selectedLevel);
	}

	override function onrender() {}

}
