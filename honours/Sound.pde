
class Sound {
  //attributes
  AudioSample soundFile;
  int minX;
  int minY;
  int maxX;
  int maxY;

  //constructor
  Sound(AudioSample sound, int x1, int y1, int x2, int y2) {
    soundFile = sound;
    minX = x1;
    minY = y1;
    maxX = x2;
    maxY = y2;
  }

  void checkSoundTriggered() {
    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
      soundFile.trigger();
      delay(soundFile.length()); // delay and stop needed to prevent continuously playing sound file. (Play only once at a time)
      soundFile.stop();
    }
  }
}