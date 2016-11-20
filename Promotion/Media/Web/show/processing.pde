/* @pjs preload="bg.png,UFO.png,b1.png,mir.png,boom.png"; */
PImage img;
PImage ufo;
PImage b1;
PImage expl;
PImage mir;
float friction = -0.9;
float g = 0.7;


ArrayList<Ball> balls;
ArrayList<Ball2> balls2;
int ballid;
int ballid2;
boolean weapon = false;

void setup() {
  size(960, 720);
  img = loadImage("bg.png");
  ufo = loadImage("UFO.png");
  b1 = loadImage("b1.png");
  mir = loadImage("mir.png");
 expl = loadImage("boom.png");
  
  balls = new ArrayList<Ball>();
  ballid = 0;
  
  balls2 = new ArrayList<Ball2>();
  ballid2 = 0;
}

void draw(){
	image(img, 0, 0, 960, 720);
	image(ufo, mouseX, mouseY, 90, 90);


                    for(int i = 0 ; i < balls.size(); i++){
                          balls.get(i).move();
                          //balls.get(i).collide();
                          balls.get(i).display(); 
            
                      }
                      
                      for(int i = 0 ; i < balls.size(); i++){                
                          if(balls.get(i).die){
                             image(expl, balls.get(i).x,balls.get(i).y, 80, 80);
                             balls.remove(i);
                           }      
                      }

                 
                 for(int i = 0 ; i < balls2.size(); i++){
                        balls2.get(i).moveright();                        
                        balls2.get(i).displayr();                                             
             
                     }
                      
                     for(int i = 0 ; i < balls2.size(); i++){                
                         if(balls2.get(i).die){
                            balls2.remove(i);
                          }      
                     }
    textSize(20);
              text("Press w to change weapon ", 70, 60); // Display the text to show where you are in the pipeline   
              
              
              //---------------------------boom-------------------------//
              if(weapon){ 
                  image(b1, 10, 40 , 50, 50);
              } 
              
              //---------------------------missile-------------------------//
              else{
                  
                  image(mir, 10, 50, 50, 30);  
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

void keyReleased() {
  
  if (key == 'w' || key == 'W') {    
     weapon = !weapon;
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
     image(b1,x,y, 40, 40);
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

  
  void displayr() {
     //ellipse(x, y, diameter, diameter);
     
     image(mir,x,y, 40, 40);

  }
}