/*********************
このバージョンはゴキブリが多数出てくる仕様です
****************/

import processing.opengl.*;
import ddf.minim.*;
import ddf.minim.effects.*;

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




//軸を描画するための関数
void renderXYZAxis(){
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

void camera2D(){
  camera( 0.0f, 0.0f, 1000.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f );              // orthoカメラではカメラを対象物に接近・離しても映るオブジェクトの大きさは変化しない
  ortho( -width / 2, width / 2, -height / 2, height / 2, 10.0f, 5000.0f ); 
}

void setup(){
  size(1980, 1080, OPENGL);
  inputter = new Inputter();
  player = new Player();
  
  theG = new Gokiburi[gokiburiSum];
  
  //ゴキブリ配列
  for(int i=0; i<gokiburiSum; i++){
    theG[i] = new Gokiburi();
    theG[i].exist = true;
  }
  
  //弾丸の配列
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

void draw1(){
  background(160, 216, 239);
  //パンチル設定
  
  
  
  
  if(mouseX< width/2 +20&& mouseX>width/2 -20 &&mouseY<height/2+20 && mouseY >height/2 -20){
    mouseFlag = true;
  }
  
  
  if(mouseFlag){
    panAngle += (mouseX - pmouseX)/3.0f;
    tilAngle += (mouseY - pmouseY)/3.0f;
  }
  
  
  //プレイヤーポジションとシューティング関係
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
  
  //弾の移動と描画
  for(int i=0; i<bulletCounter; i++){
    if(bullet[i].exist){
      bullet[i].move();
      bullet[i].render();
    }
  }
  
  
  //地面の描画
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
  
  
  //以下の領域にゴキブリに関する情報を書き連ねる
  //あたり判定も
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
          //グチャっと効果音
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
  
  //ゴキブリが全員死んでいることを確認する
  for(int i = 0; i<gokiburiSum; i++){
    if(!theG[i].exist){
      dethCounter++;
    }
  }
  
  
  //全員死んだフラグがたったら
  if(dethCounter ==gokiburiSum){
    scene = 2;
  }else{
    dethCounter = 0;
  }
  
  /*****************
  2Dカメラで描画するぞ～
  ****************/
  
  camera2D();
  
  //ここでオースカメラを設定してマウスの位置を提示
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

void draw(){
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