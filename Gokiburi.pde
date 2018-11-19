class Gokiburi{
    PShape g;
    Gokiburi(){
        randomX = random(-75,75);
        randomZ = random(-75,75);
        g = loadShape("g.obj");
        
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
  
    //以下のhitpoint関数は弾の位置をもらって
    void hitpoint(float BulletPositionX,float BulletPositionY, float BulletPositionZ){
        if(positionX ==BulletPositionX && positionY==BulletPositionY &&positionZ ==BulletPositionZ ){
            hitpoint -= 1;
        }
    }
  
    /***********
    呼び出すタイミングは
    ベクトル→回転→移動→表示
    ************/
  
    void move(){
        positionX += vecX/75;
        positionZ += vecZ/75;
        if(vecX != 0 && vecZ != 0){
            moveActive = true;
        }else{
            moveActive = false;
        }
    }
  
    void setVecter(float pX, float pZ){
        vecX = pX + randomX - positionX;
        vecZ = pZ + randomZ - positionZ;
    }
  
    void setTheta(float pX, float pZ){
        tanTheta = vecX/vecZ;
        theta = atan(tanTheta) ;
        if(pZ<positionZ){
        theta += PI;
        }
    }
  
  
    //Gの表示をつかさどる.
    void render(){
        pushMatrix();
        blendMode(MULTIPLY);
        translate(positionX +random(-1,1), positionY+random(-1,1), positionZ+random(-1,1));
        rotateY(theta);
        
        scale(0.2);
        shape(g);
        blendMode(BLEND);
        popMatrix();
    }
    
    //第一因数から順にあたり判定
    void hitted(float bulletPositionX,float bulletPositionY , float bulletPositionZ){
        distance = sqrt(sq(positionX - bulletPositionX)+sq(positionY - bulletPositionY)+ sq(positionZ - bulletPositionZ));
        if(exist){
            if(distance <30){
                exist = false;
            }
        }
    }
    
    float getDistanceToGokiburiToBullet(){
        return distance;
    }
}