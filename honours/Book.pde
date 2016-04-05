
class Book {
  //attributes
  String name;
  ArrayList<Page> pages;

  //constructor
  Book() {    
    pages = new ArrayList<Page>();
  }


  void addNewPage(Page newPage) {
    pages.add(newPage); // add page to array
  }
}