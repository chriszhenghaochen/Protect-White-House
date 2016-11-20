
/**
 * Load and Display an OBJ Shape. 
 * 
 * The loadShape() command is used to read simple SVG (Scalable Vector Graphics)
 * files and OBJ (Object) files into a Processing sketch. This example loads an
 * OBJ file of a rocket and displays it to the screen. 
 */
import java.util.ArrayList;
import beads.*;
import processing.video.*; 
Movie m;


AudioContext ac;
// this will hold the path to our audio file
String sourceFile;
// the SamplePlayer class will play the audio file
SamplePlayer sp;
Gain gain;
Glide gainValue;

PShape house;
PImage texture;
float ry;
int rotzfactor = 0;
float x,y,z;
PShape[] shapes = new PShape[3];
PImage[] pics = new PImage[3];
ArrayList<Ball> balls;
float rotx;
float roty;
PImage bg;
PImage boom;
float HP = 100;
boolean win = false;
PImage body;
PImage gg;

int framenumber = 1; 
int phase = 2; // The phase for precessing pipeline : 1, saving frames of background; 2. overwrite the background frames with 
int bgctr = 461; // The total number of background frames should be 1 if we set phase to 1

//for ball 
float gravity = -0.1;
float friction = -0.9;
float w = 400;
float h = 400;
float r = 5;
float d = -200;
//int numofBall = 0;
float spring = 0.05;

void setup() {
  size(640, 360, P3D);
  house = loadShape("res/cz805.obj");
  house.scale(2.5);
  
  //texture = loadImage("texture.png");
  //house.setTexture(texture);


  boom = loadImage("res/expl.png");
  boom.resize(15, 15);
  
  gg = loadImage("res/win.jpg");
  
  for(int i = 0; i < 3 ; i++){
    String name = "res/" + i + ".jpg";
    pics[i] = loadImage(name);
    shapes[i] = createShape(SPHERE, 2);
    shapes[i].setTexture(pics[i]);  
    shapes[i].setStroke(false);   
  }

  //get list
  balls = new ArrayList<Ball>();
  m = new Movie(this, sketchPath("res/bg.avi"));
  m.loop();
  
  
  //////------------------sounds---------------------//
  // ac = new AudioContext(); 
  // sourceFile = sketchPath("res/") + "sound.mp3";
   
  // try {
  //   // initialize our SamplePlayer, loading the file
  //   // indicated by the sourceFile string
  //   sp = new SamplePlayer(ac, new Sample(sourceFile));
  // }
   
  // catch(Exception e){
  //         // If there is an error, show an error message
  //         // at the bottom of the processing window.
  //         println("Exception while attempting to load sample!");
  //         e.printStackTrace(); // print description of the error
  //         exit(); // and exit the program
  //}
  
  // sp.setKillOnEnd(false);
 //// we create a gain that will control the volume
 //// of our sample player
  // gainValue = new Glide(ac, 0.0, 20);
  // gain = new Gain(ac, 1, gainValue);
  // gain.addInput(sp); // connect the SamplePlayer to the Gain
  // ac.out.addInput(gain); // connect the Gain to the AudioContext

  
  
}

void draw() {
  
  if(!win){

        //clear();
        background(255);
        //bg = loadImage(sketchPath("") + "res/BG/"+nf(framenumber % bgctr, 4) + ".tif"); 
        lights();
        m.read(); 
        //m.volume(0);
        int counthit = 0;
       
        //rotateX(QUARTER_PI * 1.0);  
        rotx = (mouseY/360.0)*-2*PI+PI;
        roty = (mouseX/360.0)*2*PI-PI;
      
         
        pushMatrix();
        translate(width/2, height/1.8, 250); 
        rotateZ(-PI);
        rotateX(rotx);  //
        rotateY(roty);  // rotate drawing coordinates according to user input variables
        shape(house);
        stroke(255,0,0);
        
        pushMatrix();
        translate(0, 0, 500); 
        strokeWeight(3);
        sphere(2); 
        popMatrix();
       
        if(mousePressed == true & mouseButton == RIGHT){
          balls.add(new Ball(0, 0, 100, rotx, roty));
        }
        
        for(int i = 0 ; i < balls.size(); i++){   
         
          pushMatrix(); // Save the transform before earch's spin
          
          // Translate to draw earth
          translate(balls.get(i).positionX, balls.get(i).positionY, balls.get(i).positionZ);
          //balls.get(i).collide(); 
          
          balls.get(i).move();
          //draw ball
          if(balls.get(i).die){
             if(balls.get(i).hit){
               image(boom, balls.get(i).positionX , balls.get(i).positionY); 
               counthit++;
             }
             balls.remove(i);                           
          }    
          else{    
              shape(shapes[balls.get(i).number]);  
          }
          popMatrix(); // Go back to the transform before rotating earth
           // Earth Spin
         
        }
        
        popMatrix();
        
        HP = HP - counthit * 5;
      
        //textSize(20); 
        //text("X = "+ rotx, 100, 60); // Display the text to show where you are in the pipeline
        //text("Y = "+ roty, 100, 90); // Display the text to show where you are in the pipeline
        
        //the target
        pushMatrix();
        translate(0, 0, -500); 
        
        //for(int i = 100; i < HP * 9 ; i++){
        //  for(int  j = 0 ; j < 50; j++){   
        //    int bgloc = i + j * m.width;
        //    m.pixels[bgloc] = color(255,0,0);      
        //  }
        //}
        
        
        
        image(m, -640, -320, 640*3, 360*3);
        stroke(255,0,0);
        strokeWeight(20);
        line(-300, -250, 10, -300 + HP * 14, -250, 10);
        strokeWeight(10);
        stroke(255,0,0); 
        popMatrix();
        
        if(HP < 0){
          win = true;
        }
        
        //comp5415
        //saveFrame(sketchPath("") + "/res/composite/line-####.png");

        
        
        framenumber++;

      }
        else{
        image(gg, 0, 0, 640, 360);
      }
}

// Called every time a new frame is available to read 
void movieEvent(Movie m) { 
} 

void mouseClicked() {
  balls.add(new Ball(0,0,50, rotx, roty));
}

void keyReleased(){
  if (key == 'q' || key == 'Q'){
    sound();
  }
}

void sound(){
   //ac.start(); // begin audio processing
   //gainValue.setValue(0.9);
   //sp.setToLoopStart();
   //sp.start(); // play the audio file 
}

class Ball{
  
  float positionX;
  float positionY;
  float positionZ;
  float xa;
  float ya;
  
  float speedX;
  float speedY;
  float speedZ;
  //int id;
  int number;
  boolean die = false;
  boolean hit = false;
  
  Ball(float x, float y, float z, float xa, float ya){
    this.positionX = x;
    this.positionY = y; 
    this.positionZ = z;
    this.xa = xa;
    this.ya = ya;
    
    this.speedX = 0;
    //this.speedY = -1 * (float) Math.random() * 20 + 10;
    this.speedY = 0;
    this.speedZ = 30;
    
    this.number = (int) (Math.random()*4 - 1);
    
    //id = numofBall;
    //numofBall++;  
    
    ////horny
    // if(mousePressed == true & mouseButton == RIGHT){
    //      this.speedX = -5 * (float) Math.random();
    //      this.speedY = 0;
    //      this.speedZ = 0;
    //      this.number = 11;
    // }
  }
  
  void move(){
    
    this.speedY += gravity;
    this.positionX += this.speedX;
    this.positionY += this.speedY;
    this.positionZ += this.speedZ;
    
    
    if(this.positionZ + r > 300){
      if(xa >= -0.06981325 && xa <= 0.3668925 && ya >= 3.408299 && ya <= 3.752459 ){
        hit = true;
        //print("hit");
      }
      
      die = true;
    }
    
  }
}