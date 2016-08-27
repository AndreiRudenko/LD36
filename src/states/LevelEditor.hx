package states;

import luxe.States;
import luxe.Vector;
import luxe.Input;
import luxe.Color;
import luxe.Scene;
import luxe.Visual;

import utils.ShapeDrawer;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.Convert;
import mint.render.luxe.Label;
import mint.layout.margins.Margins;

import phoenix.geometry.RectangleGeometry;

import entities.BaseEntity;

import leveleditor.Level;
import leveleditor.LObject;

import leveleditor.ui.EditorLayer;

import leveleditor.ui.LayerProps;
// import leveleditor.ui.TileProps;
// import leveleditor.ui.ObjectProps;

import leveleditor.ui.TilesPanel;
import leveleditor.ui.ObjectsPanel;
import leveleditor.ui.LayersPanel;

import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;

import haxe.Json;

import dialogs.Dialogs;

class LevelEditor extends State {

	public var objectsWindow: mint.Window;
	public var propsWindow: mint.Window;
	public var layersWindow: mint.Window;

	public var layersPanel: LayersPanel;
	public var objectsPanel: ObjectsPanel;
	public var tilesPanel: TilesPanel;

	public var layerProps: LayerProps;
	// public var tileProps: TileProps;
	// public var objectProps: ObjectProps;

	public var lastProps: Control;

	// public var objectOptions:ObjectOptions;

	public var tilesRectangle:mint.Panel;
	public var selectedtilesRectangle:mint.Panel;
	public var objectVisual:Visual;

	public var level:Level;
	public var selectedLayer:EditorLayer;

	public var objectToCreate:LObject;
	public var selectedObjects:Array<BaseEntity>;


	var lastStateScene:Scene;
	// var stateScene:Scene;

	var canvas: mint.Canvas;

	var mouseLeftPressed:Bool = false;
	var mouseRightPressed:Bool = false;
	var mouseMiddlePressed:Bool = false;

	var dragStartPos:Vector;
	var dragPos:Vector;
	var clickPos:Vector;
	var mousePos:Vector;

	var modCtrl:Bool = false;
	var modAlt:Bool = false;

	public function new() {
		super({ name: 'LevelEditor' });
		// stateScene = new Scene('LevelEditor');
	}

	override function onenter<T>(_:T) {
		Main.playScene.active = false;

		dragStartPos = new Vector();
		dragPos = new Vector();
		clickPos = new Vector();
		mousePos = new Vector();
		// selectedObjects = [];

		lastStateScene = Luxe.scene;
		Luxe.scene = Main.levelEditorScene;

		// Physics.init();

		Luxe.renderer.clear_color = new Color( 0.38, 0.38, 0.38);

		level = new Level( new Vector(), new Vector(1920, 1080), this );
		// mint
		canvas = Main.canvas;

		create_helpers();
		create_layers_window();
		create_props_window();
		create_objects_window();

		layersPanel.addLayer();

	}

	override function onleave<T>(_:T) {
		Luxe.scene.empty();
		Luxe.scene = lastStateScene;

		level.destroy();
		// Physics.destroy();

		lastProps = null;
		objectToCreate = null;

		canvas.destroy_children();

		Main.playScene.active = true;
	}

	override public function onreset() {
		Luxe.scene.reset();
	}

	override function onkeydown( e:luxe.Input.KeyEvent ) {

		modCtrl = e.mod.ctrl;
		modAlt = e.mod.alt;

	}

	override function onkeyup( e:luxe.Input.KeyEvent ) {

		modCtrl = e.mod.ctrl;
		modAlt = e.mod.alt;

		if (e.keycode == Key.key_s && e.mod.ctrl) {
			saveLevel();
		}

		if (e.keycode == Key.key_o && e.mod.ctrl) {
			loadLevel();
		}

	}

	function saveLevel():Void {
		// var path = Luxe.core.app.io.module.app_path() + "assets\\levels\\" + level.name + ".json";
		var path:String = Dialogs.save('Save level', { ext:'json', desc:'json level' });
		if(path == '') return;
		trace("save level: " + path);

		if(!StringTools.endsWith(path, ".json")) path += ".json";
		

		var output = File.write(path);

		//get data & write it
		var saveJson = level.toJson();

		// var saveStr = Json.stringify(saveJson);
		var saveStr = Json.stringify(saveJson, null, "	");
		output.writeString(saveStr);


		// var saveStr = Json.stringify(saveJson);
		// var b = haxe.io.Bytes.ofString(saveStr);
		// var enc = haxe.crypto.Base64.encode(b);
		// output.writeString(enc);

		//close file
		output.close();
	}


	function loadLevel():Void {
		// var path = Luxe.core.app.io.module.app_path() + "assets\\levels\\" + level.name + ".json";
		var path:String = Dialogs.open('Open level', [{ ext:'json', desc:'json level' }]);
		if(path == '') return;
		trace("load level: " + path);

		var fileStr = File.getContent(path);

		var json:LevelData = Json.parse(fileStr);

		// trace(fileStr);
		// trace(json);
		// trace(Reflect.fields(json.layers));
        // trace(Reflect.hasField(json, "layers"));
        // var _layers:Array<Dynamic> = Reflect.field(json, "layers");
        // trace(Reflect.field(json, "layers"));
		// trace(Reflect.fields(_layers));
		// trace(json.layers);

		if (json.type == "level") { 
			// Main.playScene.empty();
			// level.empty();
			level.destroy();
			// layersPanel.empty();
			level = Level.FromJson(json, this);

		}



/*
		if(!StringTools.endsWith(path, ".json")) path += ".json";
		

		var output = File.write(path);

		//get data & write it
		var saveJson = level.toJson();

		// var saveStr = Json.stringify(saveJson);
		var saveStr = Json.stringify(saveJson, null, "	");
		output.writeString(saveStr);


		// var saveStr = Json.stringify(saveJson);
		// var b = haxe.io.Bytes.ofString(saveStr);
		// var enc = haxe.crypto.Base64.encode(b);
		// output.writeString(enc);

		//close file
		output.close();*/
	}




	override function onmousemove(e:luxe.Input.MouseEvent) {

		mousePos = Luxe.camera.screen_point_to_world( e.pos );

		if(canvas.marked != null) return;

		if(mouseMiddlePressed){

			var diffx:Float = (e.pos.x - dragStartPos.x) / Luxe.camera.zoom;
			var diffy:Float = (e.pos.y - dragStartPos.y) / Luxe.camera.zoom;

			Luxe.camera.pos.set_xy(dragPos.x - diffx, dragPos.y - diffy);
		}
	} //onmousemove

	override function onmousewheel( e:luxe.Input.MouseEvent ) {

		if(canvas.marked != null){
			return;
		}

		if(e.y > 0) {
			Luxe.camera.zoom += 0.1;
		} else if(e.y < 0) {
			Luxe.camera.zoom -= 0.1;
		}

	} //onmousewheel

	override function onmouseup(e:luxe.Input.MouseEvent) {

		if(mouseLeftPressed){

			if(objectToCreate != null){
				if(modCtrl){

				} else if(modAlt){

				} else {
					if(selectedLayer != null && selectedLayer.visible){
						if(selectedLayer.layerType == Layer.TILE_LAYER){
							level.addTiles(clickPos, mousePos, selectedLayer.layer, objectToCreate);
						} else if(selectedLayer.layerType == Layer.OBJECT_LAYER){
							level.addObject(mousePos, selectedLayer.layer, objectToCreate);
						}
					}


				}
			}
		} else if(mouseRightPressed){
			if(selectedLayer != null && selectedLayer.visible){
				level.removeObjects(clickPos, mousePos, selectedLayer.layer);
			}
		}

		mouseLeftPressed = false;
		mouseRightPressed = false;
		mouseMiddlePressed = false;
	}

	override function onmousedown(e:luxe.Input.MouseEvent) {
		clickPos = Luxe.camera.screen_point_to_world( e.pos );

		if(canvas.marked != null) return;

		if(e.button == luxe.Input.MouseButton.left){
			mouseLeftPressed = true;
		}

		if(e.button == luxe.Input.MouseButton.right){
			mouseRightPressed = true;
		}

		if(e.button == luxe.Input.MouseButton.middle){
			mouseMiddlePressed = true;
			dragStartPos.copy_from(e.pos);
			dragPos.copy_from(Luxe.camera.pos);
		}

	}

	override function update(dt:Float) {}

	override function onrender() {


		var l:EditorLayer = selectedLayer;

		if(mouseLeftPressed){

			if(modCtrl){

			} else if(modAlt){

			} else{
				if(l != null && l.visible && l.layerType == Layer.TILE_LAYER){
					level.showBoxes(clickPos, mousePos);
					ShapeDrawer.drawBox_MinMax(clickPos, mousePos, ShapeDrawer.color_gray_05, true);
				}
			}

			if(l != null && l.visible && l.layerType == Layer.OBJECT_LAYER) objectVisual.pos.copy_from(l.layer.getObjectPos(mousePos));

		} else if(mouseRightPressed){

			objectVisual.visible = false;

			if(l != null && l.visible){

				if(l.layerType == Layer.TILE_LAYER){
					level.showBoxes(clickPos, mousePos);
				}

				ShapeDrawer.drawBox_MinMax(clickPos, mousePos, ShapeDrawer.color_gray_05, true);
			}

		} else {
			if(l != null && l.visible){
				if(l.layerType == Layer.OBJECT_LAYER){
					if(objectVisual.texture != null) objectVisual.visible = true;

					objectVisual.pos.copy_from(l.layer.getObjectPos(mousePos));
					// objectVisual.pos.copy_from(mousePos);
				} else {
					if(canvas.marked == null) level.showBox(mousePos);
				}
			}
		}

		Physics.draw();

	}

	function playLevel() {

	}

	function create_helpers() {
		tilesRectangle = new mint.Panel({
			parent: canvas,
			name: 'onmark tile',
			x: 0,
			y: 0,
			w: 64,
			h: 64,
			// path: 'assets/tiles/tile_02.png'
			options:{ color: new Color(0.5,0.5,1, 0.2) }
		});
		tilesRectangle.visible = false;

		selectedtilesRectangle = new mint.Panel({
			parent: canvas,
			name: 'selected tile',
			x: 0,
			y: 0,
			w: 64,
			h: 64,
			// path: 'assets/tiles/tile_02.png'
			options:{ color: new Color(1,1,1, 0.2) }
		});
		selectedtilesRectangle.visible = false;

		objectVisual = new Visual({
			pos : new Vector(),
			size : new Vector(64, 64),
			origin : new Vector(32, 32),
			depth : Layers.TOP
			});
		objectVisual.visible = false;
	}


	function create_buttons() {

		new mint.Button({
			parent: canvas,
			name: 'button1',
			x: 128, y: 32, w: 32, h: 32,
			text: 'tiles',
			text_size: 14,
			options: { label: { color:new Color().rgb(0x9dca63) } },
			onclick: function(e,c) {
				trace('tiles button! ${Luxe.time}' );
			}
		});
	}


	function create_layers_window() {

		layersWindow = new mint.Window({
			parent: canvas,
			name: 'layers window',
			title: 'layers',
			options: {
				color:new Color().rgb(0x121212),
				color_titlebar:new Color().rgb(0x191919),
				label: { color:new Color().rgb(0x06b4fb) },
				close_handle: { color:new Color().rgb(0x06b4fb) },
			},
			// x:Luxe.screen.width - 302, y:320, w:302, h: 256,
			x:Luxe.screen.width - 302, y:320 + 200, w: 302, h: 200,
			// w_min: 314, w_max: 314, h_min:314,
			resizable: false,
			moveable: false,
			closable: false,
			collapsible:false
		});

		layersPanel = new LayersPanel(this, layersWindow);

	}

	function create_props_window() {

		propsWindow = new mint.Window({
			parent: canvas,
			name: 'properties window',
			title: 'properties',
			options: {
				color:new Color().rgb(0x121212),
				color_titlebar:new Color().rgb(0x191919),
				label: { color:new Color().rgb(0x06b4fb) },
				close_handle: { color:new Color().rgb(0x06b4fb) },
			},
			x:Luxe.screen.width - 302, y:320, w:302, h: 200,
			// w_min: 314, w_max: 314, h_min:314,
			resizable: false,
			moveable: false,
			closable: false,
			collapsible:false
		});

		layerProps = new LayerProps(this, propsWindow);
		// tileProps = new TileProps(this, propsWindow);
		// tileProps.visible = false;
		// objectProps = new ObjectProps(this, propsWindow);
		// objectProps.visible = false;
	}

	function create_objects_window() {

		objectsWindow = new mint.Window({
			parent: canvas,
			name: 'tiles window',
			title: 'tiles',
			options: {
				color:new Color().rgb(0x121212),
				color_titlebar:new Color().rgb(0x191919),
				label: { color:new Color().rgb(0x06b4fb) },
				close_handle: { color:new Color().rgb(0x06b4fb) },
			},
			x:Luxe.screen.width - 302, y:0, w:302, h: 320,
			// w_min: 314, w_max: 314, h_min:314,
			resizable: false,
			moveable: false,
			closable: false,
			collapsible:false
		});

		tilesPanel = new TilesPanel(this, objectsWindow);
		objectsPanel = new ObjectsPanel(this, objectsWindow);
		objectsPanel.visible = false;


	}


}
