
class Page {
  //attributes
  PImage pageImage;
  ArrayList<Sound> sounds; //could be multiple or single sounds on page

  //constructor  
  Page(String imageName) {
    pageImage = loadImage(imageName);
    sounds = new ArrayList<Sound>();
  }

  void addNewSound(Sound newSound) {
    sounds.add(newSound);
  }
}