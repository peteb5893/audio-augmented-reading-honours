//libraries
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//global variables
int state;

//variables needed for start menu (State 0)
PFont f;
int topX = 20;
int topY = 0;
int bottomX = 852;//width-20;
int bottomY = 600;//height-20;
String title;
String bodyText;

//variables needed for all books
int imageIndex;
PImage currentImage;
ArrayList <Sound> currentSounds;
Minim minim;
String absoluteImagePath;
String absoluteSoundPath;
int pageLimit;


//variables needed for the Thomas book (State 1)
AudioSample beep;
AudioSample bird_noise;
AudioSample cow_moo;
AudioSample goat_noise;
AudioSample human_moo;
AudioSample oh_no_my_hat;
AudioSample there_goes_my_timber;
AudioSample train;
Book happyBirthdayThomas;

//variables needed for the Biscuit book (State 2)
AudioSample dog;
AudioSample cat;
AudioSample cricket;
Book biscuitBook;


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
  }
}

void keyPressed() {
  if (state == 0){ //state 0 - main menu
    if (key == '1') {
      setState(1);
    } else if (key == '2') {
      setState(2);
    }
  } else if (state == 1) { //state 1 - Thomas Book
    if (0<=imageIndex && imageIndex<pageLimit) {
      if (key == ENTER) {
        imageIndex++; // if ENTER button pressed, move to next image in array
        currentImage = happyBirthdayThomas.pages.get(imageIndex).pageImage;      
        currentSounds = happyBirthdayThomas.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      } else if (key == BACKSPACE) {
        imageIndex--; // if BACKSPACE button pressed, move back to previous image
        currentImage = happyBirthdayThomas.pages.get(imageIndex).pageImage;      
        currentSounds = happyBirthdayThomas.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      }
    } else if (imageIndex>=pageLimit && key == ENTER) {
      println("End Of Session");
      exit();
    }
  } else if (state == 2) { //state 2 - Biscuit Book
    if (0<=imageIndex && imageIndex<pageLimit) {
      if (key == ENTER) {
        imageIndex++;
        currentImage = biscuitBook.pages.get(imageIndex).pageImage;      
        currentSounds = biscuitBook.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      } else if (key == BACKSPACE) {
        imageIndex--;
        currentImage = biscuitBook.pages.get(imageIndex).pageImage;      
        currentSounds = biscuitBook.pages.get(imageIndex).sounds;
        println("imageIndex = " + imageIndex);
      }
    } else if (imageIndex>=pageLimit && key == ENTER) {
      println("End Of Session");
      exit();
    }
  }
}

//state 0 Menu
void setup0() {
  background(255);
  f = createFont("Arial", 36, true);
  textFont(f);
  fill(0);
  textAlign(CENTER);
  title = "Encouraging Literacy Through Audio Augmented Reading";
  text(title, topX, topY, bottomX, bottomY);

  textFont(f, 24);
  textAlign(LEFT);
  bodyText = "This program has been built by Peter Bennington for his research-oriented honours project. Its purpose is to allow participants in the study to try out four different reading techniques and give feedback on their experiences and preferences. The reading techniques being evaluated in this particular study are:\n - Traditional Reading\n - Audiobook\n - Audio-Augmented Reading using Estimated Reading-Pace\n - Audio-Augmented Reading using Eyetracking.\n\nPlease press the numbered key on the keyboard that matches your participant ID to begin the experiment.\nYou may have to wait a moment while the book loads the required resources";
  text(bodyText, topX, topY+120, bottomX, bottomY);
}
void draw0() {
}

//state 1 - Thomas Book
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

  //happy birthday thomas book
  happyBirthdayThomas = new Book();

  Page hBTPage1 = new Page(absoluteImagePath+"thomas1.png");  
  happyBirthdayThomas.addNewPage(hBTPage1);

  Page hBTPage2 = new Page(absoluteImagePath+"thomas2.png");   
  Sound hBTSound1 = new Sound(beep, 36, 40, 210, 63);
  hBTPage2.addNewSound(hBTSound1);
  happyBirthdayThomas.addNewPage(hBTPage2);

  Page hBTPage3 = new Page(absoluteImagePath+"thomas3.png");   
  happyBirthdayThomas.addNewPage(hBTPage3);

  Page hBTPage4 = new Page(absoluteImagePath+"thomas4.png");   
  happyBirthdayThomas.addNewPage(hBTPage4);

  Page hBTPage5 = new Page(absoluteImagePath+"thomas5.png");   
  happyBirthdayThomas.addNewPage(hBTPage5);

  Page hBTPage6 = new Page(absoluteImagePath+"thomas6.png");   
  Sound hBTSound2 = new Sound(oh_no_my_hat, 244, 56, 344, 80);
  hBTPage6.addNewSound(hBTSound2);
  Sound hBTSound3 = new Sound(goat_noise, 240, 360, 356, 389);
  hBTPage6.addNewSound(hBTSound3);
  Sound hBTSound4 = new Sound(there_goes_my_timber, 686, 53, 789, 78);
  hBTPage6.addNewSound(hBTSound4);
  Sound hBTSound5 = new Sound(bird_noise, 693, 361, 772, 382);
  hBTPage6.addNewSound(hBTSound5);
  happyBirthdayThomas.addNewPage(hBTPage6);

  Page hBTPage7 = new Page(absoluteImagePath+"thomas7.png");   
  happyBirthdayThomas.addNewPage(hBTPage7);

  Page hBTPage8 = new Page(absoluteImagePath+"thomas8.png");   
  happyBirthdayThomas.addNewPage(hBTPage8);

  Page hBTPage9 = new Page(absoluteImagePath+"thomas9.png");   
  happyBirthdayThomas.addNewPage(hBTPage9);

  Page hBTPage10 = new Page(absoluteImagePath+"thomas10.png");   
  Sound hBTSound6 = new Sound(cow_moo, 105, 69, 197, 102);
  hBTPage10.addNewSound(hBTSound6);
  Sound hBTSound7 = new Sound(human_moo, 556, 142, 617, 162);
  hBTPage10.addNewSound(hBTSound7);
  happyBirthdayThomas.addNewPage(hBTPage10);  

  Page hBTPage11 = new Page(absoluteImagePath+"thomas11.png");   
  happyBirthdayThomas.addNewPage(hBTPage11);

  Page hBTPage12 = new Page(absoluteImagePath+"thomas12.png");   
  Sound hBTSound8 = new Sound(train, 623, 39, 700, 59);
  hBTPage12.addNewSound(hBTSound8);
  happyBirthdayThomas.addNewPage(hBTPage12);

  Page hBTPage13 = new Page(absoluteImagePath+"thomas13.png");   
  happyBirthdayThomas.addNewPage(hBTPage13);

  Page hBTPage14 = new Page(absoluteImagePath+"thomas14.png");   
  happyBirthdayThomas.addNewPage(hBTPage14);  

  Page hBTPage15 = new Page(absoluteImagePath+"thomas15.png");   
  happyBirthdayThomas.addNewPage(hBTPage15);

  Page hBTPage16 = new Page(absoluteImagePath+"thomas16.png");   
  happyBirthdayThomas.addNewPage(hBTPage16);

  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = happyBirthdayThomas.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;
}

void draw1() {
  image(currentImage, 0, 0);
  for (int i=0; i<currentSounds.size(); i++) {
    currentSounds.get(i).checkSoundTriggered();
  }
}

//state 2 - Biscuit Book
void setup2() {
  absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/BiscuitBook/images/";
  absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/BiscuitBook/sounds/";
  pageLimit = 11;

  minim = new Minim(this);
  dog = minim.loadSample(absoluteSoundPath+"dog.mp3");
  cat = minim.loadSample(absoluteSoundPath+"cat.mp3");
  cricket = minim.loadSample(absoluteSoundPath+"cricket.mp3");

  //Biscuit Wants to Play Book
  biscuitBook = new Book();

  Page biscuitPage1 = new Page(absoluteImagePath+"biscuit1.png");
  biscuitBook.addNewPage(biscuitPage1);

  Page biscuitPage2 = new Page(absoluteImagePath+"biscuit2.png");
  Sound biscuitSound1 = new Sound(dog, 526, 462, 666, 482);
  biscuitPage2.addNewSound(biscuitSound1);
  biscuitBook.addNewPage(biscuitPage2);

  Page biscuitPage3 = new Page(absoluteImagePath+"biscuit3.png");
  Sound biscuitSound2 = new Sound(cat, 161, 490, 246, 522);
  Sound biscuitSound3 = new Sound(cat, 515, 83, 676, 108);
  biscuitPage3.addNewSound(biscuitSound2);
  biscuitPage3.addNewSound(biscuitSound3);
  biscuitBook.addNewPage(biscuitPage3);

  Page biscuitPage4 = new Page(absoluteImagePath+"biscuit4.png");
  Sound biscuitSound4 = new Sound(dog, 516, 47, 660, 68);
  biscuitPage4.addNewSound(biscuitSound4);
  biscuitBook.addNewPage(biscuitPage4);

  Page biscuitPage5 = new Page(absoluteImagePath+"biscuit5.png");
  Sound biscuitSound5 = new Sound(cat, 91, 415, 254, 447);
  Sound biscuitSound6 = new Sound(dog, 494, 472, 641, 498);
  biscuitPage5.addNewSound(biscuitSound5);
  biscuitPage5.addNewSound(biscuitSound6);
  biscuitBook.addNewPage(biscuitPage5);

  Page biscuitPage6 = new Page(absoluteImagePath+"biscuit6.png");
  Sound biscuitSound7 = new Sound(dog, 107, 452, 186, 481);
  Sound biscuitSound8 = new Sound(cat, 504, 466, 669, 490);
  biscuitPage6.addNewSound(biscuitSound7);
  biscuitPage6.addNewSound(biscuitSound8);
  biscuitBook.addNewPage(biscuitPage6);

  Page biscuitPage7 = new Page(absoluteImagePath+"biscuit7.png");
  Sound biscuitSound9 = new Sound(dog, 82, 452, 235, 287);
  Sound biscuitSound10 = new Sound(cat, 481, 47, 652, 77);
  biscuitPage7.addNewSound(biscuitSound9);
  biscuitPage7.addNewSound(biscuitSound10);
  biscuitBook.addNewPage(biscuitPage7);

  Page biscuitPage8 = new Page(absoluteImagePath+"biscuit8.png");
  Sound biscuitSound11 = new Sound(cat, 132, 484, 304, 518);
  biscuitPage8.addNewSound(biscuitSound11);
  biscuitBook.addNewPage(biscuitPage8);

  Page biscuitPage9 = new Page(absoluteImagePath+"biscuit9.png");
  Sound biscuitSound12 = new Sound(cat, 97, 446, 272, 483);
  Sound biscuitSound13 = new Sound(dog, 651, 81, 735, 111);
  biscuitPage9.addNewSound(biscuitSound12);
  biscuitPage9.addNewSound(biscuitSound13);
  biscuitBook.addNewPage(biscuitPage9);

  Page biscuitPage10 = new Page(absoluteImagePath+"biscuit10.png");
  Sound biscuitSound14 = new Sound(dog, 478, 491, 698, 517);
  biscuitPage10.addNewSound(biscuitSound14);
  biscuitBook.addNewPage(biscuitPage10);

  Page biscuitPage11 = new Page(absoluteImagePath+"biscuit11.png");
  Sound biscuitSound15 = new Sound(dog, 244, 248, 396, 288);
  biscuitPage11.addNewSound(biscuitSound15);
  biscuitBook.addNewPage(biscuitPage11);

  Page biscuitPage12 = new Page(absoluteImagePath+"biscuit12.png");
  Sound biscuitSound16 = new Sound(cat, 95, 62, 273, 96);
  biscuitPage12.addNewSound(biscuitSound16);
  biscuitBook.addNewPage(biscuitPage12);

  // get images and sounds for current page (start page in this case)
  imageIndex = 0;
  Page current = biscuitBook.pages.get(imageIndex);
  currentImage = current.pageImage;
  currentSounds = current.sounds;
}

void draw2() {
  image(currentImage, 0, 0);
  for (int i=0; i<currentSounds.size(); i++) {
    currentSounds.get(i).checkSoundTriggered();
  }
}