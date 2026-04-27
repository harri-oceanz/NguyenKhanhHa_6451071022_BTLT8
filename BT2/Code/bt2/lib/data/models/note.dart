class Note {
  int? id;
  String title;
  String content;
  int? categoryId;
  String? categoryName;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.categoryName,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'categoryId': categoryId,
    };
  }
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
    );
  }
}