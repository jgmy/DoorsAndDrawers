
/* ******************************************
 * Doors and drawers
 * By José G Moya Y 
 * for Nokia Jam 2022
 *
 * A totally new game for an old Idea I'm trying
 * to materialize since I played the ZX Spectrum
 * games of Frakie Goes to Hollywood and 
 * A View for a Kill
 ****************************************** */
/*****************************************
 * Following the Jam rules, all *code* and assets
 * is new (except fonts downloaded from 
 * nokia Jam), but *algorithms* were
 * tried before using other programming engines.
 ***************************************** */

/* In p5js I would use these: */
final int[] NBLACKArr= {0x43, 0x52, 0x3d, 255};
final int[] NWHITEArr= {0xc7, 0xf0, 0xd8, 255};
/* But Java Processing uses unsigned 64 bit integers instead */
final int NBLACK=0xff42523d;
final int NWHITE=0xffc7f0d8;

int status;
final int STATUSINTRO=0;
final int STATUSFLOOR=2;
final int STATUSROOM=3;
final int STATUSOBJECT=4;

PGraphics NokiaScreen;  
int scale=1; /* sreen resize scale*/
int nkw=0;
int nkh=0;
int nkbuffsize;
int myY=0, myX=0;
int myFloor=0;

boolean waitKeyAny= true; /* wait for any key */
void setup() {
  fullScreen();
  noSmooth();
  NokiaScreen=createGraphics(84, 48);
  scale=int(min(width/84, height/48));
  /* These are computed in advance for speed up,
   just in case compiler does not optimize them
   */
  
  thread("sprites");
  nkh=scale*48;
  nkw=scale*84;
  nkbuffsize=48*84*displayDensity();
  createPixelFont();
  iniciaPisos();
  status=STATUSFLOOR;
  NokiaScreen.beginDraw();
  NokiaScreen.noSmooth();
  NokiaScreen.background(255);
  NokiaScreen.endDraw();
}

void draw() {
  pushStyle();
  imageMode(CENTER);
  NokiaScreen.beginDraw();
  if (spritesLoaded==0) status=0; else status=STATUSFLOOR;
  
  switch (status) {
  case STATUSINTRO:
  default:
    waitKeyAny=true;
    drawIntro();
    break;
  case STATUSFLOOR:
    NokiaScreen.background(0);
    drawFloor();
    break;
   
  }
//  outString(""+status,20,32);
//  outString(""+frameCount,64/2,32);
  NokiaScreen.endDraw();
  colorFilter();

  image(NokiaScreen, width/2, height/2, nkw, nkh); 
  popStyle();
  //noLoop();
}

void drawFloor(){
  NokiaScreen.background(255);
  for (int f=0;f<8;f++){
    switch (piso[myFloor][f].rtype){
      case HSTAIRS:
      NokiaScreen.rect(f, 0,16*f,16);
       break;
      case HOFFICE:
      NokiaScreen.rect(f,0,16*f,16);
    }
  }
}

void drawIntro() {
  NokiaScreen.stroke(0);
  NokiaScreen.background(255);
  NokiaScreen.fill(255);
  NokiaScreen.ellipse(84/2, 48/2, 40, 40);
  centerString("Doors", 84/2, 12);
  centerString("and", 84/2, 20);
  centerString("Drawers", 84/2, 28);
}

void colorFilter() {
  int clear=0, dark=0;
  NokiaScreen.loadPixels();
  for (int f=0; f<nkbuffsize; f++) {
    int v=0;
    int pix=NokiaScreen.pixels[f];

    for (int g=0; g<3; g++) {
      v= v | (pix & (255 >> g));
    }
    if (v>128) {
      clear++;
      NokiaScreen.pixels[f] =NWHITE;
    } else {
      dark++;
      NokiaScreen.pixels[f]=NBLACK;
    }
  }
  NokiaScreen.updatePixels();
   // Debug:
   // println(dark+" dark pixels and "+clear+" clear pixels");
}



void keyPressed() {

  if (waitKeyAny) {
    println("Any key Pressed"+status);
    status++;
    return;
  }
  println("Keypressed");
  if (key!=CODED) {
    switch(key) {
    case 'W': 
    case 'w': 
    case '8':
      if (myY>0) myY--;
      break;
    case 'S': 
    case 's': 
    case '2':
      // 48/16=3
      if (myY<4) myY++;
      break;
    case 'A': 
    case 'a': 
    case '4':
      if (myX>0) myX--;
      break;
    case 'D': 
    case 'd': 
    case '6':
      // 84/16=5.25
      if (myX<6) myX++;
      break;
    case ' ':
      /* SELECTION -- Decide what to do */
      break;
      case (char) 27:
      /* ESCAPE */
    }
  } else {
    switch(keyCode) {
    case UP:
      if (myY>0) myY--;
      break;
    case DOWN:
      // 48/16=3
      if (myY<4) myY++;
      break;
    case LEFT:
      if (myX>0) myX--;
      break;
    case RIGHT:
      // 84/16=5.25
      if (myX<6) myX++;
      break;
    case  4:
      /* BACK ANDRODID BUTTON: Exit form mode */
      break;
    }
  }
}
