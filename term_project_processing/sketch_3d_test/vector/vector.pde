PVector location = new PVector(100, 100);
PVector speed = new PVector(2.5, 5);

void setup() {
  size(200, 200);
  smooth();
  background(255);
}

void draw() {
  noStroke();
  fill(255, 10);
  
  location.add(speed);
  
  if (location.x>width || location.x<0) {
    speed.x *= -1;
  }
  
  if (location.y>height || location.y<0) {
    speed.y *= -1;
  }
  
  stroke(0);
  fill(175);
  ellipse(location.x, location.y, 16, 16);
}
