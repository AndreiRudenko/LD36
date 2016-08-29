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

import luxe.tween.Actuate;

// import entities.Movable;
import entities.Solid;
import entities.Player;
import entities.Block;

import entities.ItemGreen;
import entities.ItemRed;
import entities.ItemBlue;
import entities.ItemYellow;
import entities.ItemWhite;

import utils.Timer;

import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledObjectGroup;

import phoenix.Texture.FilterType;


class PlayState extends State {

	var block:Block;

	var lastStateScene:Scene;

	var map: TiledMap;

	var switchGravity_eid:String;

	public var overlay: Sprite;


	public function new() {

		super({ name: 'play' });
		// stateScene = new Scene('Play');


	}

	override function onenter<T>(_:T) {

		overlay = new Sprite({
			size: Luxe.screen.size,
			depth : 100,
			centered: false,
			color: new Color(1,1,1,0.2)
		});

		overlay.color.tween(0.4, {a:0});

		lastStateScene = Luxe.scene;
		Luxe.scene = Main.playScene;

		Physics.init();
		
		Luxe.renderer.clear_color = new Color().rgb(0xd0d0d0);
		// Luxe.renderer.clear_color = new Color( 0.58, 0.58, 0.58);
		// Luxe.renderer.clear_color = new Color( 0.18, 0.18, 0.18);

		createMap();
		createMapCollision();

 		listen_events();


	}

	override function onleave<T>(_:T) {

 		unlisten_events();

 		Actuate.reset();

		// Luxe.timer.reset();
		if(map != null){
			map.destroy();
		}

		Timer.empty();

		Luxe.scene.empty();

		Physics.destroy();

		Luxe.scene = lastStateScene;

		Main.player = null;


	}


	function createMap() {

		var map_data = Luxe.resources.text('assets/level_' + Main.selectedLevel + '.tmx').asset.text;

		map = new TiledMap({ format:'tmx', tiled_file_data: map_data });

		map.display({ scale:1, filter:FilterType.nearest });

	}

	function createMapCollision() {

		var bounds = map.layer('base').bounds_fitted();
		for(bound in bounds) {
			bound.x *= map.tile_width;
			bound.y *= map.tile_height;
			bound.w *= map.tile_width;
			bound.h *= map.tile_height;
			// sim.obstacle_colliders.push(Polygon.rectangle(bound.x, bound.y, bound.w, bound.h, false));
			var solid:Solid = new Solid({
				name : "solid",
				size : new Vector(bound.w, bound.h),
				pos : new Vector(bound.x + bound.w / 2, bound.y + bound.h / 2)
			});

		}

		for(_group in map.tiledmap_data.object_groups) {
			for(_object in _group.objects) {

				switch(_object.type) {

					case 'player': {

						Main.player = new Player({
							name : "player",
							size : new Vector(28,28),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});
						
						// trace("create player");

					} //player

					case 'block': {

						var block = new Block({
							name : "block",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create block");

					} //block

					case 'itemRed': {

						var block = new ItemRed({
							name : "ItemRed",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create itemRed");

					} //itemRed

					case 'itemGreen': {

						var block = new ItemGreen({
							name : "ItemGreen",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create itemGreen");

					} //itemGreen

					case 'itemBlue': {

						var block = new ItemBlue({
							name : "ItemBlue",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create itemBlue");

					} //itemBlue

					case 'itemYellow': {

						var block = new ItemYellow({
							name : "ItemYellow",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create itemYellow");

					} //itemYellow

					case 'itemWhite': {

						var block = new ItemWhite({
							name : "ItemWhite",
							size : new Vector(32,32),
							pos : new Vector(_object.pos.x, _object.pos.y)
						});

						// trace("create itemWhite");

					} //itemWhite

				} //switch type
			} //each object
		} //each object group

	}


	function switchGravity(dir:Int) {

		switch (dir) {
			case -1 : {
				var clr:Color = new Color().rgb(0xffffff);
				Luxe.renderer.clear_color.tween(2,{ r:clr.r, g:clr.g, b:clr.b});

				Timer.schedule(2).onComplete(
					function function_name() {
						Main.selectedLevel++;
						Main.state.set( 'play' );
					}
				);

			}
			case 0 : {
				var clr:Color = new Color().rgb(0xfff3bf);
				Luxe.renderer.clear_color.tween(0.2,{ r:clr.r, g:clr.g, b:clr.b});

			}
			case 1 : {
				var clr:Color = new Color().rgb(0xffd5d5);
				Luxe.renderer.clear_color.tween(0.2,{ r:clr.r, g:clr.g, b:clr.b});
			}
			case 2 : {
				var clr:Color = new Color().rgb(0xd2ffd2);
				Luxe.renderer.clear_color.tween(0.2,{ r:clr.r, g:clr.g, b:clr.b});
			}
			case 3 : {
				var clr:Color = new Color().rgb(0xd7d7ff);
				Luxe.renderer.clear_color.tween(0.2,{ r:clr.r, g:clr.g, b:clr.b});
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


	override function onkeydown( e:KeyEvent ) {}

	override function onkeyup( e:KeyEvent ) {

        var is_paused = Main.state.enabled('pause');

            //important menu based keys
        if(e.keycode == Key.escape) {
            if(!is_paused) {
            	Actuate.pauseAll();
            	Main.playScene.active = false;
                Main.state.enable('pause');
            }
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
