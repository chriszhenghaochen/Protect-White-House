// Example for COMP3615 WEEK06 TASK 1
// @Author : Chris
// For your assignment option 1, 
// it is cozy to play the video in the 'draw()'
// and draw your objects at each frame
// After drawing all the objects just call 'saveFrame()'
// Use 'Tools->Movie Maker' to combine all the saved frames


//UFO
float spring = 0.05;
float friction = -0.9;
float g = 0.7;

//sounds
import beads.*;

AudioContext ac;
// this will hold the path to our audio file
String sourceFile;
// the SamplePlayer class will play the audio file
SamplePlayer sp;
Gain gain;
Glide gainValue;


///kmeans
import java.util.*;
int WIDTH = 568;
int HEIGHT = 320;
int nrNotChanged = 0;
int WAIT_UNTIL_RESET = 20;


import processing.video.*; 
Movie m; 

int framenumber = 1; 
int phase = 2; // The phase for precessing pipeline : 1, saving frames of background; 2. overwrite the background frames with 
int bgctr = 79; // The total number of background frames should be 1 if we set phase to 1
int BLUE = 120; // I did not tune this much, keep tunning
                // Also try to include Red and Green in your 
                // criteria to achieve better segmentation 
boolean report = false;             
int RED = 160;
int GREEN = 120;
boolean start = false;
boolean los = false;
boolean winner = false;

boolean trackShow = false;
boolean weapon = true;

//for dubug only
boolean point1Show = false;
boolean pointShow = false;


PImage bg;
PImage mg;
PImage monkeyframe;
PImage img;
PImage lefthand;
PImage righthand;
PImage head;
PImage rightfoot;
PImage leftfoot;
PImage body;
PImage b1;
PImage cover;
PImage win;
PImage lose;
PImage mil;
PImage mir;

//UFO 
PImage ufo; 
PImage expl; 

Point a;
Point b;
Point c;

KMeans K_means;
People people;

int numOfUFO = 3;

//ball
ArrayList<Ball> balls;
ArrayList<Ball2> balls2;
int ballid;
int ballid2;

void setup() { 
  size(960, 600); //Just large enough to see what is happening
  //size(1528, 600); //Just large enough to see what is happening
  
  
  //------------------sounds---------------------//
   ac = new AudioContext(); 
   sourceFile = sketchPath("res/") + "sample.wav";
   
   try {
     // initialize our SamplePlayer, loading the file
     // indicated by the sourceFile string
     sp = new SamplePlayer(ac, new Sample(sourceFile));
   }
   
   catch(Exception e){
           // If there is an error, show an error message
           // at the bottom of the processing window.
           println("Exception while attempting to load sample!");
           e.printStackTrace(); // print description of the error
           exit(); // and exit the program
  }
  
   sp.setKillOnEnd(false);
 // we create a gain that will control the volume
 // of our sample player
   gainValue = new Glide(ac, 0.0, 20);
   gain = new Gain(ac, 1, gainValue);
   gain.addInput(sp); // connect the SamplePlayer to the Gain
   ac.out.addInput(gain); // connect the Gain to the AudioContext
  
   
  //images set up
  lefthand = loadImage("res/leftwing.png");
  righthand = loadImage("res/rightwing.png");
  //head = loadImage("head.png");
  rightfoot = loadImage("res/rightfoot.png");
  leftfoot = loadImage("res/leftfoot.png");
  body = loadImage("res/body.png");
  
  ufo = loadImage("res/UFO.png");
  expl = loadImage("res/boom.png");
  b1 = loadImage("res/b1.png");
  cover = loadImage("res/cover.jpg");
  win = loadImage("res/win.jpg");
  lose = loadImage("res/lose.jpg");
  
  mil = loadImage("res/mil.png");
  mir = loadImage("res/mir.png");
  
  //filter image
   //lefthand.resize(40,40);
   //righthand.resize(40,40);
   leftfoot.resize(60,60);
   rightfoot.resize(60,60);
   //head.resize(40,40);
   ufo.resize(100,100);
   expl.resize(60,60);
   b1.resize(30,30);
   mil.resize(50,20);
   mir.resize(50,20);
   
   
   //lefthand = removeBackground2(lefthand);
   //righthand = removeBackground2(righthand);
   leftfoot = removeBackground2(leftfoot);
   rightfoot = removeBackground2(rightfoot);
  
  //frameRate(120); // Make your draw function run faster
  
  //phase 1
  //m = new Movie(this, sketchPath("star_trails.mov")); 
  
  K_means = new KMeans();
  m = new Movie(this, sketchPath("res/monkey.mov"));
  //m.frameRate(120); // Play your movie faster

  framenumber = 0; 
  fill(255, 255, 0); // Make the drawing colour yellow
  
  
  people = new People();
  
  balls = new ArrayList<Ball>();
  ballid = 0;
  
  balls2 = new ArrayList<Ball2>();
  ballid2 = 0;

  ////play the movie one time, no looping 
  //m.play(); 
} 
 
void draw() { 
  
if(start){
  // Clear the background with black colour
  float time = m.time();
  float duration = m.duration();
  ArrayList<Point> points = new ArrayList<Point>();
  ArrayList<Point> bags = new ArrayList<Point>();

  if( time >= duration ) {  
    if (phase == 1) {
      m = new Movie(this, sketchPath("res/monkey.mov"));
      //m.frameRate(120); // Play your movie faster
      m.play();
      phase = 2;
      bgctr = framenumber;
      framenumber = 1;
    }
    else if (phase == 2){
      
      if(winner == false & los == false){
            image(lose, 0,0, 960, 680);
            textSize(60);
            text("Times up! You lose, sucker", 100, 80); // Display the text to show where you are in the pipeline
        //exit(); // End the program when the second movie finishes
      }
    }
  }

    if (m.available()){
      background(0, 0, 0);
      m.read(); 
      m.volume(0);
      
      if (phase == 1){
        image(m, 0, 0);
        //m.save(sketchPath("") + "BG/"+nf(framenumber, 4) + ".tif"); // They say tiff is faster to save, but larger in disks 
      }
      else if (phase == 2) {
        

        //----------------------------------------alive-----------------------------------------//
        if(people.HP > 0 & !los){
          
            //reference 1
            image(m, 960, 0);
            
            
            pushMatrix();
            translate(0, -40);
            //mg = loadImage(sketchPath("") + "KK/"+nf(framenumber % bgctr, 4) + ".tif");
            
            
            bg = loadImage(sketchPath("") + "res/BG/"+nf(framenumber % bgctr, 4) + ".tif");
            
            if(report){
              bg = loadImage(sketchPath("") + "res/report.png");
              bg.resize(960, 700);
            }
            
            //for report only
            
            //bg = loadImage(sketchPath("") + "BG/"+ "blank.png");
    
            //filter
            monkeyframe = removeBackground1(m);
              
              
            //K-means
            // Overwrite the background 
            for (int x = 0; x < monkeyframe.width; x++){
                for (int y = 0; y < monkeyframe.height; y++){
                  int mloc = x + y * monkeyframe.width;
                  color mc = monkeyframe.pixels[mloc];
                      
                  
                      if (mc != -1) {
                            // To control where you draw the monkey
                            // You can tweak the destination position of the monkey like
                          if(trackShow){
                            int bgx = constrain(x + 500, 0, bg.width);
                            int bgy = constrain(y + 60, 0, bg.height);                       
                            int bgloc = bgx + bgy * bg.width;
                            bg.pixels[bgloc] = mc;
                          }
                                             
                          //calulate center
                          points.add(new Point(x,y));                                 
                      }
                    
               }     
          }
          
          K_means.resetPoints(points);
          K_means.train();
          
          for(int i = 0; i < 5; i++){                 
           if(K_means.centroids[i].x != 0 & K_means.centroids[i].y != 0){
             bags.add(new Point(K_means.centroids[i].x, K_means.centroids[i].y));
           }              
          }
            
              
          Point[] hehe = new Point[10];
              
          for(int i = 0; i < 10; i++){
              hehe[i] = getPoint(monkeyframe, true);
              if(hehe[i].x != 0 && hehe[i].y != 0)
              bags.add(hehe[i]);
              fill(255);      
           }
           
          for(int i = 0; i < 10; i++){
              hehe[i] = getPoint(monkeyframe, false);
              if(hehe[i].x != 0 && hehe[i].y != 0)
              bags.add(hehe[i]);
              fill(255);      
           }
           
          //boolean reset = true;
          //for(int i = 0; i < bags.size(); i++){
          //  if(bags.get(i).x > 0 || 
          //}
          
          people.reset(bags); 
                //// left hand 
                //  for (int x = 0; x < lefthand.width; x++){
                //      for (int y = 0; y < lefthand.height; y++){
                //        int mloc = x + y * lefthand.width;
                //        color mc = lefthand.pixels[mloc];
                            
                        
                //            if (mc != -1) {
                //                int bgx = constrain(x + (int) people.lh.x + 350 - 20, 0, bg.width - 1);
                //                int bgy = constrain(y + (int) people.lh.y + 60 -20, 0 , bg.height - 1);                       
                //                int bgloc = bgx + bgy * bg.width;
                //                bg.pixels[bgloc] = mc;                               
                //            }                
                //     }     
                //}
                
                //// right hand 
                //  for (int x = 0; x < righthand.width; x++){
                //      for (int y = 0; y < righthand.height; y++){
                //        int mloc = x + y * righthand.width;
                //        color mc = righthand.pixels[mloc];
                            
                        
                //            if (mc != -1) {
                //                int bgx = constrain(x + (int) people.rh.x + 350 - 20, 0, bg.width - 1);
                //                int bgy = constrain(y + (int) people.rh.y + 60 - 20, 0 , bg.height - 1);                       
                //                int bgloc = bgx + bgy * bg.width;
                //                bg.pixels[bgloc] = mc;
                                           
                //            }              
                //     }     
                //}
               
                 // left foot 
                  //for (int x = 0; x < leftfoot.width; x++){
                  //    for (int y = 0; y < leftfoot.height; y++){
                  //      int mloc = x + y * leftfoot.width;
                  //      color mc = leftfoot.pixels[mloc];
                            
                        
                  //          if (mc != -1) {
                  //              int bgx = constrain(x + (int) people.lf.x + 350 - 20, 0, bg.width - 1);
                  //              int bgy = constrain(y + (int) people.lf.y + 60 - 20, 0 , bg.height - 1);                       
                  //              int bgloc = bgx + bgy * bg.width;
                  //              bg.pixels[bgloc] = mc;
                                       
                  //          }              
                  //   }     
               // }
//                //
                 //// right foot 
                  //for (int x = 0; x < rightfoot.width; x++){
                  //    for (int y = 0; y < rightfoot.height; y++){
                  //      int mloc = x + y * rightfoot.width;
                  //      color mc = leftfoot.pixels[mloc];
                            
                        
                  //          if (mc != -1) {
                  //              int bgx = constrain(x + (int) people.rf.x + 350 - 20, 0 , bg.width - 1);
                  //              int bgy = constrain(y + (int) people.rf.y + 60 - 20, 0 , bg.height - 1);                       
                  //              int bgloc =bgx + bgy * bg.width;
                  //              bg.pixels[bgloc] = mc;
                                          
                  //          }              
                  //   }     
//}
                
                //// head 
                // for (int x = 0; x < head.width; x++){
                //      for (int y = 0; y < head.height; y++){
                //        int mloc = x + y * head.width;
                //        color mc = head.pixels[mloc];             
                //            if (mc != -1) {
                //                int bgx = constrain(x + (int) people.headp.x + 350 - 20, 0, bg.width - 1) ;
                //                int bgy = constrain(y + (int) people.headp.y + 60 - 20, 0 , bg.height -1);                       
                //                int bgloc = bgx + bgy * bg.width;
                //                bg.pixels[bgloc] = mc;                                
                //            }              
                //     }     
                //}
          

                image(bg, 0, 0);
                bg.updatePixels();
                
                
              
                ////-----for debug only-----//
                //stroke(255);
                //fill(255);
                //if(point1Show){
                // for(int i = 0 ; i < bags.size(); i++){
                //    ellipse(bags.get(i).x + 500, bags.get(i).y + 60, 40, 40);   
                // }                 
                //}
                
                //stroke(0);
                //fill(0);
                //if(pointShow){
                //  println("size = " +bags.size());
                //  ellipse(people.lf.x + 500, people.lf.y + 60, 30, 30);   
                //  ellipse(people.rf.x + 500, people.rf.y + 60, 30, 30);   
                //  ellipse(people.lh.x + 500, people.lh.y + 60, 30, 30);   
                //  ellipse(people.rh.x + 500, people.rh.y + 60, 30, 30);                     
                //}
               ////-----for debug only-----//
                 
                //reference
                 stroke(255);
                 fill(255);

                 println("size = " +bags.size());
                 ellipse(people.lf.x + 960, people.lf.y + 320, 30, 30);   
                 ellipse(people.rf.x + 960, people.rf.y + 320, 30, 30);   
                 ellipse(people.lh.x + 960, people.lh.y + 320, 30, 30);   
                 ellipse(people.rh.x + 960, people.rh.y + 320, 30, 30);  
                 
                 if(pointShow){
                   pushMatrix();
                   translate(-500,0);
                   
  
                   //motion point
                   ellipse(people.lf.x + 960, people.lf.y + 320, 30, 30); 
                   line(people.lf.x + 960, people.lf.y + 320, people.bodyp.x + 960, people.bodyp.y + 320);
                   ellipse(people.rf.x + 960, people.rf.y + 320, 30, 30);  
                   line(people.rf.x + 960, people.rf.y + 320, people.bodyp.x + 960, people.bodyp.y + 320);
                   ellipse(people.lh.x + 960, people.lh.y + 320, 30, 30);
                   line(people.lh.x + 960, people.lh.y + 320, people.bodyp.x + 960, people.bodyp.y + 320);
                   ellipse(people.rh.x + 960, people.rh.y + 320, 30, 30);  
                   line(people.rh.x + 960, people.rh.y + 320, people.bodyp.x + 960, people.bodyp.y + 320);
                   popMatrix();

                 }
                 
                 if(report){ 
                   pushMatrix();  
                   translate(-150, 50);
                   people.render();
                   popMatrix();
                 }else{
                    people.render();
                 }
                ////for report
                //saveFrame(sketchPath("") + "/composite/" + nf(framenumber, 4) + ".tif");
                
                image(ufo, mouseX, mouseY);
                if(dist(mouseX, mouseY, people.bodyp.x + 350 - 20, people.bodyp.y + 60 -20) < 100){
                            println("boom!");
                            if(framenumber > 30){
                              image(expl, mouseX, mouseY);
                              numOfUFO --;
                              framenumber = 0;
                            }
                            if(numOfUFO < 0){ 
                              los = true;                            
                            }
                }

               //if(mousePressed == true & mouseButton == LEFT ){
               //   balls.add(new Ball(mouseX, mouseY, random(20), ballid++));              
               //}
               
              textSize(20);
              text("Press w to change weapon ", 70, 60); // Display the text to show where you are in the pipeline   
              
              
              //---------------------------boom-------------------------//
              if(weapon){ 
                  image(b1, 10, 40 , 50, 50);
              } 
              
              //---------------------------missile-------------------------//
              else{
                  
                  image(mil, 10, 50, 50, 30);  
              }
                //if(mousePressed == true & mouseButton == LEFT){
                //  balls.add(new Ball(mouseX, mouseY, random(20), ballid++));    
                //}
                 
                 for(int i = 0 ; i < balls.size(); i++){
                          balls.get(i).move();
                          //balls.get(i).collide();
                          balls.get(i).display();  
                          
                          if(dist(balls.get(i).x, balls.get(i).y, people.bodyp.x + 350 - 20, people.bodyp.y + 60 -20) < 100){               
                              balls.get(i).die = true; 
                              people.HP = people.HP - 10;
                          }
            
                      }
                      
                      for(int i = 0 ; i < balls.size(); i++){                
                          if(balls.get(i).die){
                             image(expl, balls.get(i).x,balls.get(i).y);
                             sound();
                             balls.remove(i);
                           }      
                      }
                    
                //if(mousePressed == true & mouseButton == LEFT){
                //  balls.add(new Ball(mouseX, mouseY, random(20), ballid++));    
                //}

                 
                 for(int i = 0 ; i < balls2.size(); i++){
                         if(balls2.get(i).x < people.bodyp.x + 350 - 20) balls2.get(i).moveleft();  //left
                         else balls2.get(i).moveright(); 
                         //balls.get(i).collide();
                         

                         
                         if(dist(balls2.get(i).x, balls2.get(i).y, people.bodyp.x + 350 - 20, people.bodyp.y + 60 -20) < 100){               
                             balls2.get(i).die = true; 
                             people.HP = people.HP - 3;
                         }
                         
                                                
                         if(balls2.get(i).x < people.bodyp.x + 350 - 20) balls2.get(i).displayl();  //left
                         else balls2.get(i).displayr();                                             //right
             
                     }
                      
                     for(int i = 0 ; i < balls2.size(); i++){                
                         if(balls2.get(i).die){
                            image(expl, balls2.get(i).x,balls2.get(i).y);
                            sound();
                            balls2.remove(i);
                          }      
                     }              
             for(int i = 0 ; i < numOfUFO; i++){
                image(ufo, 700 + 80 * i, 30, 60, 60);
             }
                    
                // In the second phase, we just saveframe, since we would like to include the objects we drew
                // I am drawing some thing at the same time.
                
                //comp5415
                //saveFrame(sketchPath("") + "/composite/" + nf(framenumber, 4) + ".tif");
                //saveFrame(sketchPath("") + "/composite/" + "line-####" + ".png");
                
                textSize(20);
                text(String.format("Time Remain - %.2f%%",  100 - 100 * time / duration), 100, 80); // Display the text to show where you are in the pipeline
                System.out.printf("Phase: %d - Frame %d\n", phase, framenumber);
                framenumber++; 
                println(framenumber);                             
                popMatrix();
            }     
          
          else if(los){
            image(lose, 0,0, 960, 680);
            textSize(60);
            text("You lose, sucker", 100, 80); // Display the text to show where you are in the pipeline
          }
          
          //win
          else{
            image(win, 0,0, 960, 680);
            textSize(60);
            text("Congratulation! You Win", 100, 80); // Display the text to show where you are in the pipeline
            winner = true;
          }
        }     
       
      }      
    }
    
     else{
          //m.stop();
          image(cover, 0,0, 960, 680);
          textSize(60);
          text("Protect White House", 100, 80); // Display the text to show where you are in the pipeline
          textSize(20);
          text("Press S to start ", 400, 200); // Display the text to show where you are in the pipeline
     }
} 
 
// Called every time a new frame is available to read 
void movieEvent(Movie m) { 
} 

PImage removeBackground1(PImage frame) {
  for (int x = 0; x < frame.width; x ++)
    for (int y = 0; y < frame.height; y ++) {
      int loc = x + y * frame.width;
      color c = frame.pixels[loc];
      //if ( blue(c) > BLUE){ 
      //          frame.pixels[loc] = -1; 
      //}
      
      if(red(c) < RED || green(c) > GREEN || blue(c) > BLUE ){
        frame.pixels[loc] = -1; 
      }
    }

  frame.updatePixels();

  return frame;
}

PImage removeBackground2(PImage frame) {
  for (int x = 0; x < frame.width; x ++)
    for (int y = 0; y < frame.height; y ++) {
      int loc = x + y * frame.width;
      color c = frame.pixels[loc];

      if((c) > 150){
        frame.pixels[loc] = -1; 
      }
    }

  frame.updatePixels();

  return frame;
}

Point getPoint(PImage frame, boolean up){
 int x1 = 0;
 int y1 = 0;
 int count = 0;
 float xsum = 0;
 float ysum = 0;
 boolean found = true;
 int nei = 1;
 

if(up){
  for(int j = frame.height * frame.width - 1; j > 0; j--){
  //for(int j = 0; j < frame.height * frame.width; j++){
      if(frame.pixels[j] != -1){
          //println("here");
          x1 = (int) j%frame.width;
          y1 = (int) j/frame.width;;
          break;
      }
  }
}
else{
  //for(int j = frame.height * frame.width - 1; j > 0; j--){
  for(int j = 0; j < frame.height * frame.width; j++){
      if(frame.pixels[j] != -1){
          //println("here");
          x1 = (int) j%frame.width;
          y1 = (int) j/frame.width;;
          break;
      }
  }
}

while(found){
   found = false;
   for(int i = x1 - nei; i < x1 + nei + 1 ; i++){
     
     int a = constrain(i, 0, frame.width - 1);
     
     for(int j = y1 - nei; j < y1 + nei + 1; j++){
       
       int b = constrain(j, 0, frame.height - 1);
       if(frame.pixels[a + frame.width * b] != -1){
           found = true;
           count ++;
           xsum += a;
           ysum += b;
           
           frame.pixels[a + frame.width * b] = -1;
       }
     }
   }  
   nei ++;  
 }
   
  if (count < 200){
    //println("not happy");
    return new Point(0,0);
  }
  return new Point(xsum/count, ysum/count);
}


//mouse event
void keyReleased() {
  //if (key == 'b' || key == 'B') {    
  //   balls.add(new Ball(mouseX, mouseY, random(20), ballid++));
  //}
  
  if (key == 's' || key == 'S') {  
     m.play(); 
     start = true;
  }
  
  if (key == 'w' || key == 'W') {    
     weapon = !weapon;
  }
  
  if (key == 'o' || key == 'O') {    
     trackShow = ! trackShow;
  }
  
  //for dubug only
  if (key == 'p' || key == 'P') {    
    pointShow = ! pointShow;
  }
  
  if (key == 'o' || key == 'O') {    
    report = !report;
  }
}

void mouseClicked(){
  if(weapon){
    if(mouseButton == LEFT){
      balls.add(new Ball(mouseX, mouseY, random(20), ballid++));    
    }
  }else{
    if(mouseButton == LEFT){
      balls2.add(new Ball2(mouseX, mouseY, random(20), ballid2++));    
    }
  }
}

void sound(){ 
       ac.start(); // begin audio processing
       gainValue.setValue(0.9);
       sp.setToLoopStart();
       sp.start(); // play the audio file 
}




//------------------k-means-------------------//
class KMeans{
  
  int K = 5;
  Point[] points;
  Point[]centroids = new Point[K];
      
  KMeans(){
    //points = new Point[input.size()];
    
    //for(int i = 0 ; i < input.size(); i++){
    //  points[i] = input.get(i);
    //}
    
    createInitialCentroids();    
  }
  
 void resetPoints(ArrayList<Point> input){
    points = new Point[input.size()];
    
    for(int i = 0 ; i < input.size(); i++){
      points[i] = input.get(i);
    }      
 }
  
 void train(){
   boolean changed = true;
    //check if any centroid was moved
    while(changed){
      assignPoints2Clusters();    
      changed = calculateNewCentroids();
      //nothing changed
      nrNotChanged++;
      
      if(nrNotChanged == WAIT_UNTIL_RESET){
        println("number ends");
        return;
      }
      
      if(changed == false){
        println("done");
        return;
      }
    }
 
 }
  
 void createInitialCentroids(){
  //create the initial prototypes
  for(int i = 0; i < K; i++){
    int x = int(random(0, WIDTH));
    int y = int(random(0, HEIGHT));
    centroids[i] = new Point(x,y);
  }
 }
 
 void assignPoints2Clusters(){
    for(int i = 0; i < points.length; i++){
      points[i].dist2Centroid = WIDTH * HEIGHT;
      for(int j = 0; j < centroids.length; j++){
        
        //find the centroid with the smallest distance
        float distance = dist(points[i].x, points[i].y, centroids[j].x, centroids[j].y);
        if(distance < points[i].dist2Centroid){
          points[i].dist2Centroid = distance;
          points[i].clusterIdx = j;
        }
      }
  }
}

boolean calculateNewCentroids(){
  //now calculate the new centroids
  /*
   * This is a hack! The Point class structure is abused:
   * x holds the cumulate x values for all points of the referring cluster,
   * y holds the cumulated y values for all points of the referring cluster,
   * dist2Centroid holds the number of points belonging to the referring cluster.
   * The cluster is identified by it's index in the centroid array.
   */
  Point[]tempCentroids = new Point[K];
  for(int i = 0; i < tempCentroids.length; i++){
    tempCentroids[i] = new Point(0,0);
    tempCentroids[i].dist2Centroid = 0;
  }
  
  for(int i = 0; i < points.length; i++){
      int idx = points[i].clusterIdx;
      tempCentroids[idx].x += points[i].x;
      tempCentroids[idx].y += points[i].y;
      tempCentroids[idx].dist2Centroid++;
  }
  
  boolean changed = false;
  for(int i = 0; i < centroids.length; i++){
    int newX = int((tempCentroids[i].x/tempCentroids[i].dist2Centroid));
    int newY = int((tempCentroids[i].y / tempCentroids[i].dist2Centroid));
    if(centroids[i].x != newX || centroids[i].y != newY){
      changed = true;
    }
    centroids[i].x = newX;
    centroids[i].y = newY;
  }
  return changed;
}


  

}

class Point{
  float x;
  float y;
  int clusterIdx;
  float dist2Centroid;
  char index;
  
  Point(float x, float y){
    this.x = x;
    this.y = y;  
    clusterIdx = -1;
    dist2Centroid = WIDTH*HEIGHT;
  }

}


//------------------------------people-----------------------------------------//


class People{

  //PImage lefthand = loadImage("lefthand.jpg");
  //PImage righthand = loadImage("righthand.jpg");
  //PImage head = loadImage("head.jpg");
  //PImage rightfoot = loadImage("rightfoot.jpg");
  //PImage leftfoot = loadImage("leftfoot.jpg");
  //PImage body = loadImage("body.png");
  ArrayList<Point> points;
  Point lh, rh, lf, rf, headp, bodyp;
  float HP = 200;
  
  People(){    
  }
  
  void reset(ArrayList<Point> points){  
     this.points = points;
     
     if(points.size() < 5){
      Point[] hands = this.find2yMin(this.points);
      lh = hands[0];
      rh = hands[1];
        
      Point[] feet = this.find2yMax(this.points);
      lf = feet[1];
      rf = feet[0];
     }else{
       Point[] hands = this.find3yMin(this.points);
        lh = hands[0];
        rh = hands[1];
          
        Point[] feet = this.find3yMax(this.points);
        lf = feet[1];
        rf = feet[0];
     
     }
     
      //Point[] hands = this.find2yMin(this.points);
      // lh = hands[0];
      // rh = hands[1];
        
      // Point[] feet = this.find2yMax(this.points);
      // lf = feet[1];
      // rf = feet[0];
       
       
     headp = new Point((lh.x + rh.x + lf.x + rf.x)/4, (lh.y + rh.y + lf.y + rf.y)/4 - 40);
     bodyp = new Point((lh.x + rh.x + lf.x + rf.x)/4, (lh.y + rh.y + lf.y + rf.y)/4);
  }
  
 void render(){
 
    stroke(0);
    strokeWeight(10);
    //line(lh.x + 350 + 10, lh.y + 60 + 10, bodyp.x + 350, bodyp.y +60);
    //line(rh.x + 350 + 10, rh.y + 60 + 10, bodyp.x + 350, bodyp.y +60);
    strokeWeight(20);
    //line(lf.x + 350, lf.y +60, bodyp.x + 350, bodyp.y +60);
    //line(rf.x + 350, rf.y +60, bodyp.x + 350, bodyp.y +60);
    
    pushMatrix();
    translate(bodyp.x + 350, bodyp.y +60);
    float a = atan2(lh.y  - bodyp.y, lh.x - bodyp.x);
    rotate(a);
    image(righthand, 0, 0, 160, 160);  
    popMatrix();
    
    pushMatrix();
    translate(bodyp.x + 350, bodyp.y +60);
    float b = atan2(rh.y  - bodyp.y, rh.x - bodyp.x);
    rotate(b);
    image(lefthand, 0, -150, 160, 160);  
    popMatrix();
    
    image(body, bodyp.x + 350 - 60, bodyp.y + 60 - 80, 120, 200);
    
    strokeWeight(10);
    stroke(255,0,0);
    line(headp.x + 350 - 20 - 50 , headp.y + 60 - 50 - 20 , headp.x  + HP  + 350 - 30 - 50, headp.y + 60 - 50 - 20);
    
    pushMatrix();
    translate(bodyp.x + 350, bodyp.y +60);
    float c = atan2(bodyp.y - lf.y, bodyp.x - lf.x);
    rotate(c);
    image(leftfoot, -160, -60);  
    popMatrix();
    
    pushMatrix();
    translate(bodyp.x + 350, bodyp.y +60);
    float d = atan2(bodyp.y - rf.y, bodyp.x - rf.x);
    rotate(d);
    image(rightfoot, -160, -20);  
    popMatrix();
}

private Point[] find2yMax(ArrayList<Point> inputs){
   Point pmax = new Point(0,0);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y > pmax.y){
       pmax = inputs.get(i);
     }   
   }
   
    Point p2max = new Point(0,0);
    for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i) != pmax && inputs.get(i).y > p2max.y ){
       p2max = inputs.get(i);
     }   
   }
   
     Point[] y2max = new Point[2];
     y2max[0] = pmax;
     y2max[1] = p2max;
     
     return y2max;
}

private Point[] find2yMin(ArrayList<Point> inputs){
   Point pmax = new Point(1000,1000);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y < pmax.y){
       pmax = inputs.get(i);
     }   
   }
   
    Point p2max = new Point(1000,1000);
    for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i) != pmax && inputs.get(i).y < p2max.y ){
       p2max = inputs.get(i);
     }   
   }
   
     Point[] y2max = new Point[2];
     y2max[0] = pmax;
     y2max[1] = p2max;
     
     return y2max;
}


private Point[] find3yMax(ArrayList<Point> inputs){
   Point pmax = new Point(0,0);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y > pmax.y){
       pmax = inputs.get(i);
     }   
   }
   
    Point p2max = new Point(0,0);
    for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i) != pmax && inputs.get(i).y > p2max.y ){
       p2max = inputs.get(i);
     }   
   }
   
   Point p3max = new Point(0,0);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y < p2max.y && inputs.get(i).y > p3max.y){
       p3max = inputs.get(i);
     }   
   }
   
   
   Point[] y2max = new Point[3];
   y2max[0] = pmax;
   y2max[1] = p2max;
   y2max[2] = p3max;
   
   int idx1 = -1;
   float x = 0;
   for(int i = 0; i < 3; i++){
     if(y2max[i].x > x){
       idx1 = i;
       x = y2max[i].x;
     }
   }
   
   int idx2 = -1;
   x = 1000;
   for(int i = 0; i < 3; i++){
     if(y2max[i].x < x){
       idx2 = i;
       x = y2max[i].x;
     }
   }
   
   Point[] y3max = new Point[2];
   y3max[0] = y2max[idx1];
   y3max[1] = y2max[idx2];
   
   return y3max;
  }
  
  private Point[] find3yMin(ArrayList<Point> inputs){
    Point pmax = new Point(1000,1000);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y < pmax.y){
       pmax = inputs.get(i);
     }   
   }
   
    Point p2max = new Point(1000,1000);
    for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i) != pmax && inputs.get(i).y < p2max.y ){
       p2max = inputs.get(i);
     }   
   }
   
   
   Point p3max = new Point(1000,1000);
   for(int i = 0 ; i < inputs.size(); i++){
     if(inputs.get(i).y > p2max.y && inputs.get(i).y < p3max.y){
       p3max = inputs.get(i);
     }   
   }
   
   
   Point[] y2max = new Point[3];
   y2max[0] = pmax;
   y2max[1] = p2max;
   y2max[2] = p3max;
   
   int idx1 = -1;
   float x = 0;
   for(int i = 0; i < 3; i++){
     if(y2max[i].x > x){
       idx1 = i;
       x = y2max[i].x;
     }
   }
   
   int idx2 = -1;
   x = 1000;
   for(int i = 0; i < 3; i++){
     if(y2max[i].x < x){
       idx2 = i;
       x = y2max[i].x;
     }
   }
   
   Point[] y3max = new Point[2];
   y3max[0] = y2max[idx1];
   y3max[1] = y2max[idx2];
   
   return y3max;
  }
}



class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  boolean die = false;
 
  Ball(float xin, float yin, float din, int idin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
  } 
  
  //void collide() {
  // for (int i = id + 1; i < balls.size(); i++) {
  //   float dx = balls.get(i).x - x;
  //   float dy = balls.get(i).y - y;
  //   float distance = sqrt(dx*dx + dy*dy);
  //   float minDist = balls.get(i).diameter/2 + diameter/2;
  //   if (distance < minDist) { 
  //     float angle = atan2(dy, dx);
  //     float targetX = x + cos(angle) * minDist;
  //     float targetY = y + sin(angle) * minDist;
  //     float ax = (targetX - balls.get(i).x) * spring;
  //     float ay = (targetY - balls.get(i).y) * spring;
  //     vx -= ax;
  //     vy -= ay;
  //     balls.get(i).vx += ax;
  //     balls.get(i).vy += ay;
  //   }
  // }   
  //}
  
  void move() {
    vy += g;
    x += vx;
    y += vy;
    //if (x + diameter/2 > 960) {
    // x = 960 - diameter/2;
    // vx *= friction; 
    // die = true;
    //}
    ////else if (x - diameter/2 < 0) {
    //// x = diameter/2;
    //// vx *= friction;
    //// die = true;
    ////}
    if (y + diameter/2 > 600) {
      y = 600 - diameter/2;
      vy *= friction; 
      die = true;
    } 
    //else if (y - diameter/2 < 0) {
    //  y = diameter/2;
    //  vy *= friction;
    //  die = true;
    //  sound();
    //}
  }
  
  void display() {
     //ellipse(x, y, diameter, diameter);
     image(b1,x,y);
  }
}

class Ball2 {
  
  float x, y;
  float diameter;
  float vx;
  float vy;
  int id;
  boolean die = false;
 
  Ball2(float xin, float yin, float din, int idin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
  } 
  
  //void collide() {
  // for (int i = id + 1; i < balls.size(); i++) {
  //   float dx = balls.get(i).x - x;
  //   float dy = balls.get(i).y - y;
  //   float distance = sqrt(dx*dx + dy*dy);
  //   float minDist = balls.get(i).diameter/2 + diameter/2;
  //   if (distance < minDist) { 
  //     float angle = atan2(dy, dx);
  //     float targetX = x + cos(angle) * minDist;
  //     float targetY = y + sin(angle) * minDist;
  //     float ax = (targetX - balls.get(i).x) * spring;
  //     float ay = (targetY - balls.get(i).y) * spring;
  //     vx -= ax;
  //     vy -= ay;
  //     balls.get(i).vx += ax;
  //     balls.get(i).vy += ay;
  //   }
  // }   
  //}
  
  void moveleft() {
    vx = random(0,20);
    vy = random(-20,20);
    x += vx;
    y += vy;
    
    if (x + diameter/2 > 960) {
      x = 960 - diameter/2;
      vx *= friction; 
      die = true;
    }
    
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
      die = true;
    }
    
    else if (y + diameter/2 > 600) {
      y = 600 - diameter/2;
      vy *= friction; 
      die = true;
    } 
    //else if (y - diameter/2 < 0) {
    //  y = diameter/2;
    //  vy *= friction;
    //  die = true;
    //  sound();
    //}
  }
  
   void moveright() {
    vx = random(-20,0);
    vy = random(-20,20);
    x += vx;
    y += vy;
    
    if (x + diameter/2 > 960) {
      x = 960 - diameter/2;
      vx *= friction; 
      die = true;
    }
    
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
      die = true;
    }
    
    else if (y + diameter/2 > 600) {
      y = 600 - diameter/2;
      vy *= friction; 
      die = true;
    } 
    //else if (y - diameter/2 < 0) {
    //  y = diameter/2;
    //  vy *= friction;
    //  die = true;
    //  sound();
    //}
  }
  
  void displayl() {
     //ellipse(x, y, diameter, diameter);
     
     image(mil,x,y);
  }
  
  void displayr() {
     //ellipse(x, y, diameter, diameter);
     
     image(mir,x,y);

  }
}