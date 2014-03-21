library unitConverter;
import 'dart:core';
import 'package:box2d/box2d_browser.dart';


class UnitConverter{
  
  
  num _scale;
  num _width ;
  num _height;
  
  UnitConverter(num scale, num width, num height) : 
    this._scale = scale, this._width = width, this._height = height;
  
  Vector2 toPixels(Vector2 meterPoint){
    
    num x = meterPoint.x * _scale + _width/2.0;
    num y = -(meterPoint.y * _scale) + _height/2.0;
    
    return new Vector2(x,y);
  }
  
  Vector2 toMeters(Vector2 pixelPoint){
    
    num x = (pixelPoint.x - _width/2.0) / _scale;
    num y = ((_height/2.0) - pixelPoint.y) / _scale;
    return new Vector2(x,y);
  }
  
}


