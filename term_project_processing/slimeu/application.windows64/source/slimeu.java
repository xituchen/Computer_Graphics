import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import nervoussystem.obj.*; 
import java.util.Map; 
import java.awt.event.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class slimeu extends PApplet {




PVector rotation;
int action = 1;
int counter = 0;
boolean paause;
PShape slime;
PShader toon;
Pair smooth, pucker, puff, pinch, reset, pause, save, snap;
Slimu arf;

String tips = "LMB - tools       RMB - free rotate AD - rotate x      WS - rotate y      QE - rotate z      scroll - scale";

public void setup() {
  size(1280, 860, P3D);
  
  rotation = new PVector(0, 0.3f, 0);
  
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
    PVector n = new PVector(PApplet.parseFloat(aNorm[0]), PApplet.parseFloat(aNorm[1]), PApplet.parseFloat(aNorm[2]));
    norms.add(n);
    if (i<allData.length) {
      String[] aVert = trim(split(allData[i], ' '));
      PVector v = new PVector(PApplet.parseFloat(aVert[0]), PApplet.parseFloat(aVert[1]), PApplet.parseFloat(aVert[2]));
      verts.add(v);
    }
    if (i<allTex.length) {
      String[] aTex = trim(split(allTex[i], ' '));
      PVector t = new PVector(PApplet.parseFloat(aTex[0]), PApplet.parseFloat(aTex[1]));
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
      Pair m = new Pair(PApplet.parseInt(guy[0])-1, PApplet.parseInt(guy[1])-1, PApplet.parseInt(guy[2])-1);
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
  arf.rotation = rotation;
  
  paause = false;
  
  smooth = new Pair(1200, 80);
  pucker = new Pair(1200, 240);
  puff = new Pair(1200, 320);
  pinch = new Pair(1200, 160);
  
  snap = new Pair(1200, 620);
  pause = new Pair(1200, 540);
  save = new Pair(1200, 700);
  reset = new Pair(1200, 780);
   
  frameRate(24);
}


public void draw() {
  background(50);
  smooth();
  
  textSize(12);
  fill(255);
  text(tips, 80, 780, 110, 140);
  stroke(255);

  ellipseMode(CENTER);
  
  //  smooth button
  if (inCircle(smooth.x, smooth.y)) {
    textSize(12);
    fill(255);
    text("smooth", 1130, smooth.y);
    if (action == 3) {fill(220, 200, 120);}
    else {fill(150, 110, 190);}
  }
  else if (action == 3) {fill(150, 110, 190);}
  else {noFill();}
  ellipse(smooth.x, smooth.y, 50, 50);
  
  //  pinch button
  if (inCircle(pinch.x, pinch.y)) {
    textSize(12);
    fill(255);
    text("pinch", 1140, pinch.y);
    if (action == 4) {fill(220, 200, 120);}
    else {fill(120, 150, 200);}
  }
  else if (action == 4) {fill(120, 150, 200);}
  else {noFill();}
  ellipse(pinch.x, pinch.y, 50, 50);
  
  //  pucker button
  if (inCircle(pucker.x, pucker.y)) {
    textSize(12);
    fill(255);
    text("pucker", 1132, pucker.y);
    if (action == 2) {fill(220, 200, 120);}
    else {fill(120, 185, 160);}
  }
  else if (action == 2) {fill(120, 185, 160);}
  else {noFill();}
  ellipse(pucker.x, pucker.y, 50, 50);
  
  //  puff button
  if (inCircle(puff.x, puff.y)) {
    textSize(12);
    fill(255);
    text("puff", 1148, puff.y);
    if (action == 1) {fill(220, 200, 120);}
    else {fill(160, 200, 120);}
  }
  else if (action == 1) {fill(160, 200, 120);}
  else {noFill();}
  ellipse(puff.x, puff.y, 50, 50);
  
  //  snap button
  if (inCircle(snap.x, snap.y)) {
    textSize(12);
    fill(255);
    text("snap", 1143, snap.y);
    fill(220, 200, 120);
  }
  else {noFill();}
  ellipse(snap.x, snap.y, 50, 50);
  
  //  pause button
  if (inCircle(pause.x, pause.y)) {
    textSize(12);
    fill(255);
    if (!paause) {text("pause", 1135, pause.y);}
    else {text("play", 1145, pause.y);}
    fill(160, 200, 120);
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
public void keyPressed() {
  if (!paause) {
    if (key == 'w') {
      rotation.x += 0.5f;
    }
    else if (key == 's') {
      rotation.x -= 0.5f;
    }
    else if (key == 'a') {
      rotation.y += 0.5f;
    }
    else if (key == 'd') {
      rotation.y -= 0.5f;
    }
    else if (key == 'q') {
      rotation.z += 0.5f;
    }
    else if (key == 'e') {
      rotation.z -= 0.5f;
    }
    arf.rotation = rotation;
  }
}

// commands
public void mousePressed() {
  if (inCircle(reset.x, reset.y)) {
    arf.reset();
    rotation = new PVector(0.0f, 0.5f, 0.0f);
    if (paause == true) {
      arf.rotation = new PVector(0.0f, 0.0f, 0.0f);
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
  else if (inCircle(snap.x, snap.y)) {
    String name = "slimeu" + "_" + counter + ".png";
    save(name);
    counter++;
  }
  else if(inCircle(pause.x, pause.y)) {
    paause = !paause;
    if (paause) {
      arf.rotation = new PVector(0.0f, 0.0f, 0.0f);
    }
    else {
      arf.rotation = rotation;
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
public void drawSlime(PGraphics pg) {
  pg.beginShape(TRIANGLES);
  pg.fill(150, 180, 180);
  for (int i=0; i<arf.numVerts; i++) {
    PVector n = arf.thing.getVertex(i);
    pg.vertex(n.x, n.y, n.z);
  }
  pg.endShape();
}

public void mouseDragged() {
  if (mouseButton==LEFT) {
    if (!inCircle(reset.x, reset.y) && 
        !inCircle(smooth.x, smooth.y) && 
        !inCircle(pucker.x, pucker.y) && 
        !inCircle(puff.x, puff.y) &&
        !inCircle(pinch.x, pinch.y) &&
        !inCircle(pause.x, pause.y) &&
        !inCircle(snap.x, snap.y) &&
        !inCircle(save.x, save.y)) {
      arf.justDoIt(pmouseX, pmouseY, action);
    }
  }
  else {
    if (!paause) {
      rotation.x -= (mouseY - pmouseY)*0.01f;
      rotation.y -= (mouseX - pmouseX)*0.01f;
      arf.rotation = rotation;
    }
  }
}

// check if mouse is in a circle button
public boolean inCircle(int x, int y) {
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


class Slimu implements MouseWheelListener{
  public PShape thing;
  public PVector rotation;
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
//  PVector rotation: angle of rotation
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
    
    rotation = new PVector(0.0f, 0.0f, 0.0f);
    scaler = 1.0f;
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

    rot.rotateX(radians(rotation.x));
    rot.rotateY(radians(rotation.y));
    rot.rotateZ(radians(rotation.z));
    
    for (int i=0; i<numVerts; i++) {
      PVector n = new PVector();
      rot.mult(thing.getVertex(i), n);
      thing.setVertex(i, n);
    }
    
    shape(thing);
    scaler = 1.0f;
  }
  
  public void mouseWheelMoved(MouseWheelEvent e) {
    int notches = e.getWheelRotation();
    if (notches < 0) {
      scaler += 0.04f;
    }
    else {
      if (scaler >= 0.05f) {scaler -= 0.04f;}
    }
  }
  
//  resets thing to its original state
  public void reset() {
    rotation.x = 0.0f;
    rotation.y = 0.5f;
    rotation.z = 0.0f;
    
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
    float sum_x = 0.0f;
    float sum_y = 0.0f;
    float sum_z = 0.0f;

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
    //    pinch
    else {
      a = ((you.x - center.x)+(peak.x - you.x)*10)/11;
      b = ((you.y - center.y)+(peak.y - you.y)*10)/11;
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
    
    select.add(delta);
    
    for (int i=0; i<apex.size(); i++) {
      thing.setVertex(apex.get(i), select);
    }
    
    for (int j=0; j<circle.size(); j++) {
      PVector k = thing.getVertex(circle.get(j));
      IntList sobeit = getJustMe(k);
      PVector delt = deformVector(select, k, dowhat);
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
    
    PVector myself = thing.getVertex(v);
    PVector sum = new PVector(0.0f, 0.0f, 0.0f);
    float divide = 0.000001f;
    for (int i=0; i<neighbors.size(); i++) {
      PVector a = thing.getVertex(neighbors.get(i));
      float weight = a.dist(myself);
      a.mult(weight);
      sum.add(a);
      divide += weight;
    }
    
    sum.div(divide);
    PVector n = new PVector(myself.x, myself.y, myself.z);
    n.mult(30);
    sum.add(n);
    sum.div(31.0f);
    
    IntList me = getJustMe(thing.getVertex(v));
    for (int j=0; j<me.size(); j++) {
      thing.setVertex(me.get(j), sum);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "slimeu" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
