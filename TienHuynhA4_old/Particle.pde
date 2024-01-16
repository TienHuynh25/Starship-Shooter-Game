// Abstract Particle class
abstract class Particle {
  float x, y, size;
  
  Particle(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void update() {
    // Update particle logic
  }
  
  void display() {
    // Display particle
  }
}

// Player class extending Particle
class Player extends Particle {
  // Additional properties and methods specific to the player
  // ...
  
  // Example method for player movement
  void moveLeft() {
    x -= 5;
  }
  
  // Additional movement methods
  // ...
}

// Enemy class extending Particle
class Enemy extends Particle {
  // Additional properties and methods specific to enemies
  // ...
}

// Bullet class extending Particle
class Bullet extends Particle {
  // Additional properties and methods specific to bullets
  // ...
}
