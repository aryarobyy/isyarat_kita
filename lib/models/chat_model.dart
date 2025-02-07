class CommunityModel {
  final String comId;
  final String senderId;
  final String image;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommunityModel({
    required this.comId,
    required this.senderId,
    required this.image,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';

    return CommunityModel(
      comId: documentId,
      senderId: senderId,
      image: image,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comId': comId,
      'senderId': senderId,
      'image': image,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
