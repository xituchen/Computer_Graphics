class Slimu {
  public PShape original;
  public PShape thing;
  public int numVerts;
  public float dx, dy, dz;
  public int horizontal, vertical;
  private PVector center;
  private PVector select;
  private IntList circle;
  private IntList apex;
  private int upper, lower, left, right, front;
  private PMatrix3D rot;
  private PrintWriter doVerts;
  
  public Slimu(PShape s) {
    thing = s;
    numVerts = thing.getVertexCount();
    original = createShape();
    original.beginShape(TRIANGLES);
    
    for(int i=0; i<numVerts; i++) {
      PVector v = thing.getVertex(i);
      original.vertex(v.x, v.y, v.z);
    }
    
    original.endShape(CLOSE);
    
    dx = 0.0;
    dy = 0.0;
    dz = 0.0;
    upper = 0;
    lower = 0;
    left = 0;
    right = 0;
    front = 0;
    horizontal = 300;
    vertical = 200;
    
    center();
  }
  
  public void display() {
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    rot = new PMatrix3D();
    rot.rotateX(radians(dx));
    rot.rotateY(radians(dy));
    rot.rotateZ(radians(dz));
    
    for (int i=0; i<numVerts; i++) {
      PVector n = new PVector();
      rot.mult(thing.getVertex(i), n);
      thing.setVertex(i, n);
    }
    
    shape(thing);
  }
  
  public void reset() {
    dx = 0.0;
    dy = 0.0;
    dz = 0.0;
    
    for (int i=0; i<numVerts; i++) {
      PVector n = original.getVertex(i);
      thing.setVertex(i, n);
    }
  }
  
  public void getAllTheVerts() {
    doVerts = createWriter("slime_verts.txt");
    
    for (int i=0; i<thing.getChildCount(); i++) {
      PShape child = thing.getChild(i);
      for (int j=0; j<child.getVertexCount(); j++) {
        PVector v = child.getVertex(j);
        String aVert = str(v.x) + " " + str(v.y) + " " + str(v.z) + " ";
        doVerts.println(aVert);
      }
    }
    doVerts.flush();
    doVerts.close();
  }
  
  public void getGuys(int x, int y, boolean dowhat) {
    center();
    PVector pointing = new PVector(x-width/2, height-y-height/2);
    int you = 0;
    float min = 1000;
    ArrayList<PVector> neighbors = new ArrayList<PVector>();
    circle = new IntList();
    apex = new IntList();

    for (int i=0; i<numVerts; i++) {
      PVector current = thing.getVertex(i);
      PVector justaplane = new PVector(current.x, current.y);
      float d = justaplane.dist(pointing);
      if (d<min && current.z<thing.getVertex(left).z) {
          you = i;
          min = d;
      }
    }
    
    select = thing.getVertex(you);
    int loop = 0;
    println("where i actually meant: ", pointing);
    println("where i hit: ", select);
    println("minimum distance: ", select.dist(pointing));
    println();
    
    
    while (loop<numVerts) {
      boolean gotcha = false;
      
      for (int j=0; j<3; j++) {
        if (thing.getVertex(loop+j).equals(select)) {
          apex.append(loop+j);
          gotcha = true;
          break;
        }
      }
      
      if (gotcha == true) {
        ArrayList<PVector> temp = new ArrayList<PVector>();
        temp.add(thing.getVertex(loop));
        temp.add(thing.getVertex(loop+1));
        temp.add(thing.getVertex(loop+2));
        for (int k=0; k<3; k++) {
          // if vertex is not the selected one and is not in the array yet, put it in
          if (temp.get(k).equals(select) == false && neighbors.contains(temp.get(k)) == false) {
            neighbors.add(temp.get(k));
            circle.append(loop+k);
          }
        }
      }
      loop += 3;
    }
    
    for (int a=0; a<neighbors.size(); a++) {
      println(neighbors.get(a));
    }
    
    deform(dowhat);
  }
  
  private void center() {
    float sum_x = 0.0;
    float sum_y = 0.0;
    float sum_z = 0.0;

    for (int i=0; i<numVerts; i++) {
      PVector n = thing.getVertex(i);
      sum_x += n.x;
      sum_y += n.y;
      sum_z += n.z;
      if (n.x > thing.getVertex(right).x) {right = i;}
      if (n.x < thing.getVertex(left).x) {left = i;}
      if (n.y > thing.getVertex(upper).y) {upper = i;}
      if (n.y < thing.getVertex(lower).y) {lower = i;}
      if (n.z < thing.getVertex(upper).z) {front = i;}
    }
    sum_x = sum_x/numVerts;
    sum_y = sum_y/numVerts;
    sum_z = sum_z/numVerts;
    
    center = new PVector(sum_x, sum_y, sum_z);
  }
  
  private IntList getJustMe(PVector me) {
    IntList allMe = new IntList();
    for (int i=0; i<numVerts; i++) {
      if (thing.getVertex(i).equals(me)) {
        allMe.append(i);
      }
    }
    return allMe;
  }
  
  private void deform(boolean dowhat) {
    println("selected: ", select);
    println("oh really? ", apex);
    for (int i=0; i<apex.size(); i++) {
      println("   ", thing.getVertex(apex.get(i)));
    }
    
    float a = select.x - center.x;
    float b = select.y - center.y;
    float c = select.z - center.z;

    PVector delta = new PVector(a, b, c);
    delta.normalize();
    delta.mult(15);
    if (dowhat == false) {
      delta.mult(-1);
    }
    
    println("change: ", delta);
    
    select.add(delta);
    
    for (int i=0; i<apex.size(); i++) {
      thing.setVertex(apex.get(i), select);
    }
    
    for (int j=0; j<circle.size(); j++) {
      PVector k = thing.getVertex(circle.get(j));
      IntList sobeit = getJustMe(k);
      float d = k.x - center.x;
      float e = k.y - center.y;
      float f = k.z - center.z;
  
      PVector delt = new PVector(d, e, f);
      delt.normalize();
      delt.mult(10);
      if (dowhat == false) {
        delt.mult(-1);
      }
      
      println("change: ", delt);
      
      k.add(delt);
      
      for (int p=0; p<sobeit.size(); p++) {
        thing.setVertex(sobeit.get(p), k);
      }
    }
  }
  
}
