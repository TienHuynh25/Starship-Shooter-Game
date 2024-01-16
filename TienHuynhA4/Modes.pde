// player character
final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';

// turn textures or collisions on/off - useful for testing and debugging
final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';

boolean doTextures = false;
boolean doCollision = false;

void keyPressed() {
  switch(key) {
    case KEY_LEFT:
      player.buttons[player.LEFT_BUTTON] = true;
      break;
    case KEY_RIGHT:
      player.buttons[player.RIGHT_BUTTON] = true;
      break;
    case KEY_UP:
      player.buttons[player.UP_BUTTON] = true;
      break;
    case KEY_DOWN:
       player.buttons[player.DOWN_BUTTON] = true;
       break;
    case KEY_SHOOT:
      player.buttons[player.FIRE_BUTTON] = true;
      break;
  }
}

void keyReleased() {
  switch(key) {
    case KEY_LEFT:
      player.buttons[player.LEFT_BUTTON] = false; 
      break;
    case KEY_RIGHT:
      player.buttons[player.RIGHT_BUTTON] = false; 
      break;
    case KEY_UP:
      player.buttons[player.UP_BUTTON] = false; 
      break;
    case KEY_DOWN:
       player.buttons[player.DOWN_BUTTON] = false; 
       break;
    case KEY_SHOOT:
      player.buttons[player.FIRE_BUTTON] = false; 
      break;
  }
}
