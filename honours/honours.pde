//libraries //<>//
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//global variables
int state;
int technique;

//variables needed for start menu (State 0)
PFont f;
int topX = 20;
int topY = 0;
int bottomX = 842;//width-30;
int bottomY = 590;//height-30;
String title = "Encouraging Literacy Through Audio Augmented Reading";
String techniqueTitle;
String bodyText;
String instructions = "\n\nYou may read the story at your own pace,"+
  " using the ENTER button to go to the next page and the BACKSPACE button to return to the previous page."+
  "\nAfter you have finished, you will be asked to complete a questionnaire and NASA TLX form before moving onto the next technique."+
  "\n\nNow, please select the book by pressing the number key as instructed. This may take a moment to load the required resources.";

//variables needed for all books
int imageIndex;
PImage currentImage;
ArrayList <Sound> currentSounds;
Minim minim;
String absoluteImagePath;
String absoluteSoundPath;
String absoluteAudiobookPath;
int pageLimit;
Book currentBook = new Book();
float timePageLoaded;

//variables needed for eyetracker
boolean mouseVisible;

//variables needed for estimating reading pace
float wpm;
float result;
float participantWPM;
float timerStart = 0;
float offset;
float mill;
//float hundredths;
float seconds;
//float minutes;
boolean stopped = true;
boolean continued = false;

//variables needed for the Thomas book (State 1)
AudioSample beep;
AudioSample bird_noise;
AudioSample cow_moo;
AudioSample goat_noise;
AudioSample human_moo;
AudioSample oh_no_my_hat;
AudioSample there_goes_my_timber;
AudioSample train;

//variables needed for the Biscuit book (State 2)
AudioSample dog;
AudioSample cat;
AudioSample cricket;

//variables needed for the What's That Noise? book (State 3)
AudioSample tweet_tweet;
AudioSample shush;
AudioSample woof_woof;
AudioSample baa;
AudioSample zzz;
AudioSample rawr;

//variables needed for the The Haunted House book (State 4)
AudioSample thunder_bang;
AudioSample bob_bob;
AudioSample snake_hiss;
AudioSample aargh;
AudioSample turtle_noise;
AudioSample cat_scream;
AudioSample rat_shut_up;
AudioSample dog_bark;


// initial setup
void setup() {
  size(872, 635);
  state = 0;
  startState();
}

// decides which state to load
void setState(int newState) {
  state = newState;
  startState();
}

void startState() {
  switch (state) {
  case 0:
    setup0();
    break;
  case 1:
    setup1();
    break;
  case 2:
    setup2();
    break;
  case 3:
    setup3();
    break;
  case 4:
    setup4();
    break;
  case 5:
    setup5();
    break;
  case 6:
    setup6();
    break;
  case 7:
    setup7();
    break;
  case 8:
    setup8();
    break;
  case 9:
    setup9();
    break;
  }
}

void draw() {
  switch (state) {
  case 0:
    draw0();
    break;
  case 1:
    checkTechnique();
    break;
  case 2:
    checkTechnique();
    break;
  case 3:
    checkTechnique();
    break;
  case 4:
    checkTechnique();
    break;

  case 5:
    draw5();
    break;
  case 6:
    draw6();
    break;
  case 7:
    draw7();
    break;
  case 8:
    draw8();
    break;
  case 9:
    draw9();
    break;
  }
}

void keyPressed() {
  // if on the menu state should be able to choose a technique
  if (state == 0) {
    if (key == '6') {
      technique = 1;
      println("Traditional Reading Selected");
      setState(6);
    } else if (key == '7') {
      technique = 2;
      println("Audio with Eye Tracker Selected");
      setState(7);
    } else if (key == '8') {
      technique = 3;
      println("Audio Book Selected");
      setState(8);
    } else if (key == '9') {
      technique = 4;
      println("Estimated Reading Pace Selected");
      setState(9);
    }
  }

  // once a technique has been chosen a book must be selected
  else if (state == 6 || state == 7 || state == 8 || state == 9) {
    if (state == 9) {
      // ========================Controlling the timer for estimating reading pace ========================
      if (key==' ' && stopped) { // start when SPACEBAR pressed
        println("Timer Started");
        stopped = false;
        continued = false;
        timerStart = millis();
      }
      if (key == ENTER && !stopped) { // stop when ENTER pressed
        println("Timer Stopped");
        stopped = true;
      }        
      //===================================================================================================
    } 
    if (key == '0') {
      println("Main Menu Selected");
      setState(0);
    } else if (key == '1') {
      println("Happy Birthday Thomas Selected");
      setState(1);
    } else if (key == '2') {
      println("Biscuit Wants to Play Selected");
      setState(2);
    } else if (key == '3') {
      println("What's That Noise? Selected");
      setState(3);
    } else if (key == '4') {
      println("The Haunted House Selected");
      setState(4);
    }
  }
  // for all books, ENTER for next page, BACKSPACE for previous page
  else if (state == 1 | state == 2 | state == 3 | state == 4) {
    if (0<=imageIndex && imageIndex<pageLimit) {
      // allow user to toggle visibility of mouse (for eyetracker mostly) by using the SPACEBAR
      if (key == ' ') {
        if (mouseVisible) {
          mouseVisible = false;
          noCursor(); // hide cursor since will be using the eye tracker (won't work in presentation mode though)
        } else {
          mouseVisible = true;
          cursor();
        }
      }

      if (key == ENTER) {
        imageIndex++; // if ENTER button pressed, move to next image in array
        currentImage = currentBook.pages.get(imageIndex).pageImage;      
        currentSounds = currentBook.pages.get(imageIndex).sounds;
        //println("imageIndex = " + imageIndex);
        timePageLoaded = millis();
        //println("timePageLoaded="+timePageLoaded);
      } else if (key == BACKSPACE) {
        imageIndex--; // if BACKSPACE button pressed, move back to previous image
        currentImage = currentBook.pages.get(imageIndex).pageImage;      
        currentSounds = currentBook.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      }
    } else if (imageIndex>=pageLimit && key == ENTER) {
      println("End Of Session");
      setState(5);
    }
  }

  // once the participant has completed the questionnaires press ENTER or 0 to return to Main Menu
  else if (state == 5) {
    if (key == ENTER || key == '0') {
      println("Return to Main Menu");
      setState(0);
    }
  }
}

//========================================== Main Menu
void setup0() {
  background(255);
  f = createFont("Arial", 36, true);
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text(title, topX, topY, bottomX, bottomY);

  textFont(f, 24);
  textAlign(LEFT);
  bodyText = "This program has been built by Peter Bennington for his research-oriented honours project. Its purpose is to allow participants in the study to try out four different reading techniques and give feedback on their experiences and preferences. The reading techniques being evaluated in this particular study are:\n - Traditional Reading\n - Audio-Augmented Reading using Eyetracking\n - Audiobook\n - Audio-Augmented Reading using Estimated Reading-Pace\n\nPlease press the key on the keyboard to select the technique.";
  text(bodyText, topX, topY+120, bottomX, bottomY);
}
void draw0() {
}

//========================================== Book 1 - Happy Birthday Thomas
void setup1() {

  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/ThomasBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/ThomasBook/sounds/";
  absoluteAudiobookPath = "/Users/peterbennington/git/audio-augmented-reading-honours/ThomasBook/audiobook/";
  pageLimit = 15;

  minim = new Minim(this);
  beep = minim.loadSample(absoluteSoundPath+"beep.mp3");
  bird_noise = minim.loadSample(absoluteSoundPath+"bird_noise.mp3");
  cow_moo = minim.loadSample(absoluteSoundPath+"cow_moo.mp3");
  goat_noise = minim.loadSample(absoluteSoundPath+"goat_noise.mp3");
  human_moo = minim.loadSample(absoluteSoundPath+"moo_human.mp3");
  oh_no_my_hat = minim.loadSample(absoluteSoundPath+"hat.mp3");
  there_goes_my_timber = minim.loadSample(absoluteSoundPath+"timber.mp3");
  train = minim.loadSample(absoluteSoundPath+"train.mp3");


  Page hBTPage1 = new Page(absoluteImagePath+"thomas1.png");  
  currentBook.addNewPage(hBTPage1);

  Page hBTPage2 = new Page(absoluteImagePath+"thomas2.png");   
  Sound hBTSound1 = new Sound(beep, 36, 40, 210, 63, 1, 16);
  hBTPage2.addNewSound(hBTSound1);
  currentBook.addNewPage(hBTPage2);

  Page hBTPage3 = new Page(absoluteImagePath+"thomas3.png");   
  currentBook.addNewPage(hBTPage3);

  Page hBTPage4 = new Page(absoluteImagePath+"thomas4.png");   
  currentBook.addNewPage(hBTPage4);

  Page hBTPage5 = new Page(absoluteImagePath+"thomas5.png");   
  currentBook.addNewPage(hBTPage5);

  Page hBTPage6 = new Page(absoluteImagePath+"thomas6.png");   
  Sound hBTSound2 = new Sound(oh_no_my_hat, 244, 56, 344, 80, 3, 12);
  hBTPage6.addNewSound(hBTSound2);
  Sound hBTSound3 = new Sound(goat_noise, 240, 360, 356, 389, 6, 12);
  hBTPage6.addNewSound(hBTSound3);
  Sound hBTSound4 = new Sound(there_goes_my_timber, 686, 53, 789, 78, 9, 12);
  hBTPage6.addNewSound(hBTSound4);
  Sound hBTSound5 = new Sound(bird_noise, 693, 361, 772, 382, 12, 12);
  hBTPage6.addNewSound(hBTSound5);
  currentBook.addNewPage(hBTPage6);

  Page hBTPage7 = new Page(absoluteImagePath+"thomas7.png");   
  currentBook.addNewPage(hBTPage7);

  Page hBTPage8 = new Page(absoluteImagePath+"thomas8.png");   
  currentBook.addNewPage(hBTPage8);

  Page hBTPage9 = new Page(absoluteImagePath+"thomas9.png");   
  currentBook.addNewPage(hBTPage9);

  Page hBTPage10 = new Page(absoluteImagePath+"thomas10.png");   
  Sound hBTSound6 = new Sound(cow_moo, 105, 69, 197, 102, 4, 15);
  hBTPage10.addNewSound(hBTSound6);
  Sound hBTSound7 = new Sound(human_moo, 556, 142, 617, 162, 14, 15);
  hBTPage10.addNewSound(hBTSound7);
  currentBook.addNewPage(hBTPage10);  

  Page hBTPage11 = new Page(absoluteImagePath+"thomas11.png");   
  currentBook.addNewPage(hBTPage11);

  Page hBTPage12 = new Page(absoluteImagePath+"thomas12.png");   
  Sound hBTSound8 = new Sound(train, 623, 39, 700, 59, 12, 13);
  hBTPage12.addNewSound(hBTSound8);
  currentBook.addNewPage(hBTPage12);

  Page hBTPage13 = new Page(absoluteImagePath+"thomas13.png");   
  currentBook.addNewPage(hBTPage13);

  Page hBTPage14 = new Page(absoluteImagePath+"thomas14.png");   
  currentBook.addNewPage(hBTPage14);  

  Page hBTPage15 = new Page(absoluteImagePath+"thomas15.png");   
  currentBook.addNewPage(hBTPage15);

  Page hBTPage16 = new Page(absoluteImagePath+"thomas16.png");   
  currentBook.addNewPage(hBTPage16);

  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = currentBook.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;

  //if using audiobook, need the full audio to play on page load
  if (technique == 3) {
    AudioSample audioBook = minim.loadSample(absoluteAudiobookPath+"happyBirthdayThomas.mp3");
    audioBook.trigger();
  }
}

void checkTechnique() {
  //all techniques need to update the image
  image(currentImage, 0, 0);

  //if using eyetracker, need to check if sounds get triggered
  if (technique == 2) {
    for (int i=0; i<currentSounds.size(); i++) {
      currentSounds.get(i).checkSoundTriggered();
    }
  }

  //if using estimated reading pace, need to play sounds based on wpm
  else if (technique == 4) {
    for (int i=0; i<currentSounds.size(); i++) {
      if (currentSounds.get(i).hasPlayed == false) {
        currentSounds.get(i).estimateSoundEffect(result, timePageLoaded);
      }
    }
  }
}

//========================================== Book 2 - Biscuit Wants to Play
void setup2() {
  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/biscuitBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/biscuitBook/sounds/";
  absoluteAudiobookPath = "/Users/peterbennington/git/audio-augmented-reading-honours/biscuitBook/audiobook/";
  pageLimit = 11;

  minim = new Minim(this);
  dog = minim.loadSample(absoluteSoundPath+"dog.mp3");
  cat = minim.loadSample(absoluteSoundPath+"cat.mp3");
  cricket = minim.loadSample(absoluteSoundPath+"cricket.mp3");


  Page biscuitPage1 = new Page(absoluteImagePath+"biscuit1.png");
  currentBook.addNewPage(biscuitPage1);

  Page biscuitPage2 = new Page(absoluteImagePath+"biscuit2.png");
  Sound biscuitSound1 = new Sound(dog, 526, 462, 666, 482, 1, 7);
  biscuitPage2.addNewSound(biscuitSound1);
  currentBook.addNewPage(biscuitPage2);

  Page biscuitPage3 = new Page(absoluteImagePath+"biscuit3.png");
  Sound biscuitSound2 = new Sound(cat, 161, 490, 246, 522, 1, 9);
  Sound biscuitSound3 = new Sound(cat, 515, 83, 676, 108, 4, 9);
  biscuitPage3.addNewSound(biscuitSound2);
  biscuitPage3.addNewSound(biscuitSound3);
  currentBook.addNewPage(biscuitPage3);

  Page biscuitPage4 = new Page(absoluteImagePath+"biscuit4.png");
  Sound biscuitSound4 = new Sound(dog, 516, 47, 660, 68, 1, 9);
  biscuitPage4.addNewSound(biscuitSound4);
  currentBook.addNewPage(biscuitPage4);

  Page biscuitPage5 = new Page(absoluteImagePath+"biscuit5.png");
  Sound biscuitSound5 = new Sound(cat, 91, 415, 254, 447, 1, 17);
  Sound biscuitSound6 = new Sound(dog, 494, 472, 641, 498, 11, 17);
  biscuitPage5.addNewSound(biscuitSound5);
  biscuitPage5.addNewSound(biscuitSound6);
  currentBook.addNewPage(biscuitPage5);

  Page biscuitPage6 = new Page(absoluteImagePath+"biscuit6.png");
  Sound biscuitSound7 = new Sound(dog, 107, 452, 186, 481, 1, 12);
  Sound biscuitSound8 = new Sound(cat, 504, 466, 669, 490, 6, 12);
  biscuitPage6.addNewSound(biscuitSound7);
  biscuitPage6.addNewSound(biscuitSound8);
  currentBook.addNewPage(biscuitPage6);

  Page biscuitPage7 = new Page(absoluteImagePath+"biscuit7.png");
  Sound biscuitSound9 = new Sound(dog, 82, 452, 235, 287, 1, 14);
  Sound biscuitSound10 = new Sound(cat, 481, 47, 652, 77, 8, 14);
  biscuitPage7.addNewSound(biscuitSound9);
  biscuitPage7.addNewSound(biscuitSound10);
  currentBook.addNewPage(biscuitPage7);

  Page biscuitPage8 = new Page(absoluteImagePath+"biscuit8.png");
  Sound biscuitSound11 = new Sound(cat, 132, 484, 304, 518, 1, 8);
  biscuitPage8.addNewSound(biscuitSound11);
  currentBook.addNewPage(biscuitPage8);

  Page biscuitPage9 = new Page(absoluteImagePath+"biscuit9.png");
  Sound biscuitSound12 = new Sound(cat, 97, 446, 272, 483, 1, 14);
  Sound biscuitSound13 = new Sound(dog, 651, 81, 735, 111, 10, 14);
  biscuitPage9.addNewSound(biscuitSound12);
  biscuitPage9.addNewSound(biscuitSound13);
  currentBook.addNewPage(biscuitPage9);

  Page biscuitPage10 = new Page(absoluteImagePath+"biscuit10.png");
  Sound biscuitSound14 = new Sound(dog, 478, 491, 698, 517, 1, 8);
  biscuitPage10.addNewSound(biscuitSound14);
  currentBook.addNewPage(biscuitPage10);

  Page biscuitPage11 = new Page(absoluteImagePath+"biscuit11.png");
  Sound biscuitSound15 = new Sound(dog, 244, 248, 396, 288, 1, 9);
  biscuitPage11.addNewSound(biscuitSound15);
  currentBook.addNewPage(biscuitPage11);

  Page biscuitPage12 = new Page(absoluteImagePath+"biscuit12.png");
  Sound biscuitSound16 = new Sound(cat, 95, 62, 273, 96, 1, 10);
  biscuitPage12.addNewSound(biscuitSound16);
  currentBook.addNewPage(biscuitPage12);

  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = currentBook.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;

  //if using audiobook, need the full audio to play on page load
  if (technique == 3) {
    AudioSample audioBook = minim.loadSample(absoluteAudiobookPath+"biscuitWantsToPlay.mp3");
    audioBook.trigger();
  }
}

//========================================== Book 3 - What's That Noise?
void setup3() {
  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/WhatsThatNoiseBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/WhatsThatNoiseBook/sounds/";
  absoluteAudiobookPath = "/Users/peterbennington/git/audio-augmented-reading-honours/WhatsThatNoiseBook/audiobook/";
  pageLimit = 24;

  minim = new Minim(this);
  tweet_tweet = minim.loadSample(absoluteSoundPath+"tweet_tweet.mp3");
  shush = minim.loadSample(absoluteSoundPath+"shush.mp3");
  woof_woof = minim.loadSample(absoluteSoundPath+"woof_woof.mp3");
  baa = minim.loadSample(absoluteSoundPath+"baa.mp3");
  zzz = minim.loadSample(absoluteSoundPath+"zzz.mp3");
  rawr = minim.loadSample(absoluteSoundPath+"rawr.mp3"); // not used


  Page wTNPage1 = new Page(absoluteImagePath+"whatsThatNoise1.png");  
  currentBook.addNewPage(wTNPage1);

  Page wTNPage2 = new Page(absoluteImagePath+"whatsThatNoise2.png");
  Sound wTNSound1 = new Sound(tweet_tweet, 344, 520, 549, 548, 1, 2);
  wTNPage2.addNewSound(wTNSound1); 
  currentBook.addNewPage(wTNPage2);

  Page wTNPage3 = new Page(absoluteImagePath+"whatsThatNoise3.png");
  currentBook.addNewPage(wTNPage3);

  Page wTNPage4 = new Page(absoluteImagePath+"whatsThatNoise4.png");
  currentBook.addNewPage(wTNPage4);

  Page wTNPage5 = new Page(absoluteImagePath+"whatsThatNoise5.png");
  currentBook.addNewPage(wTNPage5);

  Page wTNPage6 = new Page(absoluteImagePath+"whatsThatNoise6.png");
  Sound wTNSound2 = new Sound(shush, 389, 518, 492, 543, 1, 2);
  wTNPage6.addNewSound(wTNSound2); 
  currentBook.addNewPage(wTNPage6);

  Page wTNPage7 = new Page(absoluteImagePath+"whatsThatNoise7.png");
  Sound wTNSound3 = new Sound(woof_woof, 347, 520, 542, 551, 1, 1);
  wTNPage7.addNewSound(wTNSound3); 
  currentBook.addNewPage(wTNPage7);

  Page wTNPage8 = new Page(absoluteImagePath+"whatsThatNoise8.png");
  currentBook.addNewPage(wTNPage8);

  Page wTNPage9 = new Page(absoluteImagePath+"whatsThatNoise9.png");
  currentBook.addNewPage(wTNPage9);

  Page wTNPage10 = new Page(absoluteImagePath+"whatsThatNoise10.png");
  currentBook.addNewPage(wTNPage10);

  Page wTNPage11 = new Page(absoluteImagePath+"whatsThatNoise11.png");
  currentBook.addNewPage(wTNPage11);

  Page wTNPage12 = new Page(absoluteImagePath+"whatsThatNoise12.png");
  Sound wTNSound4 = new Sound(shush, 384, 518, 495, 547, 1, 1);
  wTNPage12.addNewSound(wTNSound4); 
  currentBook.addNewPage(wTNPage12);

  Page wTNPage13 = new Page(absoluteImagePath+"whatsThatNoise13.png");
  Sound wTNSound5 = new Sound(baa, 398, 513, 492, 555, 1, 1);
  wTNPage13.addNewSound(wTNSound5); 
  currentBook.addNewPage(wTNPage13);

  Page wTNPage14 = new Page(absoluteImagePath+"whatsThatNoise14.png");
  currentBook.addNewPage(wTNPage14);

  Page wTNPage15 = new Page(absoluteImagePath+"whatsThatNoise15.png");
  currentBook.addNewPage(wTNPage15);

  Page wTNPage16 = new Page(absoluteImagePath+"whatsThatNoise16.png");
  currentBook.addNewPage(wTNPage16);

  Page wTNPage17 = new Page(absoluteImagePath+"whatsThatNoise17.png");
  currentBook.addNewPage(wTNPage17);

  Page wTNPage18 = new Page(absoluteImagePath+"whatsThatNoise18.png");
  Sound wTNSound6 = new Sound(shush, 376, 512, 508, 554, 1, 1);
  wTNPage18.addNewSound(wTNSound6); 
  currentBook.addNewPage(wTNPage18);

  Page wTNPage19 = new Page(absoluteImagePath+"whatsThatNoise19.png");
  Sound wTNSound7 = new Sound(zzz, 316, 516, 586, 546, 1, 2);
  wTNPage19.addNewSound(wTNSound7); 
  currentBook.addNewPage(wTNPage19);

  Page wTNPage20 = new Page(absoluteImagePath+"whatsThatNoise20.png");
  currentBook.addNewPage(wTNPage20);

  Page wTNPage21 = new Page(absoluteImagePath+"whatsThatNoise21.png");
  currentBook.addNewPage(wTNPage21);

  Page wTNPage22 = new Page(absoluteImagePath+"whatsThatNoise22.png");
  currentBook.addNewPage(wTNPage22);

  Page wTNPage23 = new Page(absoluteImagePath+"whatsThatNoise23.png");
  currentBook.addNewPage(wTNPage23);

  Page wTNPage24 = new Page(absoluteImagePath+"whatsThatNoise24.png");
  currentBook.addNewPage(wTNPage24);

  Page wTNPage25 = new Page(absoluteImagePath+"whatsThatNoise25.png");
  Sound wTNSound8 = new Sound(zzz, 546, 521, 655, 544, 6, 6);
  wTNPage25.addNewSound(wTNSound8); 
  currentBook.addNewPage(wTNPage25);

  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = currentBook.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;

  //if using audiobook, need the full audio to play on page load
  if (technique == 3) {
    AudioSample audioBook = minim.loadSample(absoluteAudiobookPath+"whatsThatNoise.mp3");
    audioBook.trigger();
  }
}

//========================================== Book 4 - The Haunted House
void setup4() {
  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/TheHauntedHouseBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/TheHauntedHouseBook/sounds/";
  absoluteAudiobookPath = "/Users/peterbennington/git/audio-augmented-reading-honours/TheHauntedHouseBook/audiobook/";
  pageLimit = 19;

  minim = new Minim(this);
  thunder_bang = minim.loadSample(absoluteSoundPath+"thunder_bang.mp3");
  bob_bob = minim.loadSample(absoluteSoundPath+"bob_bob.mp3");
  snake_hiss = minim.loadSample(absoluteSoundPath+"snake_hiss.mp3");
  aargh = minim.loadSample(absoluteSoundPath+"aargh.mp3");
  turtle_noise = minim.loadSample(absoluteSoundPath+"turtle_noise.mp3");
  cat_scream = minim.loadSample(absoluteSoundPath+"cat_scream.mp3");
  rat_shut_up = minim.loadSample(absoluteSoundPath+"rat_shut_up.mp3");
  dog_bark = minim.loadSample(absoluteSoundPath+"dog_bark.mp3");


  Page tHHPage1 = new Page(absoluteImagePath+"theHauntedHouse1.png");
  currentBook.addNewPage(tHHPage1);

  Page tHHPage2 = new Page(absoluteImagePath+"theHauntedHouse2.png");
  currentBook.addNewPage(tHHPage2);

  Page tHHPage3 = new Page(absoluteImagePath+"theHauntedHouse3.png");
  Sound tHHSound1 = new Sound(thunder_bang, 414, 520, 509, 547, 4, 8);
  tHHPage3.addNewSound(tHHSound1);
  currentBook.addNewPage(tHHPage3);

  Page tHHPage4 = new Page(absoluteImagePath+"theHauntedHouse4.png");
  currentBook.addNewPage(tHHPage4);

  Page tHHPage5 = new Page(absoluteImagePath+"theHauntedHouse5.png");
  currentBook.addNewPage(tHHPage5);

  Page tHHPage6 = new Page(absoluteImagePath+"theHauntedHouse6.png");
  currentBook.addNewPage(tHHPage6);

  Page tHHPage7 = new Page(absoluteImagePath+"theHauntedHouse7.png");
  currentBook.addNewPage(tHHPage7);

  Page tHHPage8 = new Page(absoluteImagePath+"theHauntedHouse8.png");
  Sound tHHSound2 = new Sound(bob_bob, 364, 517, 545, 548, 1, 2);
  tHHPage8.addNewSound(tHHSound2);
  currentBook.addNewPage(tHHPage8);

  Page tHHPage9 = new Page(absoluteImagePath+"theHauntedHouse9.png");
  Sound tHHSound3 = new Sound(snake_hiss, 675, 522, 769, 550, 10, 10);
  tHHPage9.addNewSound(tHHSound3);
  currentBook.addNewPage(tHHPage9);

  Page tHHPage10 = new Page(absoluteImagePath+"theHauntedHouse10.png");
  currentBook.addNewPage(tHHPage10);

  Page tHHPage11 = new Page(absoluteImagePath+"theHauntedHouse11.png");
  Sound tHHSound4 = new Sound(aargh, 393, 518, 519, 554, 1, 1);
  tHHPage11.addNewSound(tHHSound4);
  currentBook.addNewPage(tHHPage11);

  Page tHHPage12 = new Page(absoluteImagePath+"theHauntedHouse12.png");
  currentBook.addNewPage(tHHPage12);

  Page tHHPage13 = new Page(absoluteImagePath+"theHauntedHouse13.png");
  currentBook.addNewPage(tHHPage13);

  Page tHHPage14 = new Page(absoluteImagePath+"theHauntedHouse14.png");
  currentBook.addNewPage(tHHPage14);

  Page tHHPage15 = new Page(absoluteImagePath+"theHauntedHouse15.png");
  Sound tHHSound5 = new Sound(turtle_noise, 454, 516, 559, 549, 6, 8);
  tHHPage15.addNewSound(tHHSound5);
  currentBook.addNewPage(tHHPage15);

  Page tHHPage16 = new Page(absoluteImagePath+"theHauntedHouse16.png");
  currentBook.addNewPage(tHHPage16);

  Page tHHPage17 = new Page(absoluteImagePath+"theHauntedHouse17.png");
  Sound tHHSound6 = new Sound(cat_scream, 210, 520, 275, 550, 1, 8);
  tHHPage17.addNewSound(tHHSound6);
  currentBook.addNewPage(tHHPage17);

  Page tHHPage18 = new Page(absoluteImagePath+"theHauntedHouse18.png");
  Sound tHHSound7 = new Sound(rat_shut_up, 379, 511, 527, 552, 1, 2);
  tHHPage18.addNewSound(tHHSound7);
  currentBook.addNewPage(tHHPage18);

  Page tHHPage19 = new Page(absoluteImagePath+"theHauntedHouse19.png");
  currentBook.addNewPage(tHHPage19);

  Page tHHPage20 = new Page(absoluteImagePath+"theHauntedHouse20.png");
  Sound tHHSound8 = new Sound(dog_bark, 559, 520, 613, 546, 7, 10);
  tHHPage20.addNewSound(tHHSound8);
  currentBook.addNewPage(tHHPage20);


  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = currentBook.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;

  //if using audiobook, need the full audio to play on page load
  if (technique == 3) {
    AudioSample audioBook = minim.loadSample(absoluteAudiobookPath+"theHauntedHouse.mp3");
    audioBook.trigger(); // works, but maybe try to automate page turning...
  }
}

//========================================== Task Completion Screen
void setup5() {
  techniqueTitle = "End of Task";
  bodyText = "You have completed the task for this technique. I would now like you to fill in a quick subjective questionnaire and"+
    " NASA TLX form to find out how difficult and or satisfying you found the technique.\nOnce you have completed the questionnaires,"+
    " press ENTER to return to the main menu. You are welcome to take a minute or two as a break before continuing with the experiment";
  displayInfo(techniqueTitle, bodyText);
}
void draw5() {
}

//========================================== Traditional Reading
void setup6() {
  techniqueTitle = "Traditional Reading";
  bodyText = "In this task you will read the book by reading in the way you normally read."+instructions;
  displayInfo(techniqueTitle, bodyText);
}
void draw6() {
}

//========================================== Audio w/ Eyetracker
void setup7() {
  techniqueTitle = "Audio Augmented Reading with Eye-Tracking ";
  bodyText = "In this task you will read the book while wearing an eyetracker. This will detect where on the page you are looking at "+
    "and trigger sound effects associated with particular words in the story."+instructions;
  displayInfo(techniqueTitle, bodyText);
}
void draw7() {
}
//========================================== Audio Book
void setup8() {
  techniqueTitle = "Reading with an Audiobook";
  bodyText = "In this task you will read the book while listening to an audiobook. Each page has a separate audio file that will start once the page loads"+instructions;
  displayInfo(techniqueTitle, bodyText);
}
void draw8() {
}

//========================================== Estimate Reading Pace
void setup9() {
  techniqueTitle = "Audio Augmented Reading with Estimated Pace ";
  bodyText = "In this task you will first be timed while you read an excerpt from Harry Potter and the Philosopher's Stone. This will determine your pace in words per minute "+
    " which will then be used to estimate when to play sound effects to accompany the story you will be reading."+
    "\n\nPress SPACE to begin the timer and show the excerpt. Then press ENTER to stop the timer when you have finished reading.";
}
void draw9() {
  background(255);
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text(title, topX, topY, bottomX, bottomY);

  text(techniqueTitle, topX, topY+130, bottomX, bottomY);

  textFont(f, 24);
  if (stopped && seconds==0) {
    textAlign(LEFT);
    text(bodyText, topX, topY+220, bottomX, bottomY);
  }
  textAlign(CENTER);
  fill(0);

  if (!stopped) {
    mill=(millis()-timerStart);
    if (continued) mill += offset;

    seconds = mill / 1000;
    seconds = seconds % 60;

    text("\"Nearly ten years had passed since the Dursleys had woken up to find their nephew on the front step, but Privet Drive had hardly changed at all. " +
      "The sun rose on the same tidy front gardens and lit up the brass number four on the Dursleys' front door; it crept into their living room, which was " +
      "almost exactly the same as it had been on the night when Mr. Dursley had seen that fateful news report about the owls. " +
      "Only the photographs on the mantelpiece really showed how much time had passed.\"\n\nPress ENTER to stop the timer.", topX, topY+220, bottomX, bottomY);
  }

  if (stopped && seconds > 0) {
    wpm = (92/seconds)*60;
    result = (int)Math.round(wpm);
    textFont(f, 30);
    text("You took "+nf(seconds, 0, 2)+" seconds to read 92 words", topX, topY+360, bottomX, bottomY);
    text("Your estimated reading pace is: " + result + " words per minute\n\nPress a number key to select the book to read", topX, topY+400, bottomX, bottomY); // 92 words in paragraph
    strokeWeight(2);
    line(topX+275, topY+395, topX+345, topY+395);
    line(topX+480, topY+435, topX+550, topY+435);
  }
}

void displayInfo(String techniqueTitle, String bodyText) {
  background(255);
  f = createFont("Arial", 36, true);
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text(title, topX, topY, bottomX, bottomY);

  text(techniqueTitle, topX, topY+150, bottomX, bottomY);

  textFont(f, 24);
  textAlign(LEFT);
  text(bodyText, topX, topY+220, bottomX, bottomY);
}