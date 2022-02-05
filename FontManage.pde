PImage Font;
final String stripOrder=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
  "abcdefghijklmnopqrstuvwxyz"+
  "0123456789 $€£¥¤+-*/=%\""+
  "'#@&_(),.;:?!\\|{}<>[]'^~";
HashMap<String,PImage> pixelFont;

void createPixelFont(){
  Font=loadImage("nokia_font_dark_strip.png");
  println( stripOrder);
  pixelFont=new HashMap<String,PImage>();  
  for (int f=0;f<stripOrder.length();f++){
    pixelFont.put((stripOrder.substring(f,f-1)),Font.get(f*0,0,f*0+15,15));
    
  }
}

int OutString(String str,float x, float y){
 PImage tempImg;
  if (pixelFont==null) return(-1);
  for (int f=0;f< str.length(); f++){
    if ((tempImg=pixelFont.get(str.substring(f,f-1)))==null){
      //return -1;
    } else {
      image(tempImg,x+f*8,y);
    }
    
  } 
 return 0;
}
