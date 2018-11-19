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
    
    void move(){
        if(exist){
            positionX += velocityX;
            positionY += velocityY;
            positionZ += velocityZ;
        }
    }
  
  //いろいろ位置を返す関数
    float getBulletPositionX(){
        return positionX;
    }
    
    float getBulletPositionY(){
        return positionY;
    }
    
    float getBulletPositionZ(){
        return positionZ;
    }
  
    void render(){
        if(exist){
            pushMatrix();
            translate(positionX, positionY, positionZ);
            sphere(10);
            popMatrix(); 
        }
    }
  
  //プレイヤーの位置情報を取得
  //プレイヤーの向いてるベクトルを得る
  //そこから弾の位置を計算していく
  //第一因数から順に、プレイヤーのX,Y,Z,パン、チル
  
    void shoot(float pX, float pY, float pZ, float pan, float til){

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
    }
  
    void hitted(float distance){
        if(exist){
            if(distance<30){
                exist = false;
            }
        }
    }
    void hitGround(){
        if(positionY >-5){
        exist = false;
        }
    }
}