class BlogModel {
  final String blogId;
  final String author;
  final String image;
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BlogModel({
    required this.blogId,
    required this.author,
    required this.image,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromMap(Map<String, dynamic> data) {
    final String blogId = data['id'] ?? '';
    final String author = data['authorId'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final String type = data['type'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';

    return BlogModel(
      blogId: blogId,
      author: author,
      image: image,
      title: title,
      content: content,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blogId': blogId,
      'author': author,
      'image': image,
      'title': title,
      'content': content,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
