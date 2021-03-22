import netP5.*;
import oscP5.*;
import processing.video.*;
import com.hamoid.*;

Capture video;
OscP5 osc;
NetAddress supercollider;
VideoExport videoExport;

int x = 0;
int rectSize = 50;
float[] xRed;
float[] xGreen;
float[] xBlue;
float[] xBright;
float t = 0;
float dt = 0.05;
int xx = 0;
int yy = 0; 
int dp;
boolean expVideoFlag = false;
boolean sendOSCFlag = true;
int graphSize = 150;
int pointSize = 5;

void setup() {
  size(640,480);
  frameRate(30);
  osc = new OscP5(this,12000);
  supercollider = new NetAddress("127.0.0.1",57120);
  video = new Capture(this,width,height);
  video.start();
  xRed = new float[rectSize*rectSize];
  xGreen = new float[rectSize*rectSize];
  xBlue = new float[rectSize*rectSize];
  xBright = new float[rectSize*rectSize];
  dp = 30;
  if(expVideoFlag){
    videoExport = new VideoExport(this);
    videoExport.startMovie();
  }
  xx = width/2;
  yy = height/4;
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  image(video,0,0,width+rectSize,height+rectSize);
  loadPixels();
    int idxArray = 0;
    for (int x = 0; x < rectSize; x++) {
      for (int y = 0; y < rectSize; y++) {
        int loc = xx + x + (yy + y)*(width);
        xRed[idxArray] = red(pixels[loc]);
        xGreen[idxArray] = green(pixels[loc]);
        xBlue[idxArray] = blue(pixels[loc]);
        idxArray++;
      }
    }
  updatePixels();  
  stroke(255);
  noFill();
  strokeWeight(4);
  rect(xx,yy,rectSize/2,rectSize);
  if(sendOSCFlag){
    OscMessage msgR = new OscMessage("/xRed");
    msgR.add(xRed);
    osc.send(msgR,supercollider); 
    OscMessage msgG = new OscMessage("/xGreen");
    msgG.add(xGreen);
    osc.send(msgG,supercollider); 
    OscMessage msgB = new OscMessage("/xBlue");
    msgB.add(xBlue);
    osc.send(msgB,supercollider);
  }
  fill(0);
  noStroke();
  rect(0,height-graphSize,width,graphSize);
  for (int idx = 0; idx < width; idx++) {
    fill(color(255,0,0));
    ellipse(idx,map(xRed[idx],0,255,height,height-graphSize),pointSize,pointSize);
    fill(color(0,255,0));
    ellipse(idx,map(xGreen[idx],0,255,height,height-graphSize),pointSize,pointSize);
    fill(color(0,0,255));
    ellipse(idx,map(xBlue[idx],0,255,height,height-graphSize),pointSize,pointSize);
  };
  if(expVideoFlag){
    videoExport.saveFrame();
  }
  
}

void keyPressed() {
  if (key == 'q') {
    if(expVideoFlag){
      videoExport.endMovie();
    }
    exit();
  }
}
