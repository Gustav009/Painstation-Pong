int state = 0;

void setup() {
  fullScreen();
}

void draw() {
  background(220);
  
  // Tegn knapperne
  fill(255);
  rectMode(CENTER);
  rect(width/2, height/3, 300, 150);
  rect(width/2, height/3+180, 300,150);
  rect(width/2, height/3+360, 300,150);
  
  // Tekst på knapperne
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text("Start", width/2, height/3, 200, 50);
  text("Indstillinger", width/2, height/3+180, 300, 50);
  text("Quit", width/2, height/3+360, 200, 50);
  
  // Logik for at skifte tilstanden baseret på knaptryk
  if (state == 1) {
    fill(50);
    textSize(30);
    text("Spillet er startet!", 150, 200);
  } else if (state == 2) {
    fill(50);
    textSize(30);
    text("Indstillingerne åbnes...", 150, 200);
  } else if (state == 3) {
    exit(); // Luk programmet
  }
}

void mousePressed() {
  if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
    if (mouseY > height/3 - 75 && mouseY < height/3 + 75) {
      state = 1; // Start knap trykket
    } else if (mouseY > height/3 + 105 && mouseY < height/3 + 255) {
      state = 2; // Indstillinger knap trykket
    } else if (mouseY > height/3 + 285 && mouseY < height/3 + 435) {
      state = 3; // Quit knap trykket
    }
  }
}
