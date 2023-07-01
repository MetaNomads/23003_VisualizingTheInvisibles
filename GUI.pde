//GUI
//***adjust this number based on your hardware***
int agentNumber = 1000;
int framerate = 120;
int antialiasing = 8 ;
//***adjust this number based on your hardware***

//matrix parameters
boolean pause = false;
boolean showGui = true;
boolean showAgent = true;
boolean showPath = true;
boolean drawCooccurrentConnection = true;
boolean drawDeweyConnection = true;
boolean drawFrame = true;
color bcolor = color(220,220,220);
color fcolor = color(128,128,128);
float lineweight = 2f;
float gridSize = 50;

//agent parameters
float maxforce = 0.05f;    // Maximum steering force
float maxspeed = 1.0f;    // Maximum speed
float searchRadius = 100;

int connectionHistoryNumber = 150;
int movementHistoryNumber = 50;

//force parameters
float separationForce = 0.8;
float alignmentForce = 1;
float cohesionForce = 0.4;
float randomForce = 0.2;
float deweyAttractForce = 1f;


float X = 50;
float distance =30;
int index = 1;
void setGui(){
  // Set up the fonts
  PFont pfont = createFont("Arial", 16,true);
  ControlFont font = new ControlFont(pfont, 12);

  
  // draw the GUI
  cp5.addSlider("lineweight")
  .setColorLabel(color(0,0,0))
  .setRange(1, 5)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);

  index++;  
  cp5.addSlider("searchRadius")
  .setColorLabel(color(0,0,0))
  .setRange(0, 200)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);

  index++;  
  cp5.addSlider("separationForce")
  .setColorLabel(color(0,0,0))
  .setRange(0, 1)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  cp5.addSlider("alignmentForce")
  .setColorLabel(color(0,0,0))
  .setRange(0, 1)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  cp5.addSlider("cohesionForce")
  .setColorLabel(color(0,0,0))
  .setRange(0, 1)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  cp5.addSlider("randomForce")
  .setColorLabel(color(0,0,0))
  .setRange(0, 1)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  cp5.addSlider("deweyAttractForce")
  .setColorLabel(color(0,0,0))
  .setRange(0, 1)
  .setPosition(X, distance*index)
  .setFont(font)
  .setSize(100,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);

int extraSpace = 5;
int ind = 0;
  index++; 
  cp5.addToggle("drawFrame")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);  

  index++; 
  ind++;
  cp5.addToggle("showAgent")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
  
  index++; 
  ind++;
  cp5.addToggle("showPath")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  ind++;
  cp5.addToggle("drawCooccurrentConnection")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  index++;  
  ind++;
  cp5.addToggle("drawDeweyConnection")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);

  index++;  
  ind++;
  cp5.addToggle("pause")
  .setColorLabel(color(0,0,0))
  .setPosition(X, distance*index+extraSpace*ind)
  .setFont(font)
  .setSize(25,15)  
  .setColorValue(color(0,0,0))
    .setColorForeground(fcolor)
    .setColorBackground(bcolor);
    
  cp5.setAutoDraw(false);
}

// A function for draw GUI correctly
void gui(){
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
  
  // Deactivate the camera when the mouse is within the GUI area
  if((mouseX<360)&(mouseY<distance*(index+2))) {cam.setActive(false);}
  else{cam.setActive(true);}
}

void keyPressed() 
{
  if (key == 32) showGui = !showGui;
  else if (key == 's')  saveFrame("frame"+"-####.png");
}
