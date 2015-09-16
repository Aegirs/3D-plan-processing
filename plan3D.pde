// Example by Tom Igoe

import processing.serial.*;
import peasy.*;

PeasyCam cam;
Serial myPort;  // The serial port

int nbVar = 3; 
float[] data = new float[nbVar];
  
void setup() {  
  size(800, 400, P3D); 
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1000);
  
  int i = 0;
  for( i = 0 ; i < nbVar ; i++ ) {
    data[i] = 0.0;
  }
  
  // List all the available serial ports:
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[2], 115200);
  myPort.bufferUntil('\n');
}

void draw() {
 rotateY(-PI/6);
 rotateX(-PI - PI/12);
 
 background(0);
 lights();

 pushMatrix();
 
 drawRepere();
 
 noFill();
 stroke(255);
 
 // tetaX, tetaY, tetaZ 
 data[0] = PI * data[0] / 180;
 data[1] = -PI * data[1] / 180;
 data[2] = PI * data[2] / 180;
 
 drawPlanRot(data[0],data[1],data[2]);
 
 translate(0, -135, 0);
 
  // box ref
 fill(139, 108, 66);
 stroke(139, 108, 66);
 box(600,10,600);
 
 popMatrix();

}

void drawRepere() {

 stroke(255,0,0);
 line(-150, 0,0 , 150, 0, 0);
  
 fill(255, 0, 0);
 translate(150, 0, 0);
 sphere(5);
 translate(-150, 0, 0);
 
 stroke(0,255,0);
 line(0, -150,0 , 0, 150, 0);
 fill(255, 0, 0);
 translate(0,150, 0);
 sphere(5);
 translate(0,-150, 0);
 
 stroke(0,0,255);
 line(0, 0, -150, 0, 0, 150);
 fill(0, 0, 255);
 translate(0, 0,150);
 sphere(5);
 translate(0, 0, -150);
}

void drawPlanRot(float tetaX,float tetaY,float tetaZ) {
   rotateX(tetaX); 
   rotateY(tetaZ); 
   rotateZ(tetaY); 
   
   box(250,20,160);
   
   rotateX(-tetaX);
   rotateY(-tetaZ); 
   rotateZ(-tetaY); 
}


// appelle auto à chaque Serial.println sur le port serie
void serialEvent (Serial myPort) {
    // get the ASCII string:
   String inString = myPort.readStringUntil('\n');
   String str;
   
   int deb = 0, end = 0, len = inString.length();
   int i = 0;

   if ( inString != null ) {
     // trim off any whitespace:
     inString = trim(inString);
     println(inString);
 
     while( end != -1 ) {
        end = inString.indexOf(' ',deb);
        if ( end == -1 ) {
          str = inString.substring(deb);
        }
        else {
          str = inString.substring(deb,end);
        }
        
        deb = end+1;
        data[i] = Float.parseFloat(str);
        i++;
     }
   }
}

