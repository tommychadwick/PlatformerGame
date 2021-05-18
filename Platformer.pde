final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float DIRT_SCALE = 50.0/360;
final static float COBBLE_SCALE = 50.0/600;
final static float WOOD_SCALE = 50.0/225;
final static float LEAVES_SCALE = 50.0/391;
final static float SIZE = 50.0;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 14;

//declare global variables
Sprite p;
PImage dirt, cobble, wood, leaves, diamond;
ArrayList<Sprite> platforms;
int change_x;

float view_x =0;
float view_y = 0;

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
  scroll;
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

void scroll(){
   float right_boundary = view_x + width - RIGHT_MARGIN;
   if(player.getRight() > right_boundary){
     view_x += player.getRight() - right_boundary;
   }
   
   float left_boundary = view_x + LEFT_MARGIN;
   if(player.getLeft() < left_boundary){
     view_x -= left_boundary - player.getLeft();
   }
   
   float bottom_boundary = view_y + height - VERTICAL_MARGIN;
   if(player.getBottom() > bottom_boundary){
     view_y += player,getBottom() - bottom_boundary;
   }
   
   float top_boundary = view_y + VERTICAL_MARGIN;
   if(player.getTop() < top_boundary){
     view_y -= top_boundary - player.getTop();
   }
   
   translate(-view_x, -view_y);
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
  else if(key == 'a' && isOnPlatforms(player, platforms)){
      player.change_y = -JUMP_SPEED;
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

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  if(col_list.size() > 0){
    return true;
  }
  else
    return false;
}

public void resolvePlatformCollisions(Spite s, ArrayList<Sprite> walls){
  //add gravity to change_y
  s.change_y +=GRAVITY;
  s.center_x += s.change_x;
  
  //move in the y-directioon then resolve collision
  // by computing collision list and fixing the collision.
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
     s.setTop(collided.getBottom()); 
    }
    s.change_y = 0;
  }
  
  //move in the x-directioon then resolve collision
  // by computing collision list and fixing the collision.
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_x > 0){
      s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
     s.setLeft(collided.getRight()); 
    }
  }
}


