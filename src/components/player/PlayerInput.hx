package components.player;

import luxe.Input;
import luxe.Component;
import components.input.InputComponent;


class PlayerInput extends InputComponent {


	public function new():Void {

		super();

	}

	override function init()  {

		Luxe.input.bind_key( entity.name + "_left",  Key.key_a );
		Luxe.input.bind_key( entity.name + "_right", Key.key_d );

		Luxe.input.bind_key( entity.name + "_left",  Key.left );
		Luxe.input.bind_key( entity.name + "_right", Key.right );

		Luxe.input.bind_key( entity.name + "_jump",  Key.space );
		Luxe.input.bind_key( entity.name + "_jump",  Key.key_z );
		Luxe.input.bind_key( entity.name + "_jump",  Key.up );
		Luxe.input.bind_key( entity.name + "_jump",  Key.key_w );

	}

	override function update(dt:Float) {

		updateKeys();

	}

	function updateKeys() {

		right = Luxe.input.inputdown( entity.name + "_right" );
		left = Luxe.input.inputdown( entity.name + "_left" );
		jump = Luxe.input.inputdown( entity.name + "_jump" );

		if(left && right){
			left = right = false;
		}

		if(up && down){
			up = down = false;
		} 

	}


}
