class Book {
  final String name;
  final String author;
  final String path;
  bool isFavorite;

  Book(
      {required this.name,
      required this.author,
      required this.path,
      this.isFavorite = false});
}
