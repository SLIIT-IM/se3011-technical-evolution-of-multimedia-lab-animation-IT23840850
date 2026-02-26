// -------- BALL --------
float x = 200 , y = 100;
float speedx = 4 , speedy = 3;
float r = 10;

// -------- PADDLE --------
float paddlex;
float paddley;
float pwidth = 120;
float pheight = 10;
float step = 30;

// -------- GAME CONTROL --------
boolean trails = false;

int state = 0;
int startTime;
int duration = 30;
int score = 0;
float gameSpeed = 1;

void setup() {
  size(750, 530);
  paddlex = width/2;
  paddley = height - 30;
}

void draw() {

  // -------- START SCREEN --------
  if (state == 0) {
    background(255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Press ENTER to Start", width/2, height/2);
    return;
  }

  // -------- PLAY SCREEN --------
  if (state == 1) {

    // ⭐ FIXED TRAIL SYSTEM ⭐
    if (!trails) {
      background(255);
    } else {
      // Clear entire screen with transparency
      fill(255, 40);
      noStroke();
      rectMode(CORNER);
      rect(0, 0, width, height);
    }

    // -------- TIMER --------
    int elapsed = (millis() - startTime) / 1000;
    int left = duration - elapsed;

    fill(0);
    textSize(18);
    textAlign(LEFT, TOP);
    text("Time Left: " + left, 20, 20);
    text("Score: " + score, 20, 40);
    text("Speed: " + nf(gameSpeed,1,2), 20, 60);

    if (left <= 0) {
      state = 2;
    }

    // -------- MOVE BALL --------
    x += speedx * gameSpeed;
    y += speedy * gameSpeed;

    // WALL BOUNCE
    if (x > width - r || x < r) speedx *= -1;
    if (y < r) speedy *= -1;

    // GAME OVER
    if (y > height) {
      state = 2;
    }

    // -------- PADDLE COLLISION --------
    if (y + r > paddley &&
        x > paddlex - pwidth/2 &&
        x < paddlex + pwidth/2) {

      speedy *= -1;
      y = paddley - r;
      score += 5;
    }

    // -------- DRAW BALL --------
    fill(#8100D1);
    noStroke();
    ellipse(x, y, r*2, r*2);

    // -------- DRAW PADDLE --------
    fill(0);
    rectMode(CENTER);
    rect(paddlex, paddley, pwidth, pheight, 8);

    paddlex = constrain(paddlex,
                        pwidth/2,
                        width - pwidth/2);
  }

  // -------- END SCREEN --------
  if (state == 2) {
    background(255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(24);

    text("Game Over!\nScore: " + score +
         "\nSpeed: " + nf(gameSpeed,1,2) +
         "\nPress R to Restart", width/2, height/2);
  }
}

void keyPressed() {

  // START GAME
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }

  // RESET GAME
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0;
    x = 100;
    y = 100;
    score = 0;
    gameSpeed = 1;
  }

  // TRAILS TOGGLE
  if (key == 't' || key == 'T') {
    trails = !trails;
  }

  // SPEED CONTROL
  if (key == '+') {
    gameSpeed += 0.2;
  }

  if (key == '-') {
    gameSpeed -= 0.2;
    if (gameSpeed < 0.2) gameSpeed = 0.2;
  }

  // PADDLE MOVE
  if (state == 1) {
    if (keyCode == RIGHT) paddlex += step * gameSpeed;
    if (keyCode == LEFT)  paddlex -= step * gameSpeed;
  }
}
