
class CharDef {
  public String name;
  public float faceW = 100;
  public float faceH = 150;
  public boolean hasMouth = true;
  public float legW = 80;
  public float legH = 50;
  public float armW = 130;
  public float armH = 30;
  public float bodyY = 0;
  public float bodyX = 0;
  public float skewX = 0;
  public float skewY = 0;
  public boolean hasWick = false;
  public boolean hasTorso = false;
  public float scale = 1;
  public boolean isDark =false;
  public float offX=0;
  public float faceS=1;
  public float armL=1;
  public float angle=0;
  public boolean centered=false;
  public float faceM=1;
  public boolean hasLegs=true;
  public float bodyM=0;
  public boolean noArms=false;
  public boolean hasFace=true;
  public boolean hasWinnerHand=false;
  public float angleM=0.6;
  public float armX=0;
  public boolean armless=false;
  public float bodyTop=240;
  public float bounceS=60;
  public boolean hasEvilEyes=false;
  public boolean isFlat=false;
  public float faceX=0;
  public boolean noDraw=false;
  public boolean hasString=false;
  public boolean bell2=false;
  public boolean bell3=false;
  public boolean bell4=false;
  public float stringH=370;
  public boolean isBlackHole=false;
  public float offY=0;
}
CharDef[] defs = {
  new CharDef() {
  {
    name="8ball";
    scale=2.2;
    hasLegs=false;
    armless=true;
    isDark=true;
    bodyY=50;
    noArms=true;
    faceH=180;
  }
}
,
  new CharDef() {
  {
    name="anchor";
    scale=1.5;
    bodyY=50;
    isDark=true;
    faceW=50;
    armW=160;
    armH=50;
    faceH=190;
  }
}
,
  new CharDef() {
  {
    name="avocado";
    armless=true;
    isDark=true;
    hasMouth=false;
    bodyY=30;
    noArms=true;
    faceH=240;
  }
}
,
  new CharDef() {
  {
    name="balloony";
    scale=0.25*8;
    bodyY=-26;
    //faceH=120;
    legW=15;
    armH=200;
    armW = 10;
    armL=3;
    faceH=350;
  }
}
,
  new CharDef() {
  {
    name="barfbag";
    scale=1/3.45851164*6;
    armH=50;
    legW=100;
    faceW=80;
    armW=140;
  }
}
,
  new CharDef() {
  { 
    name = "basketball"; 
    faceW = 90; 
    faceH=220;
    noArms=true;
    armless=true;
    bodyTop=320;
  }
}
,
  new CharDef() {
  {
    name="battery";
    scale=1.2;
    bodyY=30;
    faceH=120;
  }
}
,/*
  new CharDef() {
  {
    name="bell";
    scale=1.5;
    noArms=true;
    bodyY=-200;
    hasString=true;
    hasLegs=false;
    //angleM=0.3;
    faceW=80;
    bodyTop=320;
    armless=true;
  }
}
,*/
  new CharDef() {
  {
    name="bell";
    scale=1.5;
    noArms=true;
    bodyY=-200;
    hasString=true;
    hasLegs=false;
    //angleM=0.3;
    faceW=80;
    bodyTop=320;
    armless=true;
    bell2=true;
  }
}
,/*
  new CharDef() {
  {
    name="bell";
    scale=1.5;
    noArms=true;
    bodyY=-200;
    hasString=true;
    hasLegs=false;
    //angleM=0.3;
    faceW=80;
    bodyTop=320;
    bell3=true;
  }
}
,
  new CharDef() {
  {
    name="bell";
    scale=1.5;
    noArms=true;
    bodyY=-200;
    hasString=true;
    hasLegs=false;
    //angleM=0.3;
    faceW=80;
    bodyTop=320;
    bell4=true;
  }
}
,
  */
  new CharDef() {
  { 
    name = "birthdaycake"; 
    scale=0.7;
    faceW = 70; 
    faceH=110;
    faceM=0.6;
    noArms=true;
    armless=true;
    bodyTop=180;
  }
}
,
  new CharDef() {
  { 
    name = "blackhole"; 
    scale=9;
    offY=-300;
    bodyY=42*9;
    angleM=0;
    noArms=true;
    hasLegs=false;
    hasFace=false;
    isBlackHole=true;
  }
}
,
  new CharDef() {
  {
    name="blender";
    faceH=300;
    bodyX=30;
  }
}
,
  new CharDef() {{ name = "blocky"; 
}},
  new CharDef() {
  { 
    name = "bomby"; 
    armW = 110;
    hasWick = true;
  }
}
, 
  new CharDef() {
  { 
    name = "book"; 
    faceW = 90; 
    faceH = 180; 
    skewY = .15; 
    armH = 50;
  }
}
, /*
  new CharDef() {
  {
    name="boommic6";
    scale=2;
    offX=100;
    faceH=500;
    armW=30;
    armH=100;
    legW=50;
    legH=80;
    angle=0.9;
    bodyY=-60;
    //faceW=50;
    faceS=0.7;
    centered=true;
  }
}
,*/
  new CharDef() {
  { 
    name = "bottle"; 
    faceW = 80; 
    faceH = 200; 
    armW = 130;
    armH=50;
    legH=40;
    scale=0.240907105*7;
  }
}
, 
  new CharDef() {
  { 
    name = "bracelety"; 
    faceW = 100; 
    faceH = 110; 
    armW = 160;
    scale=0.318291964*2;
    legW=120;
  }
}
, 
  new CharDef() {
  { 
    name = "bubble"; 
    faceW = 120; 
    faceH = 200; 
    armH = 40; 
    armW = 110;
  }
}
, 
  new CharDef() {
  { 
    name = "cake"; 
    scale=0.84;
    faceW = 70; 
    faceH=130;
    faceM=0.6;
    noArms=true;
    armless=true;
    bodyTop=160;
    isDark=true;
  }
}
,
  new CharDef() {
  { 
    name = "clapboard";
    faceW = 80; 
    faceH = 120;
    noArms=true;
    armless=true;
    isDark=true;
    bodyTop=150;
  }
}
,
  new CharDef() {
  { 
    name = "clip"; 
    scale=0.3*5;
    faceW = 90; 
    faceS=0.8;
    faceH = 120; 
    armW = 100;
  }
}
, new CharDef() {
  { 
    name = "clock"; 
    scale=0.7;
    faceW = 70; 
    faceH=140;
    faceM=0.6;
    noArms=true;
    armless=true;
    bodyTop=220;
  }
}
,
  new CharDef() {
  {
    name="cloudy";
    scale=0.65;
    armless=true;
    noArms=true;
    bodyM=0;
    faceM=0.4;
    hasLegs=false;
    bodyY=-120;
    faceH=130;
  }
}
,
  new CharDef() {
  { 
    name = "coiny"; 
    faceW = 80; 
    faceH = 120; 
    armW = 90;
  }
}
, 
  new CharDef() {
  {
    name="conchshell";
    scale=1.6;
    bodyY=30;
    armW=80;
    armH=55;
    armL=0.6;
    faceH=155;
    faceM=0.3;
    legH=40;
  }
}
, 
  new CharDef() {
  {
    name="crt";
    scale=1.5;
    hasLegs=false;
    isDark=true;
    armH=-20;
    faceW=60;
    armW=100;
    faceH=230;
    faceS=0.8;
    bodyX=-80;
    offX=80;
    faceM=0.1;
    angleM=0.5;
    bodyY=80;
  }
}
,
  new CharDef() {
  { 
    name = "discy"; 
    faceH = 200; 
    bodyY=30;
    armless=true;
    noArms=true;
    faceW=140;
    faceS=0.8;
    faceM=1.1;
    isFlat=true;
    legW=60;
    skewY=0.2;
    angleM=0.3;
  }
}
, 
  new CharDef() {
  { 
    name = "donut"; 
    faceH = 250; 
    hasMouth = false; 
    skewY = .1; 
    armW = 100; 
    armH = 40;
  }
}
, 
  new CharDef() {
  { 
    name = "eggy"; 
    faceW = 90; 
    faceH=220;
    noArms=true;
    armless=true;
    bodyTop=320;
  }
}
,
  new CharDef() {
  { 
    name = "eraser"; 
    faceW = 80; 
    faceH = 180; 
    skewX = .3; 
    bodyX = 10; 
    armW = 90;
  }
}
, 
  new CharDef() {
  { 
    name = "evilleafy"; 
    hasLegs=false;
    noArms=true;
    hasFace=false;
    bodyY=30;
    scale=1.15;
    angleM=0;
    armless=true;
    bodyTop=200;
    bounceS=0;
    hasEvilEyes=true;
    faceH=100;
    faceW=110;
 }
}
, new CharDef() {
  { 
    name = "fanny"; 
    scale=0.8;
    faceW = 70; 
    faceH=180;
    faceM=0.6;
    noArms=true;
    armless=true;
    bodyTop=180;
    bodyX=-40;
    faceX=-70;
    legW=60;
  }
}
,
  new CharDef() {
  { 
    name = "firey"; 
    armW = 110;
  }
}
, 
  new CharDef() {
  {
    name = "flower";
    hasTorso = true;
    bodyY = -175;
    faceH = 350;
    legH=120;
    armW=40;
    armH=80;
    faceW=80;
  }
}
,
  new CharDef() {
  { 
    name = "foldy"; 
    scale=0.7*3;
    faceW = 90; 
    noArms=true;
    armless=true;
    bodyTop=180;
  }
}
, 
  new CharDef() {
  { 
    name = "fries"; 
    armW = 100; 
    armH = 50; 
    faceW = 80;
  }
}
, 
  new CharDef() {
  { 
    name = "gaty"; 
    scale=0.65*3;
    faceW = 90; 
    noArms=true;
    armless=true;
    bodyTop=180;
  }
}
, 
  new CharDef() {
  { 
    name = "gelatin"; 
    faceW = 90; 
    armH = 50;
  }
}
, 
  new CharDef() {
  { 
    name = "golfball"; 
    faceW = 90; 
    noArms=true;
    armless=true;
    bodyTop=180;
  }
}
, 
  new CharDef() {
  {
    name="grassy";
    scale=1.23209823;
    armW=100;
    faceW=80;
    faceS=0.7;
    faceH=120;
  }
}
,
  new CharDef() {
  {
    name="icecube";
    scale=1;
    armW=100;
    faceW=80;
    faceS=0.7;
    faceH=120;
    armless=true;
    noArms=true;
  }
}
,
  new CharDef() {
  {
    name="incometaxreturndocument";
    scale=1.8;
    bodyY=0;
    faceH=180;
    armW=140;
    armH=130;
    skewY=0.2;
  }
}
,
  new CharDef() {
  {
    name="kitchensink";
    scale=1.2;
    bodyY=0;
    faceH=120;
    armW=70;
    armH=70;
    faceW=60;
  }
}
,
  new CharDef() {
  { 
    name = "leafy"; 
    faceW = 90; 
    faceH = 190; 
    legW = 70; 
    bodyY = 20; 
    skewY = .2; 
    armW = 60; 
    armH= 50;
  }
}
, 
  new CharDef() {
  {
    name="leek";
    scale=1.5;
    bodyY=0;
    faceH=160;
    faceW=50;
    armW=40;
    armH=80;
    legW=30;
  }
}
,
  new CharDef() {
  { 
    name = "legobrick"; 
    scale=0.4*3;
    faceW = 100; 
    faceH=140;
    faceM=0.2;
    noArms=true;
    armless=true;
    bodyTop=130;
  }
}
,
  new CharDef() {
  {
    name="lightning";
    scale=1.9;
    hasLegs=false;
    armW=110;
    armH=120;
    faceW=70;
    faceH=210;
    //bodyM=20;
    //faceM=-0.2;
  }
}
,
  new CharDef() {
  {
    name="liy";
    scale=0.701350402*1.2;
    faceW=70;
    faceH=200;
    armW=140;
    faceM=0.7;
    skewY=0.1;
  }
}
,
  new CharDef() {
  { 
    name = "lollipop"; 
    faceW = 80; 
    faceH = 350;
    armH=180;
    armW = 20;
    legW=20;
    legH=60;
    armL=2;
    bodyY=-20;
  }
}
, 
  new CharDef() {
  {
    name="loser";
    scale=1.5;
    faceW=90;
    faceH=150;
    armH=70;
    armW=100;
  }
},
  new CharDef() {
  { 
    name = "marker"; 
    faceW = 70; 
    faceH = 150; 
    armW = 70;
    scale=0.122408797*9;
  }
}
, 
  
  new CharDef() {
  { 
    name = "match"; 
    faceW = 50; 
    faceH = 240; 
    legW = 50; 
    armW = 40; 
    armH = 100;
  }
}
, 
  new CharDef() {
  {
    name="naily";
    scale=0.6*3;
    offX=-50;
    bodyX=80;
    bodyTop=160;
    bodyY=40;
    legW=60;
    faceH=120;
    faceM=0.7;
    noArms=true;
    armless=true;
  }
}
,
  new CharDef() {
  { 
    name = "needle"; 
    faceW = 40; 
    faceH = 290; 
    legW = 20; 
    armW = 15; 
    armH = 110;
  }
}
, 
  new CharDef() {
  {
    name="nickel";
    noArms=true;
    armless=true;
    faceW=90;
    faceH=150;
    bodyTop=160;
    skewY=0.1;
  }
},
  new CharDef() {
  {
    name = "nonexisty";
    noArms=true;
    noDraw=true;
  }
}
,
  new CharDef() {
  {
    name="onigiri";
    scale=1.7;
    bodyY=0;
    faceH=200;
    armW=140;
    armH=30;
    faceS=0.5;
  }
}
,
  new CharDef() {
  {
    name="pda";
    scale=2.2;
    bodyY=0;
    faceH=180;
    armW=125;
    faceW=70;
  }
}
,
  new CharDef() {
  { 
    name = "pen"; 
    faceW = 50; 
    faceH = 240; 
    legW = 50; 
    armW = 30; 
    armH = 100;
  }
}
, 
  new CharDef() {
  { 
    name = "pencil"; 
    faceW = 50; 
    faceH = 270; 
    legW = 50; 
    bodyY = 20; 
    legW = 40; 
    armW = 40; 
    armH = 100;
  }
}
, 
  new CharDef() {
  { 
    name = "pie"; 
    faceW = 100; 
    faceH = 170; 
    armW = 130;
    faceS=0.7;
    scale=0.298227061*5;
  }
}
, 
  new CharDef() {
  { 
    name = "pillow"; 
    faceW = 80; 
    faceH = 180; 
    armW = 110;
    scale=0.250680713*5;
    bodyY=30;
    skewY=0.2;
  }
}
, 
  new CharDef() {
  { 
    name = "pin"; 
    faceW = 70; 
    armW = 90; 
    armH = 80;
  }
}
, 
  new CharDef() {
  {
    name="portablemusicplayer";
    scale=1.2;
    faceX=80;
    bodyX=-80;
    armW=100;
    faceH=100;
    faceW=80;
  }
}
,
  new CharDef() {
  {
    name = "profily";
    isDark=true;
    scale=0.6;
    faceW=60;
    faceH=180;
    armW=60;
  }
}
,
  new CharDef() {
  {
    name="puffball";
    armless=true;
    noArms=true;
    //bodyM=20;
    hasLegs=false;
    bodyY=-120;
    faceH=160;
  }
}
,
  new CharDef() {
  { 
    name = "remote"; 
    faceW = 80; 
    faceH = 120; 
    armW = 110;
    scale=0.338088975*8;
    isDark=true;
    skewY=0.1;
  }
}
, 
  new CharDef() {
  { 
    name = "rocky"; 
    faceW = 80; 
    faceH = 80;
    bodyTop=140;
    noArms=true;
    armless=true;
    bodyY=20;
    bounceS=40;
    faceM=0.4;
  }
}
, 
  new CharDef() {
  {
    name="rubberspatula";
    //scale=1.2;
    //bodyY=30;
    faceH=450;
    faceW=80;
    armW=30;
    armH=200;
    legW=30;
    scale=2.5;
    armL=1.5;
  }
}
,
  new CharDef() {
  { 
    name = "ruby"; 
    bodyY = 30; 
    armW = 70;
  }
}
, 
  new CharDef() {
  { 
    name = "rustycoin"; 
    scale=0.5*4;
    //bodyY = 20; 
    armW = 80;
    faceW=90;
    skewY=0.1;
  }
}
, 
  new CharDef() {
  {
    name="saltlamp";
    bodyTop=250;
    noArms=true;
    armless=true;
    faceH=200;
  }
}
,
  new CharDef() {
  { 
    name = "saw"; 
    faceW = 70; 
    faceH = 200; 
    armW = 45;
    scale=1.08;
    bodyX=30;
    offX=0;
    bodyX=15;
    skewY=0.2;
    legW=40;
    faceM=0.3;
  }
}
,
  new CharDef() {
  {
    name="shampoo";
    isDark=true;
    hasMouth=false;
    scale=2.5;
    faceH=80;
    faceW=60;
    armW=80;
    armH=50;
    skewY=0.1;
  }
}
,
  new CharDef() {
  { 
    name = "slingshot"; 
    scale=0.4*8;
    faceW = 50; 
    faceH = 100; 
    armW = 50;
    armH=80;
  }
}
, 
  new CharDef() {
  { 
    name = "snaredrum"; 
    scale=0.5*4;
    faceW = 90; 
    isDark=true;
    noArms=true;
    armless=true;
    bodyTop=130;
  }
}
, 
  new CharDef() {
  { 
    name = "snowball"; 
    faceW = 120; 
    faceH = 200; 
    armW = 100;
  }
}
, 
  new CharDef() {
  { 
    name = "spongy"; 
    noArms=true;
    armless=true;
    bodyTop=400;
    legW=140;
    faceH=200;
    faceW=120;
  }
}
, 
  new CharDef() {
  { 
    name = "stapy"; 
    bodyY = 30; 
    armW = 70;
    hasLegs=false;
    scale=0.22*15;
    angleM=0.2;
    faceH=240;
    bodyX=220;
    offX=-220;
    armX=-230;
    armH=120;
    faceW=70;
    faceM=0.3;
  }
}
, 
  new CharDef() {
  { 
    name = "steamy"; 
    scale=0.35*8;
    bodyY = 0; 
    armW = 150;
    faceH=120;
  }
}
, 
  new CharDef() {
  { 
    name = "taco"; 
    faceW = 80; 
    faceH = 140; 
    armW = 120;
    scale=0.334177742*5;
    //skewX=0.1;
  }
}
, 
  new CharDef() {
  {
    name="tape";
    scale=0.65;
    armless=true;
    noArms=true;
    faceH=100;
    faceW=80;
    bodyTop=210;
  }
}
,
  new CharDef() {
  { 
    name = "teardrop"; 
    faceW = 80; 
    faceH = 120; 
    armW = 70;
  }
}
, 
  new CharDef() {
  { 
    name = "tennisball"; 
    faceW = 90; 
    faceH=220;
    noArms=true;
    armless=true;
    bodyTop=340;
  }
}
,
  new CharDef() {
  { 
    name = "tree";
    scale=0.390839384*6;
    legW=50;
    faceH=280;
    armW=25;
    armH=70;
  }
}
, 
  new CharDef() {
  { 
    name = "tune";
    legW=40;
    faceH=80;
    armW=30;
    armH=30;
    faceW=80;
    hasMouth=false;
    isDark=true;
  }
}
,
  new CharDef() {
  {
    name="vhs";
    scale=0.4*4;
    armW=180;
    faceH=120;
    faceW=70;
    faceS=0.6;
    skewY=0.1;
  }
}
,
  new CharDef() {
  { 
    name = "woody"; 
    faceH = 180; 
    skewY = .2; 
    armW = 125;
  }
}
,/*
  new CharDef() {
  { 
    name = "winner"; 
    faceH = 120; 
    skewY = .1;
    armW=0;
    armH=80;
    //armL=2;
    noArms=true;
    hasWinnerHand=true;
    scale=0.55;
  }
}
,*/
  };