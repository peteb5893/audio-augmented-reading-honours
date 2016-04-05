
void setup2() {

//audio samples
minim = new Minim(this);
dog = minim.loadSample("dog.mp3");
cat = minim.loadSample("cat.mp3");
cricket = minim.loadSample("cricket.mp3");

//Biscuit Wants to Play Book
biscuitBook = new Book();

Page biscuitPage1 = new Page("biscuit1.png");
biscuitBook.addNewPage(biscuitPage1);

Page biscuitPage2 = new Page("biscuit2.png");
Sound biscuitSound1 = new Sound(dog,526,462,666,482);
biscuitPage2.addNewSound(biscuitSound1);
biscuitBook.addNewPage(biscuitPage2);

Page biscuitPage3 = new Page("biscuit3.png");
Sound biscuitSound2 = new Sound(cat,161,490,246,522);
Sound biscuitSound3 = new Sound(cat,515,83,676,108);
biscuitPage3.addNewSound(biscuitSound2);
biscuitPage3.addNewSound(biscuitSound3);
biscuitBook.addNewPage(biscuitPage3);

Page biscuitPage4 = new Page("biscuit4.png");
Sound biscuitSound4 = new Sound(dog,516,47,660,68);
biscuitPage4.addNewSound(biscuitSound4);
biscuitBook.addNewPage(biscuitPage4);

Page biscuitPage5 = new Page("biscuit5.png");
Sound biscuitSound5 = new Sound(cat,91,415,254,447);
Sound biscuitSound6 = new Sound(dog,494,472,641,498);
biscuitPage5.addNewSound(biscuitSound5);
biscuitPage5.addNewSound(biscuitSound6);
biscuitBook.addNewPage(biscuitPage5);

Page biscuitPage6 = new Page("biscuit6.png");
Sound biscuitSound7 = new Sound(dog,107,452,186,481);
Sound biscuitSound8 = new Sound(cat,504,466,669,490);
biscuitPage6.addNewSound(biscuitSound7);
biscuitPage6.addNewSound(biscuitSound8);
biscuitBook.addNewPage(biscuitPage6);

Page biscuitPage7 = new Page("biscuit7.png");
Sound biscuitSound9 = new Sound(dog,82,452,235,287);
Sound biscuitSound10 = new Sound(cat,481,47,652,77);
biscuitPage7.addNewSound(biscuitSound9);
biscuitPage7.addNewSound(biscuitSound10);
biscuitBook.addNewPage(biscuitPage7);

Page biscuitPage8 = new Page("biscuit8.png");
Sound biscuitSound11 = new Sound(cat,132,484,304,518);
biscuitPage8.addNewSound(biscuitSound11);
biscuitBook.addNewPage(biscuitPage8);

Page biscuitPage9 = new Page("biscuit9.png");
Sound biscuitSound12 = new Sound(cat,97,446,272,483);
Sound biscuitSound13 = new Sound(dog,651,81,735,111);
biscuitPage9.addNewSound(biscuitSound12);
biscuitPage9.addNewSound(biscuitSound13);
biscuitBook.addNewPage(biscuitPage9);

Page biscuitPage10 = new Page("biscuit10.png");
Sound biscuitSound14 = new Sound(dog,478,491,698,517);
biscuitPage10.addNewSound(biscuitSound14);
biscuitBook.addNewPage(biscuitPage10);

Page biscuitPage11 = new Page("biscuit11.png");
Sound biscuitSound15 = new Sound(dog,244,248,396,288);
biscuitPage11.addNewSound(biscuitSound15);
biscuitBook.addNewPage(biscuitPage11);

Page biscuitPage12 = new Page("biscuit12.png");
Sound biscuitSound16 = new Sound(cat,95,62,273,96);
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

void cleanup2() {
}


