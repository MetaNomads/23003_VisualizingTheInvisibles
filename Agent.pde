 class Agent {

  Vector3D loc;
  Vector3D vel;
  Vector3D acc; 
  float speed;
  float force;
  float distanceToDewey;
  color col;

  Subject subject;
  ArrayList positive;
  ArrayList positive_frequency;
  ArrayList negative;
  
  // for visualization
  ArrayList connectionHistory;
  ArrayList movementHistory;
  
  Agent(Vector3D l,Subject s) {
    acc = new Vector3D(0,0,0);
    vel = new Vector3D(random(-1,1),random(-1,1),random(-1,1));
    loc = l.copy();
    speed = maxspeed;
    force = maxforce;
    distanceToDewey = 0;
    col = tone;
    subject = s;
    
    positive = new ArrayList();
    positive_frequency = new ArrayList();
    negative = new ArrayList();
    
    connectionHistory = new ArrayList();
    movementHistory = new ArrayList();
  }
  
  void run(ArrayList agents) 
  {
    chaseDeweyAttractor();
    updateNeighbors(agents);
    swarmForce(positive, positive_frequency,negative);
    if (pause == false) updateLocation();
    borders();
    if(showAgent)
    {
      render();
    }
  }

  
  
  // update location
  void updateLocation() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(speed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.setXYZ(0,0,0);
  }

  void chaseDeweyAttractor() 
  {
    distanceToDewey = 0;
    int count = 0;
    for (int i = 0 ; i < this.subject.A_dewey.size(); i++) 
    {
      DeweyAttractor attractor = matrix.deweyAttractors.get((int) subject.A_dewey.get(i));
      //move toward dewey point, slow down as move closer
      acc.add(steer(attractor.loc,true));
      Vector3D tem = new Vector3D(loc.x-attractor.loc.x, loc.y-attractor.loc.y, loc.z-attractor.loc.z);
      distanceToDewey += tem.magnitude();
      count += 1;
    }
    distanceToDewey = distanceToDewey/count;
  }

  void updateNeighbors(ArrayList agents) 
  {
    // store former neighbors
    positive.clear();
    positive_frequency.clear();
    negative.clear();
    
    for (int i = 0 ; i < agents.size(); i++) 
    {   
      Agent other = (Agent) agents.get(i);
      Vector3D d = new Vector3D();
      d = d.sub(loc, other.loc);
      // If the distance is greater than 0 and less than search distance (0 when you are yourself)
      if ((d.length() > 0) && (d.length() < searchRadius))
      {
        if ((this.subject.A_subject.contains(other.subject.id)))
        {
          positive.add(other);
          positive_frequency.add(this.subject.A_subject_frequency.get(this.subject.A_subject.indexOf(other.subject.id)));
        }
        
        else if ((this.subject.B_subject.contains(other.subject.id)))
        {
          positive.add(other);
          positive_frequency.add(this.subject.B_subject_frequency.get(this.subject.B_subject.indexOf(other.subject.id)));
        }
        
        else {negative.add(other);}
      }
    }
  }

  
  
  // accumulate a new acceleration each time based on three rules
  void swarmForce(ArrayList positive, ArrayList freq, ArrayList negative) 
  {
    Vector3D sep = new Vector3D(0,0,0);
    Vector3D ali = new Vector3D(0,0,0);
    Vector3D coh = new Vector3D(0,0,0);
    Vector3D rand = new Vector3D(random(-1,1),random(-1,1),random(-1,1)); // Random
    int count_sep = 0;
    int count_coh = 0;
    
    if (positive.size()>0)
    {
      for (int i = 0 ; i < positive.size(); i++) 
      {
        Agent other = (Agent) positive.get(i);
        float d = loc.distance(loc,other.loc);
        Vector3D diff = loc.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        
        if (subject.A_subject.contains(other.subject.id))
        {
          // Alignment
          // align to nearby agents
          int f = (int) freq.get(i);
          diff.mult(f);        // Weight by frenquency
          ali.add(other.vel);
          
          // Cohesion
          // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
          coh.add(other.loc);
          count_coh++;
        }
      }
    }
    
    // Separation
    // if nearby agents has no co-occurrent relation, steer away
    if (negative.size()>0)
    {
      for (int i = 0 ; i < negative.size(); i++) 
      {
        Agent other = (Agent) negative.get(i);
        float d = loc.distance(loc,other.loc);
        Vector3D diff = loc.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        
        if (!subject.A_subject.contains(other.subject.id))
        {
          // Calculate vector pointing away from neighbor
          sep.add(diff);
          count_sep++;
        }
      }
    }

    // Average -- divide by how many
    if (count_sep > 0) sep.div((float)count_sep);
    if (count_coh > 0)
    {
      coh.div((float)count_coh); 
      ali.div((float)count_coh);
      ali.limit(force);
    }
    coh = steer(coh,false);  // Steer towards the location   
    // weight these forces
    sep.mult(separationForce);
    ali.mult(alignmentForce);
    coh.mult(cohesionForce);
    rand.mult(randomForce);
    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
    acc.add(rand); 
  }
  
  void render() 
  {
    float ratio = (float) Math.pow(1-distanceToDewey/(gridSize*11),2);
    col = color (204*ratio,51*ratio,0);
    strokeWeight(lineweight*1.25);
    stroke(col);
    point(loc.x,loc.y,loc.z);
    
    //create path lines
    if (showPath == true) 
    {
      if (pause == false)
      {
        ArrayList movementList = new ArrayList();
        movementList.add(loc.x);
        movementList.add(loc.y);
        movementList.add(loc.z);
        movementList.add(col);
        addToMovementHistory(movementList);
      }
      for (int i = 0 ; i < this.movementHistory.size(); i++)
      {        
        ArrayList c1 = (ArrayList) movementHistory.get(i);
        strokeWeight(lineweight/1.5);
        stroke((color)c1.get(3),60*i/movementHistory.size());
        point((float)c1.get(0),(float)c1.get(1),(float)c1.get(2));
      }
    }
        
    // draw connection line between agent and dewey attractor
    if (drawDeweyConnection == true) 
    {
      strokeWeight(lineweight/10);
      stroke(col);
      for (int i = 0 ; i < this.subject.A_dewey.size(); i++)
      {
        DeweyAttractor d = matrix.deweyAttractors.get((int) subject.A_dewey.get(i));
        d.addConnectionNumber();
        line(loc.x,loc.y,loc.z,d.loc.x,d.loc.y,d.loc.z);
      }
    }

    
    //draw neighbor connection lines
    if (drawCooccurrentConnection == true) 
    {
      noFill();
      strokeWeight(lineweight*3);
      //create connection lines
      if (pause == false)
      {
        ArrayList connectionList = new ArrayList();
        for (int i = 0 ; i < this.positive.size(); i++)
        {
          Agent a = (Agent) positive.get(i); 
          float r1 = 1-this.distanceToDewey/(gridSize*11);
          float r2 = 1-a.distanceToDewey/(gridSize*11);
          float r = (float) Math.pow((r1+r2)/2,2);
          color tem = color (204*r,51*r,0);
          ArrayList d = new ArrayList();
          d.add(loc.x);
          d.add(loc.y);
          d.add(loc.z);
          d.add(a.loc.x);
          d.add(a.loc.y);
          d.add(a.loc.z);
          d.add(tem);
          connectionList.add(d);
        }
        addToConnectionHistory(connectionList);
      }

      for (int i = 0 ; i < this.connectionHistory.size(); i++)
      {
        ArrayList c1 = (ArrayList) connectionHistory.get(i);
        for (int m = 0 ; m < c1.size(); m++)
        {
          ArrayList c2 = (ArrayList) c1.get(m);
          stroke((color) c2.get(6),20*i/connectionHistory.size());
          line((float)c2.get(0),(float)c2.get(1),(float)c2.get(2),(float)c2.get(3),(float)c2.get(4),(float)c2.get(5));
        }
      }
    }
  }
  
  
  
  // Wraparound
  void borders() 
  {
    if (loc.x < 0) loc.x = worldSize.x;
    if (loc.y < 0) loc.y = worldSize.y;
    if (loc.z < 0) loc.z = worldSize.z;
    if (loc.x > worldSize.x) loc.x = 0;
    if (loc.y > worldSize.y) loc.y = 0;
    if (loc.z > worldSize.z) loc.z = 0;
  }


  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  Vector3D steer(Vector3D target, boolean slowdown) 
  {
    Vector3D steer;  // The steering vector
    Vector3D desired = target.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) 
    {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- speed)
      if ((slowdown) && (d < gridSize)) desired.mult(speed*(d/gridSize));
      else desired.mult(speed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(force);  // Limit to maximum steering force
    }
    else 
    {
      steer = new Vector3D(0,0,0);
    }
    return steer;
  }
  
  void addToConnectionHistory (ArrayList v)
  {
    if(connectionHistory.size() < connectionHistoryNumber) 
    {
      connectionHistory.add(v);
    }
    else if (connectionHistory.size() == connectionHistoryNumber) 
    {
      connectionHistory.remove(0);
      connectionHistory.add(v);
    }
  }
  
  void addToMovementHistory (ArrayList v)
  {
    if(movementHistory.size() < movementHistoryNumber) 
    {
      movementHistory.add(v);
    }
    else if (movementHistory.size() == movementHistoryNumber) 
    {
      movementHistory.remove(0);
      movementHistory.add(v);
    }
  }
}
