int groesse = 300;
int[][] lines = new int[255][2];
int nrOfLines = 0;
color c = color(255);

void draw(){
   for(int i = 0; i < nrOfLines-1; i++){
     stroke(c);
     line(lines[i][0], lines[i][1],lines[i+1][0],lines[i+1][1]);
   }
}

void setup(){
  size(300,300);
  background(0);
}

void mousePressed() {
  lines[nrOfLines][0] = mouseX;
  lines[nrOfLines][1] = mouseY;
  nrOfLines++;
}

void keyPressed(){
  if (key == DELETE){
    fill(color(0));
    rect(0,0,groesse,groesse);
    nrOfLines = 0;
  }
}
