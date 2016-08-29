package states;

import luxe.States;
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Text;

import luxe.tween.Actuate;
import utils.Timer;


class PauseState extends State {

	var overlay: Sprite;
	var key_timer: Float = 0;
	var title:Text;
	var desc:Text;

	public function new() {

		super({ name:'pause' });

			//fades in, so alpha 0
		overlay = new Sprite({
			size: Luxe.screen.size,
			centered: false,
			color: new Color(0,0,0,0)
		});

		title = new Text({
			text: 'PAUSED',
			depth: 1.5,
			letter_spacing:-6,
			align: center,
			align_vertical: center,
			point_size: 64,
			pos: new Vector(Luxe.screen.mid.x, 32),
			color: new Color().rgb(0xffffff),
		});

		desc = new Text({
			text: 'ESC / resume\nM / menu\nR / restart',
			depth: 1.5,
			line_spacing:-6,
			align: center,
			align_vertical: center,
			point_size: 18,
			pos: new Vector(Luxe.screen.mid.x, 76),
			color: new Color().rgb(0x121212),
		});

		title.color.a = 0;
		desc.color.a = 0;

	} //new

	override function onenabled<T>(_:T) {

			//show things
		overlay.color.tween(0.1, {a:0.25});
		title.color.tween(0.5, {a:1});
		desc.color.tween(0.5, {a:1});

			//tell the rest of the game we are pausing
		Luxe.events.fire('game.paused', { state:true });

			//some delay, avoiding keys from other states, now + 300ms
		key_timer = Luxe.time + 0.2;

	}

		//called when the pause state is disabled
	override function ondisabled<T>(_:T) {

			//hide things
		overlay.color.tween(0.2, {a:0});
		title.color.tween(0.5, {a:0});
		desc.color.tween(0.5, {a:0});

			//tell the rest of the game we are unpausing
		Luxe.events.fire('game.paused', { state:false });

	} //ondisabled


	override function onkeyup( e:KeyEvent ) {

			//ignore keys for a short time
			//to prevent previous states leaking
		if(Luxe.time < key_timer) return;

			//escape resumes the game by
			//disabling the pause state
		if(e.keycode == Key.escape) {
			Actuate.resumeAll();
			Main.playScene.active = true;
			Main.state.disable('pause');
		}

			//m key quits back to menu,
			//but since pause is a transient state
			//we have to disable it as well
		if(e.keycode == Key.key_m) {

			Actuate.resumeAll();
			Main.playScene.active = true;
			
			Main.state.disable('pause');

			Timer.schedule(0.51).onComplete(function() {Main.state.set('menu');});

		}

		if(e.keycode == Key.key_r) {

			Actuate.resumeAll();
			Main.playScene.active = true;

			Main.state.disable('pause');

			Timer.schedule(0.51).onComplete(function() {Main.state.set('play');});
			
		}

	} //onkeyup


} //Pause state

