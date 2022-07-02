/* Draws a Dialog Screen */
void dialogExitConfirm() {
  NokiaScreen.pushStyle();
  NokiaScreen.fill(255);
  NokiaScreen.stroke(0);
  NokiaScreen.rectMode(CORNERS);
  for (int a=10; a<13; a+=2) {
    NokiaScreen.rect(a, a, 84-a, 48-a);
  }
  outString("Exit?", 14, 14, 0);
  outString("Yes", 14, 14+10, 0);
  outString("No", 84-(12+16), 14+10, 0);
  NokiaScreen.blendMode(DIFFERENCE);
  if (myX==0) {
    NokiaScreen.rect(13, 13+10, 13+21, 13+19);
  } else {
    NokiaScreen.rect(84-(12+16), 13+10, 84-13, 13+19);
  }
  NokiaScreen.blendMode(REPLACE);
  NokiaScreen.popStyle();
}

String MessageDialog="";

void dialogMessage() {
  final int textSpace=(48-16)/7;
  NokiaScreen.pushStyle();
  NokiaScreen.fill(255);
  NokiaScreen.stroke(0);
  NokiaScreen.rectMode(CORNERS);
  for (int f=0; f<4; f+=2) {
    NokiaScreen.rect(8+f, 8+f, 83-f, 47-f);
  }
  String words[]=split(MessageDialog, " ");
  String line="";
  int y=8;
  for (int f=0; f<words.length; f++) {  
    if ((line.length()+words[f].length())<textSpace) {
      line+=words[f];
    } else {
      centerString(line, 42, y, 0);
      y+=8;
      line="";
    }
  }

  centerString(line, 42, y, 0);
  NokiaScreen.popStyle();
}

/* Temporary OK dialog. 
  This triggers DialogMessage
  after setting the right values.
*/
void tmpDialog(String str){
  MessageDialog=str;
  dialognum=DIALOG_INFO;
  switch(status){
    case STATUSFLOOR:
      storeFloorX=myX; 
      break;
    case STATUSROOM:
      storeRoomX=myX;
      storeRoomY=myY;
      break;
    case STATUSINVENTORY:
      storeRoomX=myX;
      storeRoomY=myY;
      break;
}
  status=status|STATUSDIALOG;
  
}
int MacLastFrame=0;
int MacDialogStatus;
final int MACHAPPYTHENPRINT=1;
final int MACPRINT=2;
final int MACHAPPY=0;
final int MACBLANK=3;
final int MACSAD=4;
final int MACCOULDNTPRINT=5;
void macDialog(){
  waitKeyAny=true;
  if (MacLastFrame==0) MacLastFrame=frameCount;
  switch (MacDialogStatus){
    case MACHAPPYTHENPRINT:
      NokiaScreen.image(GUIhappy,0,0);
      if ((frameCount-MacLastFrame)>10*15){
        MacDialogStatus=MACPRINT;
        MacLastFrame=frameCount;
      }
      break;
    case MACPRINT:
      NokiaScreen.image(GUIprint,0,0);
      break;
    case MACBLANK:
      NokiaScreen.image(GUIwindow,0,0);
      centerString("PASSWORD?",42,24);
      if ((frameCount-MacLastFrame)>10*15){
        MacDialogStatus=MACSAD;
      }
      break;
    case MACSAD:
      NokiaScreen.image(GUIsad,0,0);
      break;
    case MACCOULDNTPRINT:
      NokiaScreen.image(GUIwindow,0,0);
      centerString("Printer",42,16,0);
      centerString("offline",42,24,0);
      if ((frameCount-MacLastFrame)>10*15) status=STATUSROOM;
      break;
  }
  if ((frameCount-MacLastFrame)>20*15) {
    MacLastFrame=0;
    status=STATUSROOM;
  }
    
  
}
