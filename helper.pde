/** 
 * Tastatureingaben
 */
void keyReleased() {
  if (key != CODED) {
    switch(key) {
      case ENTER:
        //doIt();
        screenshot();
        break;
    }
  }
}


/** 
 * Screenshot erstellen
 */
void screenshot() {
  String timestamp = year() + nf(month(),2) + nf(day(),2) + "-" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
  saveFrame(folderOut + "screenshot-" + timestamp + ".png");
}


void mousePressed() {
  //Kameradrehung bei MousePressed stoppen
  sceneRotationDelta = 0; 
  //Peasy bei CP5 deaktivieren
  if(cp5.isMouseOver()) {
    cam.setActive(false);
  }
}
void mouseReleased() {
  //Kameradrehung bei MousePressed fortsetzen
  if(is_rotate) {
    sceneRotationDelta = 0.1;
  }
  //Peasy wieder aktivieren
  cam.setActive(true);
}


/**
 * https://processing.org/examples/directorylist.html
 */
// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  java.io.File file = new java.io.File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    println("directory not found");
    return null;
  }
}


/**
 * https://forum.processing.org/one/topic/draw-a-cone-cylinder-in-p3d.html
 */
void cylinder(float bottom, float top, float h, int sides)
{
  pushMatrix();
  
  translate(0,h/2,0);
  
  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];
  
  float[] x2 = new float[sides+1];
  float[] z2 = new float[sides+1];
 
  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * bottom;
    z[i] = cos(angle) * bottom;
  }
  
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x2[i] = sin(angle) * top;
    z2[i] = cos(angle) * top;
  }
 
  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);
 
  vertex(0,   -h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
 
  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 
 
  vertex(0,   h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x2[i], h/2, z2[i]);
  }
 
  endShape();
  
  popMatrix();
}