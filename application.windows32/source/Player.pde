class Player{
  float positionX= 300, positionY= -70, positionZ= 300;
  float panAngle;
  float tiltAngle;
  float directionX,directionY, directionZ;
  
  
  float getPositionX(){
    return positionX;
  }
  
  float getPositionZ(){
    return positionZ;
  }
  float getPositionY(){
    return positionY;
  }
  
  
  //縦がtil横がpan
  void move(float pan){
    if(inputter.getKeyState('w')){
      positionX += cos(radians(pan))*3;
      positionZ += sin(radians(pan))*3;
    }
    if(inputter.getKeyState('s')){
      positionX -= cos(radians(pan))*3;
      positionZ -= sin(radians(pan))*3;
    }
    if(inputter.getKeyState('d')){
      positionX += cos(radians(pan+90.0f))*3;
      positionZ += sin(radians(pan+90.0f))*3;
    }
    if(inputter.getKeyState('a')){
      positionX -= cos(radians(pan+90.0f))*3;
      positionZ -= sin(radians(pan+90.0f))*3;
    }
  }
  
  void view(float pan, float til){
    
    directionX=cos( radians(til) ) * cos(radians(pan));
    directionY= sin(radians(til));
    directionZ= cos( radians(til) ) * sin(radians(pan));
    camera(positionX, positionY, positionZ,
    directionX+positionX, directionY+positionY, directionZ+positionZ,
    0.0f, 1.0f, 0.0f);
    
    perspective(45.0, (float)width/ (float)height,10.0, 5000.0 );
    
  }
  
}