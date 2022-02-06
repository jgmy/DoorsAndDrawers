/* Draws a Dialog Screen */
void dialog(){
  NokiaScreen.pushStyle();
  NokiaScreen.fill(255);
  NokiaScreen.stroke(0);
  NokiaScreen.rectMode(CORNERS);
  for (int a=10; a<13;a+=2){
    NokiaScreen.rect(a,a,84-a,48-a);
  }
    outString("Exit?",14,14,0);
    outString("Yes",14,14+10,0);
    outString("No",84-(12+16),14+10,0);
    NokiaScreen.blendMode(DIFFERENCE);
    if (myX==0){
      NokiaScreen.rect(13,13+10,13+21,13+19);
    } else {
      NokiaScreen.rect(84-(12+16),13+10,84-13,13+19);
    }
    NokiaScreen.blendMode(REPLACE);
  NokiaScreen.popStyle();
}
