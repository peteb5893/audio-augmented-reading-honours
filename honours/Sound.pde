
class Sound {
  //attributes
  AudioSample soundFile;
  int minX;
  int minY;
  int maxX;
  int maxY;
  int wordOnPage;
  int totalPageWords;
  int wpm = 1;

  boolean hasPlayed;

  //constructor
  Sound(AudioSample sound, int x1, int y1, int x2, int y2, int wordPos, int total) {
    soundFile = sound;
    minX = x1;
    minY = y1;
    maxX = x2;
    maxY = y2;

    wordOnPage = wordPos;
    totalPageWords = total;

    hasPlayed = false;
  }

  void estimateSoundEffect(int wordsPerMinute) { 
    wpm = wordsPerMinute; // since delay is in milliseconds , must multiply
    delay((totalPageWords/wpm)*(wordOnPage/totalPageWords)*60000); // delay sound based on estimated reading pace
    soundFile.trigger();
    delay(soundFile.length()); // delay and stop needed to prevent continuously playing sound file. (Play only once at a time)
    soundFile.stop(); // delay in milliseconds, soundfile.length in milliseconds too
    hasPlayed = true;
  }

  void checkSoundTriggered() {
    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
      soundFile.trigger();
      delay(soundFile.length()); // delay and stop needed to prevent continuously playing sound file. (Play only once at a time)
      soundFile.stop();
    }
  }
}