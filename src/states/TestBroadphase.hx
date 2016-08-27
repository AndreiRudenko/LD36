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

// import phoenix.BitmapFont;
// import phoenix.geometry.TextGeometry;

import components.physics.Collider;
import entities.Movable;
import entities.Solid;
// import utils.Timer;

class Play extends State {

	var lastStateScene:Scene;
	var stateScene:Scene;

	public function new() {
		super({ name: 'Play' });
		stateScene = new Scene('Play');
	}

	override function onenter<T>(_:T) {
		lastStateScene = Luxe.scene;
		Luxe.scene = stateScene;

		Physics.init();
		
		Luxe.renderer.clear_color = new Color( 0.38, 0.38, 0.38);

		// _timer = new Timer();
/*		Timer.schedule(1).onUpdate(
			function() {
				trace("timer onUpdate");
			}
			);*/


		new Solid(new Vector(Luxe.screen.mid.x, 0), new Vector(Luxe.screen.width, 64), 'assets/tiles/tile_01.png');
		new Solid(new Vector(Luxe.screen.mid.x, Luxe.screen.height), new Vector(Luxe.screen.width, 64), 'assets/tiles/tile_01.png');

		new Solid(new Vector(0, Luxe.screen.mid.y), new Vector(64, Luxe.screen.height), 'assets/tiles/tile_01.png');
		new Solid(new Vector(Luxe.screen.width, Luxe.screen.mid.y), new Vector(64, Luxe.screen.height), 'assets/tiles/tile_01.png');

		for (i in 0...1) {
			var s:Movable = new Movable( 
					new Vector(Luxe.utils.random.int(32, 928), Luxe.utils.random.int(32, 608)), 
					new Vector(32,32),
					'assets/tiles/tile_01.png',
					"TestScript2"
				);

			// s.collider.velocity.x = Luxe.utils.random.int(-150,151);
			// s.collider.velocity.y = Luxe.utils.random.int(-150,151);
			// s.collider.gravity.y = 10;
			// s.collider.damping = 0.8;
		}

		for (i in 0...20) {
			var s:Movable = new Movable( 
					new Vector(Luxe.utils.random.int(32, 928), Luxe.utils.random.int(32, 608)), 
					new Vector(32,32),
					'assets/tiles/tile_01.png',
					"TestScript3"
				);

			s.collider.velocity.x = Luxe.utils.random.int(-150,151);
			s.collider.velocity.y = Luxe.utils.random.int(-150,151);
			// s.collider.velocity.x = Luxe.utils.random.int(-556, 556);
			// s.collider.velocity.y = Luxe.utils.random.int(-556, 556);
			// s.collider.gravity.y = 10;
			// s.collider.damping = 0.8;
		}

		for (i in 0...20) {
			var s:Solid = new Solid( 
					new Vector(Luxe.utils.random.int(32, 928), Luxe.utils.random.int(32, 608)), 
					new Vector(Luxe.utils.random.int(16, 65), Luxe.utils.random.int(16, 65)),
					'assets/tiles/tile_01.png'
					// "TestScript2"
				);
		}



		// _origin = new Vector(100,256);
		_origin = Luxe.screen.mid.clone();
		_origin.x +=16;
		_origin.y +=16;
		_start = new Vector();
		_end = new Vector();
		_size = new Vector(64, 64);
		_dir = new Vector(1,0);
		mousePos = new Vector();


	}
 


	override function onleave<T>(_:T) {
		Luxe.timer.reset();
		
		Luxe.scene.empty();

		#if scripted
			WrenEngine.empty();
		#end

		Physics.destroy();

		Luxe.scene = lastStateScene;
		// Luxe.renderer.batcher.empty();

	}

	override function onkeydown( e:KeyEvent ) {
	}

	override function onkeyup( e:KeyEvent ) {

		// if(e.keycode == Key.key_d){
		// 	Luxe.timescale += 0.1;
		// }
	}

	override function onmousemove(e:MouseEvent) {
		mousePos.copy_from(e.pos);
	}

	override function onmousedown(e:MouseEvent) {
	}

	override function onmouseup(e:MouseEvent) {
		_origin.copy_from(e.pos);
	}

	var _start:Vector;
	var _end:Vector;

	var _size:Vector;

	var _origin:Vector;

	var _dir:Vector;
	var mousePos:Vector;
	var distance:Float = 512;

	var rayhits:Array<physics.RaycastHit>;
	var rayhit:physics.RaycastHit;
	var rayhitBool:Bool = false;

	var hits:Array<Collider>;
	var hit:Collider;
	var hitBool:Bool = false;

	override function update(dt:Float) {

		#if scripted
			WrenEngine.update(dt);
		#end

		_dir.x = mousePos.x - _origin.x;
		_dir.y = mousePos.y - _origin.y;
		_dir.normalize();

/*		_end.copy_from(mousePos);
		_end.x += _size.x;
		_end.y += _size.y;

		_start.copy_from(mousePos);
		_start.x -= _size.x;
		_start.y -= _size.y;*/

		_end.copy_from(mousePos);

		// _start.copy_from(_origin);

		// rayhit = Physics.RayCast(_origin, _dir);
		rayhits = Physics.RayCastAll(_origin, _dir, distance);
		// rayhits = Physics.BoxCastAll(_origin, _size, _dir, distance);
		// rayhits = Physics.LineCastAll(_origin, _end);

		// hit = Physics.AreaOverlap(_start, _end);
		// hits = Physics.AreaOverlap(_start, _end);
		// hits = Physics.CircleOverlapAll(_start, _size.x);



/*		for (e in Luxe.scene.entities) {
			var script:components.ScriptComponent = e.get("ScriptComponent");
			var collider:components.Collider = e.get("Collider");
			if(script != null && collider != null && script.scriptName == "TestScript3"){
				// trace("script != null");
				var rx:Float = Luxe.utils.random.int(16, 65);
				var ry:Float = Luxe.utils.random.int(16, 65);
				var s:Sprite = cast e;
				s.size.x = rx;
				s.size.y = ry;
				collider.half.x = rx * 0.5;
				collider.half.y = ry * 0.5;
			}
		}*/

		Physics.debugUpdate();

	}

	override function onrender() {

		if(rayhits != null){
			for (h in rayhits) {
				ShapeDrawer.drawPoint(h.point.x, h.point.y, 6, ShapeDrawer.color_blue);
				ShapeDrawer.drawPoint(h.pointOut.x, h.pointOut.y, 6, ShapeDrawer.color_pink);
				ShapeDrawer.drawPoint(h.collider.position.x, h.collider.position.y, 3, ShapeDrawer.color_yellow);
			}
		}

		if(rayhit != null){
			ShapeDrawer.drawPoint(rayhit.point.x, rayhit.point.y, 6, ShapeDrawer.color_blue);
			ShapeDrawer.drawPoint(rayhit.pointOut.x, rayhit.pointOut.y, 6, ShapeDrawer.color_pink);
			ShapeDrawer.drawPoint(rayhit.collider.position.x, rayhit.collider.position.y, 3, ShapeDrawer.color_yellow);
		}

		if(hit != null){
			ShapeDrawer.drawPoint(hit.position.x, hit.position.y, 3, ShapeDrawer.color_yellow);
		}

		if(hits != null){
			for (h in hits) {
				ShapeDrawer.drawPoint(h.position.x, h.position.y, 3, ShapeDrawer.color_yellow);
			}
		}
		// ShapeDrawer.drawLine(new Vector(256, 256), new Vector(512, 512), ShapeDrawer.color_white);
		// ShapeDrawer.drawBox_MinMax(_start, _end, ShapeDrawer.color_white);
		// ShapeDrawer.drawCircle(_start, _size.x, ShapeDrawer.color_white);


		ShapeDrawer.drawRay(_origin, _dir, distance, ShapeDrawer.color_white);
		// ShapeDrawer.drawBox(_origin, _size, ShapeDrawer.color_white);
		// ShapeDrawer.drawLine(_origin, _end, ShapeDrawer.color_white);


		// Physics.draw();
	}

}
