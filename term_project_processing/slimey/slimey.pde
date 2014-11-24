
float x, y, z;
PShape slime;
Slimu arf;
PShape ground;
boolean light = false;
int action = 1;

void setup() {
  size(1280, 860, P3D);
  
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
  
  frameRate(24);
}


void draw() {
  background(50);
  stroke(255);
  ellipseMode(CENTER);
  
//  reset button
  if (inCircle(1200, 80)) {
    textSize(12);
    fill(255);
    text("reset", 1140, 80);
    fill(185, 100, 140);
  }
  else {noFill();}
  ellipse(1200, 80, 50, 50);
  
//  carve button
  if (inCircle(1200, 160)) {
    textSize(12);
    fill(255);
    text("carve", 1140, 160);
    fill(220, 200, 120);
  }
  else if (action == 2) {fill(120, 150, 180);}
  else {noFill();}
  ellipse(1200, 160, 50, 50);
  
//  pull button
  if (inCircle(1200, 240)) {
    textSize(12);
    fill(255);
    text("pull", 1148, 240);
    fill(220, 200, 120);
  }
  else if (action == 1) {fill(100, 200, 160);}
  else {noFill();}
  ellipse(1200, 240, 50, 50);
  
//  smooth button
  if (inCircle(1200, 320)) {
    textSize(12);
    fill(255);
    text("smooth", 1130, 320);
    fill(220, 200, 120);
  }
  else if (action == 3) {fill(150, 110, 190);}
  else {noFill();}
  ellipse(1200, 320, 50, 50);
  
  lights();
  arf.display();
}

// rotation
void keyPressed() {
    if (key == 'w') {
      arf.dx += 0.5;
    }
    else if (key == 's') {
      arf.dx -= 0.5;
    }
    else if (key == 'a') {
      arf.dy += 0.5;
    }
    else if (key == 'd') {
      arf.dy -= 0.5;
    }
    else if (key == 'q') {
      arf.dz += 0.5;
    }
    else if (key == 'e') {
      arf.dz -= 0.5;
    }
}

// commands
void mousePressed() {
  if (inCircle(1200, 80)) {
    arf.reset();
  }
  else if(inCircle(1200, 160)) {
    action = 2;
  }
  else if(inCircle(1200, 240)) {
    action = 1;
  }
  else if(inCircle(1200, 320)) {
    action = 3;
  }
}

void mouseDragged() {
  if (!inCircle(1200, 80) && !inCircle(1200, 160) && !inCircle(1200, 240) && !inCircle(1200, 320)) {
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

