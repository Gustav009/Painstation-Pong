//this is our game

class Game {
int player1Score = 0;
int player2Score = 0;

float ballX, ballY;
float ballSpeedX = 4;
float ballSpeedY = 4;
float ballSize = 30;

float paddleWidth = 30;
float paddleHeight = 200;

float player1X = 150;
float player1Y;
float player2X;
float player2Y;

boolean wKey, sKey;
boolean upKey, downKey;

boolean[] boxes = new boolean[6]; // 0: Blue, 1: Red, 2: Yellow for player 1; 3: Blue, 4: Red, 5: Yellow for player 2

boolean gamestarted = false;
  
  Game() {

}
  
  public void setupGame() {
  fullScreen();
  frameRate(120);
  player1Y = height / 2;
  player2X = width - 50;
  player2Y = height / 2;
  ballX = width / 2;
  ballY = height / 2;
  for (int i = 0; i < boxes.length; i++) {
    boxes[i] = true;
  }
  gamestarted = true;
}

public void updateGame() {
  if(gamestarted == true) {
  background(0);
  handleInput();
  drawPaddles();
  drawBall();
  moveBall();
  checkCollision();
  displayScores();
  drawBoxes();
  }
}

void handleInput() {
  if (keyPressed) {
    if (key == 'w') {
      wKey = true;
    } else if (key == 's') {
      sKey = true;
    }
  } else {
    wKey = false;
    sKey = false;
  }
  
  if (keyPressed) {
    if (keyCode == UP) {
      upKey = true;
    } else if (keyCode == DOWN) {
      downKey = true;
    }
  } else {
    upKey = false;
    downKey = false;
  }
}

void drawPaddles() {
  fill(255);
  if (wKey && player1Y - paddleHeight / 2 > 0) {
    player1Y -= 5;
  }
  if (sKey && player1Y + paddleHeight / 2 < height) {
    player1Y += 5;
  }
  rect(player1X, player1Y - paddleHeight / 2, paddleWidth, paddleHeight);
  
  if (upKey && player2Y - paddleHeight / 2 > 0) {
    player2Y -= 5;
  }
  if (downKey && player2Y + paddleHeight / 2 < height) {
    player2Y += 5;
  }
  rect(player2X - paddleWidth, player2Y - paddleHeight / 2, paddleWidth, paddleHeight);
}

void drawBall() {
  fill(255);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void moveBall() {
  ballX += ballSpeedX;
  ballY += ballSpeedY;
}

void checkCollision() {
  if (ballY < 0 || ballY > height) {
    ballSpeedY *= -1;
  }
  
  if (ballX < player1X + paddleWidth && ballY > player1Y - paddleHeight / 2 && ballY < player1Y + paddleHeight / 2) {
    ballSpeedX *= -1;
    int colorIndex = floor(random(3));
    collectBox(colorIndex);
  }
  
  if (ballX > player2X - paddleWidth && ballY > player2Y - paddleHeight / 2 && ballY < player2Y + paddleHeight / 2) {
    ballSpeedX *= -1;
    int colorIndex = floor(random(3)) + 3;
    collectBox(colorIndex);
  }
  
  if (ballX < 0) {
    player2Score++;
    resetBall();
  }
  
  if (ballX > width) {
    player1Score++;
    resetBall();
  }
}

void displayScores() {
  fill(255);
  textSize(32);
  textAlign(CENTER);
  text(player1Score, width / 4, 50);
  text(player2Score, 3 * width / 4, 50);
}

void drawBoxes() {
  fill(0, 0, 255);
  if (boxes[0]) rect(player1X - 100, height / 3 - 50, 50, 50);
  fill(255, 0, 0);
  if (boxes[1]) rect(player1X - 100, 2 * height / 3 - 25, 50, 50);
  fill(255, 255, 0);
  if (boxes[2]) rect(player1X - 100, height - 100, 50, 50);
  
  fill(0, 0, 255);
  if (boxes[3]) rect(player2X + 50, height / 3 - 50, 50, 50);
  fill(255, 0, 0);
  if (boxes[4]) rect(player2X + 50, 2 * height / 3 - 25, 50, 50);
  fill(255, 255, 0);
  if (boxes[5]) rect(player2X + 50, height - 100, 50, 50);
}

void collectBox(int index) {
  if (boxes[index]) {
    boxes[index] = false;
    // Change ball color based on the box color
    if (index == 0 || index == 3) {
      fill(0, 0, 255);
    } else if (index == 1 || index == 4) {
      fill(255, 0, 0);
    } else {
      fill(255, 255, 0);
    }
    // Draw the collected box at the ball position
    rect(ballX - 10, ballY - 10, 20, 20);
  }
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
}
}
