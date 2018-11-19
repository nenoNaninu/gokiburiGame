Inputter inputter;

Scene currentScene;


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
    size(1920, 1080, P3D);
    inputter = new Inputter();

    currentScene = new Title();
}

void draw(){
    background(255);
    currentScene.draw();
    if(currentScene != currentScene.getNextScene()){
        
        currentScene = currentScene.getNextScene();
    }
}
