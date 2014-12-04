import nervoussystem.obj.*;
import java.util.Map;

float dx, dy, dz;
int action = 1;
boolean paause;
PShape slime;
PShader toon;
Pair smooth, pucker, puff, pinch, reset, pause, save;
Slimu arf;

String tips = "AD - rotate x WS - rotate y QE - rotate z scroll - scale";

void setup() {
  size(1280, 860, P3D);
  
  dx = 0.0;
  dy = 0.5;
  dz = 0.0;
  
//  parse vertex data
  String[] allData = loadStrings("slime_vert.txt");
  String[] allNorm = loadStrings("slime_norm.txt");
  String[] allTex = loadStrings("slime_tex.txt");
  String[] indices = loadStrings("slime_index.txt");
  ArrayList<PVector> verts = new ArrayList<PVector>();
  ArrayList<PVector> txtrs = new ArrayList<PVector>();
  ArrayList<PVector> norms = new ArrayList<PVector>();
  HashMap<PVector, PVector> vertToTex = new HashMap<PVector, PVector>();
  PImage img = loadImage("pattern.png");

  for (int i=0; i<allNorm.length; i++) {
    String[] aNorm = trim(split(allNorm[i], ' '));
    PVector n = new PVector(float(aNorm[0]), float(aNorm[1]), float(aNorm[2]));
    norms.add(n);
    if (i<allData.length) {
      String[] aVert = trim(split(allData[i], ' '));
      PVector v = new PVector(float(aVert[0]), float(aVert[1]), float(aVert[2]));
      verts.add(v);
    }
    if (i<allTex.length) {
      String[] aTex = trim(split(allTex[i], ' '));
      PVector t = new PVector(float(aTex[0]), float(aTex[1]));
      txtrs.add(t);
    }
  }
  
  stroke(255);
  fill(150, 180, 180, 85);
  slime = createShape();
  slime.beginShape(TRIANGLES);
  slime.textureMode(NORMAL);
  slime.texture(img);
  
  int txtr = 0;
  
  for (int i=0; i<indices.length; i++) {
    String[] index = trim(split(indices[i], ' '));
    ArrayList<Pair> temp = new ArrayList<Pair>();
    
    for (int j=0; j<index.length; j++) {
      String[] guy = trim(split(index[j], '/'));
      Pair m = new Pair(int(guy[0])-1, int(guy[1])-1, int(guy[2])-1);
      temp.add(m);
    }
    
    PVector n1 = norms.get(temp.get(0).z);
    PVector t1 = txtrs.get(temp.get(0).y);
    PVector v1 = verts.get(temp.get(0).x);
    slime.normal(n1.x, n1.y, n1.z);
    slime.vertex(v1.x, v1.y, v1.z, t1.x, t1.y);
    
    PVector n2 = norms.get(temp.get(1).z);
    PVector t2 = txtrs.get(temp.get(1).y);
    PVector v2 = verts.get(temp.get(1).x);
    slime.normal(n2.x, n2.y, n2.z);
    slime.vertex(v2.x, v2.y, v2.z, t2.x, t2.y);
    
    PVector n3 = norms.get(temp.get(2).z);
    PVector t3 = txtrs.get(temp.get(2).y);
    PVector v3 = verts.get(temp.get(2).x);
    slime.normal(n3.x, n3.y, n3.z);
    slime.vertex(v3.x, v3.y, v3.z, t3.x, t3.y);
  }
  
  slime.endShape(CLOSE); 
  arf = new Slimu(slime);
  arf.dx = dx;
  arf.dy = dy;
  arf.dz = dz;
  
  paause = false;
  
  smooth = new Pair(1200, 80);
  pucker = new Pair(1200, 240);
  puff = new Pair(1200, 320);
  pinch = new Pair(1200, 160);
  
  pause = new Pair(1200, 620);
  save = new Pair(1200, 700);
  reset = new Pair(1200, 780);
   
  frameRate(24);
}


void draw() {
  background(50);
  
  textSize(12);
  fill(255);
  text(tips, 80, 780, 90, 90);
  stroke(255);

  ellipseMode(CENTER);
  
  //  smooth button
  if (inCircle(smooth.x, smooth.y)) {
    textSize(12);
    fill(255);
    text("smooth", 1130, smooth.y);
    fill(220, 200, 120);
  }
  else if (action == 3) {fill(150, 110, 190);}
  else {noFill();}
  ellipse(smooth.x, smooth.y, 50, 50);
  
  //  pinch button
  if (inCircle(pinch.x, pinch.y)) {
    textSize(12);
    fill(255);
    text("pinch", 1140, pinch.y);
    fill(220, 200, 120);
  }
  else if (action == 4) {fill(120, 150, 200);}
  else {noFill();}
  ellipse(pinch.x, pinch.y, 50, 50);
  
  //  pucker button
  if (inCircle(pucker.x, pucker.y)) {
    textSize(12);
    fill(255);
    text("pucker", 1132, pucker.y);
    fill(220, 200, 120);
  }
  else if (action == 2) {fill(120, 185, 160);}
  else {noFill();}
  ellipse(pucker.x, pucker.y, 50, 50);
  
  //  puff button
  if (inCircle(puff.x, puff.y)) {
    textSize(12);
    fill(255);
    text("puff", 1148, puff.y);
    fill(220, 200, 120);
  }
  else if (action == 1) {fill(160, 200, 120);}
  else {noFill();}
  ellipse(puff.x, puff.y, 50, 50);
  
  //  pause button
  if (inCircle(pause.x, pause.y)) {
    textSize(12);
    fill(255);
    if (!paause) {text("pause", 1135, pause.y);}
    else {text("play", 1145, pause.y);}
    fill(220, 200, 120);
  }
  else {noFill();}
  ellipse(pause.x, pause.y, 50, 50);
  if (!paause) {
    noStroke();
    fill(255);
    rectMode(CENTER);
    rect(pause.x, pause.y, 20, 20);
  }
  else {
    noStroke();
    fill(255);
    beginShape();
    vertex(pause.x-8, pause.y-10);
    vertex(pause.x+12, pause.y);
    vertex(pause.x-8, pause.y+10);
    endShape(CLOSE);
  }
  
  stroke(255);
  
  //  save button
  if (inCircle(save.x, save.y)) {
    textSize(12);
    fill(255);
    text("save", 1143, save.y);
    fill(230, 160, 120);
  }
  else {noFill();}
  ellipse(save.x, save.y, 50, 50);
  
  //  reset button
  if (inCircle(reset.x, reset.y)) {
    textSize(12);
    fill(255);
    text("reset", 1140, reset.y);
    fill(185, 100, 140);
  }
  else {noFill();}
  ellipse(reset.x, reset.y, 50, 50);
  
  lights();
  arf.display();
}

// rotation
void keyPressed() {
  if (!paause) {
    if (key == 'w') {
      dx += 0.5;
    }
    else if (key == 's') {
      dx -= 0.5;
    }
    else if (key == 'a') {
      dy += 0.5;
    }
    else if (key == 'd') {
      dy -= 0.5;
    }
    else if (key == 'q') {
      dz += 0.5;
    }
    else if (key == 'e') {
      dz -= 0.5;
    }
    arf.dx = dx;
    arf.dy = dy;
    arf.dz = dz;
  }
}

// commands
void mousePressed() {
  if (inCircle(reset.x, reset.y)) {
    arf.reset();
    dx = 0.0;
    dy = 0.5;
    dz = 0.0;
    if (paause == true) {
      arf.dx = 0;
      arf.dy = 0;
      arf.dz = 0;
    }
  }
  else if(inCircle(pucker.x, pucker.y)) {
    action = 2;
  }
  else if(inCircle(puff.x, puff.y)) {
    action = 1;
  }
  else if(inCircle(smooth.x, smooth.y)) {
    action = 3;
  }
  else if(inCircle(pinch.x, pinch.y)) {
    action = 4;
  }
  else if(inCircle(pause.x, pause.y)) {
    paause = !paause;
    if (paause) {
      arf.dx = 0;
      arf.dy = 0;
      arf.dz = 0;
    }
    else {
      arf.dx = dx;
      arf.dy = dy;
      arf.dz = dz;
    }
  }
  else if(inCircle(save.x, save.y)) {
    println("w: ", width);
    println("h: ", height);
    OBJExport obj = (OBJExport)createGraphics(300, 200, "nervoussystem.obj.OBJExport", "test.obj");
    obj.setColor(true);
    obj.beginDraw();
    drawSlime(obj);
    obj.endDraw();
    obj.dispose();
  }
}

// function that creates shape to be saved
void drawSlime(PGraphics pg) {
  pg.beginShape(TRIANGLES);
  pg.fill(150, 180, 180);
  for (int i=0; i<arf.numVerts; i++) {
    PVector n = arf.thing.getVertex(i);
    pg.vertex(n.x, n.y, n.z);
  }
  pg.endShape();
}

void mouseDragged() {
  if (!inCircle(reset.x, reset.y) && 
      !inCircle(smooth.x, smooth.y) && 
      !inCircle(pucker.x, pucker.y) && 
      !inCircle(puff.x, puff.y) &&
      !inCircle(pinch.x, pinch.y) &&
      !inCircle(pause.x, pause.y) &&
      !inCircle(save.x, save.y)) {
    arf.justDoIt(pmouseX, pmouseY, action);
  }
}

// check if mouse is in a circle button
boolean inCircle(int x, int y) {
  float dX = x - mouseX;
  float dY = y - mouseY;
  if (sqrt(sq(dX) + sq(dY)) < 50) {
    return true;
  }
  return false;
}

class Pair{
  public int x;
  public int y;
  public int z;
  
  public Pair(int a, int b) {
    x = a;
    y = b;
    z = 0;
  }
  
  public Pair(int a, int b, int c) {
    x = a;
    y = b;
    z = c;
  }
}
import java.awt.event.*;

class Slimu implements MouseWheelListener{
  public PShape thing;
  public float dx, dy, dz;
  public float scaler;
  public int numVerts;
  private PShape original;
  private PVector center;
  private PVector select;
  private PVector mouse;
  public int upper, lower, left, right, front;
  private PMatrix3D rot;
  private PrintWriter doVerts;
  
//  PShape thing: the 3D shape
//  PShape original: original state of thing
//  float dx, dy, dz: angle of rotation
//  int upper, lower, left, right, front: bounds
  public Slimu(PShape s) {
    addMouseWheelListener(this);
    
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
    scaler = 1.0;
    upper = 0;
    lower = 0;
    left = 0;
    right = 0;
    front = 0;
    
    center();
  }
  
//  PMatrix3D rot: transformation matrix
  public void display() {
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    rot = new PMatrix3D();
    rot.scale(scaler, scaler, scaler);

    rot.rotateX(radians(dx));
    rot.rotateY(radians(dy));
    rot.rotateZ(radians(dz));
    
    for (int i=0; i<numVerts; i++) {
      PVector n = new PVector();
      rot.mult(thing.getVertex(i), n);
      thing.setVertex(i, n);
    }
    
    shape(thing);
    scaler = 1.0;
  }
  
  public void mouseWheelMoved(MouseWheelEvent e) {
    int notches = e.getWheelRotation();
    if (notches < 0) {
      scaler += 0.04;
    }
    else {
      if (scaler >= 0.05) {scaler -= 0.04;}
    }
  }
  
//  resets thing to its original state
  public void reset() {
    dx = 0.0;
    dy = 0.5;
    dz = 0.0;
    
    for (int i=0; i<numVerts; i++) {
      PVector n = original.getVertex(i);
      thing.setVertex(i, n);
    }
  }
  
//  method that does mouse selection and delegates deformation action
//  int x, y: mouseX and mouseY
//  int dowhat: action code, 1 - pull, 2 - carve, 3 - smooth
  public void justDoIt(int x, int y, int dowhat) {
    center();
    mouse = new PVector(x-width/2, height-y-height/2);
    int you = 0;
    float min = 1000;
    float sides = max(thing.getVertex(left).z, thing.getVertex(right).z);
    
//  finds the closest vertex in terms of the xy-plane that is also 
//  closest to the viewer
    for (int i=0; i<numVerts; i++) {
      PVector current = thing.getVertex(i);
      PVector justaplane = new PVector(current.x, current.y);
      float d = justaplane.dist(mouse);
      if (d<min && current.z<sides) {
          you = i;
          min = d;
      }
    }
    
//  selected vertex  
    select = thing.getVertex(you);

    println("where i actually meant: ", mouse);
    println("where i hit: ", select);
    println("minimum distance: ", select.dist(mouse));
    println();
    
    if (dowhat == 3) {
      smoooth(you, 2);
    }
    else {
      deform(dowhat, getJustMe(select), getNeighbors(you));
      smoooth(you, 2);
    }
  }
  
//  returns list of integer index of unique neighbors of vertex with index me
  private IntList getNeighbors(int me) {
    ArrayList<PVector> neighbors = new ArrayList<PVector>();
    IntList n_index = new IntList();
    
    PVector s = thing.getVertex(me);
    int loop = 0;
    
    while (loop<numVerts) {
      boolean gotcha = false;
      
      for (int j=0; j<3; j++) {
        if (thing.getVertex(loop+j).equals(s)) {
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
          if (temp.get(k).equals(s) == false && neighbors.contains(temp.get(k)) == false) {
            neighbors.add(temp.get(k));
            n_index.append(loop+k);
          }
        }
      }
      loop += 3;
    }
    
    return n_index;
  }
 
// Calculates center and bounds of the shape 
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
  
// returns list of indices of vertices with the same value as me 
  private IntList getJustMe(PVector me) {
    IntList allMe = new IntList();
    for (int i=0; i<numVerts; i++) {
      if (thing.getVertex(i).equals(me)) {
        allMe.append(i);
      }
    }
    return allMe;
  }
  
  private PVector deformVector(PVector peak, PVector you, int action) {
    float a, b, c;
//    puff
    if (action == 1) {
      a = you.x - center.x;
      b = you.y - center.y;
      c = you.z - center.z;
    }
//    pucker
    else if (action == 2) {
      a = -(you.x - center.x);
      b = -(you.y - center.y);
      c = -(you.z - center.z);
    }
//    tweak
    else {
      a = ((you.x - center.x)+(peak.x - you.x)*10)/11;
      b = ((you.y - center.y)+(peak.y - you.y)*10)/11;
//      a = peak.x - you.x;
//      b = peak.y - you.y;
      c = 0;
    }
    PVector delta = new PVector(a, b, c);
    delta.normalize();
    return delta;
  }
  
// apex: list of the indices of selected vertex
// circle: list of indices of unique neighbors of selected vertex
// dowhat: action code, 1 - puff, 2 - pucker, 4 - tweak
  private void deform(int dowhat, IntList apex, IntList circle) {
    PVector delta = deformVector(mouse, select, dowhat);
    delta.mult(2);
    println("change: ", delta);
    
    select.add(delta);
    
    for (int i=0; i<apex.size(); i++) {
      thing.setVertex(apex.get(i), select);
    }
    
    for (int j=0; j<circle.size(); j++) {
      PVector k = thing.getVertex(circle.get(j));
      IntList sobeit = getJustMe(k);
      PVector delt = deformVector(select, k, dowhat);
      delt.mult(1);
      
      println("change: ", delt);
      
      k.add(delt);
      
      for (int p=0; p<sobeit.size(); p++) {
        thing.setVertex(sobeit.get(p), k);
      }
    }
  }

// smooths around vertex v with a degree of layer  
  private void smoooth(int v, int layer) {
    if (layer == 0) {return;}
    
    IntList neighbors = getNeighbors(v);
    if (neighbors.size()==0) {return;}
    
    for (int i=0; i<neighbors.size(); i++) {
      smoooth(neighbors.get(i), layer-1);
    }
    
    float sum_x = 0.0;
    float sum_y = 0.0;
    float sum_z = 0.0;
    for (int i=0; i<neighbors.size(); i++) {
      PVector a = thing.getVertex(neighbors.get(i));
      sum_x += a.x;
      sum_y += a.y;
      sum_z += a.z;
    }
    
    PVector myself = thing.getVertex(v);
    sum_x = ((sum_x/neighbors.size())+(20*myself.x))/21;
    sum_y = ((sum_y/neighbors.size())+(20*myself.y))/21;
    sum_z = ((sum_z/neighbors.size())+(20*myself.z))/21;
    
    PVector n = new PVector(sum_x, sum_y, sum_z);
    
    IntList me = getJustMe(thing.getVertex(v));
    for (int j=0; j<me.size(); j++) {
      thing.setVertex(me.get(j), n);
    }
    
  }
  
// this is...a helper function that takes a shape loaded from obj 
// and writes vertex informaiton to a .txt file  
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
  
}

