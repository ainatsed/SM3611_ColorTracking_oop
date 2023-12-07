import processing.video.*;

int videoScale = 1;
int vw = 960;    // video width, video height
int vh = 540;    // video width, video height
color trackColor;  // store the color where the mouse is clicked 

Capture video;
Movie myMovie;

PImage[] myImages = new PImage[0]; // store flower images
Flower[] flowers = new Flower[0]; // store flowers

void setup() {
  size(960, 540);
  // Construct the Capture object
  video = new Capture(this, 960, 540);
  video.start();
  
  // Load footage
  myMovie = new Movie(this, "sky_2.mp4");
  myMovie.loop();
  
  // Load images
  for(int i = 1; i < 7; i++){
    PImage thisImg = loadImage("Assets/" + i + ".png");
    thisImg.resize(50, 50); // resize to 50x50 px
    myImages = (PImage[]) append(myImages, thisImg);
  }
  // add size variance
  for(int i = 1; i < 7; i++){
    PImage thisImg = loadImage("Assets/" + i + ".png");
    thisImg.resize(80, 80); // resize to 80x80 px
    myImages = (PImage[]) append(myImages, thisImg);
  }
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);

  video.loadPixels();
        
  // Reset tracked coordinates array every frame
  PVector[] myPos = new PVector[0];
  
  for (int i = 0; i < vw; i+=30) {
    for (int j = 0; j < vh; j+=30) {

      int loc =  (vw-i) + j*video.width;     
      color c = video.pixels[loc];  

      float r1, g1, b1;  // Get the R,G,B values from image
      r1 = red  (video.pixels[loc]);
      g1 = green(video.pixels[loc]);
      b1 = blue (video.pixels[loc]);

      float r2, g2, b2;  // Get the R,G,B values from track Color
      r2 = red(trackColor);
      g2 = green(trackColor);
      b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      // We are using the dist( ) function to compare the current color with track color.
      float d = dist(r1, g1, b1, r2, g2, b2);

      // If current color is more similar to tracked color
      if (d < 40) {   
        // Store tracked coordinates
        PVector pos = new PVector(i, j);
        myPos = (PVector[]) append(myPos, pos);

      }
    }
  }
  println("--------------" );
     
  // Draw footage
  image(myMovie, 0, 0);

  // Create 2 flowers per frame at random tracked positions
  for (int i = 0; i < 2; i++) { 
    PImage thisImg = myImages[int(random(myImages.length))];
    PVector thisPos = myPos[int(random(myPos.length))];
    Flower flower = new Flower(thisPos, thisImg); 
    flowers = (Flower[]) append(flowers, flower);
  }
  
  for (int i = 0; i < flowers.length; i++) {   
    boolean isAlive = flowers[i].update();
    
    // Draw alive flowers
    if (isAlive) {
      flowers[i].display();
    }   
  }
    
  //Flip the screen
  pushMatrix();
  translate(video.width, 0);
  scale(-1, 1); 
  image(video, 0, 0, video.width/4, video.height/4);
  popMatrix();
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = (width-mouseX) + mouseY*video.width;
  trackColor = video.pixels[loc];
  println("Track Color = r:" + int(red(trackColor))+ " g:" + int(green(trackColor)) + " b:"+ int(blue(trackColor)));
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
