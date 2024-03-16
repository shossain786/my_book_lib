class Book {
  final String id;
  final String name;
  final String author;
  final String path;
  bool isFavorite;
  int timesOpened;
  int totalReadingTime;
  int lastReadPage;

  Book({
    required this.name,
    required this.author,
    required this.path,
    this.isFavorite = false,
    required this.id,
    this.timesOpened = 0,
    this.totalReadingTime = 0,
    this.lastReadPage = 0,
  });
}
