import java.io.*; //<>//
import java.util.Map;

Room[][] piso=new Room[8][8];
StringList hints=new StringList();

Furniture inventory;

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
      roomsGenerated++;
      debugString=debugString+"["+(piso[f][g].name+"    ").substring(0, 6)+"]";
    }
    println(debugString);
  }
}

void checkRoomTypes() {
  int countRepro=0;
  int countBoss=0;
  int countLab=0;
  /* Make sure there is at least one Boss, one Repro and one Lab */
  for (int ff=0; ff<8; ff++) {
    for (int gg=0; gg<8; gg++) {
      if (piso[ff][gg]!=null) {
        if (piso[ff][gg].rtype==HOFFICEBOSS) countBoss++;
        if (piso[ff][gg].rtype==HOFFICELAB) countLab++;
        if (piso[ff][gg].rtype==HOFFICEREPRO) countRepro++;
      }
    }
  }
  if (countBoss<1) {
    if (forcedSubstitute(HOFFICE, HOFFICEBOSS)==-1)
      println("Couldn't force substitute "+HOFFICE+" by "+HOFFICEBOSS);
    else
      println("Forced substitution of "+HOFFICE+" by "+HOFFICEBOSS);
  }
  if (countLab<1) {
    if (forcedSubstitute(HOFFICE, HOFFICELAB)==-1)
      println("Couldn't force substitute "+HOFFICE+" by "+HOFFICELAB);
    else
      println("Forced substitution of "+HOFFICE+" by "+HOFFICELAB);
  }
  if (countRepro<1) {
    if (forcedSubstitute(HOFFICE, HOFFICEREPRO)==-1)
      println("Couldn't force substitute "+HOFFICE+" by "+HOFFICEREPRO);
    else
      println("Forced substitution of "+HOFFICE+" by "+HOFFICEREPRO);
  }
  println("Forced substitutions ended");
}
void hideObjects() {
  int [][] dst={
    {FURNFAKEFRAME, FURNSAFE}, 
    {FURNDRAWER, FURNCABINET, FURNWARDROBE, FURNFRIDGE}, 
    {FURNTABLE, FURNLABTABLE, FURNCOFFEETABLE, FURNBOOKCASE, FURNSHELF} };
  Furniture recipeFur;
  for (int f=0; f<3; f++) {
    recipeFur=insertAtRandomFurn(dst[f], ITEMSECRETRECIPE);
    if (recipeFur==null) {
      println("trying to hide recipe at unsafer furniture");
    } else {
      recipeFur.locked=true;
      recipeFur.keynum=0;
      break;
    }
  }

  int tries=0; /* Safeguard */
  int [][] keyHideOuts={
    {FURNFAKEFRAME, FURNSAFE}, 
    {FURNDRAWER, FURNCABINET, FURNWARDROBE, FURNFRIDGE}, 
    {FURNTABLE, FURNLABTABLE, FURNCOFFEETABLE, FURNBOOKCASE, FURNSHELF} };
  while (nextKeynum<10 && tries<50) {
    tries++;
    int success=0;
    Furniture keyFur;
    // 1- Hide last used key:
    println("hide "+nextKeynum);
    for (int f=0; f<3 && success==0; f++ ) {
      keyFur=insertAtRandomFurn(keyHideOuts[f], ITEMKEY);
      if (keyFur==null) {
        println("trying to hide key"+nextKeynum+" at unsafer furniture");
      } else {
        success=1;
        break;
      }
    }
    /* If we couldn't hide last key. Abort */
    if ( success==0) {

      println("We couldn't find a place for Key"+nextKeynum);
      break; /* break while */
    }
    // 2- Close next object
    if (closeRandomFloorOrFurniture()==-1) {
      println("We couldn't find a furniture to close");
      break;
    }
  }
  /* This is a debug function */
  croquisLlaves();

  /* Insert random Items */
  insertRndItems();
}


void croquisLlaves() {
  Room thisroom;
  int planta, sala, y, x, it;
  Furniture thisfurniture;
  for (planta=0; planta<8; planta++) {
    for (sala=0; sala<8; sala++) {
      if (piso[planta][sala]!=null) {
        thisroom=piso[planta][sala];
        if (thisroom.locked) {
          println(thisroom.name+" "+planta+sala+" cerrada con llave"+thisroom.key);
        }
        if (thisroom.rtype!=HSTAIRS && thisroom.furniture!=null) {
          for (y=0; y<2; y++) {
            for (x=0; x<5; x++) {
              if (thisroom.furniture[y][x]!=null) {
                thisfurniture=thisroom.furniture[y][x];
                if (thisfurniture.locked) {
                  println(thisfurniture.name+" cerrada con llave"+thisfurniture.keynum+" en "+thisroom.name+" "+planta+sala);
                }
                if (thisfurniture.items!=null) {
                  for (it=0; it<thisfurniture.items.length; it++) {
                    if (thisfurniture.items[it].itype==ITEMKEY) {
                      println("Llave "+thisfurniture.items[it].keynum+
                        " en "+thisfurniture.name+" "+
                        (thisfurniture.locked ? ("cerrado con llave "+thisfurniture.keynum) : "abierto")+
                        " en "+thisroom.name+" "+planta+sala);
                    }
                    if (thisfurniture.items[it].itype==ITEMSECRETRECIPE) {
                      println("Receta "+thisfurniture.items[it].keynum+
                        " en "+thisfurniture.name+" "+
                        (thisfurniture.locked ? ("cerrado con llave "+thisfurniture.keynum) : "abierto")+
                        " en "+thisroom.name+" "+planta+sala);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

/* Fill all furniture, depending of item type */
class PercentApparition {
  int item, percent;
  PercentApparition(int item, int percent) {
    this.item=item;
    this.percent=percent;
  }
  String toString() {
    return "("+percent+"%: "+item+")";
  }
};

class ItemChooser {
  PercentApparition[] pTable;
  int maxPercent=100;
  ItemChooser(int[] percents) {
    int max=0;
    this.pTable=new PercentApparition[0];
    for (int f=0; f<percents.length; f+=2) {
      if (percents.length<(f+1)) break;
      this.pTable=(PercentApparition[]) append(this.pTable, new PercentApparition(percents[f], percents[f+1]));
      max=max+percents[f+1];
    }
    if (max>maxPercent) maxPercent=max;
  }
  int choose() {
    return choose(0);
  }
  /* "Plus" lowers dice roll */
  int choose(int plus) {
    if (pTable==null || pTable.length<1) return ITEMEMPTY;
    int roll=int(random(maxPercent))-plus;
    println("roll:"+roll);
    /* DEBUG START*/
    //String strDebug="";
    //for (int i=0;i<pTable.length;i++){
    //  strDebug=strDebug+pTable[i].toString()+",";
    //}
    //println(strDebug);
    /* DEBUG END */
    int current=0;
    int index=0;
    while (index<pTable.length) {
      println ("index:"+index+ " current:"+current);
      if (roll<(current+pTable[index].percent)) break;
      current+=abs(pTable[index].percent);
      index++;
      if (index>=pTable.length || current>=this.maxPercent) break;
    }  
    if (index>=pTable.length) {
      println("index:", index, ". No item");
      return ITEMEMPTY;
    } else {
      println("index:", index, ". Item"+pTable[index].item);
      return pTable[index].item;
    }
  }
};
HashMap <Integer, ItemChooser>PA=new HashMap<Integer, ItemChooser>();
void insertRndItems() {
  Room thisroom;
  int planta, sala, y, x, it;
  int extra, objetoElegido;
  Item nuevoObjeto;
  Furniture thisfurniture;

  PA.put (FURNBOOKCASE, new ItemChooser( forBookcase));
  PA.put (FURNCABINET, new ItemChooser(forCabinet));
  PA.put (FURNSHELF, new ItemChooser(forShelf ));
  PA.put (FURNWARDROBE, new ItemChooser(forWardrobe));
  PA.put (FURNFRAME, new ItemChooser(forFrame));
  PA.put (FURNBIGFILE, new ItemChooser(forBigfile));
  PA.put (FURNCOPIER, new ItemChooser(forCopier));
  PA.put (FURNSAFE, new ItemChooser(forSafe));
  PA.put (FURNCOFFEETABLE, new ItemChooser(forCoffeetable));
  PA.put (FURNCOFFEE, new ItemChooser(forCoffee));
  PA.put (FURNFRIDGE, new ItemChooser(forFridge));
  PA.put(FURNMICROWAVE, new ItemChooser(forMicrowave));
  PA.put(FURNDRAWER, new ItemChooser(forDrawer));
  PA.put(FURNWC, new ItemChooser(forWC));
  PA.put(FURNLABTABLE, new ItemChooser(forTable));
  PA.put(FURNMIRROR, new ItemChooser(forFrame));

  for (planta=0; planta<8; planta++) {
    for (sala=0; sala<8; sala++) {
      /* ROOM CHOSEN */
      extra=0;
      if (piso[planta][sala]!=null) {
        thisroom=piso[planta][sala];
        if (thisroom.locked) extra=10;
        if (thisroom.rtype!=HSTAIRS && thisroom.furniture!=null) {
          for (y=0; y<2; y++) {
            for (x=0; x<5; x++) {
              /* FORNITURE CHOSEN */
              if (thisroom.furniture[y][x]!=null) {
                thisfurniture=thisroom.furniture[y][x];
                if (thisfurniture.locked) {
                  extra+=10;
                }
                if (thisfurniture.space>0) {
                  if (PA.containsKey(thisfurniture.ftype)) {
                    objetoElegido=PA.get(thisfurniture.ftype).choose();
                    nuevoObjeto=new Item(objetoElegido);
                    thisfurniture.addToItemArray(nuevoObjeto);
                    println("Objeto "+nuevoObjeto.name+
                      " en "+thisfurniture.name+" "+
                      (thisfurniture.locked ? ("cerrado con llave "+thisfurniture.keynum) : "abierto")+
                      " en "+thisroom.name+" "+planta+sala);
                  } /* End check for furniture type in PA */
                } /* End check for space in furniture */
              } /* FORNITURE NON NULL */
            } /* END FOR x*/
          } /* END FOR y*/
        }/* END cHECK FOR HSTAIRS */
      }/* END CHECK FOR NULL ROOM */
    }    /* END ROOM CHOOSING */
  }
} /*END FUNCT */

int closeRandomFloorOrFurniture() {
  int randx=int(random(8));
  int randy=int(random(8));
  for (int f=0; f<8; f++) for (int g=0; g<8; g++) {
    int y=(f+randy) % piso.length;
    int x=(g+randx) % (piso[y].length);
    if ((piso[y][x]!=null) && (!piso[y][x].locked) && (piso[y][x].rtype!=HSTAIRS)) {
      if (random(2)<1) {
        piso[y][x].locked=true;
        piso[y][x].key=nextKeynum;
        return 0;
      } else {
        /* Try to close a furniture */
        if (closeRandomFurn(piso[y][x])==-1) {
          /* There is no closeable furn */
          piso[y][x].locked=true;
          piso[y][x].key=nextKeynum;
          return 0;
        } else {
          /* Furniture closed OK */
          return 0;
        }
      } /* end if random */
    } /* end if test piso */
  }
  return -1;
}

int closeRandomFurn(Room room) {
  int [] closeable={FURNFAKEFRAME, FURNSAFE, FURNDRAWER, FURNCABINET, FURNWARDROBE, FURNFRIDGE};

  int randx=int(random(8));
  int randy=int(random(8));
  if (room==null) return -1;
  for (int f=0; f<2; f++) for (int g=0; g<5; g++) {
    int y=(f+randy) % 2;
    int x=(g+randx) % 5;
    for (int c=0; c<closeable.length; c++) {
      if (room.safeTest(x, y, closeable[c])) {
        Furniture destFurn=room.safeGetFurnObject(x, y);
        if (!destFurn.locked) {
          destFurn.locked=true;
          destFurn.keynum=nextKeynum;
          return 0;
        }
      }
    }
  }
  return -1;
}
int forcedSubstitute(int srctype, int dsttype) {
  int randx=int(random(8));
  int randy=int(random(8));
  for (int f=0; f<8; f++) {
    for (int g=0; g<8; g++) {
      int y=(f+randy) % piso.length;
      int x=(g+randx) % (piso[y].length);
      if (piso[y][x]==null) {
        println("inserting at NULL floor "+x+","+y);
        println("!!!");
      } else  if (piso[y][x].rtype==srctype) {
        piso[y][x]=new Room(dsttype);
        return 0;
      }
    }
  }
  return -1;
}

Furniture insertAtRandomFurn(int[] desttype, int itemtype) {
  //println("insertAtRandomFurn()");
  if (desttype==null || desttype.length==0 ) return null;
  int randx=int(random(8));
  int randy=int(random(8));
  for (int f=0; f<8; f++) {
    int y=(f+randy) % piso.length;
    for (int g=0; g<8; g++) {
      int x=(g+randx) % (piso[y].length);
      //println("Looking for furn at piso"+y+" room"+x);
      if (piso[y][x]!=null && piso[y][x].rtype!=HSTAIRS) {
        if (piso[y][x].locked==false) {
          for (int ff=0; ff<2; ff++) {
            for (int gg=0; gg<5; gg++) {
              int randyy=int(random(2));
              int randxx=int(random(5));
              int yy=(ff+randyy) % 2;
              int xx=(gg+randxx) % 5;
              //println("furniture ("+yy+") ("+xx+")");
              for (int type=0; type<desttype.length; type++) {
                if (piso[y][x].safeTest(xx, yy, desttype[type])) {

                  Furniture furnObject= piso[y][x].safeGetFurnObject(yy, xx);
                  if (!furnObject.locked && !furnObject.password) {
                    if (furnObject.space>0) {
                      // if(itemtype==ITEMKEY) println( "NKN before key insertion:"+nextKeynum);
                      Item escondido=new Item(itemtype);
                      // if(itemtype==ITEMKEY) println( "NKN after key insertion:"+nextKeynum);
                      furnObject.addToItemArray(escondido);
                      makeHint(escondido.name, x, y, furnObject.name);
                      return furnObject;
                    }
                  }
                }
              }
              //println("Not found");
            }
          }
        }
      }
    }
  }
  return null;
}

void makeHint(String nombre, int habitacion, int planta, String mueble) {
  hints.push("There is a "+nombre+"inside a "+mueble);
  hints.push("Search "+piso[planta][habitacion].name+" "+planta+habitacion+" for a "+nombre);
  hints.push(nombre+" is at floor #"+planta);
}

class Room {

  public String name;
  public PImage outImage;
  public boolean locked;
  public int key;
  public int rtype;
  public int doorAt=-1;
  public int background;
  // 48/16=3 (down, top, space for text)
  // 84/16=5 (five spaces)
  Furniture[][] furniture=new Furniture[2][5];
  Room(int tipo) {
    this.locked=false;
    this.key=0;
    this.rtype=tipo;
    this.background=int(random(4));
    ;
    /* All rooms have a door */
    this.doorAt=int(random(5));
    furniture[0][doorAt]=new Furniture(this, FURNDOOR);
    furniture[1][doorAt]=new Furniture(this, FURNSEEUP);
    switch (rtype) {
    case HLOBBY:
      name="lobby";
      outImage=doorLobby;
      makeLobby();
      break;
    case HOFFICE:
    default:
      switch (int(random(10))) {
      default:
        name="office";
        outImage=doorOffice;
        makeOffice();
        displayTextRoom();
        break;
      case 1:
        this.rtype=HOFFICELAB;
        name="laboratory";
        outImage=doorLab;
        makeLab();
        displayTextRoom();
        break;
      case 2:
        this.rtype=HOFFICEBOSS;
        name="executive";
        outImage=doorOffice;
        makeBossOffice();
        makeOffice();
        displayTextRoom();
        break;
      case 3:
        this.rtype=HOFFICEREPRO;
        name="reprographic";
        outImage=doorOffice;
        makeReproOffice();
        displayTextRoom();
        break;
      }
      break;
    case HOFFICELAB:
      /* Forced Lab */
      this.rtype=HOFFICELAB;
      name="laboratory";
      outImage=doorLab;
      makeLab();
      displayTextRoom();
      break;
    case HOFFICEBOSS:
      /* Forced Boss office */
      this.rtype=HOFFICEBOSS;
      name="executive";
      outImage=doorOffice;
      makeBossOffice();
      makeOffice();
      displayTextRoom();
      break;
    case HOFFICEREPRO:
      /* Forced Repro */
      this.rtype=HOFFICEREPRO;
      name="reprographic";
      outImage=doorOffice;
      makeReproOffice();
      displayTextRoom();
      break;

    case HKITCHEN:
      name="kitchen";
      outImage=doorKitchen;
      makeKitchen();
      //displayTextRoom();
      break;
    case HTOILET:
      name="toilet";
      outImage=doorToilet;
      makeToilet();
      break;
    case HSTAIRS:
      name="stairs";
      outImage=doorStairs;
      break;
    }
  }
  void makeKitchen() {
    //println("Making kitchen");
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
            placeTallFurniture(fx, fy, FURNFRIDGE);
            break;
          case 1: 
          case 2:
            onTopOf(fx, fy, MICROWAVEorCOFFEE, DRAWERorCABINET);
            break;
          case 3: 
          case 4: /*FURNDRAWER */
            // Make drawer at [0][fx] if there is drawer at [1][fx]
            println("Drawer at ("+fx+","+fy+")");
            if (fy==1) {
              /* Drawers at floor level */
              furniture[fy][fx]=new Furniture(this, FURNDRAWER);
            } else {
              onTopOf(fx, fy, FURNDRAWER, UNDERDRAWER);
            }
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
  void makeLobby() {
    //println("Making lobby");
    /* A lobby  contains:
     probably a sofa and/or coffee table
     maybe bookcases or shelves
     */
    for (int fy=1; fy>-1; fy--) {
      for (int fx=0; fx<5; fx++) {
        /* ensure not to overwrite door */
        println("("+fx+","+fy+")");
        if ( (doorAt!=fx) && this.emptyPlace(fx, fy)) {
          int choose=int(random(20));
          switch (choose) {
          case 0:
            /*Wardrobe - 2 rows */
            placeTallFurniture(fx, fy, FURNWARDROBE);
            break;
          case 1: 
          case 2:
          case 3:
            /* SOFA */
            placeTwoSlots(fx, 1, FURNSOFA);
            break;
          case 4:
          case 5: /*FURNCOFFEETABLE */
            if (fx==1) {
              furniture[fx][fy]=new Furniture(this, FURNCOFFEETABLE);
            }
            break;

          case 6: 
            if (fy==1) {
              furniture[fy][fx]=new Furniture(this, (int(random(10))==1) ? FURNFAKEFRAME: FURNFRAME);
            }
            break;
          case 7:
            furniture[fy][fx]=new Furniture(this, FURNBOOKCASE);
            break;
          case 8:
            if (fy==0) {
              furniture[fy][fx]=new Furniture(this, FURNSHELF);
            }
            break;
          }
        }
      }
    }
  }
  void makeToilet() {
    for (int f=0; f<5; f++) {
      int rnd=int(random(10));
      if (emptyPlace(f, 1)) {
        switch (rnd) {
        case 1: 
        case 2: 
        case 3:
          this.furniture[1][f]=new Furniture(this, FURNWC);
          break;
        case 4: 
        case 5: 
        case 6: 
        case 7: 
          this.furniture[1][f]=new Furniture(this, FURNTAP);
          if (emptyPlace(f, 0) ) this.furniture[0][f]=new Furniture(this, FURNMIRROR);
          break;
        }
      }
    }
  }
  void makeLab() {
    //println("Making lab");
    /* A lab  contains:
     maybe a fridge
     some drawers, cabinets
     maybe bookcases
     PC or MAC
     (a microscope if I make the sprite);
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
            placeTallFurniture(fx, fy, FURNFRIDGE);
            break;
          case 1: 
          case 2:
            /* LAB TABLE */
            if (fy==1) {
              if ((fx<4) && emptyPlace(fx, 1) && emptyPlace(fx+1, 1)) {
                furniture[1][fx]=new Furniture(this, FURNLABTABLE);
                furniture[1][fx]=new Furniture(this, FURNSEELEFT);
              } else if ((fx>1) && emptyPlace(fx, 1) && emptyPlace(fx-1, 1)) 
              {
                furniture[1][fx]=new Furniture(this, FURNLABTABLE);
                furniture[1][fx]=new Furniture(this, FURNSEELEFT);
              }
            }
            break;
          case 3:
            onTopOf(fx, fy, PCorMAC, DRAWERorCABINET, SOLIDBOTTOM);
            break;
          case 4: 
          case 5: /*FURNDRAWER */
            // Make drawer at [0][fx] if there is drawer at [1][fx]
            println("Drawer at ("+fx+","+fy+")");
            if (fy==1) {
              /* Drawers at floor level */
              furniture[fy][fx]=new Furniture(this, FURNDRAWER);
            } else {
              /* Drawers should be on top of another object */
              switch (safeGetFurn(fx, fy-1)) {                
              case FURNCABINET:
              case FURNFAKEFRAME:
              case FURNFRAME:
              case FURNSAFE:
              case FURNDRAWER:
                furniture[fy][fx]=new Furniture(this, FURNDRAWER);
                break;
              }
            }
            break;
          case 6: 
          case 7:
            furniture[fy][fx]=new Furniture(this, FURNCABINET);
            break;
          case 8:
            furniture[fy][fx]=new Furniture(this, FURNBOOKCASE);
            break;
          case 9:
            if (fy==0) {
              furniture[fy][fx]=new Furniture(this, FURNSHELF);
            }
            break;
          case 10:
            /* MICROSCOPE */
            onTopOf(fx, fy, FURNMICROSCOPE, UNDERSCOPE, SOLIDBOTTOMEXTRA
              );
            break;
          }
        }
      }
    }
  }

  void makeReproOffice() {
    int rx; /* random x and y */
    /* Compulsory copier */
    int copiers=1+int(random(2));
    for (int f=0; f<copiers; f++) {
      rx=int(random(4));
      placeTwoSlots(rx, 1, FURNCOPIER);
    }
    /* High chance of having drawers or lockers */
    for (rx=0; rx<5; rx++) {
      if (emptyPlace(rx, 1)) {
        switch (int (random(3))) {
        case 0:
          this.furniture[1][rx]=new Furniture(this, FURNDRAWER);
        case 1:
          this.furniture[1][rx]=new Furniture(this, FURNCABINET);
        }
      }
    }
  }
  void makeBossOffice() {
    int rx, ry; /* random x and y */
    /* Compulsory table */
    rx=int(random(4));
    placeTwoSlots(rx, 1, FURNTABLE);
    /*compulsory computer */
    for (int tries=0; tries<5; tries++) {
      if (emptyPlace(rx, 0)) {
        onTopOf(rx, 0, PCorMAC, DRAWERorCABINET, SOLIDBOTTOM);
      }
      if (safeTest(rx, 0, FURNPC) || safeTest(rx, 0, FURNMAC ) )break;
      rx=(rx+1) % 4;
    }
    /* Compulsory picture and probable FAKEFRAME */
    for (int tries=0; tries<10; tries++) {
      rx=int(random(5));
      ry=int(random(2));
      if (emptyPlace(rx, ry)) {
        this.furniture[ry][rx]=
          new Furniture(this, int(random(5))==1? FURNFAKEFRAME: FURNFRAME);
        break;
      }
    }
    int pictureNumber=int(random(3));
    /* There is a chance for the boss to have its place 
     full of pictures, even at floor level
     */
    for (int tries=0; tries<pictureNumber; tries++) {
      rx=int(random(5));
      ry=int(random(2));
      if (emptyPlace(rx, ry)) {
        this.furniture[ry][rx]=
          new Furniture( this, int(random(5))==1? FURNFAKEFRAME: FURNFRAME);
        break;
      }
    }
  }
  void makeOffice() {
    //println("Making Office");
    /* An office  contains:
     table
     some drawers, cabinets
     maybe bookcases
     PC or MAC
     */
    for (int fy=1; fy>-1; fy--) {
      for (int fx=0; fx<5; fx++) {
        /* ensure not to overwrite door */
        println("("+fx+","+fy+")");
        if ( (doorAt!=fx) && this.emptyPlace(fx, fy)) {
          int choose=int(random(20));

          switch (choose) {
          case 0:
            placeTallFurniture(fx, fy, FURNBIGFILE);
            break;
          case 1: 
          case 2: 
          case 3:
            /* TABLE */
            placeTwoSlots(fx, 1, FURNTABLE);
            break;
          case 4:
            /* if possible, add a furntable */
            /* (This checks for emptiness of fx,1) */
            placeTwoSlots(fx, 1, FURNTABLE);
            /* Then add a PC or MAC */
            onTopOf(fx, fy, PCorMAC, DRAWERorCABINET, SOLIDBOTTOM);
            break;
          case 5: 
          case 6: /*FURNDRAWER */
            // Make drawer at [0][fx] if there is drawer at [1][fx]
            if (fy==1) {
              /* Drawers at floor level */
              furniture[fy][fx]=new Furniture(this, FURNDRAWER);
            } else {
              final int[] arrayofdrawers={FURNDRAWER};
              onTopOf(fx, fy, FURNDRAWER, arrayofdrawers, SOLIDBOTTOM);
            }
            break;
          case 7: 
          case 8:
            furniture[fy][fx]=new Furniture(this, FURNCABINET);
            break;
          case 9:
            furniture[fy][fx]=new Furniture(this, FURNBOOKCASE);
            break;
          case 10:
            if (fy==0) {
              furniture[fy][fx]=new Furniture(this, FURNSHELF);
            }
            break;
          case 11:
            onTopOf(fx, fy, FURNLAMP, UNDERSCOPE, SOLIDBOTTOM);
            break;
          case 12:
            placeTallFurniture(fx, fy, FURNWARDROBE);
          }
        }
      }
    }
  }
  /* Place 2-rows furniture */
  void placeTallFurniture(int cx, int cy, int ftype) {
    /* check entire column */
    if (emptyColumn(cx) ) {
      //println("Tall furn "+ftype+" at "+"("+cx+","+0+")");
      furniture[0][cx]=new Furniture(this, ftype);
      furniture[1][cx]=new Furniture(this, FURNSEEUP);
    }
  }
  void placeTwoSlots(int cx, int cy, int ftype) {
    if ((cx<4) && emptyPlace(cx, cy) && emptyPlace(cx+1, cy)) {
      furniture[cy][cx]=new Furniture(this, ftype);
      furniture[cy][cx+1]=new Furniture(this, FURNSEELEFT);
    } else if ((cx>1) && emptyPlace(cx, cy) && emptyPlace(cx-1, cy)) 
    {
      furniture[cy][cx]=new Furniture(this, ftype);
      furniture[cy][cx]=new Furniture(this, FURNSEELEFT);
    }
  }

  /* Place topftype on top of bottomftype                    */
  /* iff [fx][0] is empty and [fx][1]=bottomftype[] or empty  */
  /* (makes emptyftype  if [fx][1] empty)                    */
  void onTopOf(int cx, int cy, int[] topftype, int[] bottomftype, int[] extraftype) {
    int[] bottomextra;
    if (cx<0|cx>4|cy<0|cy>1) return;
    if (topftype==null || bottomftype==null) return;
    if (topftype.length==0) return;
    if (extraftype==null||extraftype.length==0) {
      bottomextra=concat(bottomftype, extraftype);
    } else {
      bottomextra=extraftype;
    }
    int randomftype=topftype[int(random(topftype.length))];
    if (bottomftype.length>0 && emptyColumn(cx) ) {

      //println(randomftype+" at ("+cx+","+0+") on top of makeshift furniture");
      furniture[0][cx]=new Furniture(this, randomftype);
      int randombottom=bottomftype[int(random(bottomftype.length))];
      furniture[1][cx]=new Furniture(this, randombottom);
    } else if (emptyPlace(cx, 0) ) {
      boolean passes=false;
      for (int i=0; i<bottomextra.length; i++) {
        if (safeTest(1, cx, bottomextra[i])) {
          passes=true;
          break;
        }
        if (passes) {
          furniture[0][cx]=new Furniture(this, randomftype);
          //println(randomftype+" at ("+cx+","+0+") on top of existing furniture");
        }
      }
    }
  }
  void onTopOf(int cx, int cy, int topftype, int[] bottomftype, int[] extraftype) {
    int[] oneitemarray={0};
    oneitemarray[0]=topftype;
    onTopOf(cx, cy, oneitemarray, bottomftype, extraftype);
  }
  void onTopOf(int cx, int cy, int[] topftype, int[] bottomftype) {
    final int[] zeroitemarray={};
    onTopOf(cx, cy, topftype, bottomftype, zeroitemarray);
  }
  void onTopOf(int cx, int cy, int topftype, int[] bottomftype ) {
    int[] oneitemarray={0};
    final int[] zeroitemarray={};
    oneitemarray[0]=topftype;
    onTopOf(cx, cy, oneitemarray, bottomftype, zeroitemarray);
  }


  /* Safely get furniture type at (cx,cy) OLD RECURSIVE VERSION*/
  int safeGetFurnRecursive(int cx, int cy) {
    if (cx>=5 | cx<0) return FURNINVALID;
    if (cy<0 || cy>1) return FURNINVALID;
    if (furniture==null || furniture.length<cy ) return FURNINVALID;
    if (furniture[cy][cx]==null) return FURNINVALID;
    if (furniture[cy][cx].ftype==FURNSEEUP) return safeGetFurn(cx, cy-1);
    if (furniture[cy][cx].ftype==FURNSEELEFT) return safeGetFurn(cx-1, cy);
    return furniture[cy][cx].ftype;
  }

  /* Safely get furniture type at (cx,cy) NEW NONRECURSIVE VERSION*/
  int safeGetFurn(int cx, int cy) {
    int tries=5;
    /* this should loop twice at most, but we will give 5 tries */
    while (tries>0) {
      if (cx>=5 || cx<0) return FURNINVALID;
      if (cy<0 || cy>1) return FURNINVALID;
      if (furniture==null || furniture.length<cy ) return FURNINVALID;
      if (furniture[cy][cx]==null) return FURNINVALID;

      switch  (furniture[cy][cx].ftype) {
      case FURNSEEUP: 
        cy--; 
        break;
      case FURNSEELEFT:
        cx--;
        break;
      default:
        return furniture[cy][cx].ftype;
      }
      tries--;
    }
    return FURNINVALID;
  }
  final private Furniture dummyInvalid=new Furniture(this, FURNINVALID);
  /* Safely get actual Furniture object at (cx,cy) */
  Furniture safeGetFurnObject(int cx, int cy) {

    if (cx>=5 || cx<0) return dummyInvalid;
    if (cy<0 || cy>1) return dummyInvalid;
    if (furniture[cy][cx]==null) return dummyInvalid;
    if (furniture[cy][cx].ftype==FURNSEEUP) return safeGetFurnObject(cx, cy-1);
    if (furniture[cy][cx].ftype==FURNSEELEFT) return safeGetFurnObject( cx-1, cy);
    return furniture[cy][cx];
  }

  /* Safely get if furntype at (cx,cy) is furntype */
  boolean safeTest(int cx, int cy, int furntype) {
    if (cx>=5 || cx<0) return false;
    if (cy<0 || cy>1) return false;
    if (furniture==null || furniture[cy][cx]==null) return false; 
    if (furniture[cy][cx].ftype==furntype) return true;

    /* Añadido. No sé si puede causar problemas (es posible
     que inicialmente quitase esta función a propósito) */
    /* Desde luego, no debería estar activo en la fase de creación */
    //if (furniture[cy][cx].ftype==FURNSEELEFT && cx>0) {
    //  if (furniture[cy][cx-1].ftype==furntype) return true;
    //}
    //if (furniture[cy][cx].ftype==FURNSEEUP && cy>0) {
    //  if (furniture[cy-1][cx].ftype==furntype) return true;
    //}

    return false;
  }

  /* Is this column empty? */
  boolean emptyColumn(int cx) {
    boolean empty=true;        
    if (cx>=5 || cx<0) return true;
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
    Pattern(this.background);
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
}

void Pattern(int num) {
  NokiaScreen.pushStyle();
  switch(num) {
  default:
    NokiaScreen.background(255);
    break;
  case 1:
    NokiaScreen.fill(0);
    NokiaScreen.rect(0, 0, 84, 32);
    break;
  case 2:
    NokiaScreen.background(255);
    for (int f=0; f<84; f+=5) NokiaScreen.line(f, 0, f, 32);
    for (int f=32; f>=0; f-=5) NokiaScreen.line(0, f, 84, f);
    break;
  case 3:
    NokiaScreen.background(255);
    for (int f=0; f<32; f+=2) NokiaScreen.line(0, f, 84, f);
    break;
  case 4:
    NokiaScreen.background(255);
    for (int f=0; f<84; f+=2) NokiaScreen.line(f, 20, f, 32);
    break;
  case 5:
    // Polka dots
    NokiaScreen.background(255);
    final int R=8; 
    final int halfR=4;
    final float ang=HALF_PI/3;
    for (int fy=0; fy<(48/halfR); fy++) {
      for (int fx=0; fx<(84/halfR); fx++) {
        float plus=R*(fx%2)*sin(ang);
        NokiaScreen.ellipse(fx*R*cos(ang), 
          fy*2*R*sin(ang) +plus, 
          R/4, R/4);
      }
    }
  }  

  NokiaScreen.popStyle();
}

class Furniture {
  public boolean container=false;
  public boolean door=false;
  public boolean locked=false;
  public boolean password=false;
  public int keynum=0;
  public int passnum=0;
  public int space=0;
  public Item[] items;
  public Room parentRoom;
  public int ftype; /* furniture type */
  public PImage image;
  public String name;
  final Item empty_space=new Item(ITEMEMPTY);
  Furniture(Room parentRoom) {
    container=false;
    locked=false;
    password=false;
    space=0;
    this.ftype=FURNINVALID;
    this.parentRoom=parentRoom;
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
      this.space=3;
      break;
    case FURNCABINET:
      this.name="Cabinet";
      if (int(random(20) ) %2 ==1) {
        this.image=furnCabinetL;
      } else {
        this.image=furnCabinetR;
      }
      this.space=3;
      break;
    case FURNSHELF:
      this.name="Shelf";
      this.image=furnShelf;
      this.space=1;
      break;
    case FURNWARDROBE:
      this.name="Wardrobe";
      this.image=furnWardrobe;
      this.space=4;
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
      this.space=3;
      break;
    case FURNMAC:
      this.name="GUI computer";
      this.image=furnMac;
      this.space=1;
      break;
    case FURNPC:
      this.name="Old computer";
      this.image=furnPC;
      this.space=1;
      break;
    case FURNCOPIER:
      this.name="Copier";
      this.image=furnPhotocopier;
      this.space=1;
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
      this.space=1;
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
      this.space=3;
      break;
    case FURNMICROWAVE:  
      this.name="Oven";
      this.image=furnMicrowave;
      this.space=1;
      break;
    case FURNDRAWER:
      this.name="Drawers";
      this.image=furnDrawer;
      this.space=2;
      break;
    case FURNWC:
      this.name=""+""+WCFunnyNames[int(random(WCFunnyNames.length))];
      this.image=furnWC;
      /* Oh, so NASTY!*/
      this.space=1;
      break;
    case FURNTAP:  
      this.name="Tap";
      this.image=furnTap;
      break;
    case FURNLABTABLE:
      this.name="Table";
      this.image= furnLabTable;
      this.space=2;
      break;
    case FURNMICROSCOPE:
      this.name="Microscope";
      this.image=furnMicroscope;
      /* Special. If I implement a microfilm, I will put it here */
      break;
    case FURNLAMP:
      this.name="Lamp";
      this.image=furnLamp;
      /* Special. If I implement the invisible ink message, I will use this */
      break;
    case FURNMIRROR:
      this.name="Mirror, mirror";
      this.image=furnMirror;
      /*   Special. Maybe I implement a secret mirror message,
       such as releasing a password when there is a message on mirror 
       */
      break;
    case FURNINVENTORY:
      this.name="Inventory";
      /* does not have an image */
      this.space=8;
      break;
    }
    this.items=new Item[0];
    for (int f=0; f<space; f++) {
      this.items=(Item[]) append(this.items, empty_space);
    }
  }
  /* Move item FROM this furniture TO another Furniture (or inventory) */
  int moveItem(int itemNum, Furniture dest) {
    int returnvalue;
    if (dest.space>0) {
      if (dest.items!=null && this.items!=null) {
        Item tmpItem=this.items[itemNum];
        returnvalue=dest.receiveItem(tmpItem);
        if (returnvalue==-1) {
          /* destination furniture can't receive item. CANCEL */
          return -1;
        } else { 
          /* Everything OK. Replace items array and increase space */
          this.space++;
          this.items[itemNum]=empty_space;
          return returnvalue;
        }
      }
    }
    return -1;
  }
  int receiveItem(Item item) {
    /* Process item reception */
    if (this.space<=0) return -1;

    if (this.locked) {
      if (item.isKey && (item.keynum==this.keynum)) {
        this.locked=false;
      } else {
        return -1;
      }
    }

    if (this.password) {
      if (item.isPassword && (item.passnum==this.passnum)) {
        this.password=false;
      } else {
        return -1;
      }
    } else { 
      return -1;
    }

    /* Test special furniture */
    switch(this.ftype) {
    case FURNPC:
      if (item.itype!=ITEMDISKETTEPCOLD ) return -1;
      break;
    case FURNMAC:
      if (item.itype!=ITEMDISKETTEMAC) return -1;
      break;
    case FURNCOPIER:
      if (item.itype!=ITEMMAP &&  item.itype!= ITEMPASSWORD && item.itype!=ITEMPAPER ) {
        return -1;
      }
      break;
    }  

    /* Ok Special furniture tested. Do special action */
    switch (this.ftype) {
    case FURNPC:
      /* My idea is giving a clue, as "MAP is on"... */
      break;
    case FURNMAC:
      /* My idea is choosing a random COPIER and printing a map on that */
      MacDialogStatus=MACHAPPYTHENPRINT;
      dialognum=DIALOG_MAC;
      status=status | STATUSDIALOG;
      if (insertAtRandomFurn(dst[f], ITEMMAP)==null) {
        MacDialogStatus=MACCOULDNTPRINT;
      }


      break;
    case FURNCOPIER:
      switch  (int (random(10))) {
      case 0:
        tmpDialog("PAPER JAM");
        break;
      case 1:
        tmpDialog("There was a paper on print queue ");
        /* EXPAND -- Print a random MAP, CLUE or PASSWORD */
        break;
      case 2:
        tmpDialog("NO TONER");
        break;
      default:
        addToItemArray(item);

        break;
      }
      break;
    }
    return 0;
  }
  /*
  Añadir un objeto a la matriz de objetos.
   Este método se llama solo:
   a) desde ReceiveItem
   b) Al crear el mapa.
   */

  void addToItemArray(Item item) {
    /*
    Se asume que ReceiveItem ha comprobado el espacio. 
     Si el espacio es insuficiente, es que nos llaman desde
     las rutinas de creación de mapa
     */
    if (this.space==0) this.space++;
    if (this.items==null) {
      /* Si la matriz es nula, crear una nueva matriz */
      /* 
       SE SUPONE QUE ESTO NO DEBERÍA SER NECESARIO 
       (La matriz se genera al crear el mueble)
       */
      this.items=new Item[space];
      items[0]=item;
      for (int f=1; f<this.items.length; f++) {
        items[f]=empty_space;
      }
    } else {
      boolean success=false;
      for (int f=0; f<this.items.length; f++) {
        if (this.items[f]==null || this.items[f].itype==ITEMEMPTY) {
          this.items[f]=item;
          success=true;
          break;
        }
      }
      if (success!=true) {
        Item[] it=(Item[])append(this.items, item.copy());
        this.items=it;
      }
    }
  }
  /* Check if Furniture contains selected item */
  boolean containsItem(int itype) {
    if (this.items==null) return false;
    for (int f=0; f<this.items.length; f++) {
      if ((this.items[f]!=null) &&  (this.items[f].itype==itype) ) {
        return true;
      }
    }
    return false;
  }
  boolean containsKey(int keyNumber) {
    if (this.items==null) return false;
    for (int f=0; f<this.items.length; f++) {
      if ((this.items[f]!=null) &&  (this.items[f].itype==ITEMKEY) ) {
        if (items[f].keynum==keyNumber) return true;
      }
    }
    return false;
  }
  boolean containsPassword(int passwordNumber) {
    if (this.items==null) return false;
    for (int f=0; f<this.items.length; f++) {
      if ((this.items[f]!=null) &&  (this.items[f].itype==ITEMPASSWORD) ) {
        if (items[f].passnum==passwordNumber) return true;
      }
    }
    return false;
  }
  int draw(){
    NokiaScreen.pushStyle();
    NokiaScreen.fill(255);
    NokiaScreen.stroke(0);
    NokiaScreen.strokeWeight(0);
    rect(0,0,83,47);
    String nom=this.name;
    if (nom.length()>11) nom=nom.substring(0,9);
    outString(nom,4,4,1);
    NokiaScreen.popStyle();        
    if (this.items==null){
        centerString("Not allowed",20,44);    
    } else {
      for (int f=0; f<items.length;f++){
        image(this.items[f].image,f % 5,int(f/5));
      }
    }
  };
};
