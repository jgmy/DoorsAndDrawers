/* Inventory screen scrolling */
int inventoryScroll=0;
int ACTIONHAND=0,ACTIONEYE=1,ACTIONINVENTORY=1024;
int currentAction=0;   
int [] actions={ACTIONHAND,ACTIONEYE,ACTIONINVENTORY};
// This assumes NokiaScreen.beginDraw() has been called.
String scrollDRtx="";
int scrollDRi=0;
void drawRoom() {
  Room currentRoom=piso[myFloor][myRoom];
  Furniture furn;

  piso[myFloor][myRoom].show();
    NokiaScreen.image(sprHand,0,32);
  NokiaScreen.image(sprEye,16,32);
  NokiaScreen.image(itemBackpack,32,32);

  if ((currentAction & ACTIONINVENTORY)==0){
    NokiaScreen.image(actionSprites[currentAction], myX*16, myY*16);
  }else{
    if(itemSprite==null) {
      itemSprite=actionSprites[0].copy();
    }
    NokiaScreen.image(itemSprite, myX*16, myY*16);
  }
  if (myY<2) {
    if (currentRoom.safeGetFurn(myX, myY)!=FURNINVALID) {
      //println("safeGetFurn: "+currentRoom.safeGetFurn(myX, myY) );
      furn=currentRoom.safeGetFurnObject(myX, myY);
      //println("("+myX+","+myY+":"+furn.name);
      /*begin show name*/
      if (furn.name!=null) {
        //println("name is not null");
        if (scrollDRtx.equals(furn.name)) {
          //println("Name has not changed, scroll");
          if (scrollDRtx.length()>(84/7)) {
            //println("scroll is",scrollDRi);
            scrollDRi=(++scrollDRi % (70*scrollDRtx.length()));
          }
        } else {
          //println("Name has changed, load it");
          scrollDRtx=furn.name;
          scrollDRi=0;
        }
      } 
      /*end show name */
    } else {
      /* invalid furn */
      scrollDRtx="";
      scrollDRi=0;
    } /* end check for invalid furn*/
    
    /* SHOW ICONS HERE */
     
     /*
      for (int f=0; f<inventory.items.length; f++) {
        Item object=inventory.items[f];
        if (inventory.items[f]!=null) {
          image(inventory.items[f].image, (3+f)*16, 32);
        }
      }
    */
    
    /* Scroll on bottom when myY<2 */
    outString(scrollDRtx, -scrollDRi/10, 32, 0);
    if (scrollDRi>0) {
      outString(scrollDRtx, (scrollDRtx.length()+1)*7-(scrollDRi)/10, 32, 0);
    }
  }
}
Furniture seekedFurniture;
void drawInventory(){
 seekedFurniture.draw(); 
}
