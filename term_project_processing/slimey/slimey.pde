
float x, y, z;
PShape slime;
Slimu arf;
PShape ground;
boolean light = false;

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
  
  stroke(170, 240, 250);
  fill(255);
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
  directionalLight(200, 130, 160, 1, 1, 1);
  arf.display();
  shape(ground, 0, 0);
}

int displacement(String which) {
  int dsize = 0;
  if (which == "horizontal") {
      dsize = (int)(20*sin(5*radians(frameCount%360)));
  }
  else {
      dsize = -(int)(30*sin(5*radians(frameCount%360)));
  }
  return dsize;
}

void keyPressed() {
    if (key == 'w') {
      arf.dx += 0.5;
    }
    else if (key == 's') {
      arf.dx -= 0.5;
    }
    else if (key == 'a') {
      arf.dy -= 0.5;
    }
    else if (key == 'd') {
      arf.dy += 0.5;
    }
    else if (key == 'q') {
      arf.dz -= 0.5;
    }
    else if (key == 'e') {
      arf.dz += 0.5;
    }
}

void mousePressed() {
  if (mouseX > 340 && mouseX <740 && mouseY > 230 && mouseY < 490) {
    arf.getGuys(mouseX, mouseY);
  }
  
  println("200: ", arf.thing.getVertex(200));
}

