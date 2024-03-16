abstract class Drawable implements Comparable<Drawable> {
  abstract float getDepth();
  abstract void draw();

  int compareTo(Drawable other) {
    return this.getDepth() > other.getDepth() ? 1 : -1;
  }
}

class Ball extends Drawable
{
  int id;
  PVector apparentPos;
  PImage ballBase, ballSpec;

  Ball(int id, PImage ballBase, PImage ballSpec)
  {
    this.id=id;
    this.ballBase=ballBase;
    this.ballSpec=ballSpec;
  }

  float getDepth() {
    if(apparentPos==null) return 0;
    return apparentPos.z;
  }

  void draw() {
    /*
    //if (id < ballColors.length) {
      tint(ballColors[id]);
    } else {
      colorMode(HSB, 1);
      tint((id * 0.618033988749895 + .95) % 1, .8, 1);
      colorMode(RGB, 255);
    }*/
    //int beforeIndex = ballHolder(t - passTime, id);
    int fromIndex = ballHolder(time, id);
    int toIndex = ballHolder(time + passTime, id);
    //int afterIndex = ballHolder(t + passTime * 2, id);
    if(fromIndex<0&&toIndex<0) return;
    float oldTime = time - .5 / 24;
    PVector apparentPosOld = ballApparentPos(oldTime, ballPos(oldTime, id), id);
    apparentPos = ballApparentPos(time, ballPos(time,id), id);
    //PVector apparentPosStretch=PVector.sub(apparentPosOld,apparentPos).add(apparentPos);
    PMatrix tf = smearTransform(apparentPos, apparentPosOld, 3, .5);
    pushMatrix();
    translate(apparentPos.x, apparentPos.y);
    scale(0.001);
    applyMatrix(tf);
    tint(ballColors[id]);
    image(ballBase, 0, 0, 200, 200);
    noTint();
    image(ballSpec, 0, 0, 200, 200);
    popMatrix();
  }
}


class CharHands extends Drawable
{
  int fi;
  float y;

  CharHands(int fi, float y)
  {
    this.fi=fi;
    this.y=y;
  }

  float getDepth() { 
    return y + .02;
  }

  void draw() {
    PVector[] handPosns = chars[fi].handPosns;
    PVector[] handPosnsOld = handPosns(time - .5 / 24, fi);/*
    PVector[] handPosnsStretch={
      PVector.sub(handPosnsOld[0], handPosns[0]).add(handPosns[0]), 
      PVector.sub(handPosnsOld[1], handPosns[1]).add(handPosns[1])
    };*/
    noStroke();

    fill(0);
    drawSmearedEllipse(handPosns[0], handPosnsOld[0], .03, 1, 3);
    drawSmearedEllipse(handPosns[1], handPosnsOld[1], .03, 1, 3);
  }
}/*

 class WinnerFinger extends Drawable
 {
 int type;
 float y;
 
 WinnerFinger(int t, float y)
 {
 this.type=t;
 this.y=y;
 }
 
 float getDepth()
 {
 return y+(type<2? 0.02:-0.02);
 }
 
 void draw()
 {
 
 }
 }*/

class Char extends Drawable
{
  int fi;
  CharDef def;
  PImage img;
  PImage maskImg;
  float x, y;
  
  PMatrix charTransform;
  PMatrix charBodyTransform;
  float[] ballWeights;
  PVector[] handPosns;
  PVector lookBallPos;
  float angle;

  Char(int fi, CharDef def, PImage img, PImage maskImg, float x, float y)
  {
    this.fi=fi;
    this.def=def;
    this.img=img;
    this.maskImg=maskImg;
    this.x=x;
    this.y=y;
    charTransform=charTransform(fi);
  }

  float getDepth() { 
    return y;
  }
  /*
  void computeBallWeights() {
    ballWeights=ballWeights(time,fi);
  }*/
  
  void drawWick()
  {
    PVector wickOrigin = new PVector(130, -390);
    PVector[] wickPoints = {
      new PVector(0, 0), 
      new PVector(20, -50), 
      new PVector(40, -30), 
      new PVector(60, 0), 
      new PVector(80, 20), 
      new PVector(100, 30), 
      new PVector(120, 30), 
    };
    for (int i = 0; i < wickPoints.length; i++) {
      wickPoints[i].add(wickOrigin);
    }
    //pushMatrix();
    color[] colors = {0xff8a7e5b, 0xffd4c39b};
    float[] weights = {30, 15};
    //applyMatrix(charTransform);
    noFill();
    curveTightness(0);
    PVector[] segments=new PVector[wickPoints.length];
    PMatrix tf=charBodyTransform;
    PVector segmentPos = tf.mult(wickPoints[0], null);
    segments[0]=segmentPos.copy();
    for (int i = 1; i < wickPoints.length; i++) {
      float lag = .05 * i;
      tf = charBodyTransform(time - lag, fi);
      tf.mult(wickPoints[i], segmentPos);
      //curveVertex(segmentPos.x, segmentPos.y);
      segments[i]=segmentPos.copy();
    }
    for (int l = 0; l < colors.length; l++) {
      stroke(colors[l]);
      strokeWeight(weights[l]);
      beginShape();
      
      vertex(segments[0].x, segments[0].y);
      for (int i = 0; i < wickPoints.length; i++) {
        curveVertex(segments[i].x, segments[i].y);
      }
      endShape();
    }
    //popMatrix();
  }

  void drawWinnerHand(PVector lbOld, PVector lb)
  {
    boolean drawHand=false;
    for (int ballID = 0; ballID < BALL_COUNT; ballID++) {
      if (ballHolder(time + passTime * (1), ballID) == fi||ballHolder(time + passTime * (0), ballID) == fi) {
        drawHand=true;
        break;
      }
    }
    if (drawHand) {
      float laggyTime = time - .1 - .2 * nrandp(1.5, fi);
      PVector[] turnBallPosns = new PVector[BALL_COUNT];
      for (int i = 0; i < BALL_COUNT; i++) {
        turnBallPosns[i] = ballPos(laggyTime, i);
      }
      ballWeights = ballWeights(laggyTime, fi);
      PVector turnBallPos = new PVector();
      for (int i = 0; i < BALL_COUNT; i++) {
        turnBallPos.add(turnBallPosns[i].mult(ballWeights[i]));
      }

      float ballDx = turnBallPos.x - x;
      float ballDy = turnBallPos.y - y;
      float flipF = ballDx > 0 ? 1 : -1;
      float nearXDamper = 1 - (1.42658/(ballDx * ballDx * 4 + 1.36855));

      float bodyAngle=((float) Math.atan2(ballDy * flipF, ballDx * flipF) * nearXDamper);
      PMatrix inv=charTransform(fi);
      inv.invert();
      PVector handPosns=inv.mult(handPosns(time, fi)[0], null);

      PVector[] handPoints=new PVector[4];
      for (int i=0; i<handPoints.length; i++)
      {
        handPoints[i]=PVector.lerp(new PVector(0, -def.armH), handPosns, i/2.);
      }
      float lookTime = time - .0 - .2 * nrandp(2.5, fi);
      PVector[] lookBallPosns = new PVector[BALL_COUNT];
      for (int i = 0; i < BALL_COUNT; i++) {
        lookBallPosns[i] = ballApparentPos(lookTime+.1, ballPos(lookTime+.1, i), i);
      }
      ballWeights = ballWeights(lookTime+.1, fi);
      PVector lbNew = new PVector();
      for (int i = 0; i < BALL_COUNT; i++) {
        lbNew.add(lookBallPosns[i].mult(ballWeights[i]));
      }
      float ballAngle=PVector.sub(lb,lbOld).add(PVector.sub(lbNew,lb).mult(2)).heading();
      pushMatrix();
      color[] colors = {color(122, 135, 255), color(173, 181, 255)};
      float[] weights = {80, 65};
      applyMatrix(charTransform);
      rotate(-bodyAngle);
      noFill();
      curveTightness(0);
      float handScale=200;
      for (int l = 0; l < colors.length; l++) {
        stroke(colors[l]);
        strokeWeight(weights[l]);
        beginShape();
        PMatrix tf = charBodyTransform;
        PVector segmentPos = tf.mult(handPoints[0], null);
        curveVertex(segmentPos.x, segmentPos.y);
        curveVertex(segmentPos.x, segmentPos.y);
        for (int i = 1; i < handPoints.length; i++) {
          float lag = .1 * -i*(-i+4);
          tf = charBodyTransform(time - lag, fi);
          tf.mult(handPoints[i], segmentPos);
          curveVertex(segmentPos.x, segmentPos.y);
        }
        endShape();
        pushMatrix();
        PVector palmPos=PVector.lerp(handPoints[handPoints.length-1], handPoints[handPoints.length-2], 0.5);
        PVector[] fingerCoords=new PVector[] {
          new PVector(handScale*.0, handScale*.2), 
          new PVector(handScale*.4, handScale*.2), 
          new PVector(handScale*.5, handScale*.0), 
          new PVector(handScale*.4, -handScale*.2), 
          new PVector(handScale*.1, -handScale*.4)
        };
        translate(palmPos.x, palmPos.y);
        rotate(ballAngle*0.2);/*
        fill(colors[l]);
         beginShape();
         for(int i=0; i<5; i++) vertex(fingerCoords[i].x,fingerCoords[i].y);
         endShape(CLOSE);*/
        PImage finger=getImage(filePath+"img/body/winner-finger"+(l==0? "out":"in")+"1.png");
        image(finger, fingerCoords[0].x, fingerCoords[0].y, handScale, handScale);
        //rotate(-PI/4);
        finger=getImage(filePath+"img/body/winner-finger"+(l==0? "out":"in")+"2.png");
        for (int i=1; i<4; i++) image(finger, fingerCoords[i].x, fingerCoords[i].y, handScale, handScale);
        //rotate(PI/8);
        finger=getImage(filePath+"img/body/winner-finger"+(l==0? "out":"in")+"3.png");
        image(finger, fingerCoords[4].x, fingerCoords[4].y, handScale, handScale);
        popMatrix();
      }
      popMatrix();
    }
  }

  // I've not yet added the other "sub-draw" functions here

  void draw() {
    //if(true) return;
    if(defs[fi].noArms) ballWeights=ballWeights(time,fi);
    else handPosns = handPosns(time, fi);
    charBodyTransform=charBodyTransform(time, fi);
    float lookTime = time - .2 * nrandp(2.5, fi);
    PVector[] lookBallPosns = new PVector[BALL_COUNT];
    if(defs[fi].noArms) {
      for (int i = 0; i < BALL_COUNT; i++) {
        lookBallPosns[i] = ballApparentPos(lookTime, ballPos(lookTime, i), i);
      }
      ballWeights = ballWeights(lookTime, fi);
      lookBallPos = new PVector();
      for (int i = 0; i < BALL_COUNT; i++) {
        lookBallPos.add(lookBallPosns[i].mult(ballWeights[i]));
      }

      lookBallPosns = new PVector[BALL_COUNT];
    }
    for (int i = 0; i < BALL_COUNT; i++) {
      lookBallPosns[i] = ballApparentPos(lookTime - .01, ballPos(lookTime - .01, i), i);
    }
    ballWeights = ballWeights(lookTime - .01, fi);
    PVector lookBallPosOld = new PVector();
    for (int i = 0; i < BALL_COUNT; i++) {
      lookBallPosOld.add(lookBallPosns[i].mult(ballWeights[i]));
    }/*
    float bell2T=0;
    for (int i = 0; i < BALL_COUNT; i++) {
      if(
      PVector ballHolderBefore=
    }*/
    
    
    float bounce=bounce(fi, time)*def.bounceS;
    float faceX = (float)Math.tanh(lookBallPos.x - x);
    float faceXOld = (float)Math.tanh(lookBallPosOld.x - x);
    float dFaceX = (faceX - faceXOld) / .01;
    float faceY = (float)Math.tanh(lookBallPos.y - y);
    float skewX = faceX * def.skewX;
    float flatness=(def.isFlat? faceX:-1);
    if (def.hasWinnerHand) drawWinnerHand(lookBallPosOld, lookBallPos);

    pushMatrix();
    applyMatrix(charTransform);
    if (def.hasWick) drawWick();

    float angleLeg=sin(def.angle)*def.legH;
    float legOffset=def.legW * (.5 + .1 * nrand(100, fi));
    PVector leftFoot = new PVector(angleLeg-legOffset, 0);
    PVector rightFoot = new PVector(angleLeg+legOffset, 0);

    PVector rightHipBody = new PVector(def.legW * (def.hasTorso? 0:.5), def.legH * -.5+bounce);
    //PMatrix bodyTransform = charBodyTransform;
    PVector rightHip = charBodyTransform.mult(rightHipBody, null);
    //rightHip.rotate(def.angle);

    PVector leftHipBody = new PVector(-rightHipBody.x, rightHipBody.y);
    PVector leftHip = charBodyTransform.mult(leftHipBody, null);
    //leftHip.rotate(def.angle);




    PMatrix mat = new PMatrix2D();
    mat.set(
      1, skewX, skewX * (img.height*def.scale / 2 - 100) + def.bodyX+def.offX, 
      faceX * -def.skewY, 1, def.bodyY+bounce
      );
    //if(def.centered) mat.translate(0,img.height/2);
    //mat.translate(-def.offX,0);
    //mat.rotate(def.angle);
    //mat.translate(def.offX, 0);
    
    
    
    if (def.hasTorso)
    {
      PVector shoulder=mat.mult(new PVector(0, -def.faceH+img.height-def.armH), null);
      shoulder=charBodyTransform.mult(shoulder, null);
      //pushMatrix();

      //applyMatrix(mat);
      strokeWeight(8);
      stroke(0);
      line(leftHip.x, leftHip.y, shoulder.x, shoulder.y);
      //popMatrix();
      //println(leftHip.x+" "+leftHip.y+" "+shoulder.x+" "+shoulder.y);
    }

    // Legs
    if (def.hasLegs)
    {
      stroke(0);
      strokeWeight(8);
      noFill();
      line(
        leftHip.x*abs(flatness), leftHip.y, 
        leftFoot.x, leftFoot.y
        );
      line(
        rightHip.x*abs(flatness), rightHip.y, 
        rightFoot.x, rightFoot.y
        );

      // Feet
      strokeWeight(20);
      line(
        leftFoot.x - 5, leftFoot.y, 
        leftFoot.x - 30, leftFoot.y + 10 + 12 * nrand(-10., fi)
        );
      line(
        rightFoot.x + 5, rightFoot.y, 
        rightFoot.x + 30, rightFoot.y + 10 + 12 * nrand(-11., fi)
        );
    }

    pushMatrix();
    //translate(0,def.offY);
    applyMatrix(charBodyTransform);



    // Body


    pushMatrix();
    applyMatrix(mat);
    //translate(def.body2X,0);
    //translate(def.offX,0);
    scale(def.scale);
    PImage side=null;
    float imgOffset=0;

    if (def.isFlat)
    {
      PImage flat=getImage(filePath+"img/body/" + def.name+"-flat.png");
      side=createImage(flat.height/2, flat.height/2, ARGB);
      float thick=cos(flatness*HALF_PI)/2;
      for (int j=0; j<side.height; j++)
      {
        int fj=j*2;//(j*1.02564103);
        int offset=int(cos(asin((float)j/side.height*2-1))*side.width*flatness*0.5);
        for (int i=0; i<side.width; i++)
        {
          int fi=(int)((i-side.width/2-offset)/(thick*1.4))+flat.width/2;
          if (fi>=0&&fi<flat.width/*&&fj>=0&&fj<flat.height*/) side.pixels[i+j*side.width]=flat.pixels[fi+fj*flat.width];
        }
      }
      side.updatePixels();
      imgOffset=thick*side.width/40*(flatness>0? 1:-1);
    }
    if(def.isBlackHole) blendMode(ADD);
    image(img, -faceX*def.bodyM*0.5-imgOffset, (def.centered? 0:-img.height / 2)-faceY*def.bodyM*0.5, flatness*img.width, img.height);
    if (side!=null) {
      //tint(255,255-(float)Math.abs(flatness)*255);
      image(side, -faceX*def.bodyM*0.5, (def.centered? 0:-img.height / 2)-faceY*def.bodyM*0.5,side.width*2,side.height*2);
      //noTint();
    }
    if(def.isBlackHole) {
      blendMode(BLEND);
      fill(0);
      noStroke();
      ellipse(-faceX*def.bodyM*0.5-imgOffset, (def.centered? 0:-img.height / 2)-faceY*def.bodyM*0.5,48,48);
    }
    popMatrix();

    if (def.hasFace)
    {
      PGraphics face;
      if (USE_MASKS) {
        face = createGraphics(floor(img.width/2.), floor(img.height/2.));
        face.beginDraw();
        //face.background(255,0,0);
        face.translate(face.width / 2, face.height*(def.hasTorso? 1.5:1));
        face.scale(0.5/def.scale);
        //face.rotate(def.angle);
      } else {
        face = g;
      }
      face.pushMatrix();
      if(!USE_MASKS) face.translate(def.bodyX+def.offX,def.bodyY+img.height/2*(def.hasTorso? 1:0));
      face.translate(
        faceX * def.faceW*def.faceM+def.faceX, 
        -def.faceH + faceY * 20+bounce
        );
      face.scale(-flatness, 1);

      // Eyes
      float blinkness = pulse(
        1. + 2. * nrandp(34., fi), 10, 
        time + nrandp(43., fi)
        );
      blinkness = 1 - (1 - blinkness) * // blink if turning fast
        (1 - smoothstep(5, 7, Math.abs(dFaceX)));
      blinkness = 1 - (1 - blinkness) * // blink if armless and passing a ball
        (1 - smoothstep(0.3, 0.5, bounce/def.bounceS));
      face.fill(def.isDark? 255:0);
      face.noStroke();
      float eyePosX=def.faceW / 2 *(1.42658/(faceX * faceX * .64 + 1.36855));//(float)Math.cosh(faceX * .8);
      float eyePosY=faceY*faceX*.5;
      face.pushMatrix();
      face.translate(-eyePosX +def.offX, eyePosY);
      drawEye(def, face, blinkness);
      face.translate(eyePosX*2,0);
      drawEye(def, face, blinkness);
      face.popMatrix();

      // Mouth
      if (def.hasMouth) {
        face.pushMatrix();
        face.translate(def.offX, 0);
        face.stroke(def.isDark? 255:0);
        face.strokeWeight(8);
        face.noFill();
        face.bezier(
          -def.faceW * .5 - faceX * 20, 60 + faceY * faceX * 5*def.faceS, 
          -def.faceW * .2 - faceX * 25, 80 + faceY * faceX * 2*def.faceS, 
          def.faceW * .2 - faceX * 25, 80 + faceY * faceX * 2*def.faceS, 
          def.faceW * .5 - faceX * 20, 60 - faceY * faceX * 5*def.faceS
          );
        face.popMatrix();
      }
      face.popMatrix();
      if (USE_MASKS) {
        face.endDraw();
        face.loadPixels();

        //maskImg.loadPixels();
        for (int i = 0; i < face.width; i++) {
          for (int j = 0; j < face.height; j++) {
            //int facePixel = face.pixels[i+j*face.width];
            //float faceAlpha = (facePixel >> 24 & 0xFF) / 255.;
            int maskX=i;
            if(def.isFlat) maskX=(int)Math.min(Math.max(Math.floor((i+face.width/2-face.width/2)/flatness), 0), face.width-1);
            float maskAlpha = (maskImg.pixels[maskX*2+j*img.width*2] >> 24 & 0xFF);
            //float alpha = faceAlpha * maskAlpha;
            if (maskAlpha<10) face.pixels[i+j*face.width] = color(0,0);
          }
        }
        face.updatePixels();
        //face.mask(mask);
        pushMatrix();
        applyMatrix(mat);
        //translate(0,);
        scale(-def.scale);
        //rotate(time);
        //println((def.bounceS*bounce)+"+"+(-img.height/2-faceY*def.bodyM*0.5)+"="+(-img.height / 2-faceY*def.bodyM*0.5+bounce*def.bounceS));
        image(face, -faceX*def.bodyM*0.5, -img.height / 2-faceY*def.bodyM*0.5, img.width, img.height);
        popMatrix();
      }
    }
    popMatrix();
    
    if(def.hasString) {
      stroke(0);
      strokeWeight(10);
      line(angle*-500,-10000,angle*50,def.bodyY-def.stringH+bounce);
    }



    popMatrix();
    if (!def.noArms)
    {
      // Arms
      PMatrix fullBodyTransform = charTransform.get();
      fullBodyTransform.apply(charBodyTransform);
      PVector leftShoulderBody = new PVector(-(def.hasTorso? 0:def.armW)+sin(def.angle)*def.armH-faceX*def.bodyM+def.armX, -(def.hasTorso? def.faceH-img.height/2+def.armH:def.armH)-faceY*def.bodyM);
      PVector leftShoulder = fullBodyTransform.mult(leftShoulderBody, null);

      PVector rightShoulderBody = new PVector(2*(def.hasTorso? 0:def.armW)+leftShoulderBody.x, leftShoulderBody.y);
      PVector rightShoulder = fullBodyTransform.mult(rightShoulderBody, null);

      stroke(0);
      strokeWeight(.007);
      noFill();
      line(
        leftShoulder.x, leftShoulder.y, 
        handPosns[0].x, handPosns[0].y
        );
      line(
        rightShoulder.x, rightShoulder.y, 
        handPosns[1].x, handPosns[1].y
        );
    }
    
    if (def.hasEvilEyes)
    {
      float coshFaceX=(1.42658/(faceX * faceX * .64 + 1.36855));
      pushMatrix();
      translate(0, -def.faceH*0.001 +bounce*0.001);
      strokeWeight(.015);
      stroke(0);
      PVector leftEyePos=new PVector(def.faceW / 2 * coshFaceX*0.001+def.offX*0.001+x, faceY * faceX * 0.005+y);
      PVector leftLookPos=PVector.sub(lookBallPos, leftEyePos).setMag(0.02).add(leftEyePos);
      point(leftLookPos.x, leftLookPos.y);
      //point(leftEyePos.x,leftEyePos.y);
      PVector rightEyePos=new PVector(-def.faceW / 2 * coshFaceX*0.001+def.offX*0.001+x, faceY * faceX * 0.005+y);
      PVector rightLookPos=PVector.sub(lookBallPos, rightEyePos).setMag(0.02).add(rightEyePos);
      point(rightLookPos.x, rightLookPos.y);
      //point(rightEyePos.x,rightEyePos.y);
      popMatrix();
    }
  }
}
