class ArticleModel {
  final String articleId;
  final String senderId;
  final String image;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ArticleModel({
    required this.articleId,
    required this.senderId,
    required this.image,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';

    return ArticleModel(
      articleId: documentId,
      senderId: senderId,
      image: image,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'userId': senderId,
      'image': image,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
