abstract class Scene{
    Scene scene;
    Scene getNextScene(){
        return scene;
    }
    abstract void draw();
}

class Title extends Scene{
    PImage title;

    Title(){
        scene = this;
        title = loadImage("Title.png");
    }
    void draw(){
        image(title, 0,0);
        if(keyPressed){
            scene = new GameScene();
        }
    }
}

class GameScene extends Scene{
    Gokiburi[] theG;
    Player player;
    Bullet[] bullet;

    float panAngle= 0;
    float tilAngle= 0;
    float angleValue=0;
    PImage texture1;

    boolean prevMouseState;

    int bulletCounter = 0;
    boolean mouseFlag = false;

    int gokiburiSum = 30;
    
    GameScene(){
        scene = this;
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
        
        for(int i = 0; i<gokiburiSum; i++){
            
            theG[i].positionX = 100*i;
            theG[i].positionY = -10;
            theG[i].positionZ = 10 + 50*i;
            theG[i].type = i % 2;
            
            theG[i].firstPositionX = theG[i].positionX;
            theG[i].firstPositionY = theG[i].positionY;
            theG[i].firstPositionZ = theG[i].positionZ;
        }
        

    }
    void draw(){
        background(160, 216, 239);
        //パンチル設定
  
        if(mouseX< width/2 +20&& mouseX>width/2 -20 &&mouseY<height/2+20 && mouseY >height/2 -20){
            mouseFlag = true;
        }
  
        if(mouseFlag){
            panAngle += (mouseX - pmouseX)/3.0f;
            tilAngle += (mouseY - pmouseY)/3.0f;
        }
        float playerPositionX;
        float playerPositionY;
        float playerPositionZ;
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
            
                for(int j = 0; j<bulletCounter; j++){
                    float bPX = bullet[j].getBulletPositionX();
                    float bPY = bullet[j].getBulletPositionY();
                    float bPZ = bullet[j].getBulletPositionZ();
                    if(bullet[j].exist){
                        theG[i].hitted(bPX , bPY, bPZ);
                    }
                    
                    float gokiburiToBullet = theG[i].getDistanceToGokiburiToBullet();
                    bullet[j].hitted(gokiburiToBullet);
                    bullet[j].hitGround();
                }
                theG[i].setVecter(playerPositionX, playerPositionZ);
                theG[i].setTheta(playerPositionX, playerPositionZ);
                theG[i].move();

                theG[i].render();
            }
        }
        int dethCounter=0;
        //ゴキブリが全員死んでいることを確認する
        for(int i = 0; i<gokiburiSum; i++){
            if(!theG[i].exist){
                dethCounter++;
            }
        }
  
        float miliSecond = millis();
        //全員死んだフラグがたったら
        if(dethCounter ==gokiburiSum){
            scene = new ResultScene(miliSecond);
        }
  
        /*****************
        2Dカメラで描画するぞ～
        ****************/
        
        camera2D();
        
        //ここでオースカメラを設定してマウスの位置を提示
        if(mouseFlag == false){
            pushMatrix();
            fill(255);
            box(40,40,40);
            popMatrix();
        }
  
        pushMatrix();
        translate(-width/2+100 , -height/2+20 ,-50);
        fill(255);
        box(300, 100, 20);
        popMatrix();
  

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
}

class ResultScene extends Scene{
    PImage finish;
    float playTime;

    ResultScene(float playTime){
        scene = this;
        finish = loadImage("finish.png");
        this.playTime = playTime;
    }
    void draw(){
        image(finish,-width/2,-height/2);
        textSize(100);
        fill(255);
        text("Time:"+playTime/1000, 0, 0); 
        if(keyPressed){
            exit();
        }          
    }
}
