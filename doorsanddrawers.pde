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

final int[] NBLACK= {0x43, 0x52, 0x3d, 0};
final int[] NWHITE= {0xc7, 0xf0, 0xd8, 0};
PGraphics NokiaScreen;  
int scale=1; /* sreen resize scale*/
int nkw=0;
int nkh=0;
int nkbuffsize;
int myY=0, myX=0;

void setup() {
  fullScreen();
  noSmooth();
  NokiaScreen=createGraphics(84, 48);
  scale=int(min(width/84, height/48));
  /* These are computed in advance for speed up,
   just in case compiler does not optimize them
   */

  nkh=scale*48;
  nkw=scale*84;
  nkbuffsize=48*84*displayDensity();
  NokiaScreen.beginDraw();
  NokiaScreen.noSmooth();
  NokiaScreen.background(255);
  NokiaScreen.endDraw();
}

void draw() {

  //colorFilter();
  pushStyle();
  imageMode(CENTER);
  NokiaScreen.beginDraw();
  NokiaScreen.stroke(0);
  NokiaScreen.ellipse(84/2, 48/2, 40, 40);
  NokiaScreen.endDraw();
  image(NokiaScreen, width/2, height/2, nkw, nkh);
  popStyle();
}

void keyPress() {
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
void colorFilter() {
  NokiaScreen.loadPixels();
  for (int f=0; f<nkbuffsize; f+=4) {
    int v=0;
    for (int g=0; g<3; g++) {
      v=v|NokiaScreen.pixels[f+g];
    }
    if (v>128) {
      for (int g=0; g<4; g++)
        NokiaScreen.pixels[f+g]=NWHITE[g];
    } else {
      for (int g=0; g<4; g++)
        NokiaScreen.pixels[f+g]=NBLACK[g];
    }
  }
  NokiaScreen.updatePixels();
}
