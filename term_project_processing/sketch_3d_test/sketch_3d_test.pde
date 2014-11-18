float x, y, z;
float rx = 0.0;
float ry = 0.0;
float rz = 0.0;

void setup() {
  size(720, 720, P3D);
  frameRate(24);
  x = 360;
  y = 360;
  z = -360;
}

void draw() {
  background(255, 255, 255);
  translate(x, y, z);
  rotateX(radians(rx));
  rotateY(radians(ry));
  rotateZ(radians(rz));
  rectMode(CENTER);
  fill(170, 230, 240);
  rect(0, 0, 100, 100);
  z++;
  rx++;
  ry++;
  rz++;
}
