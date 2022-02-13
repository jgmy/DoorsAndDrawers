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
final int FURNCOPIER=11;
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
/* LAST ADDED */
final int FURNMICROSCOPE=22;
final int FURNLABTABLE=23;
final int FURNLAMP=24;
final int FURNMIRROR=25;
final int FURNINVENTORY=99;
int filesLoaded=0; /* number of files loaded */
final int ITEMEMPTY=0;
final int ITEMBACKPACK = 1;
final int ITEMPEN = 2;
final int ITEMCLIP = 3;
final int ITEMCUP = 4;
final int ITEMDISKETTEMAC = 5;
final int ITEMDISKETTEPCOLD = 6;
final int ITEMENVELOPE = 7;
final int ITEMCLOCK=8;
final int ITEMGASMASK = 9;
final int ITEMKEY=10;
final int ITEMMAP=11;
final int ITEMPASSWORD=12;
final int ITEMJAR=13;
final int ITEMJARCLIP=14;
final int ITEMJARCOFFEE=15;
final int ITEMPAPER = 16;
final int ITEMTORCH = 17;
final int ITEMDIAMOND=18;
final int ITEMBOOK=19;
final int ITEMCUPCOFFEE=20;
final int ITEMHINT=30;
final int ITEMFURNITURE=40;
final int ITEMTOILETPAPER=21;
final int ITEMSECRETRECIPE=100;
final int HLOBBY=0;
final int HOFFICE=1;
final int HKITCHEN=2;
final int HTOILET=3;
final int HSTAIRS=4;
final int HOFFICELAB=5;
final int HOFFICEBOSS=6;
final int HOFFICEREPRO=7;
final int HSELF=99;
final int[] MICROWAVEorCOFFEE={FURNMICROWAVE, FURNCOFFEE};
final int[] DRAWERorCABINET={FURNDRAWER, FURNCABINET};
final int[] DRAWERorCABINETorSAFE={FURNDRAWER, FURNCABINET, FURNSAFE, FURNFAKEFRAME};
final int[] SOLIDBOTTOM={FURNDRAWER, FURNCABINET, FURNSAFE, 
  FURNFAKEFRAME, FURNTABLE, FURNLABTABLE};
final int[] SOLIDBOTTOMEXTRA={FURNDRAWER, FURNCABINET, FURNSAFE, 
  FURNFAKEFRAME, FURNTABLE, FURNLABTABLE, FURNBOOKCASE};
final int[] UNDERDRAWER={FURNCABINET, FURNFAKEFRAME, FURNSAFE, FURNDRAWER};
final int[] PCorMAC={FURNPC, FURNMAC};
final int[] UNDERSCOPE={FURNCABINET, FURNDRAWER, FURNBOOKCASE};

int[] distribucion={HLOBBY, 
  HOFFICE, HOFFICE, HOFFICE, HOFFICE, 
  HOFFICE, HKITCHEN, HTOILET};
  
IntList dist;

final String[] labFridgeNames={
  "Fresh blood", "Don't open", 
  "Biohazard", "Corpses"
};
final String[]  WCFunnyNames={
  "WC", "seat", "A Throne of Games", 
  "poopatorium", "oval office", "commode"
};
final String[] passwordNames={ 
  "1234", "admin", "7-7-1977", "TWOPIR", "john", "smith", "0000", "PAELLA", "Kandinsky", "3110"
};
final String[] bookNames={
  "Malleus Maleficarum", 
    "MSDXS User's Guide", 
  "Z-80 Assembler",
  "1081 cooking recipes",
  "A history of two Cities",
  "Cthulhu miths for dumm13s",
  "Madrid phone guide A-L",
  "Madrid phone guide M-Z",
  "Don Quixote",
  "Hack your ZX-Spectrum"
};
/* Item distribution lists */
final int[] forCabinet= { ITEMGASMASK,1,ITEMMAP,5,ITEMTORCH,5,ITEMCUP,10,ITEMDISKETTEMAC,20,ITEMDISKETTEPCOLD,20};
final int[] forDrawer= {ITEMCLOCK,-5,ITEMHINT,1,ITEMMAP,5,ITEMGASMASK,5,ITEMTORCH,5,ITEMDISKETTEMAC,5,ITEMDISKETTEPCOLD,5};
final int[] forShelf= { ITEMCUP,10,ITEMJARCLIP,5,ITEMJAR,10,ITEMDISKETTEMAC,10,ITEMDISKETTEPCOLD,10};
final int[] forBookcase=  { ITEMPASSWORD,5, ITEMBOOK, 10,ITEMJAR,10 };
final int[] forWardrobe= {ITEMGASMASK,5,ITEMTORCH,5,ITEMJAR,10};
final int[] forFrame= {ITEMHINT,5,ITEMPASSWORD,5};
final int[] forCopier= {ITEMHINT,1,ITEMPASSWORD,3,ITEMMAP,5};  
final int[] forBigfile= {ITEMPASSWORD,5,ITEMHINT,5,ITEMMAP,5,ITEMDISKETTEPCOLD,5,ITEMDISKETTEMAC,5,ITEMPAPER,20,ITEMENVELOPE,10};
final int[] forTable=  { ITEMPASSWORD,1, ITEMCLIP, 5,ITEMPAPER,5,ITEMDISKETTEPCOLD,5,ITEMDISKETTEMAC,5 };
final int[] forCoffeetable={ITEMENVELOPE,1,ITEMCLIP,5,ITEMCUP,5};
final int[] forCoffee={ITEMJARCOFFEE,5,ITEMCUP,5};
final int[] forFridge={ITEMJARCOFFEE,5,ITEMJAR,20};
final int[] forMicrowave={ITEMJAR,5};
final int[] forWC={ITEMHINT,1,ITEMTOILETPAPER,60};
//Negative on first item means "only if locked"
