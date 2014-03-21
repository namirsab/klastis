

import 'package:box2d/box2d_browser.dart';
import 'dart:core';
import 'demoApp.dart';
import 'dart:html';
import 'dart:math' as Math;
import 'UnitConverter.dart';
import 'dart:async';
import 'stage.dart';


class KlastisGame extends DemoApplication implements QueryCallback,ContactListener{
  
  /** The side of the squares forming the arena. */
  static const num WALL_SQUARE_SIDE = 1.0;      
  /** Radius of the active ball. */
  static const num ACTIVE_BALL_RADIUS = 1.0;
  static Stage stage = null;
  ButtonElement goButton;
  Body airFix = null;
  bool overlay = false;
  Body selectedBody = null;
  Body egg;
  Vector2 realMousePos;
  num LEFT_SIDE;
  num TOP_SIDE;
  num i = 1;
  
  KlastisGame() : super('Klastis!');
  
  
  
  static void main(){
    KlastisGame drawer = new KlastisGame();
    drawer.initialize();
    drawer.initializeAnimation();
    drawer.runAnimation();
  }
  
  static Future fromFile(String filePath){
    return HttpRequest.getString(filePath).then(_parseStage);
  }
    
  static void _parseStage(String stageString){
    
    stage = Stage.fromString(stageString);
  }
 
 
  void initialize(){
    Future createStage = fromFile('map.txt');
    createStage.then((_){
      draw(stage);
          
    });
    
    goButton = querySelector('#play');
    goButton.onClick.listen(onClickGo);
//    WALL_RECT_WIDTH = Demo.CANVAS_WIDTH / Demo.VIEWPORT_SCALE / 2 / stage.rows;
//    print(WALL_RECT_WIDTH);
    
    
    //Generamos el stage
    
    window.onKeyDown.listen(onKeyDown);
    
    
    
  }
  
  void onKeyDown(Event e){
    KeyboardEvent  event = e as KeyboardEvent;
    if(event.keyCode == KeyCode.ENTER){
      selectedBody = null;
    }
  }
  
  
  void onClickGo(Event e){
    addBallAtIndex(3, 3);
  }
  
  void addBallAtIndex(int i, int j){
    LEFT_SIDE = -(DemoApplication.CANVAS_WIDTH/2 / 10)+WALL_SQUARE_SIDE;
    TOP_SIDE = (DemoApplication.CANVAS_HEIGHT/2 / 10)-WALL_SQUARE_SIDE;
    // Create the bouncing egg
   final bouncingEgg = new CircleShape();
   bouncingEgg.radius = ACTIVE_BALL_RADIUS;
   // Create fixture for that egg shape.
   final activeFixtureDef = new FixtureDef();
   activeFixtureDef.restitution = 0.4;
   activeFixtureDef.density = 0.5;
   activeFixtureDef.shape = bouncingEgg;
   // Create the active ball body.
   final activeBodyDef = new BodyDef();
   activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
   activeBodyDef.type = BodyType.DYNAMIC;
   activeBodyDef.allowSleep = false;
   activeBodyDef.bullet = true;
    
    activeBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
    final activeBody = world.createBody(activeBodyDef);
    activeBody.userData = 'pelotica';
    egg = activeBody;
    bodies.add(activeBody);
    activeBody.createFixture(activeFixtureDef);
  }
  
  
  void step(num timestamp){
    super.step(timestamp);
    if(overlay){
      
      if(airFix.linearVelocity.y <= 5.0){
        print(i);
        airFix.linearVelocity.add(new Vector2(-airFix.linearVelocity.x , 2.0));
        ++i;
      }else{
        airFix.linearVelocity = new Vector2(0.0, 3.0);
      }
    }
  }
  
  void draw(Stage stage){
    
    
    LEFT_SIDE = -(DemoApplication.CANVAS_WIDTH/2 / 10)+WALL_SQUARE_SIDE;
        TOP_SIDE = (DemoApplication.CANVAS_HEIGHT/2 / 10)-WALL_SQUARE_SIDE;
    
    // Create the wall squares
    final PolygonShape squareExteriorShape = new PolygonShape();
    squareExteriorShape.setAsBox
    (WALL_SQUARE_SIDE.toDouble(), WALL_SQUARE_SIDE.toDouble());
    // Create fixture for the wall squares
    final FixtureDef squareFixtureDef = new FixtureDef();
    squareFixtureDef.shape = squareExteriorShape;
    squareFixtureDef.friction = 0.9;
    squareFixtureDef.restitution = 0.0;
    
    // Create the wall squares body
    final BodyDef squareBodyDef = new BodyDef();
    squareBodyDef.type = BodyType.STATIC;
    
   
    
    //Create the L Canion
    final PolygonShape lCannon = new PolygonShape();
    lCannon.setAsBox
    (WALL_SQUARE_SIDE.toDouble() - 0.5, WALL_SQUARE_SIDE.toDouble());
    // Create fixture for the wall squares
    final FixtureDef lCannonFixture = new FixtureDef();
    lCannonFixture.shape = lCannon;
    lCannonFixture.friction = 0.9;
    lCannonFixture.restitution = 0.0;
    lCannonFixture.isSensor = true;
    
    final BodyDef lCannonBodyDef = new BodyDef();
    lCannonBodyDef.type = BodyType.KINEMATIC;
    
    
    final PolygonShape gravityChanger = new PolygonShape();
    gravityChanger.setAsBox
     (WALL_SQUARE_SIDE.toDouble() + 0.5, WALL_SQUARE_SIDE.toDouble() + 0.5);
     // Create fixture for the wall squares
     final FixtureDef gravityChangerFixture = new FixtureDef();
     gravityChangerFixture.shape = gravityChanger;
     gravityChangerFixture.friction = 0.9;
     gravityChangerFixture.restitution = 0.0;
     gravityChangerFixture.isSensor = true;
     
     final BodyDef gravityChangerBodyDef = new BodyDef();
     gravityChangerBodyDef.type = BodyType.KINEMATIC;
     
     final PolygonShape air = new PolygonShape();
     air.setAsBox
      (WALL_SQUARE_SIDE.toDouble(), WALL_SQUARE_SIDE.toDouble() + 6.0);
      // Create fixture for the wall squares
      final FixtureDef airFixture = new FixtureDef();
      airFixture.shape = air;
      airFixture.friction = 0.9;
      airFixture.restitution = 0.0;
      airFixture.isSensor = true;
      
      final BodyDef airBodyDef = new BodyDef();
      airBodyDef.type = BodyType.KINEMATIC;
    
    
    
    
    canvas.onMouseDown.listen(mouseDown);
    world.contactListener = this;
    
    
    
    
    
    
    
    for(int i = 0; i < stage.rows; ++i){
      for(int j = 0; j < stage.columns; ++j){
        if(stage.get(i, j) == 1){
          squareBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));// ,TOP_SIDE-(WALL_SQUARE_SIDE*2.01*j));
          Body squareBody = world.createBody(squareBodyDef);
          squareBody.userData = 'END';
          bodies.add(squareBody);
          squareBody.createFixture(squareFixtureDef);
        } else if(stage.get(i, j) == 2) {
          
        } else if(stage.get(i, j) == 3) {
          squareBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));// ,TOP_SIDE-(WALL_SQUARE_SIDE*2.01*j));
          Body squareBody = world.createBody(squareBodyDef);
          squareBody.userData = 'WIN';
          bodies.add(squareBody);
          squareBody.createFixture(squareFixtureDef);
        }else if(stage.get(i, j) == 4) {
          lCannonBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
          Body lCannonBody = world.createBody(lCannonBodyDef);
          lCannonBody.userData = 'TR';
          bodies.add(lCannonBody);
          lCannonBody.createFixture(lCannonFixture);
        }else if(stage.get(i, j) == 5){
          gravityChangerBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
          Body gravityChangerBody = world.createBody(gravityChangerBodyDef);
          gravityChangerBody.userData = 'GR_UP';
          bodies.add(gravityChangerBody);
          gravityChangerBody.createFixture(gravityChangerFixture);
        }else if(stage.get(i, j) == 6){
          gravityChangerBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
          Body gravityChangerBody = world.createBody(gravityChangerBodyDef);
          gravityChangerBody.userData = 'GR_DOWN';
          bodies.add(gravityChangerBody);
          gravityChangerBody.createFixture(gravityChangerFixture);
        }else if(stage.get(i, j) == 7){
          airBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
          Body airBody = world.createBody(airBodyDef);
          airBody.userData = 'AIR_UP';
          bodies.add(airBody);
          airBody.createFixture(airFixture);
        }
      }
    }
    print(bodies.length);
  }
  
  
  bool reportFixture(Fixture fixture){
    Shape s = fixture.shape;
    if(fixture.body.type != BodyType.STATIC){
      var inside = s.testPoint(fixture.body.originTransform, realMousePos);     
      if(inside){
        selectedBody = fixture.body;
        return false;
      }
    }
    return true;
  }
  
  void mouseDown(Event e){
    UnitConverter converter = new UnitConverter(DemoApplication.VIEWPORT_SCALE.toDouble(), 
                                                DemoApplication.CANVAS_WIDTH.toDouble(), 
                                                DemoApplication.CANVAS_HEIGHT.toDouble());
    
    MouseEvent me = (e as MouseEvent);
    num x = me.page.x - canvas.offsetLeft.toDouble();
    num y = me.page.y - canvas.offsetTop.toDouble();
    print(x.toString()+','+y.toString());
    Vector2 realVector = converter.toMeters(new Vector2(x.toDouble(), y.toDouble()));
    realMousePos = realVector;
    print(realVector.x);
    print(realVector.y);
    
    if(selectedBody != null){
      print('hola');
      selectedBody.setTransform(realVector, Math.PI);
      selectedBody.linearVelocity = new Vector2(0.0, 0.0);
    }else{
      selectedBody = getBodyAtMouse(realMousePos);
      print('aaa');
    }
   
    
    
    
    
   
    
  }
  
  Body getBodyAtMouse(Vector2 position){
    selectedBody = null;
    
    AxisAlignedBox area = new AxisAlignedBox();
    area.upperBound.setValues(position.x -0.01, position.y - 0.01);
    area.lowerBound.setValues(position.x + 0.01, position.y + 0.01);
    

    world.queryAABB(this,area);
    return selectedBody;

    
  }
  
  void beginContact(Contact contact){
    
    print('hola');
    Fixture a = contact.fixtureA;
    Fixture b = contact.fixtureB;
    
    if(b.body.userData == 'pelotica'){
      String userData = a.body.userData;
      if(userData == 'TR'){
        b.body.applyLinearImpulse(new Vector2(1000.0,0.0), b.box.center);
      }else if(userData == 'END'){
        SpanElement text = new SpanElement();
        text.text = 'Loooooooser!';
        document.body.append(text);
        b.body.type = BodyType.STATIC;
      }else if(userData == 'WIN'){
        SpanElement text = new SpanElement();
        text.text = 'You WIN!!';
        document.body.append(text);
        b.body.type = BodyType.STATIC;
      }else if(userData.contains('GR')){
        String direction = userData.split('_').last;
        if(direction == 'UP'){
          b.body.linearVelocity = new Vector2(0.0,0.0);
          b.body.applyLinearImpulse(new Vector2(0.0,45.0), b.box.center);
        }else{
          b.body.linearVelocity = new Vector2(0.0,0.0);
          
        }
      }else if(userData.contains('AIR')){
        String direction = userData.split('_').last;
        if(direction == 'UP'){
          overlay = true;
          airFix = b.body;
         
          
        }
      }
      
    }
    
    
  }
  
  void endContact(Contact contact){
    overlay = false;
  }
  
  void postSolve(Contact contact, ContactImpulse impulse){
    
  }
  
  void preSolve(Contact contact, Manifold oldManifold){
    
  }
  
  
}






void main(){
  KlastisGame.main();
}