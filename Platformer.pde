final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static float SPRITE_SCALE = 50.0/128;
final static float DIRT_SCALE = 50.0/360;
final static float COBBLE_SCALE = 50.0/600;
final static float WOOD_SCALE = 50.0/225;
final static float LEAVES_SCALE = 50.0/391;
final static float SIZE = 50.0;

final static float GRAVITY = 0.6;
final static float MOVE_SPEED = 5;
final static float JUMP_SPEED = 14;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

final static float WIDTH = SIZE * 16;
final static float HEIGHT = SIZE * 17;
final static float GROUND_LEVEL = HEIGHT - SIZE;

//declare global variables
Player p;
PImage dirt, cobble, wood, leaves, diamond, coin, enemyImg, pImg;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Enemy> enemys;
int change_x;
int numCoins;
boolean isGameOver;

float view_x =0;
float view_y = 0;

void setup() {
  size(1600, 800);
  imageMode(CENTER);
  //p = new Sprite("idleR1.png", 0.2, 100, 300);
  isGameOver = false;
  numCoins = 0;
  //p.change_x = 0;
  //p.change_y = 0;

  dirt = loadImage("dirt.jpg");
  cobble = loadImage("cobble.png");
  wood = loadImage("wood.png");
  leaves = loadImage("leaves.png");
  diamond = loadImage("diamond.png");
  coin = loadImage("gold1.png");
  enemyImg = loadImage("spider_walk_right1.png");
  pImg = loadImage("idleR1.png");

  p = new Player(pImg, 0.2);
  p.setBottom(GROUND_LEVEL-100);
  p.center_x = 100;

  float view_x =0;
  float view_y = 0;

  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  enemys = new ArrayList<Enemy>();

  createPlatforms("map2.csv");
}

//loops multiple times per second
void draw() {
  background(255);
  scroll();
  displayAll();
  if (!isGameOver) {
    updateAll();
  }
}
void displayAll() {
  // Display
  for (Sprite s : platforms)
    s.display();
  for (Sprite c : coins) {
    c.display();
  }
  for (Enemy e : enemys) {
    e.display();
  }
  p.display();

  fill(0, 0, 255);
  textSize(32);
  text("COINS:" + numCoins, view_x+50, view_y+50);
  text("LIFE:" + p.lives, view_x+50, view_y+100);

  if (isGameOver) {
    fill(255, 0, 0);
    text("GAME OVER", view_x +width/2, view_y + height/2);
    if (p.lives == 0) 
      text("Lose :(", view_x +width/2, view_y + height/2 + 50);
    else
      text("YOU ARE WINNER", view_x +width/2, view_y + height/2+50);
    text("SPACEBAR to RESTART", view_x +width/2, view_y + height/2+100);
  }
}
void updateAll() {
  p.updateAnimation();
  resolvePlatformCollisions(p, platforms);
    for (Sprite c : coins) {
    ((AnimatedSprite)c).updateAnimation();
  }
  
  for (Enemy e : enemys) {
    e.update();
    e.updateAnimation();
  }

  collectCoins();
  checkDeath();
}


void createPlatforms(String filename) {
  String[] lines = loadStrings(filename);

  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {

      if (values[col].equals("1")) { // Dirt
        Sprite s = new Sprite(dirt, DIRT_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("2")) { // Cobble
        Sprite s = new Sprite(cobble, COBBLE_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("3")) { // Wood
        Sprite s = new Sprite(wood, WOOD_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("4")) { // Leaves
        Sprite s = new Sprite(leaves, LEAVES_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("5")) { // Dirt
        Sprite s = new Sprite(diamond, DIRT_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("6")) { // Giant Enemy Spider
        float bLeft = col*SIZE;
        float bRight = bLeft+4*SIZE;
        Enemy e = new Enemy(enemyImg, 50/72.0, bLeft, bRight);
        e.center_x = SIZE/2 + col * SIZE;
        e.center_y = SIZE/2 + row * SIZE;
        enemys.add(e);
      } else if (values[col].equals("9")) { // Coin
        Coin c = new Coin(coin, SPRITE_SCALE);
        c.center_x = SIZE/2 + col * SIZE;
        c.center_y = SIZE/2 + row * SIZE;
        coins.add(c);
      }
    }
  }
}
public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls) {
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  if (col_list.size() > 0) {
    return true;
  } else
    return false;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
  //add gravity to change_y
  s.change_y += GRAVITY;

  //move in the y-directioon then resolve collision
  // by computing collision list and fixing the collision.
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_y > 0) {
      s.setBottom(collided.getTop());
    } else if (s.change_y < 0) {
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  //move in the x-directioon then resolve collision
  // by computing collision list and fixing the collision.
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_x > 0) {
      s.setRight(collided.getLeft());
    } else if (s.change_x < 0) {
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
}


void scroll() {
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if (p.getRight() > right_boundary) {
    view_x += p.getRight() - right_boundary;
  }

  float left_boundary = view_x + LEFT_MARGIN;
  if (p.getLeft() < left_boundary) {
    view_x -= left_boundary - p.getLeft();
  }

  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if (p.getBottom() > bottom_boundary) {
    view_y += p.getBottom() - bottom_boundary;
  }

  float top_boundary = view_y + VERTICAL_MARGIN;
  if (p.getTop() < top_boundary) {
    view_y -= top_boundary - p.getTop();
  }

  translate(-view_x, -view_y);
}

void keyPressed() {
  if (keyCode == RIGHT) {
    p.change_x = MOVE_SPEED;
  } else if (keyCode == LEFT) {
    p.change_x = -MOVE_SPEED;
  } else if (keyCode == DOWN) {
    p.change_y = MOVE_SPEED;
  } else if (keyCode == UP && isOnPlatforms(p, platforms)) {
    p.change_y = -JUMP_SPEED;
  } else if (isGameOver && key == ' ') setup();
}

void keyReleased() { // Get rid of ELSEs?
  if (keyCode == RIGHT) {
    p.change_x = 0;
  }
  if (keyCode == LEFT) {
    p.change_x = 0;
  }
  if (keyCode == UP) {
    p.change_y = 0;
  }
  if (keyCode == DOWN) {
    p.change_y = 0;
  }
}

boolean checkCollision(Sprite s1, Sprite s2) {
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();    
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom(); 
  if (noXOverlap || noYOverlap) {
    return false;
  } else {
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

void collectCoins() {
  ArrayList<Sprite> coin_list = checkCollisionList(p, coins);
  if (coin_list.size() > 0) {
    for (Sprite coin : coin_list) {
      numCoins++;
      coins.remove(coin);
    }
  }
  if (coins.size()==0) {
    isGameOver = true;
  }
}
void checkDeath() {
  boolean collideEnemy = false;
  for (Enemy e : enemys) {
    if (checkCollision(p, e)) {
      collideEnemy = true;
    }
  }
  boolean fallOffCliff = p.getBottom() > GROUND_LEVEL;
  if (collideEnemy || fallOffCliff) {
    p.lives--;
    if (p.lives == 0) {
      isGameOver = true;
    } else {
      p.center_x = 100;
      p.setBottom(GROUND_LEVEL - 100);
    }
  }
}
