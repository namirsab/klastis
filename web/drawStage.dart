

import 'package:box2d/box2d_browser.dart';
import 'dart:core';
import 'demo.dart';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';
import 'stage.dart';


class DrawStage extends Demo{
  
  /** The side of the squares forming the arena. */
  static const num WALL_SQUARE_SIDE = 1.0;      
  /** Radius of the active ball. */
  static const num ACTIVE_BALL_RADIUS = 1.0;
  static Stage stage = null;
  DrawStage() : super('Klastis!');
  
  
  
  static void main(){
    DrawStage drawer = new DrawStage();
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
    
//    WALL_RECT_WIDTH = Demo.CANVAS_WIDTH / Demo.VIEWPORT_SCALE / 2 / stage.rows;
//    print(WALL_RECT_WIDTH);
    
    
    //Generamos el stage
    
    
    
    
    
  }
  
  void draw(Stage stage){
    num LEFT_SIDE = -(Demo.CANVAS_WIDTH/2 / 10)+WALL_SQUARE_SIDE;
    num TOP_SIDE = (Demo.CANVAS_HEIGHT/2 / 10)-WALL_SQUARE_SIDE;
    
    // Create the wall squares
    final PolygonShape squareExteriorShape = new PolygonShape();
    squareExteriorShape.setAsBox
    (WALL_SQUARE_SIDE.toDouble(), WALL_SQUARE_SIDE.toDouble());
    // Create fixture for the wall squares
    final FixtureDef squareFixtureDef = new FixtureDef();
    squareFixtureDef.shape = squareExteriorShape;
    squareFixtureDef.friction = 0.9;
    squareFixtureDef.restitution = 1.0;
    
    // Create a body def
    final BodyDef squareBodyDef = new BodyDef();
    
    // Create the bouncing egg
    final bouncingEgg = new CircleShape();
    bouncingEgg.radius = ACTIVE_BALL_RADIUS;
    // Create fixture for that egg shape.
    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.restitution = 1.0;
    activeFixtureDef.density = 0.5;
    activeFixtureDef.shape = bouncingEgg;
    // Create the active ball body.
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    
    //Create MouseJoint
    JointDef mouseJointdef = new JointDef();
    
    mouseJointdef.type = JointType.MOUSE;
    
    
    
    
    
    
    
    for(int i = 0; i < stage.rows; ++i){
      for(int j = 0; j < stage.columns; ++j){
        if(stage.get(i, j) == 1){
          squareBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));// ,TOP_SIDE-(WALL_SQUARE_SIDE*2.01*j));
          Body squareBody = world.createBody(squareBodyDef);
          bodies.add(squareBody);
          mouseJointdef.bodyA = squareBody;
          squareBody.createFixture(squareFixtureDef);
        } else if(stage.get(i, j) == 2) {
          activeBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));
          final activeBody = world.createBody(activeBodyDef);
          bodies.add(activeBody);
          activeBody.createFixture(activeFixtureDef);
          mouseJointdef.bodyB = activeBody;
        } else if(stage.get(i, j) == 3) {
          squareBodyDef.position = new Vector2(LEFT_SIDE + (WALL_SQUARE_SIDE*2.0*j),TOP_SIDE-(WALL_SQUARE_SIDE*2.0*i));// ,TOP_SIDE-(WALL_SQUARE_SIDE*2.01*j));
          Body squareBody = world.createBody(squareBodyDef);
          bodies.add(squareBody);
          squareBody.createFixture(squareFixtureDef);
        }
      }
    }
  }
  
}


void mouseDown(Event e){
  MouseEvent me = (e as MouseEvent);
  var x = me.page.x;
  var y = me.page.y;
  
}



void main(){
  DrawStage.main();
}