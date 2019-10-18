import processing.svg.*;
String[] FILENAME=new String[5];
String[] input_files=new String[5];
PShape[] input = new PShape[5];
PShape[] layer = new PShape[5];    //Layer of Elements
PShape[] TLayer = new PShape[5];  //Layer of Tiles
PShape TBG;  //Tile Background
int[][] grid={{100,100,0},
              {100,500,0},
              {100,900,0},
              {750,100,0},
              {750,500,0},
              {750,900,0},
              {1400,100,0},
              {1400,500,0},
              {1400,900,0}};
int[] rot_fix={-135,-90,-45,0,45,90,135,180};
float[] Sf=new float[5]; //Scale factor
color[] LAYER_COLORS=new color[5]; 
int[] used_grid={11,11,11,11,11};  //init values bc no 0
float[][] props=new float[45][5];  //1st D: child in order of lid id; 2nd Properties: Cx, Cy, rot, Sx, Sy (all except Sx, Sy must be converted to int)
int[][] Tsize=new int[5][2];  //tile sizes
int[] TBGsize=new int[2];
color TBGcol;
int lamt, tmp, c1, c2, c3, exp;  //layer amount; temporary var; counter for used grid; counter for props cid list; layer counter; export counter

void setup() {
  //USER ENTRY REQUIRED
  FILENAME[0]="test_03.svg";  //svg filename e.g. "test.svg"
  FILENAME[1]="test_02.svg";
  FILENAME[2]="test_01.svg";
  FILENAME[3]="";
  FILENAME[4]="";
  
  Sf[0]=1.0;    //Scale factor for Layers
  Sf[1]=1.0;
  Sf[2]=2.0;
  Sf[3]=1.0;
  Sf[4]=1.0;
  
  Tsize[0][0]=100;  //Layer 01 Tile Width
  Tsize[0][1]=20;  //Layer 01 Tile Height
  
  Tsize[1][0]=40;  //Layer 02 Tile Width
  Tsize[1][1]=60;  //Layer 02 Tile Height
  
  Tsize[2][0]=30;  //...03 W
  Tsize[2][1]=30;  //...03 H
  
  Tsize[3][0]=50;  //...04 W
  Tsize[3][1]=10;  //...04 H
  
  Tsize[4][0]=50;  //...05 W
  Tsize[4][1]=10;  //...05 H
  
  TBGsize[0]=60;    //BG W
  TBGsize[1]=60;    //BG H
  
  LAYER_COLORS[0]=color(255, 255, 0); //Color for Layer 01
  LAYER_COLORS[1]=color(220, 0, 0); //Color for Layer 02
  LAYER_COLORS[2]=color(10, 100, 160); //...03
  LAYER_COLORS[3]=color(0, 200, 0); //...04
  LAYER_COLORS[4]=color(0, 255, 255);   //...05
  TBGcol=color(200,200,200);  //Background Color
  
  
  for (int i=0; i<5; i++) {
    if (FILENAME[i]==""){
      lamt=i-1;
      break;
    }
    layer[i]=createShape(GROUP);
    input[i]=loadShape(FILENAME[i]);
  }
  background(0);
  size(1500, 1000);
  startScreen();
}

void draw() {
  if (millis() < 100) ((java.awt.Canvas) surface.getNative()).requestFocus();
}

void startScreen(){
  textAlign(CENTER,CENTER);
  textSize(50);
  text("LocalMosaicGenerator",750,300);
  rectMode(CENTER);
  stroke(255);
  fill(0);
  rect(600,400,50,50);  //Right Arrow
    beginShape();
    vertex(590,390);
    vertex(590,410);
    vertex(610,400);
    endShape(CLOSE);
  rect(565,475,50,50);  //Up Arrow
    beginShape();
    vertex(555,485);
    vertex(575,485);
    vertex(565,465);
    endShape(CLOSE);
  rect(635,475,50,50);  //Down Arrow
    beginShape();
    vertex(625,465);
    vertex(645,465);
    vertex(635,485);
    endShape(CLOSE);
  rect(600,550,50,50);  //Left Arrow
    beginShape();
    vertex(610,540);
    vertex(610,560);
    vertex(590,550);
    endShape(CLOSE);
  beginShape();  //Enter
  vertex(555,600);
  vertex(645,600);
  vertex(645,730);
  vertex(575,730);
  vertex(575,665);
  vertex(555,665);
  endShape(CLOSE);
  beginShape();
  vertex(590,620);
  vertex(590,640);
  vertex(570,630);
  endShape(CLOSE);
  beginShape();
  vertex(590,630);
  vertex(620,630);
  vertex(620,620);
  endShape(LINES);
  rect(600,780,50,50);  //s
  
}

void init(){
      clear();
      background(TBGcol);
      c1=0;
      c2=0;
      c3=0;
      
      for (int i=0; i<=lamt;i++){
        tmp=int(random(11));
        for (int p=0;p<5;p++){
          if (tmp==used_grid[p]){
            tmp=int(random(11));
            p=0;
          }
        }
        for(int p=layer[i].getChildCount();p!=0;p--){
          layer[i].removeChild(p);
        }
        
        gridPos(i,tmp);
      }  
}

void keyPressed(){
  if (key==CODED) {
    if (keyCode==RIGHT){
      init();
    } else if (keyCode==UP){
      if (c3<lamt) c3++;
      draw_layer(c3,1);
    } else if (keyCode==DOWN){
      if (c3>0) c3--;
      draw_layer(c3,1);
    } else if (keyCode==LEFT){
      for (int i=0; i<=lamt; i++){
        draw_layer(i,0);  
      }
    }
  }
  if (keyCode==ENTER){
    TBG=createShape(GROUP);
    tiling(TBGsize[0],TBGsize[1],9,int(random(3)),random(0.5));
    for (int lid=0;lid<=lamt;lid++){
      TLayer[lid]=createShape(GROUP);
      draw_layer(lid,1);
      tiling(Tsize[lid][0],Tsize[lid][1],lid,int(random(3)),random(0.5));
    }
    clear();
    for (int u=0;u<=TBG.getChildCount()-2;u++){
      PShape temp=TBG.getChild(u);
      temp.setStroke(0);
      temp.setFill(TBGcol);
      shape(temp);
    }
    for (int lid=0;lid<=lamt;lid++){
      for (int u=0;u<=TLayer[lid].getChildCount()-2;u++){
        PShape temp=TLayer[lid].getChild(u);
        temp.setStroke(0);
        temp.setFill(LAYER_COLORS[lid]);
        shape(temp);
      } 
    }
  }
  if (key=='s' || key=='S'){
    //SVG
    clear();
    beginRecord(SVG, "out_"+exp+"_BG.svg");
      drawShape(TBG,0);
      drawShape(TBG,1);
      for (int i=0;i<=lamt;i++){
        drawShape(TLayer[i],2);
      }
    endRecord();
    for(int s=0;s<=lamt;s++){
      clear();
      beginRecord(SVG, "out_"+exp+"_L"+s+".svg");
        stroke(color(255,0,0));
        strokeWeight(2);
        noFill();
        rectMode(CENTER);
        rect(750,500,1499,99);
        drawShape(TLayer[s],0);
        drawShape(TLayer[s],1);
        for (int i=s+1;i<=lamt;i++){
          drawShape(TLayer[i],0);
        }
      endRecord();
    }
    //PNG
    clear();
    drawShape(TBG,0);
    stroke(color(255,0,0));
    strokeWeight(2);
    noFill();
    rect(750,500,1499,999);
    rectMode(CENTER);
    save("out_"+exp+"_BG_c.png");
    clear();
    drawShape(TBG,1);
    for (int i=0;i<=lamt;i++){
      drawShape(TLayer[i],2);
    }
    save("out_"+exp+"_BG_e.png");
    
    for(int s=0;s<=lamt;s++){
      clear();
      drawShape(TLayer[s],1);
      save("out_"+exp+"_L"+s+"_e.png");
      clear();
      drawShape(TLayer[s],0);
      for (int i=s+1;i<=lamt;i++){
        drawShape(TLayer[i],0); //<>//
      }
      stroke(color(255,0,0));
      strokeWeight(2);
      noFill();
      rectMode(CENTER);
      rect(750,500,1499,999);
      save("out_"+exp+"_L"+s+"_c.png");
    }
    exp++;
  }
}

void drawShape(PShape shp, int CorE){
  for (int u=0;u<=shp.getChildCount()-2;u++){
    PShape temp=shp.getChild(u);
    if (CorE==0){
      temp.setStroke(color(255,0,0));
      temp.setFill(color(255,0,0));
    } else if(CorE==1){
      temp.setStroke(color(0,0,255));
      temp.setFill(color(0,0,0));
    } else if (CorE==2){
      temp.setStroke(color(0,0,255));
      temp.setFill(color(0,0,255));
    }
    shape(temp);
  }   
}

void tiling(int TsizeX, int TsizeY,int lid, int seed_pat, float Srand){  //Cut or Engraved
  int pt_zero_X=TsizeX/2,pt_zero_Y=TsizeY/2, TCx=0,TCy=0; 
  int seed_col=int(random(3));
  int tmpX=0,tmpY=0;
  
  TsizeX=int(TsizeX*(0.75+Srand));
  TsizeY=int(TsizeY*(0.75+Srand));
  
  for (int TPy=0;TPy<=height/TsizeY;TPy++){
    for (int TPx=0;TPx<=width/TsizeX;TPx++){
      switch(seed_pat){
        case 0:
          if (TPy % 2 ==1){
            TCx=(TsizeX*TPx);
          } else {
            TCx=pt_zero_X+(TsizeX*TPx);
          }
          break;
        case 1:
          TCx=pt_zero_X+(TsizeX*TPx);
          break;
        case 2:
          if (TPy % 4 ==0){
            TCx=(TsizeX*TPx);
          } else if (TPy % 4 ==1){
            TCx=(TsizeX/4)+(TsizeX*TPx);
          } else if (TPy % 4 ==2){
            TCx=((TsizeX/4)*2)+(TsizeX*TPx);
          } else if (TPy % 4 ==3){
            TCx=((TsizeX/4)*3)+(TsizeX*TPx);
          }
          break;
      }
      
      //if (TPx % 2 ==1){
      //  TCy=(Tsize[lid][1]*TPy);
      //} else {
      //  TCy=pt_zero_Y+(Tsize[lid][1]*TPy);
      //}
      TCy=pt_zero_Y+(TsizeY*TPy);
      if (lid!=9){
        if (isColor(TCx, TCy, seed_col,TsizeX,TsizeY)){
          tmpX=TCx;
          tmpY=TCy;
          drawRect(TsizeX,TsizeY,lid,TCx,TCy);
        }
      } else {
        drawRect(TsizeX,TsizeY,lid,TCx,TCy);
      }
    }
  }  
  drawRect(TsizeX,TsizeY,lid,tmpX,tmpY);
}

void drawRect(int TsizeX, int TsizeY,int lid,int TCx, int TCy){
  PShape tile;
  rectMode(CENTER);
  stroke(255);
  fill(color(0,0,0),255);
  tile=createShape(RECT,TCx,TCy,TsizeX,TsizeY);
  shape(tile);
  if (lid!=9){
    TLayer[lid].addChild(tile);
  } else {
    TBG.addChild(tile);  
  }
}

boolean isColor(int TCx, int TCy, int seed,int TsizeX, int TsizeY){
  int offX=0, offY=0;
  color col;  //get color for tiling
  switch (seed){
    case 0:
      offX=(TsizeX/2)-2;
      offY=(TsizeY/2)-2;
      break;
    case 1:
      offX=TsizeX/4;
      offY=TsizeY/4;;  
      break;
    case 2:
      offX=0;
      offY=0;
      break;
  }
  for (int p=-offX;p<=offX;p++){
    for (int q=-offY;q<=offY;q++){
      col=get(TCx+p,TCy+q);
      if (int(red(col))!=0 || int(green(col))!=0 || int(blue(col))!=0){
        return true;
      }
    }
  }
  return false;
}

void draw_layer(int lid, int solo){
  if (solo==1) clear();
  c2=0;
  int[] start=new int[5];
  start[0]=0;
  for (int i=1; i<=lamt; i++){
    start[i]=start[i-1]+layer[i-1].getChildCount()-1;
  }
  
  c2=start[lid];
  for (int x=0;x<=layer[lid].getChildCount()-2;x++){
    layer[lid].disableStyle();
    stroke(LAYER_COLORS[lid]);
    fill(LAYER_COLORS[lid]);
    pushMatrix();
    translate(int(props[c2][0]),int(props[c2][1]));
    shapeMode(CENTER);
    rotate(radians(int(props[c2][2])));
    scale(props[c2][3]*Sf[lid],props[c2][4]*Sf[lid]);
    shape(layer[lid].getChild(x),0,0);
    popMatrix();
    c2++;
  } 
}

void gridPos(int lid,int Pos){
  int rot=rot_fix[int(random(8))];
  float scl=0.5+random(2);
  switch(Pos){
    case 0:
      renderShape(lid,grid[0][0],grid[0][1],rot,scl,scl);
      renderShape(lid,grid[1][0],grid[1][1],rot,scl,scl);
      renderShape(lid,grid[2][0],grid[2][1],rot,scl,scl);
      renderShape(lid,grid[3][0],grid[3][1],rot,scl,scl);
      renderShape(lid,grid[4][0],grid[4][1],rot,scl,scl);
      renderShape(lid,grid[5][0],grid[5][1],rot,scl,scl);
      renderShape(lid,grid[6][0],grid[6][1],rot,scl,scl);
      renderShape(lid,grid[7][0],grid[7][1],rot,scl,scl);
      renderShape(lid,grid[8][0],grid[8][1],rot,scl,scl);
      used_grid[c1]=0;
      c1++;
      break;
    case 1:
      renderShape(lid,grid[0][0],grid[0][1],rot,scl,scl);
      renderShape(lid,grid[2][0],grid[2][1],180-rot,-scl,scl);
      renderShape(lid,grid[6][0],grid[6][1],-rot,-scl,scl);
      renderShape(lid,grid[8][0],grid[8][1],180+rot,scl,scl);
      used_grid[c1]=1;
      c1++;
      break;
    case 2:
      renderShape(lid,grid[1][0],grid[1][1],rot,scl,scl);
      renderShape(lid,grid[3][0],grid[3][1],rot,scl,scl);
      renderShape(lid,grid[5][0],grid[5][1],rot,scl,scl);
      renderShape(lid,grid[7][0],grid[7][1],rot,scl,scl);
      used_grid[c1]=2;
      c1++;
      break;
    case 3:
      renderShape(lid,grid[1][0],grid[1][1],rot,scl,scl);
      renderShape(lid,grid[4][0],grid[4][1],rot,scl,scl);
      renderShape(lid,grid[7][0],grid[7][1],rot,scl,scl);
      used_grid[c1]=3;
      c1++;
      break;
    case 4:
      renderShape(lid,grid[1][0],grid[1][1],rot,scl,scl);
      renderShape(lid,grid[7][0],grid[7][1],rot,-scl,-scl);
      used_grid[c1]=4;
      c1++;
      break;
    case 5:
      renderShape(lid,grid[3][0],grid[3][1],rot,scl,scl);
      renderShape(lid,grid[5][0],grid[5][1],rot,-scl,scl);
      used_grid[c1]=5;
      c1++;
      break;
    case 6:
      renderShape(lid,grid[0][0],grid[0][1],rot,scl,scl);
      renderShape(lid,grid[6][0],grid[6][1],-rot,-scl,scl);
      used_grid[c1]=6;
      c1++;
      break;
    case 7:
      renderShape(lid,grid[2][0],grid[2][1],rot,scl,scl);
      renderShape(lid,grid[8][0],grid[8][1],-rot,-scl,scl);
      used_grid[c1]=7;
      c1++;
      break;
    case 8:
      renderShape(lid,grid[3][0],grid[3][1],rot,scl,scl);
      used_grid[c1]=8;
      c1++;
      break;
    case 9:
      renderShape(lid,grid[4][0],grid[4][1],rot,scl,scl);
      used_grid[c1]=9;
      c1++;
      break;
    case 10:
      renderShape(lid,grid[5][0],grid[5][1],rot,scl,scl);
      used_grid[c1]=10;
      c1++;
      break;
  }
}

void renderShape(int lid, int Cx, int Cy, int rot,float Sx, float Sy){  //lid: layer id; Cx: X-Coordinate; Cy: Y-Coordinate of Grid Point; Rotation Random Int; Scale X & Y
  input[lid].disableStyle();
  stroke(LAYER_COLORS[lid]);
  fill(LAYER_COLORS[lid]);
  pushMatrix();
  translate(Cx,Cy);
  shapeMode(CENTER);
  rotate(radians(rot));
  scale(Sx * Sf[lid],Sy * Sf[lid]);
  shape(input[lid], 0, 0);
  props[c2][0]=float(Cx);
  props[c2][1]=float(Cy);
  props[c2][2]=float(rot);
  props[c2][3]=Sx;
  props[c2][4]=Sy;
  c2++;
  layer[lid].addChild(input[lid]);
  popMatrix();
}
