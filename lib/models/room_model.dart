class RoomModel {
  final String roomId;
  final String image;
  final String authorId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RoomModel({
    required this.roomId,
    required this.image,
    required this.authorId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data) {
    final String roomId = data['id'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final String authorId = data['authorId'] ?? '';
    final DateTime createdAt = DateTime.parse(data['createdAt']);
    final DateTime? updatedAt = data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null;

    return RoomModel(
      roomId: roomId,
      title: title,
      image: image,
      authorId: authorId,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'RoomModel(roomId: $roomId, title: $title, image: $image, authorId: $authorId, createdAt: $createdAt)';
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'image': image,
      'authorId': authorId,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
