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
  for (int f=0; f<4; f+=2) {
    NokiaScreen.rect(8+f, 8+f, 84-f, 48-f);
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
  switch(status){
    case STATUSFLOOR:
      storeFloorX=myX; 
      break;
    case STATUSROOM:
      storeRoomX=myX;
      storeRoomY=myY;
  }
  status=status|STATUSDIALOG;
  
}
