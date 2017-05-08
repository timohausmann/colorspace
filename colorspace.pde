/*
 * 3D Color Space
 * https://github.com/timohausmann/colorspace
 * @license MIT
 */

import peasy.*;
import controlP5.*;
import java.io.File;


float maxPoints = 8000;         //the maximum number of plotted points
float scaleDiameter = 1.5;      //XY scale factor
float scaleHeight = 2;          //Z scale factor

boolean is_cone = false;        //display as cone
boolean is_scale = false;       //display scale
boolean is_rotate = true;       //scene auto rotate
float sceneRotation = 0;
float sceneRotationDelta = 0.1;

PImage img;       //the current image
IntList imgData;  //the processed image pixel data as a list of colors

PeasyCam cam;
ControlP5 cp5;
Slider cpScaleXZ;
Slider cpScaleY;

String folderIn;
String folderOut;
int fileIndex;
String[] fileList;

/** 
 * Setup
 */
void setup() {

  size(1280, 800, P3D);
  colorMode(HSB); 

  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(3200);
  cam.setDistance(1000);

  folderIn = sketchPath() + "/in/";     //folder with source images
  folderOut = sketchPath() + "/out/";   //output folder for screenshots

  fileList = listFileNames(folderIn);
  fileIndex = 0;
  loadFile(fileList[0]);

  cp5 = new ControlP5(this);
  setupGui(cp5);
}


/** 
 * Draw
 */
void draw() {
  
  background(255);
  //ambientLight(0, 0, 255);
  //directionalLight(0, 0, 255, 0.5, 1, 0);

  rotateY( radians(sceneRotation) );
  drawPlot();

  if(is_rotate) sceneRotation += sceneRotationDelta;
  if( is_scale ) drawScale();

  drawGui();
}


/** 
 * Draw Plot
 */
void drawPlot() {

  pushMatrix();
  noStroke();
  sphereDetail(4);
  translate(0, 255*scaleHeight/2, 0);
  
  for(int i=0;i<imgData.size();i++) {
    
    int hsb = imgData.get(i);
    
    float h = hue(hsb);
    float s = saturation(hsb);
    float b = brightness(hsb);
    fill(h,s,b);

    pushMatrix();
    PVector pos = hsb2Vector(h,s,b);
    translate(pos.x, pos.y, pos.z);
    sphere(10);
    popMatrix();
  }
  popMatrix();
}


/** 
 * Draw Scale
 */
void drawScale() {

  pushMatrix();
  translate(0,-255*scaleHeight/2,0);
  noFill();
  stroke(0,0,0,44);

  if( is_cone ) {
    cylinder(255*scaleDiameter,0,255*scaleHeight,24);
  } else {
    cylinder(255*scaleDiameter,255*scaleDiameter,255*scaleHeight,24);
  }
  popMatrix();
}


/** 
 * Get Pixels
 * returns an IntList representing pixels from the image
 * the IntList is limited by maxPoints
 * (Processing stores color() as type int)
 */
IntList getPixels(PImage img) {

  int counter = 0;
  IntList tmpImgData = new IntList();
  int pixelCount = img.width * img.height;
  float step = pixelCount/maxPoints;
  if(step < 1 ) step = 1;
  
  loadPixels();  
  for (float i=0; i<pixelCount; i+=step,counter++ ) {
    
      int loc = round(i);        
      float h = hue(img.pixels[loc]);
      float s = saturation(img.pixels[loc]);
      float b = brightness(img.pixels[loc]);
      
      int hsb = color(h,s,b);
      tmpImgData.append(hsb);
  }
  updatePixels();

  println("scanned " + counter + " pixels (pixel count: " + pixelCount + " | pixel step: " + step + ")");
  return tmpImgData;
}


/** 
 * HSB to Vector
 * Converts HSB-Values (0-255) to Colorspace XYZ
 */
PVector hsb2Vector(float h, float s, float b) {

    PVector tmpVector = new PVector();

    float xyDist = s; //get the distance from the center (saturation)
    if( is_cone ) xyDist *= b/255.0; //multiply with brightness factor for cone effect
    xyDist *= scaleDiameter; //scale
    
    //convert hue to radians and multiply it with satuation to get x/y positions
    tmpVector.x = sin(radians((h/255.0)*360)) * xyDist;
    tmpVector.z = cos(radians((h/255.0)*360)) * xyDist;
    //convert brightness to y position
    tmpVector.y = -b*scaleHeight;

    return tmpVector;
}


/**
 * loadFile
 * load image file and store its data
 */
void loadFile(String path) {
  img = loadImage(folderIn + path);
  imgData = getPixels(img);
}