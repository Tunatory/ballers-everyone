import java.util.*; 

int FRAME_RATE = 24;
boolean USE_MASKS = false;
boolean WRITE_FRAMES = false;
boolean DRAW_SHADOWS = false;
boolean MOVE_CAMERA = false;
boolean DRAW_BG = true;
int BALL_COUNT = 5;
String filePath="";

int[] enterTimes = {
  4,
  4 + 32,
  4 + 32 + 32,
  4 + 32 + 32 + 32,
  4 + 32 * 6
};
int[] exitTimes = {
  20 + 32 * 8,
  20 + 32 * 5,
  20 + 32 * 4,
  20 + 32 * 3,
  20 + 32 * 8
};
color[] ballColors = {
  0xffff3388,
  0xff66ccff,
  0xff33ff99,
  0xffff99ff,
  0xffffff66
};
 
int[][] calculateNearPoints(PVector[] p, float maxd) {
  int[][] res=new int[p.length][0];
  for(int i=0; i<p.length; i++) {
    for(int j=0; j<p.length; j++) {
      if(PVector.dist(p[i],p[j])<maxd) {
        res[i]=append(res[i],j);
      }
    }
  }
  return res;
}

void calculateHolderLocations() {
  holderLocation=new PVector[defs.length];
  for(int i=0; i<defs.length; i++) {
    PVector hold=PVector.add(points[i],new PVector(defs[i].offX*.001,0));
    if(defs[i].hasWinnerHand) holderLocation[i]=PVector.add(hold,new PVector(0,0,0.4));
    else if(defs[i].armless) holderLocation[i]=PVector.add(hold,new PVector(0,0,(defs[i].bodyTop-defs[i].bodyY)*.001));
    else if(defs[i].hasString) holderLocation[i]=PVector.add(hold,new PVector(0,0,-(defs[i].bodyY-defs[i].bodyTop)*.001));
    else holderLocation[i]=hold;
  }
}

int[][] pointsNear;

PVector[] points;
PVector[] holderLocation;
float time;

PGraphics shade;

Ball[] balls;
CharHands[] charHands;
Char[] chars;

void setup() {
  size(1280,720,P2D);
  imageMode(CENTER);
  frameRate(FRAME_RATE);
  //frameRate(0.4);
  curveDetail(2);
  bezierDetail(3);

  points = generatePoints(
    new PVector(-6, -2.6), 
    new PVector(5, -4.8), 
    0.4402, 100, defs.length
    );/*
  points=new PVector[defs.length];
  for(int i=0; i<defs.length; i++) {
    points[i]=new PVector(0,-0.7).rotate(i*TAU/defs.length+0.2).add(0,0.2);
  }*/
  pointsNear=calculateNearPoints(points,1.5);
  calculateHolderLocations();
  shade = createGraphics(width/3, height/3);
  
  balls=new Ball[BALL_COUNT];
  for (int ballID = 0; ballID < BALL_COUNT; ballID++) {
    PImage ballBase = getImage(filePath+"img/ball-base.png");
    PImage ballSpec = getImage(filePath+"img/ball-spec.png");
    balls[ballID]=new Ball(ballID,ballBase,ballSpec);
  }
  charHands=new CharHands[defs.length];
  for (int i = 0; i < defs.length; i++) {
    float y = holderLocation[i].y;
    if(!defs[i].noArms) charHands[i]=new CharHands(i,y);
  }
  chars=new Char[defs.length];
  for (int i = 0; i < defs.length; i++) {
    CharDef def = defs[i];
    String path = filePath+"img/body/" + def.name;
    PImage img = getImage(path+".png");
    PImage maskImg=null;
    try { maskImg=getImage(path+"-mask.png"); }
    catch(IllegalArgumentException e)
    {
      images.put(path+"-mask.png",maskImg=img);
      maskImg.loadPixels();
    }
    float x = points[i].x;
    float y = points[i].y;

    chars[i]=new Char(i,def,img,maskImg,x,y);
  }
}

void draw() {
  int lastTime=millis();
  time=float(frameCount)/FRAME_RATE+1.8;//FRAME_RATE;
  //time=millis()/1000.-1;
  //USE_MASKS=!USE_MASKS;

  background(200);

  pushMatrix();
  translate(width/2.,height/2.);
  scale(height/4);
  
  if (MOVE_CAMERA) {
    PVector avgBallPos = new PVector();
    float totalWeight = 1;
    for (int i = 0; i < BALL_COUNT; i++) {
      float t = time - .2;
      float enterTime = passTime * enterTimes[Math.min(i, enterTimes.length - 1)];
      float weight = smoothstep(enterTime - passTime, enterTime, time);
      avgBallPos.add(ballApparentPos(t, ballPos(t, i), i).mult(weight));
      totalWeight += weight;
    }
    for (int i = 0; i < BALL_COUNT; i++) {
      float t = time - .5;
      float enterTime = passTime * enterTimes[Math.min(i, enterTimes.length - 1)];
      float weight = smoothstep(enterTime - passTime, enterTime, time);
      avgBallPos.add(ballApparentPos(t, ballPos(t, i), i).mult(weight));
      totalWeight += weight;
    }
    avgBallPos.mult(-.1 / totalWeight);
    translate(avgBallPos.x, avgBallPos.y);
  }
  
  if (DRAW_BG) {
    pushMatrix();
      scale(2.5 / height);
      PImage bg = getImage(filePath+"img/bg.png");
      image(bg, 0, 0, height * 2*bg.width/bg.height, height * 2);
    popMatrix();
  }

  strokeWeight(.005);
  //for (PVector p : points) {
  //  stroke(0);
  //  noFill();
  //  ellipse(p.x, p.y, .05, .05);
  //}

  ArrayList<Drawable> draws = new ArrayList<Drawable>();
  
  if (DRAW_SHADOWS) {/*
    draws.add(new Drawable() {
      public float getDepth() {
        return Float.NEGATIVE_INFINITY;
      }
      public void draw() {*/
        shade.beginDraw();
        shade.background(0);
        shade.noStroke();
        shade.fill(0xff2e1100);
        
        shade.pushMatrix();
        shade.translate(shade.width / 2., shade.height / 2.);
        shade.scale(shade.height / 4.);
        for (int i = 0; i < defs.length; i++) {
          //shade.pushMatrix();
          //shade.applyMatrix(charTransform(i));
          //PMatrix turny = charBodyTransform(time, i);
          //PVector center = turny.mult(new PVector(0, -100), null);
          if(!defs[i].noDraw) shade.ellipse(points[i].x, points[i].y, .4, .1);
          //shade.popMatrix();
        }
        
        for (int i = 0; i < BALL_COUNT; i++) {
          //shade.pushMatrix();
          
          PVector pos = ballPos(time, i);
          shade.ellipse(pos.x, pos.y, .2, .05);
          //shade.popMatrix();
        }
        
        shade.popMatrix();
        shade.endDraw();
        blendMode(SUBTRACT);
        
        //pushMatrix();
        //scale(4. / height);
        image(shade, 0, 0, width*4./height, 4);
        //popMatrix();
        blendMode(BLEND);/*
      }
    });*/
  }

  for (int ballID = 0; ballID < BALL_COUNT; ballID++) {
    draws.add(balls[ballID]);
  }
  for(int i=0; i<defs.length; i++) {
    if(!defs[i].noDraw) draws.add(chars[i]);
    if(!defs[i].noArms) draws.add(charHands[i]);
  }
  Collections.sort(draws);
  for (Drawable draw : draws) {
    draw.draw();
  }
  popMatrix();
  //if(frameCount==2) saveFrame("/storage/emulated/0/Stuff/renders/ballers.png");
  if (WRITE_FRAMES) {
    saveFrame("outloop/baller-"+nf(frameCount,4)+".jpg");
    println("Frame " + frameCount + " (" + ((float) frameCount / FRAME_RATE) + " sec)");
  }
  fill(0);
  textSize(20);
  textAlign(LEFT,TOP);
  text(frameRate+" FPS ("+(millis()-lastTime)+"ms)",5,5);
}