
import 'dart:core';



class Stage{
  
  List<List<int>> stage;
  int rows;
  int columns;
  
  Stage(int rows, int columns) : this.stage = new List<List<int>>(rows){
    this.rows = rows;
    this.columns = columns;
    for(int i = 0; i < rows; ++i){
      this.stage[i] = new List(columns);
      for(int j = 0; j < columns; ++j){
        this.stage[i][j] = 0;
      }
    }
  }
  
  
  static Stage fromString(String stage){
    List<String> lines = stage.split('\n');
    Stage s = new Stage(lines.length, lines[0].length);
    print(s.rows);
    print(s.columns);
    
    for(int i = 0; i < lines.length; ++i){
      for(int k = 0; k < lines[i].length;++k){
        s.set(i, k,int.parse(lines[i][k]));
      }
      
    }

    
    return s;
  }
  
  
  
  int get(int i,int j){
    return stage[i][j];
  }
  
  void set(int i, int j, int value){
    this.stage[i][j] = value;
  }
  
  
  
  void printMatrix(){
    for(int i = 0; i < rows; ++i){
      for(int j = 0; j < columns; j++){
        print(stage[i][j]);
      }
      print(i);
    }
  }
  
  
}



void main(){
}
