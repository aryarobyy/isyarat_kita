class VocabModel {
  final int vocabId;
  final String name;
  final String image;
  final String type;

  VocabModel({
    required this.vocabId,
    required this.image,
    required this.name,
    required this.type,
  });

  factory VocabModel.fromMap(Map<String, dynamic> data) {
    final int vocabId = data['id'] ?? '';
    final String image = data['image'] ?? '';
    final String type = data['signCode'] ?? "";
    final String name = data['name'] ?? '';

    return VocabModel(
      vocabId: vocabId,
      image: image,
      type: type,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': vocabId,
      'image': image,
      'signCode': type,
      'name': name,
    };
  }
}