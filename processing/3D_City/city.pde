float[][] heights;
  float[][] lights;
  float[][] lighttargets;

  int numlights = 6;
  int buildings = 12;
  int spacing = 60;
  int building_size = 50;
  int maxheight = 500;

  int border;
  int size;

  // targeting
  int currentStreet;
  boolean left = true;

  // camera
  boolean out = false;

  // camera Movement
  float steplength = 0.5f;
  float targetsteplenght = 2f;
  float[] camerapos;
  float[] camtargetpos;
  float[] targetpos;

  public void calcHeights() {
    heights = new float[buildings][buildings];
    for (int x = 0; x < heights.length; x++) {
      for (int y = 0; y < heights[x].length; y++) {
        heights[x][y] = (int) random(maxheight);
      }
    }

    border = (building_size + spacing);
    size = buildings * (building_size + spacing);
  }

  public void setup() {
    calcHeights();
    calcLights();
    background(0);
    camerapos = new float[3];
    camtargetpos = new float[3];
    targetpos = new float[3];

    size(500, 500, OPENGL);
  }

  private void calcLights() {

    lights = new float[numlights][9];
    for (int i = 0; i < lights.length; i++) {
      // Light
      lights[i][0] = random(128);
      lights[i][1] = random(128);
      lights[i][2] = random(128);

      // Startposition
      lights[i][3] = random(size);
      lights[i][4] = random(size);
      lights[i][5] = random(maxheight);

      // Starttargets
      lights[i][6] = random(size);
      lights[i][7] = random(size);
      lights[i][8] = random(maxheight);
    }
  }

  public void draw() {
    background(0);
    noStroke();
    if (out) {
      camera(mouseX - (width / 2), mouseY - (height / 2), 1000, size / 2,
          size / 2, 0, 0, 1, 0);

      pushMatrix();
      translate(0, 0, 10);
      fill(255, 0, 0);
      rect(camerapos[0] - 5, camerapos[1] - 10, 10, 10);

      fill(0, 255, 0);
      rect(camtargetpos[0] - 5, camtargetpos[1] - 5, 10, 10);
      popMatrix();
    } else {
      camera(camerapos[0], camerapos[1], camerapos[2], camtargetpos[0],
          camtargetpos[1], camtargetpos[2], 0, 0, -1);
    }

    stepCamera();
    stepTarget();
    stepLights();
    //stepBuildings();
    
    if (targetReached()) {
      nextTarget();
    }
    // translate(width/2, height/2, -100);

    directionalLight(50, 50, 50, 0, 0, -1);
    ambientLight(50, 50, 50);

    for (int i = 0; i < lights.length; i++) {
      pointLight(lights[i][0], lights[i][1], lights[i][2], lights[i][3],
          lights[i][4], lights[i][5]);
    }

    drawGround();
    drawBuildings();
  }

  private void stepLights() {
    for (int i = 0; i < lights.length; i++) {
      lights[i][0] += (random(2) - 1);
      lights[i][1] += (random(2) - 1);
      lights[i][2] += (random(2) - 1);
    }
  }

  private void stepBuildings() {
    for (int x = 0; x < heights.length; x++) {
      for (int y = 0; y < heights[x].length; y++) {
        heights[x][y] += random(1) - 0.5;
      }
    }
  }

  private void nextTarget() {

    if (left) {
      targetpos[0] = 0;
    } else {
      targetpos[0] = size;
    }
    targetpos[1] = currentStreet * (building_size + spacing)
        - building_size / 2 - spacing / 2;

    targetpos[2] = 0f;

    left = !left;
    currentStreet++;
    if (currentStreet > buildings) {
      currentStreet = 0;
    }
  }

  private boolean targetReached() {
    float dx = camerapos[0] - targetpos[0];
    float dy = camerapos[1] - targetpos[1];
    float distance = (float) Math.sqrt(dx * dx + dy * dy);
    if (distance < 50) {
      return true;
    }
    return false;
  }

  private void stepTarget() {
    step(camtargetpos, targetpos, steplength * 2);
    camtargetpos[2] = 0;
  }

  private void step(float[] entity, float[] target, float s) {
    for (int i = 0; i < entity.length; i++) {
      if (entity[i] < target[i]) {
        entity[i] += s;
      } else if (entity[i] > target[i]) {
        entity[i] -= s;
      }
    }
  }

  private void stepCamera() {
    step(camerapos, camtargetpos, steplength);
    camerapos[2] = 50;
  }

  public void drawGround() {

    fill(200);

    rect(-border, -border, border + size, border + size);
  }

  public void drawBuildings() {
    for (int x = 0; x < heights.length; x++) {
      for (int y = 0; y < heights[x].length; y++) {
        box(building_size, building_size, heights[x][y]);
        translate(0, building_size + spacing);
      }
      translate(building_size + spacing, 0);
      translate(0, -buildings * (building_size + spacing));
    }
  }

  @Override
  public void mousePressed() {
    out = true;
  }

  @Override
  public void mouseReleased() {
    out = false;
  }
