class DeweyAttractor 
{
  Vector3D loc;
  float scale;
  float saturation;
  color col;
  DeweyDict deweyDict;
  int connectionNumber;
  
  // constructor
  DeweyAttractor(Vector3D l, DeweyDict d) 
  {
    loc = l;
    scale = 1.0;
    col = color(204,51,0);
    deweyDict = d;
    connectionNumber = 0;
  }
  
  public DeweyDict getDeweyDict()
  {
    return deweyDict;
  }
  
  public void addConnectionNumber()
  {
    connectionNumber++;
  }
  
  void render() 
  {  
    float pointSize = (float) lineweight*scale*10;
    strokeWeight(pointSize);
    stroke(col);
    point(loc.x,loc.y,loc.z);
    //display text
    float mouseObjectDistance = sq(mouseX-screenX(loc.x,loc.y,loc.z))+sq(mouseY-screenY(loc.x,loc.y,loc.z));
    if(mouseObjectDistance <20)
    {
      // add a bigger point
      strokeWeight(pointSize*1.5);
      fill(col);
      point(loc.x,loc.y,loc.z);
      // add text label
      textMode(SHAPE);
      // if the distance is close, make the textsize smaller
      if(cam.getDistance()<100){textSize(8);}
      // if the distance is far, make the textsize bigger
      else{textSize(12);}
      
      
      pushMatrix();
      translate(loc.x,loc.y,loc.z);
      float[] rotations = cam.getRotations();
      rotateX(rotations[0]);
      rotateY(rotations[1]);
      rotateZ(rotations[2]);
      text(this.getDeweyDict().name,pointSize/2+2,1.5,0);
      popMatrix();
    }
  } 
}
