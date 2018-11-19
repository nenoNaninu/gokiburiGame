class Inputter{
  boolean[] keyState; // 配列の準備
    Inputter(){
        keyState = new boolean[127];
        for(int i= 0; i<127; i++){
            keyState[i] = false;
        }
    }
  
    public boolean getKeyState(int code){
        if(key >0 && key<127){
            return keyState[code];
        }else{
            return false;
        }
    }
}

void keyPressed(){  
    if(key>0 && key<127){
      inputter.keyState[key] = true;
    }
}

void keyReleased(){
    inputter.keyState[key] = false;
}