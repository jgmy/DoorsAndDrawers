import java.io.*;

final int HLOBBY=0;
final int HOFFICE=1;
final int HKITCHEN=2;
final int HTOILET=3;
final int HSTAIRS=4;
int[] distribucion={HLOBBY, 
  HOFFICE, HOFFICE, HOFFICE, HOFFICE, 
  HOFFICE, HKITCHEN, HTOILET};
IntList dist;
Room[][] piso=new Room[8][8];
int spritesLoaded=0;
  PImage sprPadlock;
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
ArrayList <PImage> furnFrame=new ArrayList <PImage>();
/* Office and Special office furniture*/
PImage furnBigfile, furnMac, furnPC;
PImage furnPhotocopier, furnSafe, furnTable;

/* Lobby */
PImage furnCoffeTable, furnSofa;
/* Kitchen */
PImage furnCoffeMachine, furnFridge, furnMicrowave;
PImage furnDrawer, furnWC, furnTap;


/* Small Objects inside of furniture */
ArrayList <PImage> itemKey=new ArrayList <PImage>();
PImage itemPen, itemClip, itemCup, itemDiskette1;
PImage itemDiskette2, itemEnvelope, itemGasMask;
PImage itemJar,itemPaper, itemTorch;  

void sprites(){
  spritesLoaded=0;
  //String path=dataPath(File.separator)+File.separator+"assets_rooms"+File.separator;
  String path="";
  doorOffice=loadImage(path+"office1.png");
 
  if (doorOffice==null) println("doorOffice not found");
  sprPadlock=loadImage(path+"Padlock.png");
  doorStairs=loadImage(path+"Stairs.png");
  doorToilet=loadImage(path+"Toilet.png");
  doorKitchen=loadImage(path+"Kitchen.png");
  doorLab=loadImage(path+"Lab.png");
  doorLobby=loadImage(path+"Lobby.png");
  
  //String path=dataPath(File.separator)+File.separator+"assets_furniture"+File.separator;
/** Furniture **/

/* Multi-purpose */
furnDoor=loadImage(path+"door.png"); /* door seen from inside of room. 1Wx2H */
furnBookcase=loadImage(path+"bookcase.png");  /* 1Wx2H */
furnCabinetL=loadImage(path+"cabinetleft.png");  /* 1Wx1H */
furnCabinetR=loadImage(path+"Cabinetright.png");  /* 1Wx1H */
furnShelf=loadImage(path+"Shelf.png"); /* 1Wx1H */
furnWardrobe=loadImage("wardrobe.png"); /* 1Wx2H */
PImage furnFrameTmp;

furnFrame.add(loadImage(path+"Frame1.png")); 
furnFrame.add(loadImage(path+"Frame2.png"));
furnFrame.add(loadImage(path+"Frame3.png"));
furnFrame.add(loadImage(path+"Frame4.png"));

/* Office and Special office */ 
furnBigfile=loadImage(path+"bigfile.png"); /*1Wx2H*/
furnMac=loadImage(path+"Mac-ll-ci.png"); /* 1Wx1H */
furnPC=loadImage(path+"PC.png"); /* 1Wx1H */
furnPhotocopier=loadImage(path+"Photocopier.png"); /* 2Wx1H */
furnSafe=loadImage(path+"Safe.png"); /* 1Wx1H */
furnTable=loadImage("Table.png"); /* 2Wx1H */

/* Lobby */
furnCoffeTable=loadImage(path+"coffeetable.png");  /* 1Wx1H */
furnSofa=loadImage(path+"Sofa.png"); /* 2Wx1H */
/* Kitchen */
furnCoffeMachine=loadImage(path+"CoffeeMachine.png");  /* 1Wx1H */
furnFridge=loadImage(path+"Fridge.png");  /* 1Wx2H */
furnMicrowave=loadImage(path+"Microwave.png");  /* 1Wx1H */
furnDrawer=loadImage(path+"drawer.png");  /* 1Wx1H */
furnWC=loadImage(path+"WC.png");  /* 1Wx1H */
furnTap=loadImage(path+"Tap.png");  /* 1Wx1H */


/* Small Objects inside of furniture */
itemKey.add(loadImage(path+"key1.png"));
itemKey.add(loadImage(path+"key2.png"));
itemKey.add(loadImage(path+"Key3.png"));

itemPen=loadImage(path+"ballpen.png");  /* 1Wx1H */
itemClip=loadImage(path+"clip.png");  /* 1Wx1H */
itemCup=loadImage(path+"Cup.png");/* 1Wx1H */
itemDiskette1=loadImage(path+"disketteMac.png"); /* 1Wx1H */
itemDiskette2=loadImage(path+"diskettePcOld.png"); /* 1Wx1H */
itemEnvelope=loadImage(path+"Envelope.png"); /* 1Wx1H */
itemGasMask=loadImage(path+"GasMask.png"); /* 1Wx1H */
itemJar=loadImage(path+"Jar.png"); /* 1Wx1H */
itemPaper=loadImage(path+"Paper.png"); /* 1Wx1H */
itemTorch=loadImage(path+"Torch.png"); /* 1Wx1H */

  
  
  spritesLoaded=1;
  println("All Sprites loaded");

  
  
  
  iniciaPisos();
}
void iniciaPisos() {
  dist=new IntList();
  for (int f=0; f<distribucion.length; f++) {
    dist.append(distribucion[f]);
  }
  String debugString="";  
  int stairsAt=int(random(8));
  for (int f=0; f<8; f++) {
    dist.shuffle();
    debugString="";
    for (int g=0; g<8; g++) {
      if (g==stairsAt) {
        piso[f][g]=new Room(HSTAIRS);
      } else {
        piso[f][g]=new Room(dist.get(g));
      }
      debugString=debugString+"["+(piso[f][g].name+"    ").substring(0,6)+"]";
    }
    println(debugString);
  }
}


class Room {
  public String name;
  public PImage outImage;
  public boolean locked;
  public int key;
  public int rtype;
  Furniture[][] furniture;
  Room(int tipo) {
    this.rtype=tipo;
    switch (rtype) {
    case HLOBBY:
      name="lobby";
      outImage=doorLobby;
      break;    
    case HOFFICE:
      switch (int(random(10))) {
      default:
        name="office";
        outImage=doorOffice;
        break;
      case 1:
        name="laboratory";
        outImage=doorLab;
        break;
      case 2:
        name="executive";
        outImage=doorOffice;
        break;
      }
      break;
    case HKITCHEN:
      name="kitchen";
      outImage=doorKitchen;
      makeKitchen();
      break;
      
    case HTOILET:
      name="toilet";
      outImage=doorToilet;
      break;
    case HSTAIRS:
      name="stairs";
      outImage=doorStairs;
      break;
    }

    this.locked=false;
    this.key=0;
    this.furniture=new Furniture[3][5];
  }
  void makeKitchen(){
  /* A kitchen contains:
   a Door (top-to-down),
   some drawers
   an optional microwave
   some 
  */
  }
};

class Furniture {
  public boolean container=false;
  public boolean door=false;
  public boolean locked=false;
  public int space=0;
  public Item[] items[];
  public Room parentRoom;
  Furniture(Room parentRoom) {
    container=false;
    locked=false;
    space=0;
  }
};

class Item {
  Item() {

  };
};
