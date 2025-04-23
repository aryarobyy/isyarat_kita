enum Type {
  ARTICLE,
  NEWS,
  EVENT;

  @override
  String toString() => name;
}

class BlogModel {
  final int blogId;
  final String authorId;
  final String image;
  final String title;
  final String content;
  final Type type;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BlogModel({
    required this.blogId,
    required this.authorId,
    required this.image,
    required this.title,
    required this.content,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromMap(Map<String, dynamic> data) {
    final int blogId = data['id'] ?? 0;
    final String authorId = data['authorId'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final String typeString = (data['type'] ?? '').toString().trim().toUpperCase();

    final Type type = Type.values.firstWhere(
          (e) => e.name.toUpperCase() == typeString,
      orElse: () {
        print("Unknown type from API: $typeString");
        return Type.ARTICLE; // fallback
      },
    );
    final String createdBy = data['createdBy'] ?? '';
    final DateTime createdAt = DateTime.parse(data['createdAt']);
    final String? updatedAtString = data['updatedAt'];

    return BlogModel(
      blogId: blogId,
      authorId: authorId,
      image: image,
      title: title,
      content: content,
      type: type,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAtString != null && updatedAtString.isNotEmpty
          ? DateTime.parse(updatedAtString)
          : null,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': blogId,
      'authorId': authorId,
      'image': image,
      'title': title,
      'content': content,
      'type': type,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
