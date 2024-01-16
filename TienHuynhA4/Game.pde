class Game {
  ArrayList<Particle> Particle = new ArrayList<Particle>();
  ArrayList<Particle> newParticle = new ArrayList<Particle>();
  HashMap<String, PImage> cachedImages = new HashMap<String, PImage>();

  boolean paused = false;

  PImage getImage(String uri, int width, int height) {
    if (cachedImages.containsKey(uri)) {
      return cachedImages.get(uri);
    } else {
      PImage newImage = loadImage(uri);
      newImage.resize(width, height); // Resize the image
      cachedImages.put(uri, newImage);
      return newImage;
    }
  }

  void addParticle(Particle s) {
    // This method adds a new Particle to the game.
    // Particle are objects that can be updated and displayed in the game.

    newParticle.add(s);
  }

  void run() {
    // This method is the main game loop.
    // It updates and displays all the Particle in the game.

    if (newParticle.size() > 0) {
      for (Particle s : newParticle) {
        Particle.add(s);
      }
      newParticle.clear();
    }

    if (!paused) {
      for (Particle s : Particle) {
        s.update();
      }
    }

    for (Particle s : Particle) {
      s.display();
    }

    // Pruning: Remove dead Particle from the game.
    for (int index = Particle.size() - 1; index >= 0; index--) {
      Particle s = Particle.get(index);
      if (s.dead)
        Particle.remove(index);
    }
  }
}
