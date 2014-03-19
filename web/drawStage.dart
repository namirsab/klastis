

import 'package:box2d/box2d_browser.dart';
import 'dart:core';
import 'demo.dart';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';
import 'stage.dart';


class DrawStage extends Demo{
  
  /** The side of the squares forming the arena. */
  
  var WALL_RECT_WIDTH = 1;
  static Stage stage = null;
  DrawStage() : super('DrawStage');
  
  
  
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
    num LEFT_SIDE = -(Demo.CANVAS_WIDTH/2 / 10)+WALL_RECT_WIDTH;
    num TOP_SIDE = (Demo.CANVAS_HEIGHT/2 / 10)-WALL_RECT_WIDTH;
    final PolygonShape squareExteriorShape = new PolygonShape();
    squareExteriorShape.setAsBox
    (WALL_RECT_WIDTH.toDouble(), WALL_RECT_WIDTH.toDouble());
    
    final FixtureDef squareFixtureDef = new FixtureDef();
    squareFixtureDef.shape = squareExteriorShape;
    squareFixtureDef.friction = 0.9;
    squareFixtureDef.restitution = 1.0;
    
    // Create a body def.
    final BodyDef squareBodyDef = new BodyDef();
    
    for(int i = 0; i < stage.rows; ++i){
      for(int j = 0; j < stage.columns; ++j){
        if(stage.get(i, j) == 1){
          squareBodyDef.position = new Vector2(LEFT_SIDE + (WALL_RECT_WIDTH*2.0*j),TOP_SIDE-(WALL_RECT_WIDTH*2.0*i));// ,TOP_SIDE-(WALL_SQUARE_SIDE*2.01*j));
          Body squareBody = world.createBody(squareBodyDef);
          bodies.add(squareBody);
          squareBody.createFixture(squareFixtureDef);
        }
      }
    }
  }
  
}


void main(){
  DrawStage.main();
}