float pulse(float period, float sharpness, float t) {
  return (float) Math.pow(
    .5 + .5 * Math.cos(2 * Math.PI * t / period), 
    period * period * sharpness
  );
}

float smoothstep(float edge0, float edge1, float x) {
  x = Math.min(Math.max((x - edge0)/(edge1 - edge0), 0), 1); 
  return x*x*(3 - 2*x);
}

PVector[] intersections(PVector p1, float r1, PVector p2, float r2) {
  float d, a, h;
  d = p1.dist(p2);
  a = (r1*r1 - r2*r2 + d*d)/(2*d);
  h = sqrt(r1*r1 - a*a);
  PVector p3 = p2.copy().sub(p1).mult(a/d).add(p1);
  float x3, y3, x4, y4;
  x3 = p3.x + h*(p2.y - p1.y)/d;
  y3 = p3.y - h*(p2.x - p1.x)/d;
  x4 = p3.x - h*(p2.y - p1.y)/d;
  y4 = p3.y + h*(p2.x - p1.x)/d;

  return new PVector[] {new PVector(x3, y3), new PVector(x4, y4)};
}

float nrand(float x, float y) {
  return (float) Math.sin(
    new PVector(x, y).dot(new PVector(12.9898, 78.233))
    ) * 43758.5453 % 1.;
}
float nrandp(float x, float y) {
  return Math.abs(nrand(x, y));
}
float[] transformAABB(float minX, float minY, float maxX, float maxY, PMatrix mat) {
  PVector p1 = mat.mult(new PVector(minX, minY), null);
  PVector p2 = mat.mult(new PVector(maxX, minY), null);
  PVector p3 = mat.mult(new PVector(minX, maxY), null);
  PVector p4 = mat.mult(new PVector(maxX, maxY), null);
  return new float[] {
    Math.min(Math.min(Math.min(p1.x, p2.x), p3.x), p4.x), 
    Math.min(Math.min(Math.min(p1.y, p2.y), p3.y), p4.y), 
    Math.max(Math.max(Math.max(p1.x, p2.x), p3.x), p4.x), 
    Math.max(Math.max(Math.max(p1.y, p2.y), p3.y), p4.y), 
  };
}

Map<String, PImage> images = new HashMap<String, PImage>();
PImage getImage(String path) {
  PImage image = images.get(path);
  if (image == null) {
    images.put(path, image = loadImage(path));
    image.loadPixels();
  }
  return image;
}

Map<String, int[]> masks = new HashMap<String, int[]>();
int[] getMask(String path) {
  int[] mask = masks.get(path);
  if (mask != null) return mask;

  PImage image = getImage(path);
  image.loadPixels();
  mask = new int[image.pixels.length];
  for (int i = 0; i < mask.length; i++) {
    mask[i] = image.pixels[i] >> 24;
  }
  return mask;
}

PVector[] generatePoints(PVector p1, PVector p2, float spacing, int count, int maxItems) {
  // idea from https://mollyrocket.com/casey/stream_0016.html
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int i = 1; i <= count; i++) {
    //float r1 = (float) i * spacing;
    //stroke(255, 0, 0);
    //noFill();
    //ellipse(p1.x, p1.y, r1 * 2, r1 * 2);
    for (int j = 1; j <= count; j++) {
      float rs1 = (float) (i + (j % 3 == 0 ? .3 : 0)) * spacing;
      float rs2 = (float) (j + (i % 3 == 0 ? .3 : 0)) * spacing;
      //if (i == 1) {
      //float r2 = (float) i * spacing;
      //stroke(0, 100, 255);
      //noFill();
      //ellipse(p2.x, p2.y, r2 * 2, r2 * 2);
      //}

      PVector[] hits = intersections(p1, rs1, p2, rs2);

      //stroke(0);
      //noFill();
      //ellipse(hits[0].x, hits[0].y, .05, .05);
      //ellipse(hits[1].x, hits[1].y, .05, .05);
      if (
        Float.isNaN(hits[0].x) || Float.isNaN(hits[0].y) || 
        Float.isNaN(hits[1].x) || Float.isNaN(hits[1].y)
        ) continue;

      if (
        hits[0].x >= -4.4 && hits[0].x < 4.4 &&
        hits[0].y >= -1.4 && hits[0].y < 1.5
        ) points.add(hits[0]);
      if (
        hits[1].x >= -4.4 && hits[1].x < 4.3 &&
        hits[1].y >= -1.4 && hits[1].y < 1.5
        ) points.add(hits[1]);
    }
  }

  Collections.sort(points, new Comparator<PVector>() {
    public int compare(PVector p1, PVector p2) {
      return new PVector().dist(p1) > new PVector().dist(p2) ? 1 : -1;
    }
  }
  );

  int itemCount = Math.min(maxItems, points.size());
  PVector[] closestPoints = new PVector[itemCount];
  for (int i = 0; i < itemCount; i++) {
    closestPoints[i] = points.get(i);
  }
  
  return closestPoints;
}




float passTime = .5;
float ballDelay(float id) {
  return id / BALL_COUNT * passTime;
}
float ballProgress(float t, float id) {
  return (t + ballDelay(id)) / passTime % 1;
}
int ballHolder(float t, int id) {
  float ballTime = t + ballDelay(id);
  int round = (int) (ballTime / passTime);
  //if (round >= 4 + 10) round -= 10;
  if (round < enterTimes[Math.min(id, enterTimes.length - 1)]) return -1 - id;
  if (round >= exitTimes[Math.min(id, exitTimes.length - 1)]&&round<196) return -1 - id;
  if (round >= 212+id*16) return -1 - id;
  //if(round%20==0) return 0;
  if(round%5==0) return (int) (nrandp(4 + .1 * id, round) * points.length);
  else {
    int holder=ballHolder(t-passTime,id);
    if(holder<0) return (int) (nrandp(8.091563 + .1 * id, round*14.1331415) * points.length);
    int[] near=pointsNear[holder];
    return near[floor(nrandp(5+.2*id,round*2)*near.length)];
  }
}
PVector offScreenBallPosL=new PVector(-5,0);
PVector offScreenBallPosR=new PVector(5,0);
PVector holderLocation(int holderID) {
  if (holderID < 0) return (holderID % 2 == 0 ? offScreenBallPosR : offScreenBallPosL).copy();
  return holderLocation[holderID];
}
PVector ballPos(float t, int id) {
  int beforeIndex = ballHolder(t - passTime, id);
  int fromIndex = ballHolder(t, id);
  int toIndex = ballHolder(t + passTime, id);
  int afterIndex = ballHolder(t + passTime * 2, id);
  if(fromIndex<0&&toIndex<0) return holderLocation(fromIndex).copy();
  float progress=ballProgress(t, id);
  //int index=fromIndex;

  curveTightness(-1);
  //curveTightness(index>=0? (defs[index].hasWinnerHand? -1:-1):-1); // VARY THIS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  PVector ballPos = new PVector();
  ballPos.x = curvePoint(
    holderLocation(beforeIndex).x, 
    holderLocation(fromIndex).x, 
    holderLocation(toIndex).x, 
    holderLocation(afterIndex).x, 
    progress
    );
  ballPos.y = curvePoint(
    holderLocation(beforeIndex).y, 
    holderLocation(fromIndex).y, 
    holderLocation(toIndex).y, 
    holderLocation(afterIndex).y, 
    progress
    );
  ballPos.z = curvePoint(
    holderLocation(beforeIndex).z, 
    holderLocation(fromIndex).z, 
    holderLocation(toIndex).z,
    holderLocation(afterIndex).z, 
    progress
    );
  float parabola = (1 - (float) Math.pow(2 * progress - 1, 2));
  ballPos.z += (float) Math.pow(parabola, 2) * .5;
  return ballPos;
}
PVector ballApparentPos(float t, PVector realPos, int id) {
  float prog=ballProgress(t, id);
  int nearIndex = ballHolder(prog > .5 ? (t + passTime) : t, id);/*
  boolean shouldSnapDepth =
    ballProgress(t, id) < .3 ||
    ballProgress(t, id) > .7;*/
  float fSnapDepth=(float)(1./(10000*Math.pow(prog-0.5,6)+1));
  return new PVector(
    realPos.x, 
    realPos.y - .1 - realPos.z, 
    //shouldSnapDepth ? holderLocation(nearIndex).y + .01 : realPos.y
    lerp(holderLocation(nearIndex).y + .01, realPos.y, fSnapDepth)
  );
}

PMatrix charTransform(int index) {
  float x = points[index].x;//holderLocation(index).x;
  float y = points[index].y;//holderLocation(index).y;

  PMatrix mat = new PMatrix2D();
  mat.translate(x, y);
  mat.scale(.001);
  return mat;
}
PMatrix charBodyTransform(float t, int index) {
  CharDef def = defs[index];
  float x = holderLocation[index].x;
  float y = holderLocation[index].y;

  PMatrix mat = new PMatrix2D();
  mat.translate(0, def.offY-def.legH);
  
  float laggyTime = t - .1 - .2 * nrandp(1.5, index);
  PVector[] turnBallPosns = new PVector[BALL_COUNT];
  for (int i = 0; i < BALL_COUNT; i++) {
    turnBallPosns[i] = ballPos(laggyTime, i);
  }
  float[] ballWeights = ballWeights(laggyTime, index);
  PVector turnBallPos = new PVector();
  for (int i = 0; i < BALL_COUNT; i++) {
    turnBallPos.add(turnBallPosns[i].mult(ballWeights[i]));
  }
  
  float ballDx = turnBallPos.x - x;
  float ballDy = turnBallPos.y - y;
  float flipF = ballDx > 0 ? 1 : -1;
  float nearXDamper = 1 - (1.42658/(ballDx * ballDx * 4 + 1.36855));
  float angle=(float) Math.atan2(ballDy * flipF, ballDx * flipF) * nearXDamper;
  chars[index].angle=angle;
  
  if(def.hasString) mat.translate(angle*50,-(def.bodyTop-def.bodyY));
  if(def.isBlackHole) mat.translate(angle*100,0);
  mat.rotate(angle*def.angleM);
  if(def.hasString) mat.translate(0,def.bodyTop-def.bodyY);
  return mat;
}

PVector[] handPosns(float time, int fi) {
  CharDef def = defs[fi];

  PMatrix bodyTransformLeft = chars[fi].charTransform.get();
  bodyTransformLeft.apply(charBodyTransform(time - .1, fi));
  PMatrix bodyTransformRight = chars[fi].charTransform.get();
  bodyTransformRight.apply(charBodyTransform(time - .12, fi));
  
  float lookTime = time - .2 * nrandp(2.5, fi);
  PVector[] lookBallPosns = new PVector[BALL_COUNT];
  for (int i = 0; i < BALL_COUNT; i++) {
    lookBallPosns[i] = ballApparentPos(lookTime, ballPos(lookTime, i), i);
  }
  float[] ballWeights = ballWeights(lookTime, fi);
  PVector lookBallPos = new PVector();
  for (int i = 0; i < BALL_COUNT; i++) {
    lookBallPos.add(lookBallPosns[i].mult(ballWeights[i]));
  }
  chars[fi].lookBallPos=lookBallPos;
  float sx=holderLocation[fi].x;
  float faceX = (float)Math.tanh((lookBallPos.x - sx) * 1.5);
  float sy=holderLocation[fi].y;
  float faceY = (float)Math.tanh((lookBallPos.y - sy) * 1.5);

  PVector leftHandBody = new PVector((-def.armW - 40)*(def.armL*0.125+.875)*(def.hasWinnerHand? 0:1)-faceX*def.bodyM+def.armX, -def.armH+50*def.armL-faceY*def.bodyM);
  PVector leftHand = bodyTransformLeft.mult(leftHandBody, null);
  PVector rightHandBody = new PVector((def.armW + 40)*(def.armL*0.25+.75)-faceX*def.bodyM+def.armX, -def.armH+50*def.armL-faceY*def.bodyM);
  PVector rightHand = bodyTransformRight.mult(rightHandBody, null);

  PVector[] leftHandPossibilities = new PVector[BALL_COUNT];
  PVector[] rightHandPossibilities = new PVector[BALL_COUNT];
  for (int ballID = 0; ballID < BALL_COUNT; ballID++) {
    float toBallF = 0;
    float x = ballProgress(time, ballID);
    if (ballHolder(time + passTime, ballID) == fi) {
      toBallF += Math.min(x * x * x * 1.2, 1);
    }
    float x2 = x * 6 + 5.498;
    for(int i = 0; i >= -3; i--) {
      if(ballHolder(time + passTime * i, ballID) == fi) {
        toBallF += (float) Math.min(Math.cos(x2) * 16667 * Math.pow(x2, -5.5), 1);
      }
      x2 += 6;
    }
    leftHandPossibilities[ballID] = leftHand.copy();
    rightHandPossibilities[ballID] = rightHand.copy();
    if(abs(toBallF)<0.002) continue;
    PVector bap = ballApparentPos(time, ballPos(time, ballID), ballID);
    PVector leftHandBall  = new PVector(-.07, .07).add(bap);
    PVector rightHandBall = new PVector( .07, .07).add(bap);
    leftHandPossibilities[ballID].lerp(leftHandBall, toBallF);
    rightHandPossibilities[ballID].lerp(rightHandBall, toBallF);
  }
  PVector leftHandResult = new PVector();
  PVector rightHandResult = new PVector();
  float[] weights = ballWeights(time, fi);
  for (int i = 0; i < weights.length; i++) {
    leftHandResult.add(leftHandPossibilities[i].mult(weights[i]));
    rightHandResult.add(rightHandPossibilities[i].mult(weights[i]));
  }
  
  return new PVector[] {leftHandResult, rightHandResult};
}

void drawSmearedEllipse(PVector pos, PVector oldPos, float radius, float power, float thinness) {
  PVector frameVel = pos.copy().sub(oldPos);
  float stretch = frameVel.mag();//(float) Math.pow(frameVel.mag(), power);

  pushMatrix();
  translate(pos.x, pos.y);
  rotate((float) Math.atan2(frameVel.y, frameVel.x));
  ellipse(0, 0, radius * (stretch*thinness+1), radius / (stretch * thinness+1));
  popMatrix();
}
PMatrix smearTransform(PVector pos, PVector oldPos, float stretch, float squish) {
  PVector frameVel = pos.copy().sub(oldPos);
  float mag = frameVel.mag();//(float) Math.pow(frameVel.mag(), 1);
  float angle = (float) Math.atan2(frameVel.y, frameVel.x);
  PMatrix smeared = new PMatrix2D();
  smeared.rotate(angle);
  smeared.scale(mag*stretch+1, 1./ (mag*squish+1));
  smeared.rotate(-angle);
  return smeared;
}
void drawEye(CharDef def, PGraphics face, float blinkness) {
  PVector eyeTop    = new PVector( 0, lerp(-15*def.faceS, 10/def.faceS-5, blinkness));
  PVector eyeBottom = new PVector( 0, 15/def.faceS);
  PVector eyeRight  = new PVector(lerp(7, 15, blinkness), 15-15*def.faceS);
  PVector eyeLeft   = new PVector(-lerp(7, 15, blinkness), 15-15*def.faceS);
  face.fill(def.isDark? 255:0);
  face.noStroke();
  face.curveTightness(-1);
  face.beginShape();
  face.curveVertex(eyeTop.x, eyeTop.y);
  face.curveVertex(eyeRight.x, eyeRight.y);
  face.curveVertex(eyeBottom.x, eyeBottom.y);
  face.curveVertex(eyeLeft.x, eyeLeft.y);
  face.curveVertex(eyeTop.x, eyeTop.y);
  face.curveVertex(eyeRight.x, eyeRight.y);
  face.curveVertex(eyeBottom.x, eyeBottom.y);
  face.endShape();
}

float[] ballWeights(float t, int charID) {
  PVector op = holderLocation[charID];
  float[] weights = new float[BALL_COUNT];
  float total = 0;
  for (int i = 0; i < BALL_COUNT; i++) {
    PVector bp = ballPos(t, i).sub(op);
    //weights[i] = (float) Math.pow(bp.dist(op) + .01, -2);
    weights[i] = 1./(bp.x*bp.x+bp.y*bp.y+bp.z*bp.z+.005);
    weights[i] *= .1 + .9 * smoothstep(1.8, .5, Math.abs(bp.x+op.x));
    total += weights[i];
  }
  for (int i = 0; i < BALL_COUNT; i++) {
    weights[i] /= total;
  }
  return weights;
}

float bounce(int fi, float time)
{
  if(!defs[fi].armless) return 0;
  //float[] bounces=new float[BALL_COUNT];
  //float[] weights=ballWeights(time,fi);
  float bounce=0;
  for (int ballID = 0; ballID < BALL_COUNT; ballID++) {
    float x=ballProgress(time,ballID);
    float bounce2=0;
    if (ballHolder(time + passTime, ballID) == fi) {
      bounce2+=pow(x,5);
    }
    if (ballHolder(time           , ballID) == fi) {
      bounce2+=cos(8*x)*pow(.5*x-1,4)*exp(x);
    }
    if (ballHolder(time - passTime, ballID) == fi) {
      bounce2+=cos(8*x+8)*pow(.5*x-.5,4)*exp(x+1);
    }
    //if(bounce2==0) continue;
    bounce+=bounce2*chars[fi].ballWeights[ballID];
  }
  return bounce;
}