class Particle {
  PVector position;
  float direction = 0;
  float speed = 0;
  float radius = 20;

  PImage frame;
  boolean dead = false;
  

  Particle(float x, float y) {
    position = new PVector(x, y);
  }

  void update() {
    // This method updates the position of the Particle based on its speed and direction.
    position.x += sin(radians(direction)) * speed;
    position.y -= cos(radians(direction)) * speed;
  }

  void display() {
    // This method displays the Particle on the screen.
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(direction));
    image(frame, 0, 0);
    popMatrix();
  }
  
  // Collision detection with another particle
  boolean collidesWith(Particle other) {
    float distance = dist(position.x, position.y, other.position.x, other.position.y);
    float minDistance = radius + other.radius;
    return distance < minDistance;
  }
}

class Enemy extends Particle {
  boolean moveRight = true;
  float moveSpeed = 2;
  float keyframeX;
  float keyframeY;
  float lerpFactor = 0.05; // Adjust the lerp factor for the ease-in/out effect
  int shootCooldown = 65;

  Enemy(float x, float y, String skin) {
    super(x, y);
    this.frame = game.getImage(skin, 50, 50);
    updateKeyframe(); // Initialize the keyframe positions
  }

  void updateKeyframe() {
    keyframeX = random(0, width); // Ensure keyframes are within the visible area
    keyframeY = random(0, height / 2); 
  }

  @Override
  void update() {
    super.update();

    // If the enemy is close to the keyframe position, update the keyframe
    float distanceThreshold = 10;
    if (dist(position.x, position.y, keyframeX, keyframeY) < distanceThreshold) {
      updateKeyframe();
    }

    // Ease-in/out lerping
    float lerpX = lerp(position.x, keyframeX, lerpFactor);
    float lerpY = lerp(position.y, keyframeY, lerpFactor);
    position.set(lerpX, lerpY);
    
    //check collision
    if (collidesWith(player)) {
      player.dead = true; // Player dies
    }
    // Shoot bullets periodically
    if (frameCount % shootCooldown == 0) {
      shootBullet();
    }
  }
  void shootBullet() {
    Bullet enemyBullet = new Bullet(position.x, position.y + 30, 180, true); 
    enemyBullet.frame = game.getImage("enemyBullet.png", 15, 30); 
    game.addParticle(enemyBullet);
    enemyBullets.add(enemyBullet);
  }
}


class Player extends Particle {
  boolean[] buttons = new boolean[6];

  int LEFT_BUTTON = 0;
  int RIGHT_BUTTON = 1;
  int UP_BUTTON = 2;
  int DOWN_BUTTON = 3;
  int FIRE_BUTTON = 4;
  int SHIELD_BUTTON = 5;
  float MAX_SPEED = 5;
  float homeX;
  float homeY;
  float driftSpeed = 0.02; // Adjust the drift speed as needed

  Player(float homeX, float homeY) {
    super(homeX, homeY);
    this.homeX = homeX;
    this.homeY = homeY;
  }

  @Override
  void update() {
    super.update();

    if (buttons[FIRE_BUTTON]) {
      // Create a bullet and add it to the game
      Bullet bullet = new Bullet(position.x, position.y - 30, direction, false);
      bullet.frame = game.getImage(bulletImage, 5, 5);
      game.addParticle(bullet);
      bullets.add(bullet);
    }

    // If no keys are pressed, drift back toward the home location
    if (!buttons[LEFT_BUTTON] && !buttons[RIGHT_BUTTON] && !buttons[UP_BUTTON] && !buttons[DOWN_BUTTON]) {
      position.x = lerp(position.x, homeX, driftSpeed);
      position.y = lerp(position.y, homeY, driftSpeed);
    } else {
      // Reset speed
      speed = 0;

      if (buttons[LEFT_BUTTON]) {
        position.x -= MAX_SPEED;
      }
      if (buttons[RIGHT_BUTTON]) {
        position.x += MAX_SPEED;
      }
      if (buttons[UP_BUTTON]) {
        position.y -= MAX_SPEED;
      }
      if (buttons[DOWN_BUTTON]) {
        position.y += MAX_SPEED;
      }
    }

    // Ensure the player stays within left and right boundaries
    position.x = constrain(position.x, 0, width);
    // Ensure the player stays within top and bottom boundaries
    position.y = constrain(position.y, 0, height);

    // Check for collisions with enemy bullets
    for(Bullet enemyBullet : enemyBullets) {
      if (collidesWith(enemyBullet)) {
        dead = true; // Player dies
        gameOver = true;
      }
    }
  }
}



class Bullet extends Particle {
  float initialDirection;
  Boolean fromEnemy;

  Bullet(float x, float y, float direction,Boolean fromEnemy) {
    super(x, y);
    this.frame = game.getImage("bullet.png", 5, 5);
    speed = 10;
    this.initialDirection = direction;
    this.direction = initialDirection;
    this.fromEnemy = fromEnemy;
  }

  @Override
  void update() {
    super.update();
    
    // Remove bullets that go beyond left or right boundaries
    if (position.x < 0 || position.x > width) {
      dead = true;
    }
    if(!fromEnemy){
      // Check for collisions with enemies
      for (Enemy enemy : enemies) {
        if (collidesWith(enemy)) {
          enemy.dead = true; // Enemy dies
          dead = true; // Bullet dies
          enemiesKilled++;
        }
      }
    }
  }
}
