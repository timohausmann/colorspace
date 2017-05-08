/** 
 * Setup GUI
 */
void setupGui(ControlP5 cp5) {
  cp5.setAutoDraw(false);

  cpScaleXZ = cp5.addSlider("_scale_xz",0.5,8,scaleDiameter,20,height-60,120,10).setColorLabel(color(100));
  cpScaleY = cp5.addSlider("_scale_y",0.1,4,scaleHeight,20,height-80,120,10).setColorLabel(color(100));

  cp5.addRadioButton("_camlock")
    .setColorLabel(color(100))
    .setItemsPerRow(4)
    .setSpacingColumn(50)
    .setPosition(20,height-120)
    .addItem("_free", 0)
    .addItem("_pitch", 1)
    .addItem("_yaw", 2)
    .addItem("_roll", 3)
    .activate(2);

  _camlock(2);

  cp5.addToggle("_rotation",is_rotate,20,height-40,9,9).setColorLabel(color(100));
  cp5.addToggle("_is_cone",is_cone,100,height-40,9,9).setColorLabel(color(100));
  cp5.addToggle("_show_scale",is_scale,180,height-40,9,9).setColorLabel(color(100));

  if(fileList.length > 1 ) {
    cp5.addButton("_prev").setPosition(20,260);
    cp5.addButton("_next").setPosition(111,260);
  }
}


/** 
 * Draw GUI
 */
void drawGui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  image(img, 20, 20, 160, (img.height/float(img.width))*160);
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}


/** 
 * GUI handler
 */
void _next() {
  if( fileIndex+1 < fileList.length ) {
    fileIndex++;
  } else {
    fileIndex = 0;
  }
  loadFile(fileList[fileIndex]);
}
void _prev() {
  if( fileIndex > 0 ) {
    fileIndex--;
  } else {
    fileIndex = fileList.length-1;
  }
  loadFile(fileList[fileIndex]);
}

void _camlock(int cp5val) {
  
  if(cp5val == 3) {
    cam.setRollRotationMode();  // like a radio knob
  } else if(cp5val == 2) {
    cam.setYawRotationMode();   // like spinning a globe
  } else if(cp5val == 1) {
    cam.setPitchRotationMode(); // like a somersault
  } else {
    cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.
  }
}

void _scale_xz(float cp5val) {
  scaleDiameter = cp5val;
}
void _scale_y(float cp5val) {
  scaleHeight = cp5val;
}
void _is_cone(boolean cp5val) {
  is_cone = cp5val;
}
void _show_scale(boolean cp5val) {
  is_scale = cp5val;
}
void _rotation(boolean cp5val) {
  is_rotate = cp5val;
}