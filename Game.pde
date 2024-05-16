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
  int distanceFromEdge = 120; // Afstand fra kanten
  
  int boxWidth = 50;
  int boxHeight = 150

  int[] joystickValues = new int[2]; // Array til at gemme joysticks' y-akseværdier
  float maxSpeed = 5.0; // Maksimal hastighed for kasserne
  float player1Y; // Y-position for spawn for første boks
  float player2Y; // Y-position for spawn for anden boks
  float player1X = distanceFromEdge;
  float player2X = width - distanceFromEdge - paddleWidth;
  int middleValuePlayer1 = 505; // Midterværdi for joysticks for box 1 / værdien hvor kasse står stille
  int middleValuePlayer2 = 502; // Midterværdi for joysticks for box 2 / værdien hvor kasse står stille

  boolean wKey, sKey;
  boolean upKey, downKey;

  boolean[] boxes = new boolean[6]; // 0: Blue, 1: Red, 2: Yellow for player 1; 3: Blue, 4: Red, 5: Yellow for player 2

  boolean gamestarted = false;

  Game() {
  }

  public void setupGame() {
    fullScreen();
    frameRate(60);
    player1Y = height/2;
    player2Y = height/2;
    ballX = width / 2;
    ballY = height / 2;
    
    
    for (int i = 0; i < boxes.length; i++) {
      boxes[i] = true;
    }
    gamestarted = true;
  }

  public void updateGame() {
    if (gamestarted == true) {
      background(0);
      drawPaddles();
      drawBall();
      moveBall();
      checkCollision();
      checkBoxCollision();
      displayScores();
      drawBoxes();
      if (port.available() > 0) {
        String data = port.readStringUntil('\n');
        if (data != null) {
          data = data.trim(); // Renser datastrengen for ekstra mellemrum
          String[] values = split(data, ' ');
          if (values.length == 2) {
            joystickValues[0] = int(values[0]);
            joystickValues[1] = int(values[1]);
          }
        }
      }
    }
  }


  // Draw paddles
  void drawPaddles() {
   // Opdater boksene baseret på joysticks' y-værdier
 float player1Speed = map(joystickValues[0], 0, 1023, -maxSpeed, maxSpeed);
 float player2Speed = map(joystickValues[1], 0, 1023, -maxSpeed, maxSpeed);

 // Juster midterværdierne for joysticks med en tolerance på 5 enheder
 int tolerance = 5;

 if (abs(joystickValues[0] - middleValuePlayer1) <= tolerance) {
  joystickValues[0] = middleValuePlayer1;
 }

 if (abs(joystickValues[1] - middleValuePlayer2) <= tolerance) {
  joystickValues[1] = middleValuePlayer2;
 }

 if (joystickValues[0] > middleValuePlayer1) {
  // Opdater boks1's position med hastighed
  player1Y = player1Y + player1Speed;
  // Hold boksens position inden for skærmens grænser
  //player1Y = constrain(player1Y, 0, height); // Ændret til height
 } else if (joystickValues[0] < middleValuePlayer1) {
  // Opdater boks1's position med hastighed
  player1Y = player1Y + player1Speed;
  // Hold boksens position inden for skærmens grænser
  player1Y = constrain(player1Y, 0, height); // Ændret til height
 }

 if (joystickValues[1] > middleValuePlayer2) {
  // Opdater boks2's position med hastighed
  player2Y = player2Y + player2Speed;
  // Hold boksens position inden for skærmens grænser
  player2Y = constrain(player2Y, 0, height); // Ændret til height
 } else if (joystickValues[1] < middleValuePlayer2) {
  // Opdater boks2's position med hastighed
  player2Y = player2Y + player2Speed;
  // Hold boksens position inden for skærmens grænser
  player2Y = constrain(player2Y, 0, height); // Ændret til height
 }

 // Tegn kasserne med de opdaterede positioner
 fill(255);
 rect(distanceFromEdge, player1Y, paddleWidth, paddleHeight);

 fill(255);
 rect(width - distanceFromEdge - paddleWidth, player2Y, paddleWidth, paddleHeight);
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
 // Wall collision
    if (ballY < ballSize / 2 || ballY > height - ballSize / 2) {
    ballSpeedY = -1;
    }

 // Paddle collision for player 1
    if (ballX - ballSize / 2 < player1X + paddleWidth / 2 &&
        ballY > player1Y - paddleHeight / 2 &&
        ballY < player1Y + paddleHeight / 2 &&
        ballSpeedX < 0) {
        ballSpeedX= -1;
       
        }

 // Paddle collision for player 2
    if (ballX + ballSize / 2 > player2X - paddleWidth / 2 &&
        ballY > player2Y - paddleHeight / 2 &&
        ballY < player2Y + paddleHeight / 2 &&
        ballSpeedX > 0) {
        ballSpeedX *= -1;
       
        }
    //Scoring
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
    if (boxes[0]) rect(player1X - 100, height / 3 - boxHeight / 2, boxWidth, boxHeight);
    fill(255, 0, 0);
    if (boxes[1]) rect(player1X - 100, 2 * height / 3 - boxHeight / 2, boxWidth, boxHeight);
    fill(255, 255, 0);
    if (boxes[2]) rect(player1X - 100, height - 100 - boxHeight / 2 + boxHeight / 2, boxWidth, boxHeight);

    fill(0, 0, 255);
    if (boxes[3]) rect(player2X + 50, height / 3 - boxHeight / 2, boxWidth, boxHeight);
    fill(255, 0, 0);
    if (boxes[4]) rect(player2X + 50, 2 * height / 3 - boxHeight / 2, boxWidth, boxHeight);
    fill(255, 255, 0);
    if (boxes[5]) rect(player2X + 50, height - 100 - boxHeight / 2 + boxHeight / 2, boxWidth, boxHeight);
}

  void checkBoxCollision() {
    // Check for box collisions for player 1
    if (ballX < player1X && ballPos.x > player1X - boxWidth) {
        if (ballY > height / 3 - boxHeight / 2 && ballY < height / 3 + boxHeight / 2 && boxes[0]) {
            boxes[0] = false;
        } else if (ballY > 2 * height / 3 - boxHeight / 2 && ballY < 2 * height / 3 + boxHeight / 2 && boxes[1]) {
            boxes[1] = false;
        } else if (ballY > height - 100 - boxHeight / 2 && ballY < height - 100 + boxHeight / 2 && boxes[2]) {
            boxes[2] = false;
        }
    }

    // Check for box collisions for player 2
    if (ballX > player2X && ballX < player2X + boxWidth) {
        if (ballY > height / 3 - boxHeight / 2 && ballY < height / 3 + boxHeight / 2 && boxes[3]) {
            boxes[3] = false;
        } else if (ballY > 2 * height / 3 - boxHeight / 2 && ballY < 2 * height / 3 + boxHeight / 2 && boxes[4]) {
            boxes[4] = false;
        } else if (ballY > height - 100 - boxHeight / 2 && ballY < height - 100 + boxHeight / 2 && boxes[5]) {
            boxes[5] = false;
        }
    }
}

  void resetBall() {
    ballX = width / 2;
    ballY = height / 2;
    
    //Reset boxes
    for (int i = 0; i < boxes.length; i++) {
     boxes[i] = true;
  }
}
