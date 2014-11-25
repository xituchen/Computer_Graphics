float dx, dy, dz;
int action = 1;
boolean paause;
PShape slime;
Pair smooth, carve, pull, reset, pause, save;
Slimu arf;

void setup() {
  size(1280, 860, P3D);
  
  dx = 0.0;
  dy = 0.5;
  dz = 0.0;
  
//  parse vertex data
  String[] allData = loadStrings("slime_verts.txt");
  
  stroke(255);
  fill(150, 180, 180, 85);
  slime = createShape();
  slime.beginShape(TRIANGLES);
  
  for (int i=0; i<allData.length; i++) {
    String[] aVert = trim(split(allData[i], ' '));
    slime.vertex(float(aVert[0]), float(aVert[1]), float(aVert[2]));
  }
  
  slime.endShape(CLOSE); 
  arf = new Slimu(slime);
  arf.dx = dx;
  arf.dy = dy;
  arf.dz = dz;
  
  paause = false;
  
  smooth = new Pair(1200, 80);
  carve = new Pair(1200, 160);
  pull = new Pair(1200, 240);
  
  pause = new Pair(1200, 620);
  save = new Pair(1200, 700);
  reset = new Pair(1200, 780);
   
  frameRate(24);
}


void draw() {
  background(50);
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
  
//  carve button
  if (inCircle(carve.x, carve.y)) {
    textSize(12);
    fill(255);
    text("carve", 1140, carve.y);
    fill(220, 200, 120);
  }
  else if (action == 2) {fill(120, 150, 180);}
  else {noFill();}
  ellipse(carve.x, carve.y, 50, 50);
  
//  pull button
  if (inCircle(pull.x, pull.y)) {
    textSize(12);
    fill(255);
    text("pull", 1148, pull.y);
    fill(220, 200, 120);
  }
  else if (action == 1) {fill(100, 200, 160);}
  else {noFill();}
  ellipse(pull.x, pull.y, 50, 50);
  
  //  pause button
  if (inCircle(pause.x, pause.y)) {
    textSize(12);
    fill(255);
    if (!paause) {text("pause", 1135, pause.y);}
    else {text("play", 1145, pause.y);}
    fill(120);
  }
  else if (paause) {fill(100, 200, 160);}
  else {noFill();}
  ellipse(pause.x, pause.y, 50, 50);
  if (!paause) {
    noStroke();
    fill(255);
    rectMode(CENTER);
    rect(pause.x, pause.y, 20, 20);
  }
  
  stroke(255);
  //  save button
  if (inCircle(save.x, save.y)) {
    textSize(12);
    fill(255);
    text("save", 1143, save.y);
    fill(185, 100, 140);
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
  }
  else if(inCircle(carve.x, carve.y)) {
    action = 2;
  }
  else if(inCircle(pull.x, pull.y)) {
    action = 1;
  }
  else if(inCircle(smooth.x, smooth.y)) {
    action = 3;
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
}

void mouseDragged() {
  if (!inCircle(reset.x, reset.y) && 
      !inCircle(smooth.x, smooth.y) && 
      !inCircle(carve.x, carve.y) && 
      !inCircle(pull.x, pull.y) &&
      !inCircle(pause.x, pause.y)) {
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

