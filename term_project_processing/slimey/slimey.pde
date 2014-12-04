import nervoussystem.obj.*;
import java.util.Map;

float dx, dy, dz;
int action = 1;
boolean paause;
PShape slime;
PShader toon;
Pair smooth, pucker, puff, pinch, reset, pause, save, shadeit;
Slimu arf;

String tips = "AD - rotate x WS - rotate y QE - rotate z scroll - scale";

void setup() {
  size(1280, 860, P3D);
  
  dx = 0.0;
  dy = 0.5;
  dz = 0.0;
  
//  parse vertex data
  String[] allData = loadStrings("slime_verts.txt");
  String[] allNorm = loadStrings("slime_norm.txt");
  String[] allTex = loadStrings("slime_tex.txt");
  HashMap<PVector, PVector> vertToTex = new HashMap<PVector, PVector>();
//  PImage img = loadImage("pattern.png");
  
  stroke(255);
  fill(150, 180, 180, 85);
//  noStroke();
//  textureMode(IMAGE);
  slime = createShape();
  slime.beginShape(TRIANGLES);
//  texture(img);
  
  int txtr = 0;
  
  for (int i=0; i<allData.length; i++) {
    String[] aVert = trim(split(allData[i], ' '));
    String[] aNorm = trim(split(allNorm[i], ' '));
    String[] aTex = trim(split(allTex[txtr], ' '));
    
    PVector v = new PVector(float(aVert[0]), float(aVert[1]), float(aVert[2]));
    PVector t;
    if (vertToTex.containsKey(v) == true) {
      t = vertToTex.get(v);
    }
    else {
      t = new PVector(float(aTex[0]), float(aTex[1]));
      vertToTex.put(v, t);
      txtr++;
    }
    slime.normal(float(aNorm[0]), float(aNorm[1]), float(aNorm[2]));
    slime.vertex(v.x, v.y, v.z, t.x, t.y);
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
  shadeit = new Pair(1200, 620);
  
  pause = new Pair(1200, 540);
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
  
  //  shade button
  if (inCircle(shadeit.x, shadeit.y)) {
    textSize(12);
    fill(255);
    text("shade", 1140, shadeit.y);
    fill(220, 200, 120);
  }
  else if (arf.shade == true) {fill(160, 200, 120);}
  else {noFill();}
  ellipse(shadeit.x, shadeit.y, 50, 50);
  
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
  if (arf.shade == true) {
    noStroke();
    fill(150, 180, 180);
  }
  else {
    stroke(255);
    fill(150, 180, 180, 80);
  }
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
  else if(inCircle(shadeit.x, shadeit.y)) {
    arf.shade = !arf.shade;
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

