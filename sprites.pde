PImage sprHand;
PImage sprPadlock;
PImage sprPadlock2;

PImage sprEye;
PImage doorOffice;
PImage doorStairs;
PImage doorToilet;
PImage doorKitchen;
PImage doorLab;
PImage doorLobby;
/* Multi-purpose Furniture */
PImage furnDoor;
PImage furnBookcase;
PImage furnCabinetL;
PImage furnCabinetR;
PImage furnShelf;
PImage furnWardrobe;
PImage furnLabTable;
PImage furnMicroscope;
PImage furnLamp;
PImage arrowR;
PImage arrowL;
PImage emptySpace;
PImage GUIwindow;
PImage GUIprint;
PImage GUIsad;
PImage GUIhappy;


ArrayList <namedImage> furnFrame=new ArrayList <namedImage>();
/* Office and Special office furniture*/
PImage furnBigFile, furnMac, furnPC;
PImage furnPhotocopier, furnSafe, furnTable;

/* Lobby */
PImage furnCoffeeTable, furnSofa;
/* Kitchen */
PImage furnCoffeeMachine, furnFridge, furnMicrowave;
PImage furnDrawer, furnWC, furnTap, furnMirror;


/* Small Objects inside of furniture */
ArrayList <PImage> itemKey=new ArrayList <PImage>();
PImage itemClip, itemCup, itemEnvelope, itemGasMask;
PImage itemJar, itemPaper, itemTorch;  
PImage itemBackpack, itemPen;
PImage itemDiskettemac;
PImage itemDiskettepcold;
PImage itemMap, itemBook, itemBlowgun;
PImage itemDiamond,itemClock;
PImage itemToiletPaper;
PImage itemCupCoffee;
PImage[] actionSprites={sprHand,sprEye,itemBackpack};
PImage itemSprite;

class namedImage {
  PImage image;
  String name;
  namedImage(PImage i, String n) {
    this.image=i;
    this.name=n;
  }
}

int spritesLoaded=0;
int roomsGenerated=0;

void sprites() {
  spritesLoaded=0;
  filesLoaded=0;

  sprHand=loadImage("hand.png");
  filesLoaded++;
  sprEye=loadImage("eye.png");
  filesLoaded++;
  itemBackpack =loadImage("backpack.png");
  filesLoaded++;

  //String path=dataPath(Fileseparator)+File.separator+"assets_rooms"+File.separator;
  String path="";
  actionSprites[0]=sprHand;
  actionSprites[1]=sprEye;
  actionSprites[2]=itemBackpack;
  itemSprite=sprHand;  

   GUIwindow=loadImage("GUICOMP-window.png");
   GUIprint=loadImage("GUICOMP-docprinted.png");
   GUIsad=loadImage("GUICOMP-icon-sad.png");
   GUIhappy=loadImage("GUICOMP-icon-happy.png");;

  doorOffice=loadImage(path+"office1.png");
  filesLoaded++;
  if (doorOffice==null) println("doorOffice not found");
  sprPadlock=loadImage(path+"Padlock.png");
  sprPadlock2=loadImage(path+"Padlock-mini.png");
  filesLoaded++;
  doorStairs=loadImage(path+"Stairs.png");
  filesLoaded++;
  doorToilet=loadImage(path+"Toilet.png");
  filesLoaded++;
  doorKitchen=loadImage(path+"Kitchen.png");
  filesLoaded++;
  doorLab=loadImage(path+"Lab.png");
  filesLoaded++;
  doorLobby=loadImage(path+"Lobby.png");

  //String path=dataPath(File.separator)+File.separator+"assets_furniture"+File.separator;
  /** Furniture **/

  /* Multi-purpose */
  furnDoor=loadImage(path+"door.png"); /* door seen from inside of room. 1Wx2H */
  filesLoaded++;
  furnBookcase=loadImage(path+"bookcase.png");  /* 1Wx2H */
  filesLoaded++;
  furnCabinetL=loadImage(path+"cabinetleft.png");  /* 1Wx1H */
  filesLoaded++;
  furnCabinetR=loadImage(path+"Cabinetright.png");  /* 1Wx1H */
  filesLoaded++;
  furnShelf=loadImage(path+"Shelf.png"); /* 1Wx1H */
  filesLoaded++;
  furnWardrobe=loadImage("wardrobe.png"); /* 1Wx2H */
  filesLoaded++;
  furnFrame.add(new namedImage(loadImage(path+"Frame1.png"), "Kandinsky copy")); 
  filesLoaded++;
  furnFrame.add(new namedImage(loadImage(path+"frame2.png"), "Spiral pattern"));
  filesLoaded++;
  furnFrame.add(new namedImage(loadImage(path+"Frame3.png"), "Tree"));
  filesLoaded++;
  furnFrame.add(new namedImage(loadImage(path+"Frame4.png"), "Invaders"));

  /* Office and Special office */
  furnBigFile=loadImage(path+"bigfile.png"); /*1Wx2H*/
  filesLoaded++;
  furnMac=loadImage(path+"Mac-ll-ci.png"); /* 1Wx1H */
  filesLoaded++;
  furnPC=loadImage(path+"PC.png"); /* 1Wx1H */
  filesLoaded++;
  furnPhotocopier=loadImage(path+"Photocopier.png"); /* 2Wx1H */
  filesLoaded++;
  furnSafe=loadImage(path+"Safe.png"); /* 1Wx1H */
  filesLoaded++;
  furnTable=loadImage("Table.png"); /* 2Wx1H */

  /* Lobby */
  furnCoffeeTable=loadImage(path+"coffeetable.png");  /* 1Wx1H */
  filesLoaded++;
  furnSofa=loadImage(path+"Sofa.png"); /* 2Wx1H */
  filesLoaded++;

  /* Kitchen */
  furnCoffeeMachine=loadImage(path+"CoffeeMachine.png");  /* 1Wx1H */
  filesLoaded++;
  furnFridge=loadImage(path+"Fridge.png");  /* 1Wx2H */
  filesLoaded++;
  furnMicrowave=loadImage(path+"Microwave.png");  /* 1Wx1H */
  filesLoaded++;
  furnDrawer=loadImage(path+"drawer.png");  /* 1Wx1H */
  filesLoaded++;
  furnWC=loadImage(path+"WC.png");  /* 1Wx1H */
  filesLoaded++;
  furnTap=loadImage(path+"Tap.png");  /* 1Wx1H */
  furnMicroscope=loadImage(path+"Microscope.png");
  filesLoaded++;  
  furnLabTable=loadImage(path+"Labtable.png");
  filesLoaded++;
  furnLamp=loadImage(path+"Lamp.png");
  filesLoaded++;
  furnMirror=loadImage(path+"Mirror.png");
  filesLoaded++;
  

  /* Small Objects inside of furniture */
  itemKey.add(loadImage(path+"key1.png"));
  filesLoaded++;
  itemKey.add(loadImage(path+"key2.png"));
  filesLoaded++;
  itemKey.add(loadImage(path+"Key3.png"));
  filesLoaded++;
  itemPen=loadImage(path+"ballpen.png");  /* 1Wx1H */
  filesLoaded++;
  itemClip=loadImage(path+"clip.png");  /* 1Wx1H */
  filesLoaded++;
  itemCup=loadImage(path+"Cup.png");/* 1Wx1H */
  filesLoaded++;
  itemDiskettemac=loadImage(path+"disketteMac.png"); /* 1Wx1H */
  filesLoaded++;
  itemDiskettepcold=loadImage(path+"diskettePcOld.png"); /* 1Wx1H */
  filesLoaded++;
  itemEnvelope=loadImage(path+"Envelope.png"); /* 1Wx1H */
  filesLoaded++;
  itemGasMask=loadImage(path+"GasMask.png"); /* 1Wx1H */
  filesLoaded++;
  itemJar=loadImage(path+"Jar.png"); /* 1Wx1H */
  filesLoaded++;
  itemPaper=loadImage(path+"Paper.png"); /* 1Wx1H */
  filesLoaded++;
  itemTorch=loadImage(path+"Torch.png"); /* 1Wx1H */
  filesLoaded++;
  itemBackpack =loadImage(path+"backpack.png");
  filesLoaded++;
  itemPaper=loadImage(path+"Paper.png");
  filesLoaded++;
  itemMap=loadImage(path+"Map.png");
  filesLoaded++;
  itemBook=loadImage(path+"Book.png");
  filesLoaded++;
  itemBlowgun=loadImage(path+"blowgun.png");
  filesLoaded++;
  arrowR=loadImage("flechaR.png");
  filesLoaded++;
  arrowL=loadImage("flechaL.png");
  filesLoaded++;
  emptySpace=loadImage("EmptySpace.png");
  filesLoaded++;
  itemDiamond=loadImage("Diamond.png");
  filesLoaded++;
  itemClock=loadImage("Clock.png");
  filesLoaded++;
  itemToiletPaper=loadImage("ToiletPaper.png");
  itemCupCoffee=loadImage("CupCoffee.png"); 
  println(filesLoaded+" files loaded.");
 
  println("All Sprites loaded");
 
  spritesLoaded=1;

  spritesLoaded=1;
  inventory=new Furniture(new Room(HSELF), FURNINVENTORY);
  iniciaPisos();
  checkRoomTypes();
  println("Pisos Iniciados");
  hideObjects();
  spritesLoaded=2;
}
