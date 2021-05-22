// CSV Numbers:
// 1 = Dirt
// 2 = Cobblestone
// 3 = Wood
// 4 = Leaves
// 6 = Spider OR
// e# = Spider. Replace # with the distance you want it to move.
// 10 = Invisible Block
// 9 = Diamond
// s = Player Start Location

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static float SPRITE_SCALE = 50.0/128;
final static float DIRT_SCALE = 50.0/128;
final static float COBBLE_SCALE = 50.0/128;
final static float WOOD_SCALE = 50.0/128;
final static float LEAVES_SCALE = 50.0/128;
final static float SIZE = 50.0;

final static float GRAVITY = 0.6;
final static float MOVE_SPEED = 5;
final static float JUMP_SPEED = 14;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

final static int maxLevels = 3;
//final static int maxLevels = 2; //TESTING

final static float WIDTH = SIZE * 16;
final static float HEIGHT = SIZE * 17;
final static float GROUND_LEVEL = HEIGHT - SIZE;



//declare global variables
Player p;
PImage dirt, cobble, wood, leaves, blank, coin, enemyImg, pImg;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Enemy> enemys;
int change_x;
int numCoins;

int currentLevel = 1;
int completedLevels = 0;

boolean isGameOver;

float view_x =0;
float view_y = 0;

float[] startLocation = new float[2];

void setup() {

  size(1600, 800, P2D);
  imageMode(CENTER);

  isGameOver = false;
  numCoins = 0;

  dirt = loadImage("dirt.jpg");
  cobble = loadImage("cobble.png");
  wood = loadImage("wood.png");
  leaves = loadImage("leaves.png");
  blank = loadImage("blank.png");
  coin = loadImage("gold1.png");
  enemyImg = loadImage("spider_walk_right1.png");
  pImg = loadImage("idleR1.png");

  p = new Player(pImg, 0.4);
  p.setBottom(GROUND_LEVEL-100); // Default Location
  p.center_x = 100;

  view_x = 0;
  view_y = 0;

  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  enemys = new ArrayList<Enemy>();
  createPlatforms("map" + currentLevel +".csv");
  //createPlatforms("test" + currentLevel +".csv");
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
  textAlign(LEFT);
  textSize(32);
  text("COINS:" + numCoins, view_x+10, view_y+40);
  text("LIFE:" + p.lives, view_x+1600-100, view_y+40);
  text("LEVEL:" + completedLevels, view_x+1600-700, view_y+40);

  if (isGameOver) {
    textAlign(CENTER);
    fill(0, 0, 255, 100);
    noStroke();
    rect(view_x+width/2-310, view_y+height/2-100, 620, 175); 


    //text("GAME OVER", view_x +width/2, view_y + height/2);
    if (p.lives == 0) {
      fill(255, 0, 0);
      text("GAME OVER", view_x +width/2, view_y + height/2 - 50);
      text("You completed "+completedLevels+" level(s)!", view_x +width/2, view_y + height/2);
      text("SPACEBAR to RESTART", view_x +width/2, view_y + height/2+50);
    } else {
      fill(0, 0, 255);
      text("YOU ARE WINNER", view_x +width/2, view_y + height/2-50);
      text("Press SPACEBAR to continue to Level " + currentLevel, view_x +width/2, view_y + height/2+50);
      if (currentLevel==1) {
        fill(255, 0, 0);
        text("WARNING! Enemy speed increased!", view_x +width/2, view_y + height/2);
      }
    }
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
      } else if (values[col].equals("6")||values[col].length()>1 && values[col].substring(0, 1).equals("e")) { // Giant Enemy Spider
        float bLeft = col*SIZE;
        float bRight = bLeft+4*SIZE;
        if (!values[col].substring(1).equals("")) { // Redundacy.
          bLeft = col*SIZE;
          bRight = bLeft+float(values[col].substring(1))*SIZE;
        }
        Enemy e = new Enemy(enemyImg, 50/72.0, bLeft, bRight);
        e.center_x = SIZE/2 + col * SIZE;
        e.center_y = SIZE/2 + row * SIZE;
        enemys.add(e);
      } else if (values[col].equals("9")) { // Coin
        Coin c = new Coin(coin, SPRITE_SCALE);
        c.center_x = SIZE/2 + col * SIZE;
        c.center_y = SIZE/2 + row * SIZE;
        coins.add(c);
      } else if (values[col].equals("10")) { // Blank
        Sprite s = new Sprite(blank, SPRITE_SCALE);
        s.center_x = SIZE/2 + col * SIZE;
        s.center_y = SIZE/2 + row * SIZE;
        platforms.add(s);
      } else if (values[col].equals("s")) { // Start Location
        startLocation[1] = SIZE/2 + col * SIZE; // X
        startLocation[0] = SIZE/2 + row * SIZE; // Y

        p.setBottom(startLocation[0]);
        p.center_x = startLocation[1];
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
    //p.change_y = MOVE_SPEED;
  } else if (keyCode == UP && isOnPlatforms(p, platforms)) {
    p.change_y = -JUMP_SPEED;
  } else if (isGameOver && key == ' ') { 
    if (p.lives==0) { //TRUE RESET
      completedLevels = 0;
      currentLevel = 1;
    }
    setup();
  }
}

void keyReleased() { // Get rid of ELSEs?
  if (keyCode == RIGHT) {
    p.change_x = 0;
  }
  if (keyCode == LEFT) {
    p.change_x = 0;
  }
  if (keyCode == UP) {
    if (p.change_y < 0) p.change_y=0;
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
  if (coins.size()==0) { //Good ending.
    isGameOver = true;
    if (currentLevel>=maxLevels) {
      currentLevel=1;
      completedLevels++;
    } else { 
      currentLevel++;
      completedLevels++;
    }
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
    } else {  // "Soft Reset," When player loses a life.
      p.setBottom(startLocation[0]);
      p.center_x = startLocation[1];
      view_y = 0;
    }
  }
}
