PShape slime;

void setup() {
  size(1080, 720, P3D);

  
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
  
  PMatrix3D rot = new PMatrix3D();
  rot.translate(width/2, height/2, 0);
  rot.rotateX(radians(180));
  
  for (int i=0; i<slime.getVertexCount(); i++) {
    PVector n = new PVector();
    rot.mult(slime.getVertex(i), n);
    slime.setVertex(i, n);
  }
   
  frameRate(24);
}

void draw() {
  background(120);
  shape(slime, 0, 0);
}
