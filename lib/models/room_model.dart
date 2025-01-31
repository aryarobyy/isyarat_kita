class RoomModel {
  final String comId;
  final String image;
  final String createdBy;
  final String title;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? members;

  RoomModel({
    required this.comId,
    required this.image,
    required this.createdBy,
    required this.title,
    required this.createdAt,
    this.updatedAt,
    this.members,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String image = data['image'] ?? '';
    final String title = data['title'] ?? '';
    final String createdBy = data['createdBy'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';
    final String members = data['members'] ?? '';

    return RoomModel(
      comId: documentId,
      title: title,
      image: image,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
      members: members  != null ? List<String>.from(data['members']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comId': comId,
      'image': image,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'members': members,
    };
  }
}
