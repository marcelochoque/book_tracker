class Book {
  final int? id;
  final String title;
  final String author;
  final int status; // 0 = To Read, 1 = Reading, 2 = Read

  Book({
    this.id,
    required this.title,
    required this.author,
    this.status = 0,
  });

  // Convert a Book into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'status': status
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      status: map['status'],
    );
  }
}