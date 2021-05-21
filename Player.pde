public class Player extends AnimatedSprite {
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;

  public Player(PImage img, float scale) {
    super(img, scale);
    lives = 3;
    direction = RIGHT_FACING;
    onPlatform = false;
    inPlace = true;
    standLeft = new PImage[2];
    standLeft[0] = loadImage("idleL1.png");
    standLeft[1] = loadImage("idleL2.png");
    standRight = new PImage[2];
    standRight[0] = loadImage("idleR1.png");
    standRight[1] = loadImage("idleR2.png");

    jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("l4.png");
    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("r4.png");

    moveLeft = new PImage[4];
    moveLeft[0] = loadImage("l1.png");
    moveLeft[1] = loadImage("l2.png");
    moveLeft[2] = loadImage("l3.png");
    moveLeft[3] = loadImage("l4.png");

    moveRight = new PImage[4];
    moveRight[0] = loadImage("r1.png");
    moveRight[1] = loadImage("r2.png");
    moveRight[2] = loadImage("r3.png");
    moveRight[3] = loadImage("r4.png");
    currentImages = standRight;
  }

  @Override
    public void updateAnimation() {
    onPlatform = isOnPlatforms(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }

  @Override
    public void selectDirection() {
    if (change_x > 0) {
      direction = RIGHT_FACING;
    } else if (change_x<0) {
      direction = LEFT_FACING;
    }
  }

  @Override
    public void selectCurrentImages() {
    if (direction == RIGHT_FACING) {
      if (inPlace) {
        currentImages = standRight;
      } else if (!onPlatform) {
        currentImages = jumpRight;
      } else {
        currentImages = moveRight;
      }
    } else if (direction == LEFT_FACING) {
      if (inPlace) {
        currentImages = standLeft;
      } else if (!onPlatform) {
        currentImages = jumpLeft;
      } else {
        currentImages = moveLeft;
      }
    }
  }
}
