import nervoussystem.obj.*;
import java.util.Map;

PVector rotation;
int action = 1;
int counter = 0;
boolean paause;
PShape slime;
PShader toon;
Pair smooth, pucker, puff, pinch, reset, pause, save, snap;
Slimu arf;

String tips = "LMB - tools       RMB - free rotate AD - rotate x      WS - rotate y      QE - rotate z      scroll - scale";

void setup() {
  size(1280, 860, P3D);
  
  rotation = new PVector(0, 0.3, 0);
  
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


void draw() {
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
void keyPressed() {
  if (!paause) {
    if (key == 'w') {
      rotation.x += 0.5;
    }
    else if (key == 's') {
      rotation.x -= 0.5;
    }
    else if (key == 'a') {
      rotation.y += 0.5;
    }
    else if (key == 'd') {
      rotation.y -= 0.5;
    }
    else if (key == 'q') {
      rotation.z += 0.5;
    }
    else if (key == 'e') {
      rotation.z -= 0.5;
    }
    arf.rotation = rotation;
  }
}

// commands
void mousePressed() {
  if (inCircle(reset.x, reset.y)) {
    arf.reset();
    rotation = new PVector(0.0, 0.5, 0.0);
    if (paause == true) {
      arf.rotation = new PVector(0.0, 0.0, 0.0);
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
      arf.rotation = new PVector(0.0, 0.0, 0.0);
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
      rotation.x -= (mouseY - pmouseY)*0.01;
      rotation.y -= (mouseX - pmouseX)*0.01;
      arf.rotation = rotation;
    }
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

