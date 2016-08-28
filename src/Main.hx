
import luxe.GameConfig;
import luxe.Input;
import luxe.Scene;
import luxe.Color;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.resource.Resource;

import phoenix.Batcher;
import phoenix.Camera;

import utils.Timer;

import entities.Player;


class Main extends luxe.Game {


	var hud : Scene;
	public static var hud_batcher:Batcher;

	public static var playScene: Scene;

	public static var state : luxe.States;

	public static var player : Player;


	override function config(config:GameConfig) {

		config.window.title = 'ld 36';
		config.window.width = 512;
		config.window.height = 512;
		config.window.fullscreen = false;

		// config.preload.texts.push({id:'assets/tilemap.tmx'});
		
		return config;

	}

	override function ready() {

		Luxe.resources.load_json('assets/parcel.json').then(function(json:JSONResource) {
			var parcel = new Parcel();
			parcel.from_json(json.asset.json);

			var progress = new ParcelProgress({
				parcel      : parcel,
				background  : new Color(1,1,1,0.85),
				oncomplete  : assets_loaded
			});
			parcel.load();
		});


	}

	function assets_loaded(_) {

		Luxe.fixed_timestep = true;


		hud = new Scene('hud scene');
		hud_batcher = new Batcher(Luxe.renderer, 'hud_batcher');
		var hud_view = new Camera();
		hud_batcher.view = hud_view;
		hud_batcher.layer = 2;
		Luxe.renderer.add_batch(hud_batcher);

		var fps = new utils.FPS({
			batcher : hud_batcher
			// color : new Color(1,1,1,1)
			});

		playScene = new Scene('PlayScene');

		state = new luxe.States({ name:'machine' });
		state.add( new states.PlayState() );
		state.set( 'PlayState' );


	}

	override function onkeyup( e:KeyEvent ) {

		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}

		if(e.keycode == Key.key_9) {
			state.set( 'PlayState' );
		}

	}

	override function update(dt:Float) {

		Timer.update(dt);

	}

}
