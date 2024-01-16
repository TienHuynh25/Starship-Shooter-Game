Game game;
Player player;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
ArrayList<Bullet> enemyBullets;
ArrayList<PVector> stars;
int numStars = 500;
String[] enemyImages = {"ufo0.png", "ufo1.png", "ufo2.png", "ufo3.png"};
String playerSkin = "starShip0.png";
String bulletImage = "bullet.png";
boolean gameOver = false;
int enemiesKilled = 0;

// Constants
final int INITIAL_ENEMY_COUNT = 5;
final int ENEMIES_TO_CREATE = 10;

void setup() {
  size(600, 600, P3D);
  initializeGame();
}

void draw() {
  background(0);
  
  if (!gameOver) {
    drawGame();
  } else {
    drawGameOverScreen();
  }
}

void initializeGame() {
  colorMode(RGB, 1.0f);
  textureMode(NORMAL);
  textureWrap(REPEAT);
  imageMode(CENTER);
  game = new Game();
  initializeCamera();
  initializeStars(numStars);
  initializePlayerAndEnemies();
}

void initializeCamera() {
  float fov = PI / 2;
  float cameraZ = (height / 2.0) / tan(fov / 2.0);
  perspective(PI / 3, float(width) / float(height), cameraZ / 10.0, cameraZ * 10.0);
  translate(width / 2, height / 2, -cameraZ * 2);
}

void initializeStars(int numStars) {
  stars = new ArrayList<PVector>();
  for (int i = 0; i < numStars; i++) {
    float x = random(width);
    float y = random(height);
    float z = 0; // Stars are at z=0
    float size = random(1, 3);
    stars.add(new PVector(x, y, size));
  }
}

void initializePlayerAndEnemies() {
  player = new Player(width / 2, height);
  player.frame = game.getImage(playerSkin, 50, 50);
  player.direction = 360;
  game.addParticle(player);
  
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  enemyBullets = new ArrayList<Bullet>();

  // Create enemies at the top
  for (int i = 0; i < INITIAL_ENEMY_COUNT; i++) {
    String enemySkin = enemyImages[int(random(enemyImages.length))];
    Enemy enemy = new Enemy(random(-width, width), random(-height, height / 2), enemySkin);
    game.addParticle(enemy);
    enemies.add(enemy);
  }
}

void drawGame() {
  drawStars();
  player.update();

  for (Enemy enemy : enemies) {
    enemy.update();
  }

  player.display();

  for (Enemy enemy : enemies) {
    enemy.display();
  }

  handleCollisions();
  updateAndDisplayBullets();
  removeDeadParticles();
  displayScore();

  createNewEnemiesIfNeeded();
}

void handleCollisions() {
  for (Enemy enemy : enemies) {
    if (player.collidesWith(enemy)) {
      player.dead = true;
      gameOver = true;
    }
  }
}

void updateAndDisplayBullets() {
  for (Bullet bullet : bullets) {
    bullet.update();
    bullet.display();
  }

  for (Bullet bullet : enemyBullets) {
    bullet.update();
    bullet.display();
  }
}

void removeDeadParticles() {
  enemies.removeIf(e -> e.dead);
  bullets.removeIf(b -> b.dead);
  enemyBullets.removeIf(b -> b.dead);
}

void displayScore() {
  fill(255, 128, 0);
  text(enemiesKilled, 30, 30);
}

void createNewEnemiesIfNeeded() {
  if (enemies.size() < 2) {
    for (int i = 0; i < ENEMIES_TO_CREATE; i++) {
      String enemySkin = enemyImages[int(random(enemyImages.length))];
      Enemy enemy = new Enemy(random(-width, width), random(-height, height / 2), enemySkin);
      game.addParticle(enemy);
      enemies.add(enemy);
    }
  }
}

void drawGameOverScreen() {
  background(0);
  fill(150, 50, 20);
  textSize(64);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 2 - 30);
  drawPlayAgainButton();
}

void drawPlayAgainButton() {
  noFill();
  rect(width / 2 - 100, height / 2 + 20, 200, 40, 10);
  fill(150, 50, 20);
  textSize(32);
  String buttonText = "Play Again";
  text(buttonText, width / 2, height / 2 + 40);
}

void mousePressed() {
  if (gameOver) {
    checkPlayAgainButtonClick();
  }
}

void checkPlayAgainButtonClick() {
  float buttonX = width / 2 - 100;
  float buttonY = height / 2 + 20;
  float buttonWidth = 200;
  float buttonHeight = 40;

  if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
      mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    resetGame();
  }
}

void resetGame() {
  gameOver = false;
  player.dead = false;
  enemiesKilled = 0;
  player.position.set(width / 2, height - 50);
  enemies.clear();
  bullets.clear();
  enemyBullets.clear();

  for (int i = 0; i < INITIAL_ENEMY_COUNT; i++) {
    String enemySkin = enemyImages[int(random(enemyImages.length))];
    Enemy enemy = new Enemy(random(-width, width), random(-height, height / 2), enemySkin);
    game.addParticle(enemy);
    enemies.add(enemy);
  }
}

void drawStars() {
  stroke(0, 0, 255);
  fill(255, 0, 255);

  for (PVector star : stars) {
    pushMatrix();
    translate(star.x, star.y);
    ellipse(0, 0, star.z, star.z);
    popMatrix();
  }
}
