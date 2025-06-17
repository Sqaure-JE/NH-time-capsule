class Content {
  final String id;
  final String capsuleId;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;

  Content({
    required this.id,
    required this.capsuleId,
    required this.text,
    this.imageUrl,
    required this.createdAt,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as String,
      capsuleId: map['capsuleId'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String?,
      createdAt: map['createdAt'] is String 
          ? DateTime.parse(map['createdAt'])
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'capsuleId': capsuleId,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Content copyWith({
    String? id,
    String? capsuleId,
    String? text,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Content(
      id: id ?? this.id,
      capsuleId: capsuleId ?? this.capsuleId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 