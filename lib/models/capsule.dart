enum CapsuleType {
  personal,
  group,
}

class Capsule {
  final String id;
  final String title;
  final CapsuleType type;
  final String? groupName;
  final List<String> members;
  final DateTime createdAt;
  final DateTime openDate;
  final int points;
  final bool isOpened;

  Capsule({
    required this.id,
    required this.title,
    required this.type,
    this.groupName,
    required this.members,
    required this.createdAt,
    required this.openDate,
    required this.points,
    required this.isOpened,
  });

  factory Capsule.fromMap(Map<String, dynamic> map) {
    return Capsule(
      id: map['id'] as String,
      title: map['title'] as String,
      type: map['type'] == 'CapsuleType.personal' || map['type'] == 'personal'
          ? CapsuleType.personal
          : CapsuleType.group,
      groupName: map['groupName'] as String?,
      members: map['members'] != null 
          ? (map['members'] is String 
              ? (map['members'] as String).split(',').where((s) => s.isNotEmpty).toList()
              : List<String>.from(map['members']))
          : [],
      createdAt: map['createdAt'] is String 
          ? DateTime.parse(map['createdAt'])
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      openDate: map['openDate'] is String 
          ? DateTime.parse(map['openDate'])
          : DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int),
      points: map['points'] as int,
      isOpened: map['isOpened'] is int ? map['isOpened'] == 1 : map['isOpened'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'groupName': groupName,
      'members': members,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'openDate': openDate.millisecondsSinceEpoch,
      'points': points,
      'isOpened': isOpened,
    };
  }

  Capsule copyWith({
    String? id,
    String? title,
    CapsuleType? type,
    String? groupName,
    List<String>? members,
    DateTime? createdAt,
    DateTime? openDate,
    int? points,
    bool? isOpened,
  }) {
    return Capsule(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      openDate: openDate ?? this.openDate,
      points: points ?? this.points,
      isOpened: isOpened ?? this.isOpened,
    );
  }
} 