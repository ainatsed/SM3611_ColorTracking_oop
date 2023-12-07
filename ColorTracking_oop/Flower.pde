class Flower {
  PVector pos; // random 2D tracked coordinate
  PVector off; // offset position on grid
  PImage img; // random image 
  int sz; // random size
  float rot; // random rotation
  
  float pTime, cTime; // previous, current timestamp
  float life, lifespan; 
  boolean alive;
  
  Flower(PVector thisPos, PImage thisImg) {
    pos = thisPos;
    off = new PVector(random(10, 50), random(10, 50));
    img = thisImg;
    sz = int(random(10, 30));
    rot = random(2*PI);
    
    pTime = 0;
    life = 0;
    lifespan = 5; // kill flower after 5s
    alive = true;
  }
      
  void display() { 
    push();
    //rotate(rot);
    //img.resize(sz, sz);
    float a = map(life, 0, 5, 255, 0); // fades towards lifespan
    tint(255, a);
    image(img, pos.x + off.x, pos.y + off.y);
    pop();
  }
  
  boolean update() {
    float cTime = millis();
    
    if (cTime - pTime > 1000) {
      life++;
      if (life > lifespan) {
        alive = false;
      } 
      pTime = cTime; // reset  
    }
    
    return alive;
  }
}
