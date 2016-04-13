//libraries
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
int pageLimit;
Book currentBook = new Book();

//variables needed for estimating reading pace
float wpm;
int result;
float participantWPM;
float timerStart = 0;
float offset;
float mill;
float hundredths;
float seconds;
float minutes;
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
    draw1();
    break;
  case 2:
    draw2();
    break;
  case 3:
    draw3();
    break;
  case 4:
    draw4();
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
    // techniques
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
    } 
    if (key == '1') {
      println("Thomas Book Selected");
      setState(1);
    } 
    if (key == '2') {
      println("Biscuit Book Selected");
      setState(2);
    } 
    if (key == '3') {
      println("Book Selected");
      setState(3);
    } 
    if (key == '4') {
      println("Book Selected");
      setState(4);
    }
  }
  // for all books, ENTER for next page, BACKSPACE for previous page
  else if (state == 1 | state == 2 | state == 3 | state == 4) {
    if (0<=imageIndex && imageIndex<pageLimit) {
      if (key == ENTER) {
        imageIndex++; // if ENTER button pressed, move to next image in array
        currentImage = currentBook.pages.get(imageIndex).pageImage;      
        currentSounds = currentBook.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      } else if (key == BACKSPACE) {
        imageIndex--; // if BACKSPACE button pressed, move back to previous image
        currentImage = currentBook.pages.get(imageIndex).pageImage;      
        currentSounds = currentBook.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      }
    } else if (imageIndex>=pageLimit && key == ENTER) {
      println("End Of Session");
      exit();
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
}

void draw1() {
  //all techniques need to update the image
  image(currentImage, 0, 0);

  //if using eyetracker, need to also check if sounds get triggered
  if (technique == 2) {
    noCursor(); // hide cursor since will be using the eye tracker (won't work in presentation mode though)
    for (int i=0; i<currentSounds.size(); i++) {
      currentSounds.get(i).checkSoundTriggered();
    }
  }

  //if using audiobook, need the full audio to play on page load
  else if (technique == 3) {
    //playAudio
  }

  //if using estimated reading pace, need to play sounds based on wpm
  else if (technique == 4) {
    for (int i=0; i<currentSounds.size(); i++) {
      if (currentSounds.get(i).hasPlayed == false) {
        currentSounds.get(i).estimateSoundEffect(result);
      }
    }
  }
}

//========================================== Book 2 - Biscuit Wants to Play
void setup2() {
  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/biscuitBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/biscuitBook/sounds/";
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
}

void draw2() {
  //all techniques need to update the image
  image(currentImage, 0, 0);

  //if technique 2, need to also check if sounds get triggered
  if (technique == 2) {
    for (int i=0; i<currentSounds.size(); i++) {
      currentSounds.get(i).checkSoundTriggered();
    }
  }

  //if technique 3, need the full audio to play on page load
  else if (technique == 3) {
    //playAudio
  }

  //if technique 4, need to play sounds based on the estimated reading pace
  else if (technique == 4) {
    for (int i=0; i<currentSounds.size(); i++) {
      currentSounds.get(i).estimateSoundEffect(result);
    }
  }
}

//========================================== Book 3 - 
void setup3() {
}
void draw3() {
}

//========================================== Book 4 - 
void setup4() {
}
void draw4() {
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
    minutes = seconds / 60;
    seconds = seconds % 60;
    hundredths = mill / 10 % 100;

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
    //text("Your estimated reading pace is: " + nf(wpm, 0, 0) + " words per minute\n\nPress a number key to select the book to read", topX, topY+400, bottomX, bottomY); // 92 words in paragraph
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