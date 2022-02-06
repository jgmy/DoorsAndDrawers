PImage Font;
final String stripOrder=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
  "abcdefghijklmnopqrstuvwxyz"+
  "0123456789 $€£¥¤+-*/=%\""+
  "'#@&_(),.;:?!\\|{}<>[]'^~";
HashMap<String,PImage> pixelFont;

void createPixelFont(){
  String caracter;
  PImage FFont;
  //String path=dataPath(File.separator)+File.separator+"assets_fonts"+File.separator;
  String path="";
  FFont=loadImage(path+"nokia_font_dark_strip.png");
  println(path+"nokia_font_dark_strip.png");
  Font=addAlpha(FFont);
 // println( stripOrder);
  pixelFont=new HashMap<String,PImage>();  

  for (int f=0;f<stripOrder.length();f++){
    caracter=stripOrder.substring(f,f+1);
    if (caracter!=null){
      pixelFont.put(caracter,Font.get(f*7,0,7,8));
    //DEBUG:
    //  image(Font.get(f*7,0,7,8),0,f*8);
    }
    
  }
}

int outString(String str, float x, float y, int spacing){
 PImage tempImg;
 int myspacing=7+spacing;
  if (pixelFont==null) return(-1);
  for (int f=0;f< str.length(); f++){
    if ((tempImg=pixelFont.get(str.substring(f,f+1)))==null){
      //return -1;
      println("error: tempImg is null");
      
    } else {
      NokiaScreen.image(tempImg,x+f*myspacing,y);
      
    }
 
  } 
 return 0; 
}
int outString(String str,float x, float y){
 return outString( str, x,  y,1);
}

void centerString(String str,float cx, float y){
  centerString(str,cx,y,1);
}

void centerString(String str,float cx, float y,int spacing){
PImage tempImg;
int w=str.length()*(7+spacing);
 int x=int(cx-w/2);
  if (pixelFont==null) return;
  for (int f=0;f< str.length(); f++){
    if ((tempImg=pixelFont.get(str.substring(f,f+1)))==null){
     
      println("error: tempImg is null");
      
    } else {
      NokiaScreen.image(tempImg,x+f*(7+spacing),y);
    }
  } 
}


/* Creates a PImage copy with alpha outline added */
PImage addAlpha(PImage img){
 final int FILLALPHA=0xff000000;
   PImage rImage=img.get(0,0,img.width,img.height);

  img.loadPixels();
  rImage.loadPixels();
  for (int fx=0;fx<img.width;fx++){
     for (int fy=0;fy<img.height;fy++){
      int px=img.pixels[fx+fy*img.width];
      if (
          (((px>>24) & 0xff )>0) &&
          (((px | (px >>8) | (px>> 16)) & 0xff) <0x80) ){
        // Si un pixel < 80, entonces, los 4 de alrededor se
        // llenan con blanco y alpha denso.
        for (int ffx=max(fx-1,0);ffx<min(fx+2,img.width);ffx++){
          for (int ffy=max(fy-1,0);ffy<min(fy+2,img.height);ffy++){
            if ((img.pixels[ffx+ffy*img.width] & FILLALPHA)==0){
                 rImage.pixels[ffx+ffy*img.width]=0xffffffff;
            }
          }
        }
      }
     }
  }
  img.updatePixels();
  rImage.updatePixels();
  return rImage;
}
