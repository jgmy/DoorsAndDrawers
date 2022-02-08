import java.io.*; //<>// //<>//

final int HLOBBY=0;
final int HOFFICE=1;
final int HKITCHEN=2;
final int HTOILET=3;
final int HSTAIRS=4;
final int HOFFICELAB=5;
final int HOFFICEBOSS=6;
final int HOFFICEREPRO=7;
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

String[] labFridgeNames={
  "Fresh blood", "Don't open", 
  "Biohazard", "Corpses"
};
String[]  WCFunnyNames={
  "WC", "seat", "A Throne of Games", 
  "poopatorium", "oval office", "commode"
};
ArrayList <namedImage> furnFrame=new ArrayList <namedImage>();
/* Office and Special office furniture*/
PImage furnBigFile, furnMac, furnPC;
PImage furnPhotocopier, furnSafe, furnTable;

/* Lobby */
PImage furnCoffeeTable, furnSofa;
/* Kitchen */
PImage furnCoffeeMachine, furnFridge, furnMicrowave;
PImage furnDrawer, furnWC, furnTap;


/* Small Objects inside of furniture */
ArrayList <PImage> itemKey=new ArrayList <PImage>();
PImage itemPen, itemClip, itemCup, itemDiskette1;
PImage itemDiskette2, itemEnvelope, itemGasMask;
PImage itemJar, itemPaper, itemTorch;  
final int FURNSEEUP=-1; /* EMPTY furniture slot occupied by furniture at top*/
final int FURNSEELEFT=-2; /* EMPTY furniture slot occupied by furniture at left*/
final int FURNINVALID=0;
final int FURNDOOR=1;
final int FURNBOOKCASE=2;
final int FURNCABINET=3;
final int FURNSHELF=4;
final int FURNWARDROBE=5;
final int FURNFRAME=6;
final int FURNFAKEFRAME=7;
final int FURNBIGFILE=8;
final int FURNMAC=9;
final int FURNPC=10;
final int FURNPHOTOCOPIER=11;
final int FURNSAFE=12; /* see also FURNFAKEFRAME */
final int FURNTABLE=13;
final int FURNCOFFEETABLE=14;
final int FURNSOFA=15;
final int FURNCOFFEE=16;
final int FURNFRIDGE=17;
final int FURNMICROWAVE=18;
final int FURNDRAWER=19;
final int FURNWC=20;
final int FURNTAP=21;


int filesLoaded=0; /* number of files loaded */

class namedImage {
  PImage image;
  String name;
  namedImage(PImage i, String n) {
    this.image=i;
    this.name=n;
  }
}

void sprites() {
  spritesLoaded=0;
  filesLoaded=0;
  //String path=dataPath(File.separator)+File.separator+"assets_rooms"+File.separator;
  String path="";
  doorOffice=loadImage(path+"office1.png");
  filesLoaded++;
  if (doorOffice==null) println("doorOffice not found");
  sprPadlock=loadImage(path+"Padlock.png");
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
  furnFrame.add(new namedImage(loadImage(path+"Frame2.png"), "Spiral pattern"));
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
  itemDiskette1=loadImage(path+"disketteMac.png"); /* 1Wx1H */
  filesLoaded++;
  itemDiskette2=loadImage(path+"diskettePcOld.png"); /* 1Wx1H */
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

  //println(filesLoaded+" files loaded.");
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
      debugString=debugString+"["+(piso[f][g].name+"    ").substring(0, 6)+"]";
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
  public int doorAt=-1;
  // 48/16=3 (down, top, space for text)
  // 84/16=5 (five spaces)
  Furniture[][] furniture=new Furniture[2][5];
  Room(int tipo) {
    this.locked=false;
    this.key=0;
    this.rtype=tipo;
    /* All rooms have a door */
    this.doorAt=int(random(5));
    furniture[0][doorAt]=new Furniture(this, FURNDOOR);
    furniture[1][doorAt]=new Furniture(this, FURNSEEUP);
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
        this.rtype=HOFFICELAB;
        name="laboratory";
        outImage=doorLab;
        break;
      case 2:
        this.rtype=HOFFICEBOSS;
        name="executive";
        outImage=doorOffice;
        break;
      case 3:
        this.rtype=HOFFICEREPRO;
        name="reprographic";
        outImage=doorOffice;
        break;
      }
      break;
    case HKITCHEN:
      name="kitchen";
      outImage=doorKitchen;
      makeKitchen();
      displayTextRoom();

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

 }
  void makeKitchen() {
    println("Making kitchen");
    /* A kitchen contains:
     maybe a fridge
     some drawers
     an optional microwave
     */
    for (int fy=1; fy>-1; fy--) {
      for (int fx=0; fx<5; fx++) {
        /* ensure not to overwrite door */
        println("("+fx+","+fy+")");
        if ( (doorAt!=fx) && this.emptyPlace(fx, fy)) {
          int choose=int(random(20));

          switch (choose) {
          case 0:
            /*FRIDGE - 2 columns */
            /* check entire column */
            if (emptyColumn(fx) ) {
              println("Fridge at"+"("+fx+","+0+")");
              furniture[0][fx]=new Furniture(this, FURNFRIDGE);
              furniture[1][fx]=new Furniture(this, FURNSEEUP);
            }
            break;
          case 1: 
          case 2:
            /*FURNMICROWAVE or FURNCOFFEE on [fx][0]
            /* iff [fx][0] is empty and */
            /* [fx][1]=FURNDRAWER or FURNCABINET or empty  */
            /* makes empty drawer if [fx][1] empty */
            if (emptyColumn(fx) ) {
              println("Microwave or Coffee at ("+fx+","+0+") on top of makeshift furniture");
              furniture[0][fx]=new Furniture(this, (choose==1 ? FURNMICROWAVE : FURNCOFFEE));
              int rnd2=int (random(10) % 2);
              furniture[1][fx]=new Furniture(this, (rnd2==1 ? FURNCABINET : FURNDRAWER));
            } else {
              if (emptyPlace(fx, fy) ) {
                if (safetest(1, fx, FURNCABINET) || safetest (1, fx, FURNDRAWER)) {
                  println("Microwave or Coffee at ("+fx+","+0+") on top of existing furniture");
                  furniture[0][fx]=new Furniture(this, (choose==1 ? FURNMICROWAVE : FURNCOFFEE));
                }
              }
            }
            break;
          case 3: 
          case 4: /*FURNDRAWER */
            println("Drawer at ("+fx+","+fy+")");
            furniture[fy][fx]=new Furniture(this, FURNDRAWER);
            break;
          case 5: 
          case 6:
            println("Cabinet at ("+fx+","+fy+")");
            furniture[fy][fx]=new Furniture(this, FURNCABINET);
            break;
          case 7:
            if (fy==0) {
              println("Shelf at ("+fx+","+fy+")");
              furniture[fy][fx]=new Furniture(this, FURNSHELF);
            }
            break;
          }
        }
      }
    }
  }
  int safeGetFurn(int cx, int cy) {
    if (cx>=5 | cx<0) return FURNINVALID;
    if (cy<0 | cy>1) return FURNINVALID;
    if (furniture[cy][cx]==null) return FURNINVALID;
    if (furniture[cy][cx].ftype==FURNSEEUP) return safeGetFurn(cx, cy-1);
    if (furniture[cy][cx].ftype==FURNSEELEFT) return safeGetFurn(cx-1, cy);
    return furniture[cy][cx].ftype;
  }

  Furniture safeGetFurnObject(int cx, int cy) {
    if (cx>=5 | cx<0) return new Furniture (this, FURNINVALID);
    if (cy<0 | cy>1) return new Furniture (this, FURNINVALID);
    if (furniture[cy][cx]==null) return new Furniture (this, FURNINVALID);
    if (furniture[cy][cx].ftype==FURNSEEUP) return safeGetFurnObject(cx, cy);
    if (furniture[cy][cx].ftype==FURNSEELEFT) return safeGetFurnObject( cx, cy);
    return furniture[cy][cx];
  }
  boolean safetest(int cx, int cy, int furntype) {
    if (cx>=5 | cx<0) return false;
    if (cy<0 | cy>1) return false;
    if (furniture[cy][cx]==null) return false;
    if (furniture[cy][cx].ftype==furntype) return true;
    return false;
  }
  boolean emptyColumn(int cx) {
    boolean empty=true;        
    if (cx>=5 | cx<0) return true;
    for (int cy=0; cy<2; cy++) {
      if (this.furniture[cy][cx]!=null) {
        if (this.furniture[cy][cx].ftype!=FURNINVALID) {
          empty=false;
          return empty;
        }
      }
    }
    return empty;
  }
  boolean emptyPlace(int cx, int cy) {
    if (this.furniture[cy][cx]!=null) {
      if (this.furniture[cy][cx].ftype!=FURNINVALID) {
        return false;
      }
    } 
    return true;
  }
  void show() {
    NokiaScreen.background(255);  
    for (int cy=0; cy<2; cy++) {
      for (int cx=0; cx<5; cx++) {
        if (this.furniture[cy][cx]!=null) {
          switch (this.furniture[cy][cx].ftype) {
          case FURNINVALID:
          case FURNSEELEFT:
          case FURNSEEUP:
            /* do nothing */
            break;
          default:
            if (this.furniture[cy][cx].image!=null) {
              NokiaScreen.image(this.furniture[cy][cx].image, cx*16, cy*16);
            } else {
             // println("NULL image:"+this.furniture[cy][cx].name);
            }
            break;
          }
        } else {
          // println ("Null at"+cx+","+cy);
        }
      }
    }
  }
  void displayTextRoom() {
    for (int fky=0; fky<2; fky++) {
      String Kit="";
      for (int fkx=0; fkx<5; fkx++) {
        Kit+="["+nfp(safeGetFurn(fkx, fky), 2)+"]";
      }
      println(Kit);
    }
  }
};

class Furniture {
  public boolean container=false;
  public boolean door=false;
  public boolean locked=false;
  public int space=0;
  public Item[] items[];
  public Room parentRoom;
  public int ftype; /* furniture type */
  public PImage image;
  public String name;
  Furniture(Room parentRoom) {
    container=false;
    locked=false;
    space=0;
    this.ftype=FURNINVALID;
  }
  Furniture(Room pRoom, int furntype) {
    container=false;
    locked=false;
    space=0;
    this.parentRoom=pRoom;
    this.ftype=furntype;
    switch (this.ftype) {
    case FURNSEEUP:
      break;
    case FURNSEELEFT:  
      break;
    case FURNINVALID:  
      break;
    case FURNDOOR:
      this.name="Exit room";
      this.image=furnDoor;
      this.door=true;
      break;
    case FURNBOOKCASE:
      this.name="Bookcase";
      this.image=furnBookcase;
      break;
    case FURNCABINET:
      this.name="Cabinet";
      if (int(random(20) ) %2 ==1) {
        this.image=furnCabinetL;
      } else {
        this.image=furnCabinetR;
      }
      break;
    case FURNSHELF:
      this.name="Shelf";
      this.image=furnShelf;
      break;
    case FURNWARDROBE:
      this.name="Wardrobe";
      this.image=furnWardrobe;
      break;
    case FURNFAKEFRAME:
      /*SAFE inside a Picture frame */
    case FURNFRAME:
      int rnd=int(random(furnFrame.size()));
      this.name=furnFrame.get(rnd).name;
      this.image=furnFrame.get(rnd).image;
      break;
    case FURNBIGFILE:
      this.name="File";
      this.image=furnBigFile;
      break;
    case FURNMAC:
      this.name="GUI computer";
      this.image=furnMac;
      break;
    case FURNPC:
      this.name="Old computer";
      this.image=furnPC;
      break;
    case FURNPHOTOCOPIER:
      this.name="Copier";
      this.image=furnPhotocopier;
      break;
    case FURNSAFE:
      this.name="Safe";
      this.image=furnSafe;
      break;
    case FURNTABLE:
      this.name="Desk";
      this.image=furnTable;
      break;
    case FURNCOFFEETABLE:  
      this.name="Coffee table";
      this.image=furnCoffeeTable;
      break;
    case FURNSOFA:  
      this.name="Restplace";
      this.image=furnSofa;
      break;
    case FURNCOFFEE:
      this.name="Coffee machine";
      this.image=furnCoffeeMachine;
      break;
    case FURNFRIDGE:
      this.name="Fridge";
      this.image=furnFridge;
      if (this.parentRoom.rtype==HOFFICELAB) {
        this.name=""+labFridgeNames[int(random(labFridgeNames.length))];
      }
      break;
    case FURNMICROWAVE:  
      this.name="Oven";
      this.image=furnMicrowave;
      break;
    case FURNDRAWER:
      this.name="Drawers";
      this.image=furnDrawer;
      break;
    case FURNWC:
      this.name=""+""+WCFunnyNames[int(random(WCFunnyNames.length))];
      this.image=furnWC;
      break;
    case FURNTAP:  
      this.name="Tap";
      this.image=furnTap;
      break;
    }
  }
};

class Item {
  Item() {
  };
};
