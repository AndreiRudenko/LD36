package states;

import luxe.Vector;
import luxe.Input;
import luxe.Color;

import physics.collision.data.RaycastHit;
import physics.math.Vector2;
import physics.Space;
import physics.Body;
import physics.joints.DistanceJoint;
import physics.joints.RopeJoint;
import utils.ShapeDrawer;

class Test extends luxe.States.State {
    var b1:Body;
    var b2:Body;
    // var j:RopeJoint;

    var ground:Body;
    var roof:Body;
    var rwall:Body;
    var lwall:Body;
    var block:Body;

    var lineStart:Vector2;
    var lineEnd:Vector2;

    var boxMin:Vector2;
    var boxMax:Vector2;

    var pointPos:Vector2;

    var circlePos:Vector2;
    var circleRad:Float = 128;

    var bodies:Array<Body>;

    override function onenter<T>(_:T) {
        Luxe.physics.add_engine( Physics );
        Physics.space.gravity.y = 0;


        lineStart = new Vector2(100,100);
        lineEnd = new Vector2(200,200);

        boxMin = new Vector2(100,100);
        boxMax = new Vector2(200,200);

        pointPos = new Vector2(200,200);

        circlePos = new Vector2(200,200);



        bodies = [];

        b1 = new Body();
        b1.position.x = 1000;
        b1.position.y = 300;
        // b1.damping = 1;
        b1.damping = 0.9;
        // b1.restitution = 1.2;
        b1.half.x = 32;
        b1.half.y = 32; // 21 // 26
        b1.isBullet = true;
        b1.space = Physics.space;

        b2 = new Body();
        b2.position.x = 500;
        b2.position.y = 300;
        b2.damping = 0.9;
        // b2.restitution = 1.2;
        b2.half.x = 32;
        b2.half.y = 32;
        b2.isBullet = true;
        // b2.isStatic = true;
        b2.space = Physics.space;

        // j = new RopeJoint();
        // j.bodyA = b1;
        // j.bodyB = b2;
        // j.recalcLength();
        // j.length = 64;
        // j.frequency = 1;
        // j.dampingRatio = 0.5;

        // j.localAnchorA.x = 10;

        // Physics.space.addJoint(j);



        ground = new Body();
        ground.isStatic = true;
        ground.position.x = Luxe.screen.mid.x;
        ground.position.y = Luxe.screen.h - 32;
        ground.half.x = Luxe.screen.mid.x;
        ground.half.y = 32;
        ground.isBullet = true;
        ground.space = Physics.space;

        roof = new Body();
        roof.isStatic = true;
        roof.position.x = Luxe.screen.mid.x;
        roof.position.y = 32;
        roof.half.x = Luxe.screen.mid.x;
        roof.half.y = 32;
        roof.isBullet = true;
        roof.space = Physics.space;

        lwall = new Body();
        lwall.isStatic = true;
        lwall.position.x = 32;
        lwall.position.y = Luxe.screen.mid.y;
        lwall.half.x = 32;
        lwall.half.y = Luxe.screen.mid.y;
        lwall.isBullet = true;
        lwall.space = Physics.space;

        rwall = new Body();
        rwall.isStatic = true;
        rwall.position.x = Luxe.screen.w - 32;
        rwall.position.y = Luxe.screen.mid.y;
        rwall.half.x = 32;
        rwall.half.y = Luxe.screen.mid.y;
        rwall.isBullet = true;
        rwall.space = Physics.space;


        // block = new Body();
        // block.isStatic = true;
        // block.position.x = Luxe.screen.mid.x;
        // block.position.y = 400;
        // block.half.x = 128;
        // block.half.y = 32;
        // block.isBullet = true;
        // block.space = Physics.space;

        ground.draw(false);
        roof.draw(false);
        lwall.draw(false);
        rwall.draw(false);
        // block.draw(false);


        // addBody(new Vector2(500, 300), new Vector2(16,16), 0);

        // addStack(new Vector2(600, 500), new Vector2(16,16), 2);


        // addStairs(new Vector2(300, 680), new Vector2(64,8), 12);
        // addStack(new Vector2(200, 600), new Vector2(16,16), 16);
        // addStack(new Vector2(300, 600), new Vector2(16,16), 16);
        // addStack(new Vector2(400, 600), new Vector2(16,16), 16);
        // addStack(new Vector2(500, 600), new Vector2(16,16), 16);
        // addStack(new Vector2(600, 600), new Vector2(16,16), 16);
        // addStack(new Vector2(700, 500), new Vector2(16,16), 10);
        // addStack(new Vector2(800, 500), new Vector2(16,16), 10);
        // addStack(new Vector2(900, 500), new Vector2(16,16), 10);

   /*     addStack(new Vector2(250, 500), new Vector2(16,16), 10);
        addStack(new Vector2(350, 500), new Vector2(16,16), 10);
        addStack(new Vector2(450, 500), new Vector2(16,16), 10);
        addStack(new Vector2(550, 500), new Vector2(16,16), 10);
        addStack(new Vector2(650, 500), new Vector2(16,16), 10);
        addStack(new Vector2(750, 500), new Vector2(16,16), 10);
        addStack(new Vector2(850, 500), new Vector2(16,16), 10);
        addStack(new Vector2(950, 500), new Vector2(16,16), 10);*/
    }

    function addStack(_pos:Vector2, _half:Vector2, num:Int, _mass:Float = 1) {
        
        for (i in 0...num) {
            _pos.y = _pos.y - _half.y * 2.1;
            addBody(_pos, _half, _mass);
        }
    }

    function addStairs(_pos:Vector2, _half:Vector2, num:Int) {
        for (i in 0...num) {
            addStairBody(_pos, _half);
            _pos.y = _pos.y - _half.y;
            _pos.x = _pos.x + _half.x * 0.5;
        }
    }

    function addBody(_pos:Vector2, _half:Vector2, _mass:Float = 1) {
        var b:Body = new Body();
        b.position = _pos.clone();
        b.half = _half.clone();
        b.mass = Std.random(5) * 0.1 + 0.5;
        // b.mass = _mass;
        // b.isBullet = true;
        // b.isStatic = true;
        b.space = Physics.space;
        bodies.push(b);
    }

    function addStairBody(_pos:Vector2, _half:Vector2) {
        var b:Body = new Body();
        b.position = _pos.clone();
        b.half = _half.clone();
        b.isStatic = true;
        b.isBullet = true;
        b.space = Physics.space;
        bodies.push(b);
    }

    function addRandomBody():Void {
        var rX:Float = Std.random(1000) + 120;
        var rY:Float = Std.random(500) + 120;
        addBody(new Vector2(rX, rY), new Vector2(16,16));
    }

    function removeRandomBody() {
        var b:Int = Std.random(bodies.length);
        bodies[b].destroy();
        bodies.splice(b, 1);
    }

    override function onleave<T>(_:T) {
        // b1.destroy();
        // b1 = null;
        // ground.destroy();
        // ground = null;
    } //onleave

    override function onkeyup( e:KeyEvent ) {
        // if(e.keycode == Key.escape) {
        //     Luxe.shutdown();
        // }
        if(e.keycode == Key.space) {
            for (i in 0...10) {
                addRandomBody();  
            }
        }

        if(e.keycode == Key.key_x) {
            removeRandomBody();  
        }

        if(e.keycode == Key.key_c) {
            Main._usePause = !Main._usePause;
        }
        if(e.keycode == Key.key_v) {
            Luxe.physics.engines[0].paused = false;
        }

        if(e.keycode == Key.key_e) {
            Luxe.physics.engines[0].paused = !Luxe.physics.engines[0].paused;
        }
        // if(e.keycode == Key.key_v) {
        //     var b:Body = Physics.space.bodyList;
        //     while(b != null) {
        //         b.marked = false;
        //         b = b.next;
        //     }
        // }
    }

    var _speed:Float = 50;

    override function onmousemove(e:MouseEvent) {

        // box1.position.x = e.pos.x;
        // box1.position.y = e.pos.y;

        // lineEnd.x = e.pos.x;
        // lineEnd.y = e.pos.y;

        // boxMax.x = e.pos.x;
        // boxMax.y = e.pos.y;

        // circlePos.x = e.pos.x;
        // circlePos.y = e.pos.y;

        // pointPos.x = e.pos.x;
        // pointPos.y = e.pos.y;

        // b1.addVelocity(-(b1.position.x - e.pos.x)*0.1, -(b1.position.y - e.pos.y)*0.1);

    } //onmousemove

    override function update(dt:Float) {


        if(Luxe.input.keydown(Key.key_w)) {
            b1.addVelocity(0, -_speed);
        }
        if(Luxe.input.keydown(Key.key_s)) {
            b1.addVelocity(0, _speed);
        }
        if(Luxe.input.keydown(Key.key_a)) {
            b1.addVelocity(-_speed, 0);
        }
        if(Luxe.input.keydown(Key.key_d)) {
            b1.addVelocity(_speed, 0);
        }

        if(Luxe.input.keydown(Key.key_t)) {
            b1.addVelocity(0, -5000);
        }
        if(Luxe.input.keydown(Key.key_g)) {
            b1.addVelocity(0, 5000);
        }
        if(Luxe.input.keydown(Key.key_f)) {
            b1.addVelocity(-5000, 0);
        }
        if(Luxe.input.keydown(Key.key_h)) {
            b1.addVelocity(5000, 0);
        }


        if(Luxe.input.keydown(Key.up)) {
            b2.addVelocity(0, -_speed);
        }
        if(Luxe.input.keydown(Key.down)) {
            b2.addVelocity(0, _speed);
        }
        if(Luxe.input.keydown(Key.left)) {
            b2.addVelocity(-_speed, 0);
        }
        if(Luxe.input.keydown(Key.right)) {
            b2.addVelocity(_speed, 0);
        }

    }

    override function onrender() {

        b1.draw();
        b2.draw();
        // j.draw();

        for (b in bodies) {
            b.draw();
        }

        ShapeDrawer.drawText(50, 20, "bodies : " + Physics.space.bodyCount);
        ShapeDrawer.drawText(50, 40, "contacts : " + Physics.space.contactCount);
        // ShapeDrawer.drawText(50, 60, "b1.restitution : " + b1.restitution);
        // ShapeDrawer.drawText(50, 60, "islands : " + Physics.space.islandsCount);
        // ShapeDrawer.drawText(50, 60, "velocityIterations : " + Physics.space.velocityIterations);
        // ShapeDrawer.drawText(50, 80, "positionIterations : " + Physics.space.positionIterations);
    }

}
