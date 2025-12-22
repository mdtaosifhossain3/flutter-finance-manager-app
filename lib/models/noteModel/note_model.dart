class NoteModel {
  final int? id;
  final String content;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    this.id,
    required this.content,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      content: map['content'],
      imagePath: map['image_path'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'image_path': imagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'content': content,
      'image_path': imagePath,
      'updated_at': updatedAt,
    };
  }

  NoteModel copyWith({
    int? id,
    String? content,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
