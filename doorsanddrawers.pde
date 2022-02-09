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
final int NBLACK=0xff43523d;
final int NWHITE=0xffc7f0d8;

final int NUMBEROFFILES=40;
final int NUMBEROFROOMS=8*8;
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
int myY=0, myX=0, storeFloorX=0;
int maxX=8, maxY=4;
int myFloor=0;
int myRoom=0;
boolean waitKeyAny= true; /* wait for any key */
void setup() {
  fullScreen();
//size(840,480);
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
int lastStatus=STATUSINTRO;
void draw() {
  float ti;

  if (status!=lastStatus) println("Status changed from "+lastStatus+" to "+status);
  lastStatus=status;
  ti=millis();
  if (drawing) {
    println("Call to draw() while still drawing");
    return;
  }
  drawing=true;
  pushStyle();
  imageMode(CENTER);
  NokiaScreen.beginDraw();
  if (spritesLoaded<2) {
    outString(
      spritesLoaded==1 ? "Loading Sprites" : "Generating Rooms", 
      32, 0);  
    status=STATUSINTRO;
  } else {
    //status=STATUSFLOOR;
  }

  //println("Status: "+status);
  switch (status) {
  case STATUSINTRO:
    maxX=1;
    maxY=1;
    waitKeyAny=true;
    drawIntro();
    //println("Drawing Intro");
    break;
  case STATUSFLOOR:
    waitKeyAny=false;
    maxX=32*8;
    maxY=8;
    //println("Drawing floor");
    drawFloor();    
    break;
  case STATUSDIALOG:
    case (STATUSDIALOG | STATUSFLOOR):
    waitKeyAny=false;
    maxX=2;
    maxY=1;
    dialog();
    break;
  case STATUSEXITGAME:
    waitKeyAny=true;
    maxX=1; 
    maxY=1;
    drawExit();
    break;
  case STATUSROOM:

    waitKeyAny=true;
    maxX=1;
    maxY=1;
    piso[myFloor][myRoom].show();
    break;
  default:
    outString("STATUS is:"+status, 0, 32);
  }
  //  outString(""+status,20,32);
  //centerString("Frame:"+frameCount,64/2,32,0);
  NokiaScreen.endDraw();
  colorFilter();
  image(NokiaScreen, width/2, height/2, nkw, nkh); 
  popStyle();
// saveFrame("recording-"+nf(frameCount)+".png");
  drawing=false;
  //  println (millis()-ti +" milliseconds per frame");
  //if (status==STATUSFLOOR) noLoop();

}

/* Draw a floor, with scrolling */
void drawFloor() {
  int drawx;
  NokiaScreen.background(255, 255, 255, 255);
  int floorx=-myX;
  //println ("floorx:"+floorx);
  if (floorx<0) floorx+=8*32;
  for (int doorn=0; doorn<8; doorn++) {
    drawx=floorx+32*doorn;
    while (drawx>7*32) {
      drawx=drawx-8*32;
    }
    if (piso[myFloor][doorn]!=null && piso[myFloor][doorn].outImage!=null) {
      //println("door"+doorn+" at "+drawx);
      if (drawx>=-60 && drawx<=84) { 
        NokiaScreen.image(piso[myFloor][doorn].outImage, drawx, 0);
        //println("drawing image at ("+drawx+",0)");
        //println("Drawing floor x:"+(floorx*32+(myX % 32)));
        if (piso[myFloor][doorn].rtype==HSTAIRS) {
          /* Add floor number to sprite */
          outString(""+myFloor, drawx+10, 0);
        }
      } else {
        //println("drawx out of bounds:"+drawx);
      }
    } else {
      println("piso["+myFloor+"]["+doorn+"].outImage is null");
      println("piso rtype:"+piso[myFloor][doorn].rtype);
    }
  }

  // We used selDoor before to show selected door, but
  // we should change active Room instead.
  myRoom=int(1+myX/32) % 8;

  if (piso[myFloor][myRoom].rtype==HSTAIRS) {
    centerString(myFloor==0 ? "Go Up/Exit": 
      (myFloor<7 ? "Go Up/Down" : "Go Down"), 42, 33, 0);
  } else {
    centerString(myRoom+":"+piso[myFloor][myRoom].name, 42, 33);
  }
}

String strInstrucciones="Press any key"+
  " - WASD / ARROWS / KEYPAD move"+
  " - Find the secret Chorizo Paella recipe and escape building...";
int textScrollx=0;
void drawIntro() {
  NokiaScreen.stroke(0);
  NokiaScreen.fill(255);
  if (spritesLoaded==0) {
    NokiaScreen.background(0);
    NokiaScreen.arc(84/2, 48/2, 40, 40, 0, (roomsGenerated+filesLoaded)*TWO_PI/(NUMBEROFFILES+NUMBEROFROOMS));
  } else { 
    NokiaScreen.background(255);
    NokiaScreen.ellipse(84/2, 48/2, 40, 40);
  }
  centerString("Doors", 84/2, 12);
  centerString("and", 84/2, 20);
  centerString("Drawers", 84/2, 28);
  textScrollx++;
  outString(strInstrucciones, 84-textScrollx, 36, 1);
  if (textScrollx> (strInstrucciones.length()*8+84)) textScrollx=0;
  // The scroll text seems to ve lighter, but you can try
  // this to show it is same color:
  //  if (textScrollx==84) noLoop();
}



void drawExit() {
  int points=0;
  NokiaScreen.fill(255);
  centerString("You came out", nkw/2, 8);
  centerString("Points:"+points, nkw/2, 16);
  centerString("Press any key", nkw/2, 32);
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
  if (waitKeyAny|status==STATUSINTRO) {
    println("Any key Pressed"+status);
    println("Sprites loaded:"+spritesLoaded);
    if (status==STATUSINTRO) status=STATUSFLOOR;
    else if (status==STATUSROOM) 
    {
      status=STATUSFLOOR;
      myX=((7+myRoom) % 8)*32;
    } else if (status==STATUSEXITGAME) exit();
    println("Next Status"+status);
    return;
  }
  //println("Keypressed");
  if (key!=CODED) {
    /* CODED (ASCII) KEY USED */
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
      //println("LEFT");
      myX--;
      /* If maxX==0 this causes infinite loop */
      if (maxX>0) {
        while (myX<0) myX+=maxX;
      } else {
        myX=0;
      }
      break;
    case 'D': 
    case 'd': 
    case '6':
      //println("RIGHT, myX is "+myX+" and maxX is "+maxX);
      if (maxX>0) myX=(myX+1) % maxX;
      //println("Resulting myX:"+myX);
      break;
    case ' ':    
    case RETURN: 
    case '5':
      /* SELECTION -- Decide what to do */
      if ( (status & STATUSDIALOG)!=0) {
        dialogReturn(); 
        break;
      } else if ( status==STATUSFLOOR) {
        myRoom=int(1+myX/32) % 8;
        if (piso[myFloor][myRoom].rtype==HKITCHEN | 
          piso[myFloor][myRoom].rtype==HTOILET|
          piso[myFloor][myRoom].rtype==HOFFICE |
          piso[myFloor][myRoom].rtype==HOFFICEBOSS |
          piso[myFloor][myRoom].rtype==HOFFICEREPRO |
          piso[myFloor][myRoom].rtype==HOFFICELAB |
          piso[myFloor][myRoom].rtype==HLOBBY ) {
          status=STATUSROOM;
        }
      }
      break;
    case 27:      /* ESCAPE */
      println("DoEscape()");
      doEscape();
      break;
    default:
      println("Key code: "+hex(key));
      break;
    }
  } else {
    /* KEYCODE USED */
    switch(keyCode) {
    case UP:
      println ("UP key");
      doUp();
      break;
    case DOWN:
      // 48/16=3
      doDown();
      break;
    case LEFT:
      //println("LEFT");
      myX--;
      /* If maxX==0 this causes infinite loop */
      if (maxX>0) {
        while (myX<0) myX+=maxX;
      } else {
        myX=0;
      }
      break;
    case RIGHT:
      //println("RIGHT");
      // 84/16=5.25
      if (maxX>0) myX=(myX+1)%maxX;
      break;
    case  4:
      /* BACK ANDRODID BUTTON: Exit form mode */
      println("Android Back Button");
      doEscape();
      break;
    default:
      println("Keycode Pressed"+keyCode);
      break;
    }
  }
}

/* Processes "UP" key:*/
void doUp() {
  //println("UP");
  if (status==STATUSFLOOR) {
    int selDoor=int(1+myX/32) % 8;
    if (piso[myFloor][selDoor].rtype==HSTAIRS) {
      if (myFloor<7) {
        myFloor++;
      }
    } else if (piso[myFloor][myRoom].rtype==HKITCHEN | 
          piso[myFloor][myRoom].rtype==HTOILET|
          piso[myFloor][myRoom].rtype==HOFFICE |
          piso[myFloor][myRoom].rtype==HOFFICEBOSS |
          piso[myFloor][myRoom].rtype==HOFFICEREPRO |
          piso[myFloor][myRoom].rtype==HOFFICELAB |
          piso[myFloor][myRoom].rtype==HLOBBY ) {
        myRoom=int(1+myX/32) % 8;
        
        status=STATUSROOM;
    }
  } else {  
    myY--;
    /* If maxY<0 this causes infinite loop */
    if (maxY>0) {
      while (myY<0) myY+=maxY;
    }
  }
}

void doDown() {
  //println("DOWN");
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
        maxX=1; 
        maxY=1;
      }
    }
  } else {
    if (maxY>0) myY=(myY+1)%maxY;
  }
}
/* Process Escape. I.E. Exit from a Dialog */
void doEscape() {
  println("ESCAPE/EXIT/BACK");
  if ((status & STATUSDIALOG)!=0) {
    switch (status ^STATUSDIALOG) {
    case STATUSFLOOR:
      // XOR StatusDIALOG bit
      status^=STATUSDIALOG;
      if (status==STATUSFLOOR) {
        myX=storeFloorX;
      }
      break;
    }
  }
}

void dialogReturn() {
  println("RETURN");
  switch (dialognum) {
  case CONFIRM_EXIT:
    if (myX==0) {
      status=STATUSEXITGAME;
      return;
    } else {
      // XOR StatusDIALOG bit
      status^=STATUSDIALOG;
      if (status==STATUSFLOOR) {
        myX=storeFloorX;
      }
    }
    break;
  }
}
