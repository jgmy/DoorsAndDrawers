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
/* FOR DEBUG PURPOSES */
final boolean PARALLEL=true;


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
final int STATUSINVENTORY=4;
final int STATUSDIALOG=128; /* this will be added to status */
final int STATUSEXITGAME=5; /* after confirming exit building */
int dialognum; /* Chooses between Dialogs */

final int CONFIRM_EXIT=1;
final int DIALOG_INFO=0;
final int DIALOG_MAC=2;
final int DIALOGINVENTORYERROR=3; /* Dummy value to avoid hiding the dialog error on invent screen */
PGraphics NokiaScreen;  
int scale=1; /* sreen resize scale*/
int nkw=0;
int nkh=0;
int nkbuffsize;
int myY=0, myX=0, storeFloorX=0;
int storeRoomX=0, storeRoomY=0;
int[] passwordknown={0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int[] keyhold={0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
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

  if (PARALLEL) thread("sprites"); 
  else sprites();
  //sprites();
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

  if (status!=lastStatus) {
    println("Status changed from "+lastStatus+" to "+status);
  }
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
    if (dialognum==CONFIRM_EXIT) { 
      waitKeyAny=false;
      maxX=2;
      maxY=1;
      dialogExitConfirm();
    } else if (dialognum==DIALOG_INFO) {
      waitKeyAny=true;
      dialogMessage();
    }
    break;
  case STATUSINVENTORY:
    waitKeyAny=false;
    maxX=5;
    maxY=3;
    drawInventory();
    break;
  case STATUSDIALOG | STATUSROOM:
    if (dialognum==DIALOG_INFO) {
      waitKeyAny=true;
      dialogMessage();
    } else if (dialognum==DIALOG_MAC) {
      macDialog();
      waitKeyAny=true;
    } else if (dialognum== DIALOGINVENTORYERROR){
      
      waitKeyAny=true;
    }
 
    break;
  case STATUSEXITGAME:
    waitKeyAny=true;
    maxX=1; 
    maxY=1;
    drawExit();
    break;
  case STATUSROOM:
    waitKeyAny=false;
    maxX=8;
    maxY=3;
    drawRoom();
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
        if (piso[myFloor][doorn].locked) {
          NokiaScreen.image(sprPadlock, drawx, 0);
        }
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

String[] strInstrucciones={"Loading Sprites", "Generating rooms", "Press any key"+
  " - WASD / ARROWS / KEYPAD move, SPACE/ESC select/cancel "+
  " - Find the secret Chorizo Paella recipe and escape building..."};
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
  outString(strInstrucciones[spritesLoaded], 84-textScrollx, 36, 1);
  if (textScrollx> (strInstrucciones[spritesLoaded].length()*8+84)) textScrollx=0;
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
    // println("Any key Pressed"+status);
    // println("Sprites loaded:"+spritesLoaded);
    if (status==STATUSINTRO) status=STATUSFLOOR;
    else if (status==STATUSROOM) 
    {
      status=STATUSFLOOR;
      myX=((7+myRoom) % 8)*32;
    } else if (status==STATUSEXITGAME) exit();
    // println("Next Status"+status);
    return;
  } else if (status==(STATUSDIALOG | STATUSROOM)) {
    myX=storeRoomX;
    myY=storeRoomY;
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
        enterRoom();
      } else if (status==STATUSROOM) {
        actionRoom();
      } else if (status==STATUSINVENTORY) {
        actionInventory();
    } else if (status==(STATUSROOM | STATUSDIALOG)) {
        storeRoomX=myX;
        storeRoomY=myY;
      }
      break;
    case 27:      /* ESCAPE */
      key=0;
      println("DoEscape()");
      doEscape();
      break;
    default:
      println("ASCII Key code: "+hex(key));
      break;
    }
  } else {
    /* KEYCODE USED */
    switch(keyCode) {
    case UP:
      // println ("UP key");
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
    case 12:
      /* SELECTION -- Decide what to do */
      if ( (status & STATUSDIALOG)!=0) {
        dialogReturn(); 
        break;
      } else if ( status==STATUSFLOOR) {
        enterRoom();
      } else if (status==STATUSROOM) {
        actionRoom();
      } else if (status==(STATUSROOM | STATUSDIALOG)) {
        storeRoomX=myX;
        storeRoomY=myY;
      }

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
    } else {
      enterRoom();
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
    switch (status ^ STATUSDIALOG) {
    case STATUSFLOOR:
      // XOR StatusDIALOG bit
      status^=STATUSDIALOG;
      if (status==STATUSFLOOR) {
        myX=storeFloorX;
      } else if (status==STATUSROOM) {
        myX=storeRoomX;
        myY=storeRoomY;
      } 
      break;
    case STATUSINVENTORY:
      status=STATUSROOM;
      myX=0;
      myY=0;
      println("exit via 2");
      break;
    }
  } else {
    switch (status){
      case STATUSINVENTORY:
        status=STATUSROOM;
        myX=0;
        myY=0;
        println("exit via 1");
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
  case DIALOG_INFO:
    status^=STATUSDIALOG;
    switch (status) {
    case STATUSFLOOR:
      myX=storeFloorX;
      break;
    case STATUSROOM:
      myX=storeRoomX;
      myY=storeRoomY;
      break;
    } 
    break;
  }
}

/* Does the check to enter a room and adjusts values
 *
 * Moved from the keypressed function to avoid having 
 * to mantain different copies for "SELECT" (5/SPACE) and "UP"
 */
void enterRoom() {
  myRoom=int(1+myX/32) % 8;
  Room room=piso[myFloor][myRoom];
  if (room==null) {
    println("Room "+myFloor+myRoom+" is invalid.");
    return;
  }
  if (room.rtype!=HSTAIRS) {
    if (room.locked && inventory.containsKey(room.key)) {
      room.locked=false;
    }
    if (!room.locked) {
      myX=2;
      myY=1;
      status=STATUSROOM;
    }
  }
}
void actionRoom() {
  Furniture furn;
  if (status==STATUSROOM) {
    if (myX<5 && myX>=0 && myY<2 && myY>=0) {
      /* 
       println("piso["+myFloor+"]["+myRoom+"]"+
       ".safeGetFurn("+myX+","+ myY+")="+
       piso[myFloor][myRoom].safeGetFurn(myX, myY));
       */
      switch (piso[myFloor][myRoom].safeGetFurn(myX, myY)) {
      case FURNINVALID:
        /* this allow to use default: for real furniture */
        break;
      case FURNDOOR:
        myX=((7+myRoom) % 8)*32;
        status=STATUSFLOOR;
        break;
      case FURNFAKEFRAME:
        /* reveal fake frames */
        furn=piso[myFloor][myRoom].safeGetFurnObject(myX, myY);
        if (furn!=null) furn.image=furnSafe;
        break;
      case FURNMAC:
        if (inventory.containsItem(ITEMDISKETTEMAC)) {
          furn=piso[myFloor][myRoom].safeGetFurnObject(myX, myY);
          furn.receiveItem(inventory.getFirstItem(ITEMDISKETTEMAC));
        };
      case FURNPC:
        break;
      case FURNCOPIER:
        break;
      case FURNBOOKCASE:
      case FURNCABINET:
      case FURNWARDROBE:
      case FURNBIGFILE:
      case FURNSAFE: 
      case FURNFRIDGE:
      case FURNMICROWAVE:
      case FURNDRAWER:
        furn=piso[myFloor][myRoom].safeGetFurnObject(myX, myY);
        if (furn!=null) {
          if (furn.locked) { 
            if (inventory.containsKey(furn.keynum) ) {
              furn.locked=false;
            }
          };
          if (furn.password) {
            if (inventory.containsPassword(furn.passnum)) {
              furn.locked=false;
            }
          }
          if (!furn.locked && !furn.password ) {
            seekedFurniture=furn;
            status=STATUSINVENTORY;
          }
        }
        break;

      case FURNMIRROR:
      case FURNFRAME:
        /*These could contain hints */
        seekedFurniture=inventory;
        status=STATUSINVENTORY;
        break;
      case FURNWC:
      case FURNTAP:
      case FURNTABLE:
      case FURNLABTABLE:
      case FURNCOFFEETABLE:
        furn=piso[myFloor][myRoom].safeGetFurnObject(myX, myY);
        if (furn!=null) {
          seekedFurniture=furn;
          status=STATUSINVENTORY;
        }
        break;
      case FURNCOFFEE:
        furn=piso[myFloor][myRoom].safeGetFurnObject(myX, myY);
        if (furn!=null) {
          if (currentAction==ACTIONINVENTORY && itemOnHand!=null) {
            switch (itemOnHand.itype) {
            case ITEMJARCOFFEE:
            case ITEMCUP:
              if (!furn.containsItem(itemOnHand.itype)) {
                furn.receiveItem(itemOnHand);
                tmpDialog("Thank you");
              } else {
                tmpDialog("Enough Coffee loaded");
              }
              break;
            }
          }
        }
        break;
      }
    } else if (myY==2 && myX<actions.length && myX>=0  ) {
      /* Change mode */
      currentAction=actions[myX];
      if (currentAction==ACTIONINVENTORY ) {
        seekedFurniture=inventory;
        status=STATUSINVENTORY;
      }
    }
  } else if (status==STATUSINVENTORY) {
    actionInventory();
  }
}

void actionInventory() { 
  if (status==STATUSINVENTORY) {
    /* SUGERENCIA: Que el primer objeto de Inventario
    sea "Volver atrás". Eso reduciría el inventario a 
    7 elementos */
    if (myX<5 && myX>=0 && myY<2 && myY>=0) {
      if (seekedFurniture==null ||  seekedFurniture.items==null){
          status=STATUSROOM;
          return;
      }
      
      if ((myX+2*myY)>=0 && ((myX+2*myY)<seekedFurniture.items.length)){
        println("Intentando mover a inventario...");
        seekedFurniture.moveItem(myX+2*myY,inventory);  
        
      }
    }
  }
}
