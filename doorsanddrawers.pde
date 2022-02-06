
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

int status; /* Chooses between screens */
final int STATUSINTRO=0;
final int STATUSFLOOR=2;
final int STATUSROOM=3;
final int STATUSOBJECT=4;
final int STATUSDIALOG=128; /* this will be added to status */
final int STATUSEXITGAME=5; /* after confirming exit building */
int dialognum; /* Chooses between Dialogs */

final int CONFIRM_EXIT=1;

PGraphics NokiaScreen;  
int scale=1; /* sreen resize scale*/
int nkw=0;
int nkh=0;
int nkbuffsize;
int myY=0, myX=0,storeFloorX=0;
int maxX=8, maxY=4;
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
  // This will be started when sprites load
  //iniciaPisos();
  status=STATUSFLOOR;
  NokiaScreen.beginDraw();
  NokiaScreen.noSmooth();
  NokiaScreen.background(255);
  NokiaScreen.endDraw();
}
boolean drawing=false;
void draw() {
  float ti;
  ti=millis();
  if (drawing) return;
  drawing=true;
  pushStyle();
  imageMode(CENTER);
  NokiaScreen.beginDraw();
  if (spritesLoaded==0) {
    status=STATUSINTRO;
  } else {
    //status=STATUSFLOOR;
  }
  println(status);
  switch (status) {
  case STATUSINTRO:
  default:
    maxX=0;
    maxY=0;
    waitKeyAny=true;
    drawIntro();
    println("Drawing Intro");
    break;
  case STATUSFLOOR:
    waitKeyAny=false;
    maxX=32*8;
    maxY=8;
    NokiaScreen.background(0);
    println("Drawing floor");
    drawFloor();
    break;
  case STATUSDIALOG:
    case (STATUSDIALOG | STATUSFLOOR):
    waitKeyAny=false;
    maxX=2;
    maxY=0;
    dialog();
  }


  //  outString(""+status,20,32);
  //  outString(""+frameCount,64/2,32);
  NokiaScreen.endDraw();
  colorFilter();
  image(NokiaScreen, width/2, height/2, nkw, nkh); 
  popStyle();
  drawing=false;
  //println (millis()-ti);
  //if (status==STATUSFLOOR) noLoop();
}

/* Draw a floor, with scrolling */
void drawFloor() {
  int drawx;
  NokiaScreen.background(255, 255, 255, 255);
  int floorx=-myX;
  if (floorx<0) floorx+=8*32;
  for (int doorn=0; doorn<8; doorn++) {
    drawx=floorx+32*doorn;
    while (drawx>7*32) {
      drawx=drawx-8*32;
    }
    if (piso[myFloor][doorn].outImage!=null) {
      println("door"+doorn+" at "+drawx);
      if (drawx>=-60 && drawx<=84) { 
        NokiaScreen.image(piso[myFloor][doorn].outImage, drawx, 0);    
        //println("Drawing floor x:"+(floorx*32+(myX % 32)));
        if (piso[myFloor][doorn].rtype==HSTAIRS) {
          outString(""+myFloor, drawx+8, 0);
        }
      } else {
        println("drawx out of bounds:"+drawx);
      }
    } else {
      println("piso["+myFloor+"]["+doorn+"].outImage is null");
      println("piso rtype:"+piso[myFloor][doorn].rtype);
    }
  }

  int selDoor=int(1+myX/32) % 8;
  if (piso[myFloor][selDoor].rtype==HSTAIRS) {
    centerString(myFloor==0 ? "Go Up/Exit":"Go Up/Down", 42, 33, 0);
  } else {
    centerString(selDoor+":"+piso[myFloor][selDoor].name, 42, 33);
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

  NokiaScreen.loadPixels();
  for (int f=0; f<nkbuffsize; f++) {
    int v=0;
    int pix=NokiaScreen.pixels[f];

    for (int g=0; g<3; g++) {
      v= v | (pix & (255 >> g));
    }
    if (v>128) {
      NokiaScreen.pixels[f] =NWHITE;
    } else {
      NokiaScreen.pixels[f]=NBLACK;
    }
  }
  NokiaScreen.updatePixels();
}



void keyPressed() {

  if (waitKeyAny) {
    println("Any key Pressed"+status);
    if (status==STATUSINTRO) status=STATUSFLOOR;
    return;
  }
  println("Keypressed");
  if (key!=CODED) {
    switch(key) {
    case 'W': 
    case 'w': 
    case '8':
      doUp();
      break;
    case 'S': 
    case 's': 
    case '2':
      doDown();
      break;
    case 'A': 
    case 'a': 
    case '4':
      myX--;
      while (myX<0) myX+=maxX;
      println("myX=", myX);
      break;
    case 'D': 
    case 'd': 
    case '6':
      // 84/16=5.25
      myX=(myX+1)%maxX;
      println("myX=", myX);
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
      doUp();
    case DOWN:
      // 48/16=3
      doDown();
      break;
    case LEFT:
      myX--;
      while (myX<0) myX+=maxX;
      break;
    case RIGHT:
      // 84/16=5.25
      myX=(myX+1)%maxX;
      break;

    case  4:
      /* BACK ANDRODID BUTTON: Exit form mode */
      break;
    }
  }
}

/* Processes "UP" key:*/
void doUp() {
  if (status==STATUSFLOOR) {
    int selDoor=int(1+myX/32) % 8;
    if (piso[myFloor][selDoor].rtype==HSTAIRS) {
      if (myFloor<8) {
        myFloor++;
      }
    }
  } else {  
    myY--;
    while (myY<0) myY+=maxY;
  }
}

void doDown() {
  if (status==STATUSFLOOR) {
    int selDoor=int(1+myX/32) % 8;
    if (piso[myFloor][selDoor].rtype==HSTAIRS) {
      if (myFloor>0) {
        myFloor--;
      } else {
        status=STATUSDIALOG | STATUSFLOOR;
        dialognum=CONFIRM_EXIT;
        storeFloorX=myX;
        myX=0;
        maxX=1; maxY=0;
      }
    }
  } else {
    myY=(myY+1)%maxY;
  }
}

void dialogReturn(){
  switch (dialognum){
    case CONFIRM_EXIT:
      if (myX==0) {
        status=STATUSEXITGAME;
        return;
      } else {
        // XOR StatusDIALOG bit
        status^=STATUSDIALOG;
        if(status==STATUSFLOOR){
          myX=storeFloorX;
        }
      }
    break;
  }
}
