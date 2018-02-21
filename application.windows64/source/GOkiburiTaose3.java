import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import ddf.minim.*; 
import ddf.minim.effects.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GOkiburiTaose3 extends PApplet {

/*********************
\u3053\u306e\u30d0\u30fc\u30b8\u30e7\u30f3\u306f\u30b4\u30ad\u30d6\u30ea\u304c\u591a\u6570\u51fa\u3066\u304f\u308b\u4ed5\u69d8\u3067\u3059
****************/





Inputter inputter;
Gokiburi[] theG;
Player player;
Bullet[] bullet;

float panAngle= 0;
float tilAngle= 0;
float angleValue=0;
PImage texture1;

boolean prevMouseState;

float playerPositionX;
float playerPositionY;
float playerPositionZ;

int bulletCounter = 0;
boolean mouseFlag = false;
float miliSecond;
int scene = 0;
PImage title;
PImage finish;

boolean allDeth;
int dethCounter=0;
PShape g;

Minim gKasaSoundSorce;
AudioPlayer gKasaSound;

Minim shootSoundSorce;
AudioSnippet shootSound;

Minim gutyaSoundSorce;
AudioSnippet gutyaSound;

int soundLoader;

int gokiburiSum = 30;
int gutyaCounter = 0;




//\u8ef8\u3092\u63cf\u753b\u3059\u308b\u305f\u3081\u306e\u95a2\u6570
public void renderXYZAxis(){
  pushMatrix();
    
    beginShape(LINES);
      vertex(-100.0f, 0.0f, 0.0f);
      vertex(2000.0f, 0.0f, 0.0f);
    endShape();
    
    beginShape(LINES);
      vertex(0.0f, -100.0f, 0.0f);
      vertex(0.0f, 2000.0f, 0.0f);
    endShape();
    
    beginShape(LINES);
      vertex(0.0f, 0.0f, -100.0f);
      vertex(0.0f, 0.0f, 2000.0f);
    endShape();
    
  popMatrix();  
}

public void camera2D(){
  camera( 0.0f, 0.0f, 1000.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f );              // ortho\u30ab\u30e1\u30e9\u3067\u306f\u30ab\u30e1\u30e9\u3092\u5bfe\u8c61\u7269\u306b\u63a5\u8fd1\u30fb\u96e2\u3057\u3066\u3082\u6620\u308b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u5927\u304d\u3055\u306f\u5909\u5316\u3057\u306a\u3044
  ortho( -width / 2, width / 2, -height / 2, height / 2, 10.0f, 5000.0f ); 
}

public void setup(){
  
  inputter = new Inputter();
  player = new Player();
  
  theG = new Gokiburi[gokiburiSum];
  
  //\u30b4\u30ad\u30d6\u30ea\u914d\u5217
  for(int i=0; i<gokiburiSum; i++){
    theG[i] = new Gokiburi();
    theG[i].exist = true;
  }
  
  //\u5f3e\u4e38\u306e\u914d\u5217
  bullet = new Bullet[200];
  for(int i =0; i<200; i++){
    bullet[i] = new Bullet();
  }
  
  texture1 = loadImage("Ground.png");
  textureMode(NORMAL);
  title = loadImage("Title.png");
  finish = loadImage("finish.png");
  
  for(int i = 0; i<gokiburiSum; i++){
    
    theG[i].positionX = 100*i;
    theG[i].positionY = -10;
    theG[i].positionZ = 10 + 50*i;
    theG[i].type = i % 2;
    
    theG[i].firstPositionX = theG[i].positionX;
    theG[i].firstPositionY = theG[i].positionY;
    theG[i].firstPositionZ = theG[i].positionZ;
    
    
  }
  
  g = loadShape("g.obj");
  
  gKasaSoundSorce = new Minim(this);
  gKasaSound = gKasaSoundSorce.loadFile("gokiKasa.mp3");
  
  shootSoundSorce = new Minim(this);
  shootSound = shootSoundSorce.loadSnippet("gun1.mp3");
  
  gutyaSoundSorce = new Minim(this);
  gutyaSound = gutyaSoundSorce.loadSnippet("gutya.mp3");
  
  
  
}

public void draw1(){
  background(160, 216, 239);
  //\u30d1\u30f3\u30c1\u30eb\u8a2d\u5b9a
  
  
  
  
  if(mouseX< width/2 +20&& mouseX>width/2 -20 &&mouseY<height/2+20 && mouseY >height/2 -20){
    mouseFlag = true;
  }
  
  
  if(mouseFlag){
    panAngle += (mouseX - pmouseX)/3.0f;
    tilAngle += (mouseY - pmouseY)/3.0f;
  }
  
  
  //\u30d7\u30ec\u30a4\u30e4\u30fc\u30dd\u30b8\u30b7\u30e7\u30f3\u3068\u30b7\u30e5\u30fc\u30c6\u30a3\u30f3\u30b0\u95a2\u4fc2
  playerPositionX = player.getPositionX();
  playerPositionY = player.getPositionY();
  playerPositionZ = player.getPositionZ();
  
  player.move(panAngle);
  player.view(panAngle, tilAngle);
  
  renderXYZAxis();
  
  if( !prevMouseState && mousePressed){
    bullet[bulletCounter].exist = true;
    bullet[bulletCounter].shoot(playerPositionX,playerPositionY,playerPositionZ , panAngle, tilAngle);
    shootSound.rewind();
    shootSound.play();
    bulletCounter++;
  }
  prevMouseState = mousePressed;
  
  //\u5f3e\u306e\u79fb\u52d5\u3068\u63cf\u753b
  for(int i=0; i<bulletCounter; i++){
    if(bullet[i].exist){
      bullet[i].move();
      bullet[i].render();
    }
  }
  
  
  //\u5730\u9762\u306e\u63cf\u753b
  pushMatrix();
  beginShape(QUADS);
  texture(texture1);
  //fill(84,77,203);
  vertex(0, 0, 0, 0, 0);
  vertex(1000, 0, 0, 1, 0);
  vertex(1000, 0, 1000, 1, 1);
  vertex(0, 0, 1000, 0, 1);
  endShape();
  popMatrix();
  
  
  //\u4ee5\u4e0b\u306e\u9818\u57df\u306b\u30b4\u30ad\u30d6\u30ea\u306b\u95a2\u3059\u308b\u60c5\u5831\u3092\u66f8\u304d\u9023\u306d\u308b
  //\u3042\u305f\u308a\u5224\u5b9a\u3082
  for(int i =0; i<gokiburiSum; i++){
    if(theG[i].exist){
      
      /*
      switch(theG[i].type){
        case 0:
          theG[i].moveX();
          break;
        case 1:
          theG[i].moveZ();
          break;
        
        case 2:
          theG[i].moveZ();
          break;
      }
      */
      
      
      
      for(int j = 0; j<bulletCounter; j++){
        float bPX = bullet[j].getBulletPositionX();
        float bPY = bullet[j].getBulletPositionY();
        float bPZ = bullet[j].getBulletPositionZ();
        if(bullet[j].exist){
          theG[i].hitted(bPX , bPY, bPZ);
          //\u30b0\u30c1\u30e3\u3063\u3068\u52b9\u679c\u97f3
          if(gutyaCounter == 70){
            gutyaSound.rewind();
            gutyaCounter = 0;
          }else{
            gutyaCounter++;
          }
          gutyaSound.play();
        }
        
        float gokiburiToBullet = theG[i].getDistanceToGokiburiToBullet();
        bullet[j].hitted(gokiburiToBullet);
        bullet[j].hitGround();
        
        
      }
      theG[i].setVecter(playerPositionX, playerPositionZ);
      theG[i].setTheta(playerPositionX, playerPositionZ);
      theG[i].move();
      if(theG[i].moveActive){
        if(soundLoader ==300){
          gKasaSound.rewind();
          soundLoader =0;
          
        }else{
          soundLoader++;
        }
        gKasaSound.play();
      }
      theG[i].render();
    }
  }
  
  //\u30b4\u30ad\u30d6\u30ea\u304c\u5168\u54e1\u6b7b\u3093\u3067\u3044\u308b\u3053\u3068\u3092\u78ba\u8a8d\u3059\u308b
  for(int i = 0; i<gokiburiSum; i++){
    if(!theG[i].exist){
      dethCounter++;
    }
  }
  
  
  //\u5168\u54e1\u6b7b\u3093\u3060\u30d5\u30e9\u30b0\u304c\u305f\u3063\u305f\u3089
  if(dethCounter ==gokiburiSum){
    scene = 2;
  }else{
    dethCounter = 0;
  }
  
  /*****************
  2D\u30ab\u30e1\u30e9\u3067\u63cf\u753b\u3059\u308b\u305e\uff5e
  ****************/
  
  camera2D();
  
  //\u3053\u3053\u3067\u30aa\u30fc\u30b9\u30ab\u30e1\u30e9\u3092\u8a2d\u5b9a\u3057\u3066\u30de\u30a6\u30b9\u306e\u4f4d\u7f6e\u3092\u63d0\u793a
  if(mouseFlag == false){
    pushMatrix();
    fill(255);
    //translate();
    box(40,40,40);
    popMatrix();
  }
  
  pushMatrix();
  translate(-width/2+100 , -height/2+20 ,-50);
  fill(255);
  box(300, 100, 20);
  popMatrix();
  
  miliSecond = millis();
  fill(0);
  textSize(36);
  text("time:"+miliSecond/1000,-width/2,-height/2+50,0 );
  
  beginShape(LINES);
  fill(20);
  vertex(width/10, height/10,0);
  vertex(-width/10, -height/10,0);
  endShape();
  
  
  beginShape(LINES);
  fill(20);
  vertex(width/10, -height/10,0);
  vertex(-width/10, height/10,0);
  endShape();
  
  
  
  
}

public void draw(){
  background(255);
  if(scene ==0){
    image(title, 0,0);
    if(keyPressed){
      scene =1;
    }
  }else if(scene ==1){
    draw1();
  }else if(scene == 2){
    image(finish,-width/2,-height/2);
    textSize(100);
    fill(255);
    text("Time:"+miliSecond/1000, 0, 0);
    
  }
  
  
}
class Bullet{
  boolean exist = false;
  float shootTimingPositionX;
  float shootTimingPositionY;
  float shootTimingPositionZ;
  float shootTimingTil;
  float shootTimingPan;
  float positionX;
  float positionY;
  float positionZ;
  float velocityX;
  float velocityY;
  float velocityZ;
  
  
  
  public void move(){
    if(exist){
      positionX += velocityX;
      positionY += velocityY;
      positionZ += velocityZ;
      
    }
    
  }
  
  //\u3044\u308d\u3044\u308d\u4f4d\u7f6e\u3092\u8fd4\u3059\u95a2\u6570
  public float getBulletPositionX(){
    return positionX;
  }
  
  public float getBulletPositionY(){
    return positionY;
  }
  
  public float getBulletPositionZ(){
    return positionZ;
  }
  
  public void render(){
    if(exist){
      pushMatrix();
      translate(positionX, positionY, positionZ);
      sphere(10);
      popMatrix(); 
    }
  }
  
  
  
  //\u30d7\u30ec\u30a4\u30e4\u30fc\u306e\u4f4d\u7f6e\u60c5\u5831\u3092\u53d6\u5f97
  //\u30d7\u30ec\u30a4\u30e4\u30fc\u306e\u5411\u3044\u3066\u308b\u30d9\u30af\u30c8\u30eb\u3092\u5f97\u308b
  //\u305d\u3053\u304b\u3089\u5f3e\u306e\u4f4d\u7f6e\u3092\u8a08\u7b97\u3057\u3066\u3044\u304f
  //\u7b2c\u4e00\u56e0\u6570\u304b\u3089\u9806\u306b\u3001\u30d7\u30ec\u30a4\u30e4\u30fc\u306eX,Y,Z,\u30d1\u30f3\u3001\u30c1\u30eb
  
  public void shoot(float pX, float pY, float pZ, float pan, float til){
    //if(mousePressed){
      //exist = true;
      shootTimingPositionX = pX;
      shootTimingPositionY = pY;
      shootTimingPositionZ = pZ;
      
      shootTimingTil =til;
      shootTimingPan = pan;
      
      positionX = pX;
      positionY = pY;
      positionZ = pZ;
      
      velocityX = 10*cos(radians(til))*cos(radians(pan));
      velocityY = 10*sin(radians(til));
      velocityZ = 10*cos(radians(til))*sin(radians(pan));
      
    //}
  }
  
  public void hitted(float distance){
    if(exist){
      if(distance<30){
        exist = false;
      }
    }
  }
  public void hitGround(){
    if(positionY >-5){
      exist = false;
    }
    
  }
  
  
}
class Gokiburi{
  Gokiburi(){
    randomX = random(-75,75);
    randomZ = random(-75,75);
    
  }
  float randomX, randomZ;
  boolean exist;
  int hitpoint;
  int velocityX = 5 , velocityY =5, velocityZ =5;
  float firstPositionX, firstPositionY, firstPositionZ;
  float positionX, positionY, positionZ;
  int type;
  float distance;
  float vecX;
  float vecZ;
  float theta;
  float tanTheta;
  boolean moveActive = false;
  
  /*
  positionX = firstPositionX;
  positionY = firstPositionY;
  positionZ = firstPositionZ;
  */
  
  //\u4ee5\u4e0b\u306ehitpoint\u95a2\u6570\u306f\u5f3e\u306e\u4f4d\u7f6e\u3092\u3082\u3089\u3063\u3066
  public void hitpoint(float BulletPositionX,float BulletPositionY, float BulletPositionZ){
    if(positionX ==BulletPositionX && positionY==BulletPositionY &&positionZ ==BulletPositionZ ){
      hitpoint -= 1;
    }
    
  }
  
  
  //\u79fb\u52d5\u3055\u305b\u308b\u3088.X\u65b9\u5411\u306b X=0
  /*
  void moveX(){
    if(positionX < firstPositionX +200){
      velocityX = +20;
    }else if(positionX > firstPositionX -200){
      velocityX = -20;
    }
    positionX += velocityX;
  }
  */
    
    /*
    if(positionX<firstPositionX+100){
      velocityX = 20;
    }else if(positionX>firstPositionX-100){
      velocityX = -20;
    }else if(){
      velocity
    }
    positionX += velocityX;
    */
  
  
  
  //Y\u8ef8\u5e73\u884c\u306b\u79fb\u52d5 Y =0;
  /*
  void moveY(){
    if(positionY==firstPositionY+100){
      velocityY = 20;
    }else if(positionY==firstPositionY-100){
      velocityY = -20;
    }
    positionY += velocityY;
  }
  */
  
  //Z\u8ef8\u5e73\u884c\u306b\u79fb\u52d5 Z =2;
  /*
  void moveZ(){
    if(positionZ>firstPositionZ+200){
      velocityX = -20;
    }else if(positionZ<firstPositionZ-200){
      velocityZ = +20;
    }
    positionZ += velocityZ;
  }
  
  */
  
  /***********
  \u547c\u3073\u51fa\u3059\u30bf\u30a4\u30df\u30f3\u30b0\u306f
  \u30d9\u30af\u30c8\u30eb\u2192\u56de\u8ee2\u2192\u79fb\u52d5\u2192\u8868\u793a
  ************/
  
  public void move(){
    positionX += vecX/75;
    positionZ += vecZ/75;
    if(vecX != 0 && vecZ != 0){
      moveActive = true;
    }else{
      moveActive = false;
    }
    
  }
  
  public void setVecter(float pX, float pZ){
    vecX = pX + randomX - positionX;
    vecZ = pZ + randomZ - positionZ;
  }
  
  public void setTheta(float pX, float pZ){
    tanTheta = vecX/vecZ;
    theta = atan(tanTheta) ;
    if(pZ<positionZ){
      theta += PI;
    }
  }
  
  
  //G\u306e\u8868\u793a\u3092\u3064\u304b\u3055\u3069\u308b.
  public void render(){
    pushMatrix();
    blendMode(MULTIPLY);
    translate(positionX +random(-1,1), positionY+random(-1,1), positionZ+random(-1,1));
    rotateY(theta);
    
    //box(10, 10, 50);
    scale(0.2f);
    shape(g);
    blendMode(BLEND);
    popMatrix();
  }
  
 
 //\u7b2c\u4e00\u56e0\u6570\u304b\u3089\u9806\u306b\u3042\u305f\u308a\u5224\u5b9a
 public void hitted(float bulletPositionX,float bulletPositionY , float bulletPositionZ){
   distance = sqrt(sq(positionX - bulletPositionX)+sq(positionY - bulletPositionY)+ sq(positionZ - bulletPositionZ));
   if(exist){
     if(distance <30){
       exist = false;
     }
   }
 }
 
 public float getDistanceToGokiburiToBullet(){
   return distance;
 }
 
}
class Inputter{
  boolean[] keyState; // \u914d\u5217\u306e\u6e96\u5099
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

public void keyPressed(){
  if(key>0 && key<127){
    inputter.keyState[key] = true;
  }
}

public void keyReleased(){
  inputter.keyState[key] = false;
}
class Player{
  float positionX= 300, positionY= -70, positionZ= 300;
  float panAngle;
  float tiltAngle;
  float directionX,directionY, directionZ;
  
  
  public float getPositionX(){
    return positionX;
  }
  
  public float getPositionZ(){
    return positionZ;
  }
  public float getPositionY(){
    return positionY;
  }
  
  
  //\u7e26\u304ctil\u6a2a\u304cpan
  public void move(float pan){
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
  
  public void view(float pan, float til){
    
    directionX=cos( radians(til) ) * cos(radians(pan));
    directionY= sin(radians(til));
    directionZ= cos( radians(til) ) * sin(radians(pan));
    camera(positionX, positionY, positionZ,
    directionX+positionX, directionY+positionY, directionZ+positionZ,
    0.0f, 1.0f, 0.0f);
    
    perspective(45.0f, (float)width/ (float)height,10.0f, 5000.0f );
    
  }
  
}
  public void settings() {  size(1980, 1080, OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GOkiburiTaose3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
