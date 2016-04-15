
class Sound {
  //attributes
  AudioSample soundFile;
  int minX;
  int minY;
  int maxX;
  int maxY;
  float wordOnPage;
  float totalPageWords;
  float wpm = 1;

  boolean hasPlayed;
  float timeDelay;
  //constructor
  Sound(AudioSample sound, int x1, int y1, int x2, int y2, float wordPos, float total) {
    soundFile = sound;
    minX = x1;
    minY = y1;
    maxX = x2;
    maxY = y2;

    wordOnPage = wordPos;
    totalPageWords = total;

    hasPlayed = false;
  }

  void estimateSoundEffect(float wordsPerMinute, float timePageLoaded) { 
    wpm = wordsPerMinute; // since delay is in milliseconds , must multiply
    timeDelay = (totalPageWords/wpm)*(wordOnPage/totalPageWords)*60000;
    //delay(int(timeDelay)); // delay sound based on estimated reading pace
    
    // if current time is >= the timeDelay, play the sound
    if (millis() >= (timePageLoaded + timeDelay)){
      soundFile.trigger();
      delay(soundFile.length()); // delay and stop needed to prevent continuously playing sound file. (Play only once at a time)
      soundFile.stop(); // delay in milliseconds, soundfile.length in milliseconds too
      hasPlayed = true;
    }
    println("");
    println("totalPageWords="+totalPageWords);
    println("wordOnPage="+wordOnPage);
    println("WPM="+wpm);
    println("timeDelay="+timeDelay);
    println("soundFile length="+soundFile.length());
    println("hasPlayed="+hasPlayed);
  }

  void checkSoundTriggered() {
    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
      soundFile.trigger();
      delay(soundFile.length()); // delay and stop needed to prevent continuously playing sound file. (Play only once at a time)
      soundFile.stop();
    }
  }
}