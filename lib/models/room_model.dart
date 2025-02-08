class RoomModel {
  final String roomId;
  final String image;
  final String author;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> members;

  RoomModel({
    required this.roomId,
    required this.image,
    required this.author,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    required this.members,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data) {
    final String roomId = data['id'] ?? '';
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final String author = data['authorId'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';
    final List<String> members = data['members'] ?? '';

    return RoomModel(
      roomId: roomId,
      title: title,
      image: image,
      author: author,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
      members: members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'image': image,
      'author': author,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'members': members,
    };
  }
}
