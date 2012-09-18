int groesse = 300;

void draw(){
   for(int i = 0; i < 100; i++){
     color c = color(random(255),random(255),random(255));
     stroke(c);
     line(random(groesse),random(groesse),random(groesse),random(groesse));
   }
   noLoop();
}

void setup(){
  size(300,300);
  background(0);
}


void mousePressed() {
   fill(0);
   rect(0,0,groesse,groesse);
   loop();
}
