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
  PImage doorOffice;
  PImage sprPadlock;
  PImage doorStairs;
  PImage doorToilet;
  PImage doorKitchen;
  PImage doorLab;
  PImage doorLobby;

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
