final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50.0;

final static float DIRT_SCALE = 360.0/128;
final static float DIRT_SIZE = 360;


Sprite p;
PImage dirt, cobble, wood, leaves, diamond;
ArrayList<Sprite> platforms;

void setup() {
  size(1600,800);
  p = new Sprite("Idle 1.png", 0.2, 100, 300);
  p.change_x = 0;
  p.change_y = 0;
  
  dirt = loadImage("dirt.jpg");
  cobble = loadImage("cobble.png");
  wood = loadImage("wood.png");
  leaves = loadImage("leaves.png");
  diamond = loadImage("diamond.png");
  
  platforms = new ArrayList<Sprite>();
  createPlatforms("map.csv");  
}

//loops multiple times per second
void draw() {
  background(255);
  p.display();
  p.update();
  
  for(Sprite s: platforms)
    s.display();
}

void createPlatforms(String filename) {
  String[] lines = loadStrings(filename);
  
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      
      if (values[col].equals("1")) {
        Sprite s = new Sprite(dirt, DIRT_SCALE);
      s.center_x = WOOD_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + 2 * row * SPRITE_SIZE;
        platforms.add(s);
      } 
      else if (values[col].equals("2")) {
        Sprite s = new Sprite(cobble, DIRT_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("3")) {
        Sprite s = new Sprite(wood, DIRT_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + 2 * row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("4")) {
        Sprite s = new Sprite(leaves, DIRT_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("5")) {
        Sprite s = new Sprite(diamond, DIRT_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    p.change_x = MOVE_SPEED;
  }
  else if (keyCode == LEFT) {
    p.change_x = -MOVE_SPEED;
  }
  else if (keyCode == UP) {
    p.change_y = -MOVE_SPEED;
  }
  else if (keyCode == DOWN) {
    p.change_y = MOVE_SPEED;
  }
  
}

void keyReleased() {
  if (keyCode == RIGHT) {
    p.change_x = 0;
  }
  else if (keyCode == LEFT) {
    p.change_x = 0;
  }
  else if (keyCode == UP) {
    p.change_y = 0;
  }
  else if (keyCode == DOWN) {
    p.change_y = 0;
  }
  
}
