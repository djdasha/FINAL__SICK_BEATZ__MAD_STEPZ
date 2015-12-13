import processing.serial.*;
import cc.arduino.*;

import processing.sound.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;

AudioPlayer soundfile1;
AudioPlayer soundfile2;
AudioPlayer soundfile3;
AudioPlayer soundfile4;


Arduino arduino;

//setup for the generative art
int num = 30;
float incr = 1.3, decr = 0.8, v=2.0;
PVector[] loc = new PVector[num];
PVector[] vel = new PVector[num];
float[] sz = new float[num];

void setup() {
  size(800, 600);
  minim = new Minim(this);
  soundfile1 = minim.loadFile("beat1.wav");
  soundfile2 = minim.loadFile("beat2.wav");
  soundfile3 = minim.loadFile("voice.wav");
  soundfile4 = minim.loadFile("drums.wav");

  frame.setResizable(true);
  frameRate(10);

  initStuff();
  clearScreen();

  //save the audio as
  minim = new Minim(this);
  in = minim.getLineIn();
  recorder = minim.createRecorder(in, "sick_beatz_mad_stepz15.wav");

  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[1], 57600);
}

void draw() {
  if (frameCount%150==0) {
    background(0);
    //fill(0);
    //noStroke();
    //rect(0, 0, width, height);
  }
  for (int i=0; i<loc.length; i++) {
    loc[i].add(vel[i]);
    if (loc[i].x > width-sz[i]/2 || loc[i].x<sz[i]/2) {
      vel[i].x = -vel[i].x;
    }
    if (loc[i].y > height-sz[i]/2 || loc[i].y<sz[i]/2) {
      vel[i].y = -vel[i].y;
    }
  }
  drawElement();

  //record audio
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  } else
  {
    text("Not recording.", 5, 15);
  }

  int sensor1=arduino.analogRead(3);
  int sensor2=arduino.analogRead(2);
  int sensor3=arduino.analogRead(4);
  int sensor4=arduino.analogRead(5);


  if (sensor1<950 && sensor2<1000 && sensor3<1000 && sensor4<830) {
    initStuff();
  }

  if (sensor1>950) {
    if (!soundfile1.isPlaying()) {
      soundfile1.loop();
    } 
    //initStuff();
  } else {
    soundfile1.pause();
  }
  if (sensor2>1000) {
    if (!soundfile2.isPlaying()) {
      soundfile2.loop();
    } 
    //initStuff();
  } else {
    soundfile2.pause();
  }
  if (sensor3>1000) {
    if (!soundfile3.isPlaying()) {
      soundfile3.loop();
    } 
    
  } else {
    soundfile3.pause();
    //initStuff();
  }
  
  
  if (sensor4>810) { //pin5
    if (!soundfile4.isPlaying()) {
      soundfile4.loop();
    } 
  }
  else {
    soundfile4.pause();
  //  clearScreen();
    //initStuff();
  }
  

  //println(sensor1);
  //println(sensor2); //two gray wires
  //println(sensor3);
  println(sensor4);
}

void drawElement() {
  for (int i=0; i<loc.length; i++) {
    stroke(255, 20);
    for (int j=0; j<loc.length; j++) {
      float distance=dist(loc[i].x, loc[i].y, loc[j].x, loc[j].y);
      float proximity=(sz[i]+sz[j])/2;
      if (distance<proximity) {
        if (i != j) line(loc[i].x, loc[i].y, loc[j].x, loc[j].y);
      }
    }
  }
}

void keyReleased() {
  if ( key == 'd' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of whatever 
    // has been recorded so far.
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    } else 
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}

void clearScreen() {
 //background(0); 
}

void initStuff() {
  background(0);
  for (int i=0; i<num; i++) {
    sz[i] = random(width/10, width/5);
    float x = random(sz[i], width-sz[i]);
    float y = random(sz[i], height-sz[i]);
    loc[i] = new PVector(x, y);
    vel[i] = new PVector(random(-v, v), random(-v, v));
  }
}