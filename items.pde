int nextKeynum=0;
int nextPassword=0;
int nextBook=0;

class Item {
  Furniture parent; /* parent furniture */
  public PImage image;
  public String name="";
  public int itype;
  public boolean isKey=false;
  public boolean isPassword=false;
  public int keynum=0;
  public int passnum=0;
  /* Complete constructor for cloning */
  Item(PImage image, String name, int itype, boolean isKey, boolean isPassword, int keynum, int passnum) {
    this.image=image;
    this.name=name;
    this.itype=itype;
    this.isKey=isKey;
    this.isPassword=isPassword;
    this.keynum=keynum;
    this.isPassword=isPassword;
    this.passnum=passnum;
  };
  Item(int itype) {
    this.itype=itype;
    this.isKey=false;
    this.isPassword=false;
    this.keynum=0;
    this.passnum=0;
    switch (itype) {
    case ITEMEMPTY:
      this.image=emptySpace;
      this.name="";
      break;
    case ITEMBACKPACK: 
      this.image=itemBackpack;
      this.name="Backpack";
      break;
    case ITEMPEN:
      this.image=itemPen;
      this.name="Ballpen";
      break;
    case ITEMCLIP:
      this.image=itemClip;
      this.name="Clip";
      break;
    case ITEMCUP:
      this.name="Cup";
      this.image=itemCup;
      break;
    case ITEMDISKETTEMAC: 
      this.name="3 1/2\" disk";
      this.image=itemDiskettemac;
      break;
    case ITEMDISKETTEPCOLD: 
      this.name="5 1/4\" disk";
      this.image=itemDiskettepcold;
      break;
    case ITEMENVELOPE: 
      this.image=itemEnvelope;
      this.name="envelope";
      break;
    case ITEMGASMASK: 
      this.image=itemGasMask;
      this.name="Gas mask";
      break;
    case ITEMKEY: 
      int rand=int(random(itemKey.size() ));
      this.image=itemKey.get(rand);
      this.isKey=true;
      this.keynum=nextKeynum++;
      break;
    case ITEMMAP: 
      this.image=itemMap;
      this.name="Map";
      break;
    case ITEMPASSWORD:
      this.image=itemPaper;
      this.isPassword=true;
      this.passnum=nextPassword++;
      this.name=passwordNames[this.passnum % passwordNames.length];
      break;
    case ITEMPAPER: 
      this.image=itemPaper;
      this.name="Paper";
      break;
    case ITEMTORCH: 
      this.image=itemTorch;
      this.name="Torch";
      break;
    case ITEMBOOK: 
      this.name=bookNames[(nextBook++) % bookNames.length];
      this.image=itemBook;
      break;
    case ITEMFURNITURE: 
      this.name="Fake item for Furniture usage";
      this.image=furnWC;
      break;
    case ITEMSECRETRECIPE: 
      this.name="Secret Paella Recipe";
      this.image=itemPaper;
      break;
    }
  }
  Item copy() {
    return new Item(this.image, this.name, this.itype, this.isKey, this.isPassword, this.keynum, this.passnum);
  }
};
