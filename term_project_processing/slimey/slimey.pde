
float x, y, z;
PShape slime;
Slimu arf;
PShape ground;
boolean light = false;
boolean pull = true;

void setup() {
  size(1080, 720, P3D);   
  fill(170, 230, 240);
  noStroke();
  ground = createShape();
  ground.beginShape(TRIANGLE_FAN);
  ground.vertex(-256, -200, 256);
  ground.vertex(-256, -150, -256);
  ground.vertex(256, -150, -256);
  ground.vertex(256, -200, 256);
  ground.endShape(CLOSE);
  
  String[] allData = loadStrings("slime_verts.txt");
  
  stroke(255);
  fill(180, 230, 250, 70);
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
  
  if (inCircle(1000, 80)) {
    textSize(12);
    fill(255);
    text("reset", 940, 80);
    fill(185, 100, 140);
  }
  else {noFill();}
  ellipse(1000, 80, 50, 50);
  
  if (inCircle(1000, 160)) {
    textSize(12);
    fill(255);
    text("carve", 940, 160);
    fill(220, 200, 120);
  }
  else if (pull == false) {fill(120, 150, 180);}
  else {noFill();}
  ellipse(1000, 160, 50, 50);
  
  if (inCircle(1000, 240)) {
    textSize(12);
    fill(255);
    text("pull", 940, 240);
    fill(220, 200, 120);
  }
  else if (pull == true) {fill(100, 200, 160);}
  else {noFill();}
  ellipse(1000, 240, 50, 50);
  
  lights();
  arf.display();
}

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

void mousePressed() {
  if (inCircle(1000, 80)) {
    arf.reset();
  }
  else if(inCircle(1000, 160)) {
    pull = false;
  }
  else if(inCircle(1000, 240)) {
    pull = true;
  }
  else {
    arf.getGuys(mouseX, mouseY, pull);  
  }
  
  println("200: ", arf.thing.getVertex(200));
  println("pull? ", pull);
  println('\n');
}

boolean inCircle(int x, int y) {
  float dX = x - mouseX;
  float dY = y - mouseY;
  if (sqrt(sq(dX) + sq(dY)) < 50) {
    return true;
  }
  return false;
}

