final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 14;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

//declare global variables
Sprite player;
PImage img;
ArrayList<Sprite> platforms;
int change_x;

float view_x = 0;
float view_y = 0;

void setup(){
  size(800, 600);
  imageMode(CENTER);
  p = new Sprite("player.png", 0.8, 400, 200);
  p.change_x = 0;
  p.change_y = 0;
}

void draw(){
  background(255);
  scroll();
  
  p.display();
  resolvePlatformCollisions(p, platforms);
  
  for(Sprite s: platforms)
    s.display();
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

//called whenever a key is pressed.
void keyPressed(){
    ifIkeyCode == RIGHT){
      player.change_x = MOVE_SPEED;
    }
    else if(keyCode == LEFT){
      player.change_x = -MOVE_SPEED;
    }
    else if(key == 'a' && isOnPlatforms(player, platforms)){
      player.change_y = -JUMP_SPEED;
    }
}
