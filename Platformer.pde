final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float DIRT_SCALE = 50.0/360;
final static float COBBLE_SCALE = 50.0/600;
final static float WOOD_SCALE = 50.0/225;
final static float LEAVES_SCALE = 50.0/391;
final static float SIZE = 50.0;

Sprite p;
PImage dirt, cobble, wood, leaves, diamond;
ArrayList<Sprite> platforms;

void setup() {
  size(1600,800);
  imageMode(CENTER);
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
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } 
      else if (values[col].equals("2")) {
        Sprite s = new Sprite(cobble, COBBLE_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("3")) {
        Sprite s = new Sprite(wood, WOOD_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("4")) {
        Sprite s = new Sprite(leaves, LEAVES_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("5")) {
        Sprite s = new Sprite(diamond, DIRT_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
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

boolean checkCollision(Sprite s1, Sprite s2) {
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();    
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom(); 
  if(noXOverlap || noYOverlap) {
    return false;
  }
  else {
    return true;
  }
}

ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {
    if (checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}
