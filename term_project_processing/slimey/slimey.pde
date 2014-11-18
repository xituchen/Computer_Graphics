
float x, y, z;
float rx = 0.0;
float ry = 0.0;
float rz = 0.0;
float dx = 0.0;
float dy = 0.0;
float dz = 0.0;
PShape slime;
Slimu arf;
PShape ground;
boolean light = false;

class Slimu {
  public PShape thing;
  public float rX, rY, rZ;
  public int dx, dy, dz;
  public int horizontal, vertical;
  
  public Slimu(PShape s) {
    thing = s;
    rX = 0.0;
    rY = 0.0;
    rZ = 0.0;
    dx = 0;
    dy = 0;
    dz = 0;
    horizontal = 300;
    vertical = 200;
  }
  
  public void display() {
    background(90, 140, 150);
    shape(ground, 0, 0);
    rotateX(radians(rX));
    rotateY(radians(rY));
    rotateZ(radians(rZ));
    
    rX += dx;
    rY += dy;
    rZ += dz;
    
    int horizontal = 300 + displacement("horizontal");
    int vertical = 200 + displacement("vertical");
  
    shape(thing, 0, 0, horizontal, vertical);
  }
  
  public void keydosomething() {
    
  }
}

void setup() {
  size(512, 512, P3D);   
  fill(170, 230, 240);
  noStroke();
  ground = createShape();
  ground.beginShape(TRIANGLE_FAN);
  ground.vertex(-256, -200, 256);
  ground.vertex(-256, -150, -256);
  ground.vertex(256, -150, -256);
  ground.vertex(256, -200, 256);
  ground.endShape(CLOSE);
  
  slime = loadShape("slime.obj");
  arf = new Slimu(slime);
  
  frameRate(24);
}

void draw() {
  background(90, 140, 150);
  if (mousePressed) {
  light = !light;
  }
  
  if (light) {
    lights();
  }
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  shape(ground, 0, 0);
//  rotateX(radians(rx));
//  rotateY(radians(ry));
//  rotateZ(radians(rz));
//  
//  rx += dx;
//  ry += dy;
//  rz += dz;
//  
//  int horizontal = 300 + displacement("horizontal");
//  int vertical = 200+displacement("vertical");
//
//  shape(arf.thing, 0, 0, horizontal, vertical);
  arf.display();
  
}

int displacement(String which) {
  int dsize = 0;
  if (which == "horizontal") {
      dsize = (int)(30*sin(5*radians(frameCount%360)));
  }
  else {
      dsize = -(int)(40*sin(5*radians(frameCount%360)));
  }
  return dsize;
}

void keyPressed() {
    if (key == 'w') {
      dx += 0.5;
    }
    else if (key == 's') {
      dx -= 0.5;
    }
    else if (key == 'a') {
      dy -= 0.5;
    }
    else if (key == 'd') {
      dy += 0.5;
    }
    else if (key == 'q') {
      dz -= 0.5;
    }
    else if (key == 'e') {
      dz += 0.5;
    }
}








