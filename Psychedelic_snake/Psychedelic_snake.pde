//Name: Trevor Farthing, Will Miner Date: December 7, 2015 
//Psychedelic Snake Game
//Description: Creates a simple snake arcade game with crazy visuals 
//             in the background at certain points
//Some visuals taken from previous projects and incorporated into game

import ddf.minim.*;
Minim minim;
AudioPlayer player1; //Audio player to play background song
AudioPlayer player2;  //Audio player for sound effects

int[] snakeX = new int[100]; //X locations of snake parts
int[] snakeY = new int[100]; //Y locations of snake parts
//Below booleans will keep track of direction of snake
boolean NORTH = false;
boolean SOUTH = false;
boolean EAST = false;
boolean WEST = false;
int foodX; //X location of the food
int foodY; //Y location of the food
int speed = 15; //How fast the snake is moving
boolean foodEaten = false; //If the food has been eaten by the snake
int blockSize = 15; //Size of the snake parts
int snakeLength = 0; //The total length of the snake
boolean gameOver = false;

//Background image
PImage bg;

//Variables for VISUAL 1
int xPos = 100;
int yPos = 100;
boolean movingRight = true;
boolean movingDown = false;
int xChange = 1;
int yChange = -2;

//Variables for VISUAL 2
int ellipseRadius = 0;
int rectRadius = 600;
boolean edge = false;
int ellipseXPos = width/2;
int ellipseYPos = height/2;
float linex = 0;
float liney = 0;

//Variables for VISUAL 3
int ballxpos = 0;
int ballypos = 300;
int ballradius = 10;
boolean right = true;
boolean down = true;

void setup() {
  size(600,600);
  snakeX[0] = width/2;
  snakeY[0] = height/2;
  foodX = (int)(random(width - blockSize/2) + blockSize/2);
  foodY = (int)(random(height - blockSize/2) + blockSize/2);
  rectMode(CENTER);
  frameRate(20);
  bg = loadImage("spiral.png");
  minim = new Minim(this);
  player1 = minim.loadFile("cinema.mp3");
  player1.play();
  player1.loop(); //Uncomment these lines to hear music
}

void draw() {
  if(snakeLength < 20) {
    image(bg,0,0);
  } else if(snakeLength < 30) {
    background(random(255),random(255),random(255));
  } else {
    bg = loadImage("face.jpg");
    image(bg,0,0);
  }
  
    //Displays visuals in the background
  if(snakeLength >= 5 && snakeLength < 10) {
    visual1();
  } else if(snakeLength >= 10 && snakeLength <= 30) {
    visual2();
  } else if(snakeLength >= 30) {
    visual3();
  }
  
  //Changes the direction of the snake based on the arrow key pressed
  if(keyPressed) {
    if(key == CODED) {
      if(keyCode == UP) {
        NORTH = true;
        SOUTH = EAST = WEST = false;
      } else if(keyCode == DOWN) {
        SOUTH = true;
        NORTH = EAST = WEST = false;
      } else if(keyCode == LEFT) {
        WEST = true;
        SOUTH = EAST = NORTH = false;
      } else if(keyCode == RIGHT) {
        EAST = true;
        SOUTH = NORTH = WEST = false;
      }
    }
  }
  rectMode(CENTER);
  //Functions to run the game
  moveSnake();
  updateTail();
  fill(255);
  collisionCheck();
  if(foodChecker(snakeX[0], snakeY[0])) { //goes into if block if current snake head location is food 
    foodEaten = true;
  }
  displayFood();
  
  fill(255); 
  textSize(20); 
  //Displays the score in upper left
  text("SCORE: " + snakeLength, 50,50);
 
 //Checks if player has won the game
  if(snakeLength == 100) {
    gameOver();
    restartCheck();
  }
}

//Checks for collisions between the snake itself and between the snake and wall
void collisionCheck() {
  for(int i = snakeLength; i > 0; i--) {
    if(snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
      gameOver();
      restartCheck();
    }
  }
  //Checks for wall collisions
  if(snakeX[0] + blockSize/2 >= width + speed || snakeY[0] + blockSize/2 >= height + speed || 
     snakeY[0] - blockSize/2 <= 0 - speed  || snakeX[0] - blockSize/2 <= 0 - speed) {
    gameOver();
    restartCheck();
  }
}

//Shows the food and updates its location if needed
void displayFood() {
  //If the food has been eaten then a new location will be generated
  if(foodEaten) {
    foodX = (int)(random(blockSize/2, width - blockSize/2));
    foodY = (int)(random(blockSize/2,height - blockSize/2));
    foodEaten = false;
  }
  fill(0,0,255);
  rect(foodX,foodY,blockSize,blockSize);
}

//Function to see if location is food, returns boolean based off result 
boolean foodChecker(int x, int y) {
  if(x >= foodX - blockSize/2 && x <= foodX + blockSize/2) {
    if(y >= foodY - blockSize/2 && y <= foodY + blockSize/2) {
      mouseEvent();
      //Plays sound effect when the snake eats the food
      player2 = minim.loadFile("ding.mp3");
      player2.play();
      snakeLength++;
      snakeX[snakeLength] = x;
      snakeY[snakeLength] = y;
      return true;
    } else {
      return false;
    }
  } else {
   return false; 
  }
}

//Actually draws the blocks of the snake
void updateTail() {
  fill(255);
  for(int i = 0; i <= snakeLength; i++) {
    rect(snakeX[i], snakeY[i], blockSize, blockSize);
  }
}

void moveSnake() {
  
  for(int i = snakeLength; i > 0; i--) { // Update tail when snake haz one 
    if(NORTH) {
      snakeX[i] = snakeX[i - 1];
      snakeY[i] = snakeY[i - 1]; 
    } else if(SOUTH) {
      snakeX[i] = snakeX[i - 1];
      snakeY[i] = snakeY[i - 1]; 
    } else if(WEST) {
      snakeX[i] = snakeX[i - 1]; 
      snakeY[i] = snakeY[i - 1];
    } else {
      snakeX[i] = snakeX[i - 1];
      snakeY[i] = snakeY[i - 1];
    }
  }
  
  if(NORTH) { //moving upwards
    snakeY[0] -=speed;
    
  } else if(SOUTH) { //moving downwards
    snakeY[0] +=speed;
    
  } else if(WEST) { //moving left
    snakeX[0] -=speed;
  } else if(EAST) { //moving right
    snakeX[0] +=speed;
  }
}

//Displays a game over message if there is a collision and asks the
//user if they wish to play again
void gameOver() {
   gameOver = true;
   speed = 0;
   fill(255,0,0); 
   textAlign(CENTER);
   textSize(50);
   if(snakeLength == 100) {
     text("YOU WIN!\n",width/2,height/2);
   } else {
     text("GAME OVER\n",width/2,height/2);
   }
   textSize(20);
   fill(255);
   text("\n\nPlay again?",width/2,height/2);
   rect(width/4,height/3 + height/4,100,50);
   rect(3*width/4,height/3 + height/4,100,50);
   fill(255,0,0);
   text("YES", width/4,height/3 + height/4);
   text("NO", 3*width/4,height/3 + height/4);
}

//Checks if the user would like to play again and responds
//accordingly to the mouse click
void restartCheck() {
  if(mousePressed == true) {
    if(mouseY <= height/3 + height/4 + 25 && mouseY >= height/3+height/4 - 25) {
      if(mouseX >= width/4 - 50 && mouseX <= width/4 + 50) { //Restart the game
      //All restart conditions below
        snakeLength = 0;
        speed = 15;
        NORTH = SOUTH = EAST = WEST = false;
        foodEaten = false;
        snakeX[0] = width/2;
        snakeY[0] = height/2;
        foodX = (int)(random(width - blockSize/2) + blockSize/2);
        foodY = (int)(random(height - blockSize/2) + blockSize/2);
        noTint();
        stroke(0);
        strokeWeight(1);
        bg = loadImage("spiral.png");
        gameOver = false;
      } else if(mouseX >= 3*width/4 - 50 && mouseX <= 3*width/4 + 50) { //End the program
        exit();
      }
    }
  }
}

//CODE FOR TRIPPY VISUAL 1
void visual1() {
  stroke(0);
  fill(random(255)+1,random(255)+1,random(255)+1);
  if (xPos > (width - 20) && movingRight) {
    movingRight = false;
    xChange = -xChange;
  }
  else if(yPos > (width - 20) && movingDown) {
    movingDown = false;
    yChange = -yChange;
  }
  else if (xPos <= 20 && !movingRight)
  {
    movingRight = true;
    xChange = -xChange;
  }
  else if(yPos <= 20 && !movingDown) {
    movingDown = true;
    yChange = -yChange;
  }
  ellipse(xPos,yPos,40,40);
  rect(width - xPos, height - yPos, 40, 40);
  
  if(xPos > 400) {
    xPos = (int)random(200)+1;
    movingRight = !movingRight;
  }
  if(yPos > 400) {
    yPos = (int)random(200)+1;
    movingDown = !movingDown;
  }
 
  xPos += xChange;
  yPos += yChange;
  smooth();
}

//Function to change background color if food is eaten 
void mouseEvent() {
  int change = (int)random(4)+1;
  background(random(255)+1,random(255)+1,random(255)+1);
  int yf = (int)random(1);
  if(yf == 1 && (yChange/-1) == -yChange) {
    yChange = change;
  } else if(yf == 1 && (yChange/-1) == yChange) {
    yChange = -change;
  } else if(yf == 0 && (xChange/-1) == -xChange) {
    xChange = change;
  } else if(yf == 0 && (xChange/-1) == xChange) {
    xChange = -change;
  } 
}

//CODE FOR TRIPPY VISUAL 2
void visual2() {
  tint(random(255),random(255),random(255),random(255));

  noFill();
  stroke(random(255),random(255),random(255),127);
  strokeWeight(10);
 
  //Creates the growing ellipse and shrinking rectangle
  drawEllipse();
  drawRect();
  
  //Creates the random lines
  linex = random(width);
  liney = random(width);
  drawLines();
}

//Draws the growing ellipses which start at the center of the screen and
// move outward
void drawEllipse() {
  //Checks if the growing ellipse has hit the outside edge
   if(ellipseXPos + ellipseRadius >= width || ellipseYPos + ellipseRadius >= height) {
    ellipseRadius = 0;
  }
  ellipse(width/2,height/2, ellipseRadius+=20,ellipseRadius+=20);
}

//Draws the shrinking rectangles which start at the outside of the screen
// and move inwards
void drawRect() {
  rectMode(RADIUS);
  rect(width/2,height/2, rectRadius -=10, rectRadius -=10);
  
  //Checks if the shrinking rectangle has gotten too small
  if(rectRadius <= 0) {
    rectRadius = width/2;
  }
}

//Draws the randomly appearing lines which start at the edge of the screen
// and end at the center
void drawLines() {
  strokeWeight(2);
  line(linex,0, width/2,height/2);
  line(0,liney, width/2,height/2);
  line(width,liney,width/2,height/2);
  line(linex,height,width/2,height/2);
}

//CODE FOR TRIPPY VISUAL 3
void visual3() {
  //Places the background image
  tint(random(255),random(255),random(255),random(255));
  
  //Creates the eyes
  fill(0);
  noStroke();
  ellipse(150,250,50,115);
  ellipse(420,230,50,115);
  
  //Draws the moving pupils
  drawPupil();

  noFill();
  stroke(random(255),random(255),random(255),127);
  strokeWeight(10);
 
  //Creates the growing ellipse and shrinking rectangle
  drawEllipse();
  drawRect();
 
  //Creates the moving ball
  moveBall();
  
  //Creates the random lines
  linex = random(width);
  liney = random(width);
  drawLines();
}
  
//Generates the moving ball which hits the center of each wall
// and then changes direction
void moveBall() {
  fill(random(255));
  //Controls the left and right movement of the ball
  if(ballxpos + ballradius > width) {
    //hit right edge
    right = false;
  } else if(ballxpos < ballradius) {
     right = true;
  }
  //Controls the up and down movement of the ball
   if(ballypos + ballradius > height) {
     down = false;
  } else if(ballypos < ballradius) {
     down = true;
  } 
  //Changes the direction of the ellipse in different cases
   if(right == true && down == true) {
     ellipse(ballxpos+=20, ballypos+=20, ballradius*2,ballradius*2);
  } else if(right == true && down == false) {
     ellipse(ballxpos+=20, ballypos-=20, ballradius*2,ballradius*2);
  } else if(right == false && down == true) {
     ellipse(ballxpos-=20, ballypos+=20, ballradius*2,ballradius*2);
  } else {
     ellipse(ballxpos-=20, ballypos-=20, ballradius*2,ballradius*2);
  }
}

//Draws the pupils and moves them according to the ball's position
void drawPupil() {
  fill(255);
  //Moves the pupil to the correct spot 
  if(right == true && down == true) {
    ellipse(150,270,20,20);
    ellipse(420,260,20,20);
  } else if(right == true && down == false) {
    ellipse(160,250,20,20);
    ellipse(430,240,20,20);
  } else if(right == false && down == false) {
    ellipse(160,230,20,20);
    ellipse(430,210,20,20);
  } else {
    ellipse(140,230,20,20);
    ellipse(410,210,20,20);
  }
}

  