String absoluteImagePath = "/Users/peterbennington/git/audio-augmented-reading-honours/ThomasBook/images/";
String absoluteSoundPath = "/Users/peterbennington/git/audio-augmented-reading-honours/ThomasBook/sounds/";
int pageLimit = 15;

void setup1() {

  //audio samples
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

void cleanup1() {
}
