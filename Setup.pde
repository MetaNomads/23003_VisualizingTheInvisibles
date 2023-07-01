import processing.opengl.*;
import processing.dxf.*;
import peasy.*;
import controlP5.*;



PeasyCam cam;
ControlP5 cp5;

//global
boolean neighborhoodview;

//private
int mX,mY,camX,camY;

//world size
Vector3D worldSize = new Vector3D(gridSize*11,gridSize*11,gridSize*11);

Matrix matrix;
Random rand = new Random();

void setup() 
{
  frameRate(framerate);
  smooth(antialiasing);
  ReadData();
  
  fullScreen(P3D);
  colorMode(RGB,255,255,255,100);
  
  cam = new PeasyCam(this, worldSize.y*1.5);
  cam.lookAt(worldSize.x/2,worldSize.y/2,worldSize.z/2);
  //perspective(120, 1.5, 0, 1000);
  cam.setMinimumDistance(-worldSize.y*1.5);
  cam.setMaximumDistance(worldSize.y*1.5);

  //set up the GUI
  cp5 = new ControlP5(this);
  setGui();

  //set up the Matrix
  noStroke();
  matrix = new Matrix();
  matrix.setupMatrix();
}



void draw() 
{
  background(255);
    
  matrix.run();
  matrix.render();
  
  //GUI
  if(showGui)
  {
    gui();
  }
}

public void pause()
{
  pause = !pause;
}
