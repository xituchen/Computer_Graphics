class Slimu {
  public PShape thing;
  public int numVerts;
  public float rX, rY, rZ;
  public float dx, dy, dz;
  public int horizontal, vertical;
  private PVector center;
  private PVector select;
  private IntList circle;
  private IntList apex;
  private PMatrix3D rot;
  private PrintWriter doVerts;
  
  public Slimu(PShape s) {
    thing = s;
    rX = 0.0;
    rY = 0.0;
    rZ = 0.0;
    dx = 0.0;
    dy = 0.0;
    dz = 0.0;
    horizontal = 300;
    vertical = 200;
    numVerts = thing.getVertexCount();
    
    float sum_x = 0.0;
    float sum_y = 0.0;
    float sum_z = 0.0;

    for (int i=0; i<numVerts; i++) {
      sum_x += thing.getVertex(i).x;
      sum_y += thing.getVertex(i).y;
      sum_z += thing.getVertex(i).z;
    }
    sum_x = sum_x/numVerts;
    sum_y = sum_y/numVerts;
    sum_z = sum_z/numVerts;
    
    center = new PVector(sum_x, sum_y, sum_z);
  }
  
  public void display() {
    background(90, 140, 150);
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
  
  public void getGuys(int x, int y) {
    center();
    PVector pointing = new PVector(x-width/2, height-y-height/2, center.z);
    int you = 0;
    float min = 1000.0;
    ArrayList<PVector> neighbors = new ArrayList<PVector>();
    circle = new IntList();
    apex = new IntList();

    for (int i=0; i<numVerts; i++) {
      float d = thing.getVertex(i).dist(pointing);
      if (d<min) {
        you = i;
        min = d;
      }
    }
    
    select = thing.getVertex(you);
    circle.append(you);
    int loop = 0;
    println("where i actually meant: ", pointing);
    println("where i hit: ", select);
    println("minimum distance: ", min);
    println();
    
    
    while (loop<numVerts) {
      boolean gotcha = false;
      
      for (int j=0; j<3; j++) {
        if (thing.getVertex(loop+j).equals(select)) {
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
          if (temp.get(k).equals(select)) {
            apex.append(k);
          }
          else if (!neighbors.contains(temp.get(k))) {
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
    
    extrude();
  }
  
  public void center() {
    float sum_x = 0.0;
    float sum_y = 0.0;
    float sum_z = 0.0;

    for (int i=0; i<numVerts; i++) {
      sum_x += thing.getVertex(i).x;
      sum_y += thing.getVertex(i).y;
      sum_z += thing.getVertex(i).z;
    }
    sum_x = sum_x/numVerts;
    sum_y = sum_y/numVerts;
    sum_z = sum_z/numVerts;
    
    center = new PVector(sum_x, sum_y, sum_z);
  }
  
  public void extrude() {
    float a = select.x - center.x;
    float b = select.y - center.y;
    float c = select.z - center.z;

    PVector delta = new PVector(a, b, c);
    delta.normalize();
    delta.mult(50);
    
    println("change: ", delta);
    
    select.add(delta);
    
    for (int i=0; i<apex.size(); i++) {
      thing.setVertex(apex.get(i), select);
    }
    
    for (int j=0; j<circle.size(); j++) {
      PVector k = thing.getVertex(circle.get(j));
      float d = k.x - center.x;
      float e = k.y - center.y;
      float f = k.z - center.z;
  
      PVector delt = new PVector(d, e, f);
      delt.normalize();
      delt.mult(20);
      
      println("change: ", delt);
      
      k.add(delt);
      thing.setVertex(circle.get(j), k);
    }
  }
  
}
