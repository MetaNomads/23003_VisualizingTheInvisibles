import java.lang.*;

color accent = color (204,51,0);
color tone = color (0,0,0);
color noise = color (255,255,153);

class Matrix 
{
  ArrayList<DeweyAttractor> deweyAttractors = new ArrayList<DeweyAttractor>(); // An arraylist for all the deweyAttractors
  ArrayList<Agent> agents = new ArrayList<Agent>(); // An arraylist for all the agents
  
  void run() 
  {
    for (int i = 0; i < agents.size(); i++) 
    {
      Agent b = (Agent) agents.get(i);  
      b.run(agents);  // Passing the entire list of agents to each agent individually
    }
  }
  
  
  //initiate Agents and DeweyAttractors
  void setupMatrix() 
  {
    //initiate Agents
    for (int i = 0; i < agentNumber; i++) 
    {
      agents.add(new Agent(new Vector3D(random(gridSize*11),random(gridSize*11),random(gridSize*11)),subjects.get(rand.nextInt(subjects.size()))));
    }
       
    //initiate DeweyAttractors
    int x;
    int y;
    int z;
    for (int m = 0; m < deweyDict.size(); m++)
    {
      int d = deweyDict.get(m).id;
      if (d < 10)
      {
        x = 0;
        y = 0; 
        z = d;
      }
      else if(d >= 10 & d < 100)
      {
        String number = Integer.toString(d); 
        x = 0; 
        y = Integer.parseInt(number.substring(0,1)); 
        z = Integer.parseInt(number.substring(1,2));
      }
      else
      {
        String number = Integer.toString(d); 
        x = Integer.parseInt(number.substring(0,1)); 
        y = Integer.parseInt(number.substring(1,2)); 
        z = Integer.parseInt(number.substring(2,3));
      }
      Vector3D poc = new Vector3D(x*gridSize+gridSize,y*gridSize+gridSize,z*gridSize+gridSize);   
      DeweyDict dd = deweyDict.get(d);
      deweyAttractors.add(new DeweyAttractor(poc, dd));
    }


        
        
    //calculate connectionNumber for each DeweyAttractor
    for (int i = 0; i < agents.size(); i++)
    {  
      Agent a = (Agent) agents.get(i); 
      for (int k = 0 ; k < a.subject.A_dewey.size(); k++)
      {
        DeweyAttractor de = matrix.deweyAttractors.get((int) a.subject.A_dewey.get(k));
        de.addConnectionNumber();
      }
    }
    int max = 1;
    for (int i = 0; i < deweyAttractors.size(); i++)
    {
      DeweyAttractor da = deweyAttractors.get(i); 
      if (da.connectionNumber > max)
      {
        max = da.connectionNumber;
      }
    }
    
    for (int i = 0; i < deweyAttractors.size(); i++)
    {
      DeweyAttractor da = deweyAttractors.get(i); 
      //set size for each deweyAttractor
      float temp1 = remap(da.connectionNumber, 0, max, 0,1);
      da.scale = (float) Math.pow((float)temp1, 0.6);
      //set color for each deweyAttractor
      float temp2 = remap(da.connectionNumber, 0, max, 0.3,1);
      da.col = color(0,0,0);
    } 
    
  }
   
  void render() 
  {
    for (int i = 0; i < deweyAttractors.size(); i++) 
    {
      DeweyAttractor p = (DeweyAttractor) deweyAttractors.get(i);  
      p.render(); 
    }
    if (drawFrame)
    {
      pushMatrix();
      noFill();
      translate(worldSize.x/2.0,worldSize.y/2.0,worldSize.z/2.0);
      strokeWeight(0.5);
      stroke(0,0,0);
      box(worldSize.x,worldSize.y,worldSize.z);
      popMatrix();
    }

  }
}

public static float remap(float val, float in1, float in2, float out1, float out2)
    {
        return out1 + (val - in1) * (out2 - out1) / (in2 - in1);
    }
