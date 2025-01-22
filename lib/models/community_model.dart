class CommunityModel {
  final String comId;
  final String senderId;
  final String image;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? members;

  CommunityModel({
    required this.comId,
    required this.senderId,
    required this.image,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.members,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';
    final String members = data['members'] ?? '';

    return CommunityModel(
      comId: documentId,
      senderId: senderId,
      image: image,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
      members: members  != null ? List<String>.from(data['members']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comId': comId,
      'senderId': senderId,
      'image': image,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'members': members,
    };
  }
}
