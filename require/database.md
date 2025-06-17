# SQLite 데이터베이스 구조 및 사용 방법 (Flutter 앱용)

## 1. SQLite 데이터베이스 구조

### 1.1 테이블 구조

#### capsules 테이블
```sql
CREATE TABLE capsules(
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  groupName TEXT,
  members TEXT,
  createdAt TEXT NOT NULL,
  openDate TEXT NOT NULL,
  points INTEGER NOT NULL,
  isOpened INTEGER NOT NULL
)
```

#### contents 테이블
```sql
CREATE TABLE contents(
  id TEXT PRIMARY KEY,
  capsuleId TEXT NOT NULL,
  text TEXT NOT NULL,
  imageUrl TEXT,
  createdAt TEXT NOT NULL,
  FOREIGN KEY (capsuleId) REFERENCES capsules (id)
)
```

### 1.2 데이터 타입 설명

**capsules 테이블**:
- `id`: UUID로 생성된 고유 ID (TEXT)
- `title`: 타임캡슐 제목 (TEXT, 최대 30자)
- `type`: 캡슐 유형 (TEXT, 'CapsuleType.personal' 또는 'CapsuleType.group')
- `groupName`: 모임형일 때 모임 이름 (TEXT, 최대 30자, NULL 가능)
- `members`: 모임형일 때 참여자 이름 목록 (TEXT, 쉼표로 구분)
- `createdAt`: 생성 시간 (TEXT, ISO8601 형식)
- `openDate`: 열람 가능 시간 (TEXT, ISO8601 형식)
- `points`: 누적 포인트 (INTEGER)
- `isOpened`: 열람 여부 (INTEGER, 0 또는 1)

**contents 테이블**:
- `id`: UUID로 생성된 고유 ID (TEXT)
- `capsuleId`: 연결된 캡슐 ID (TEXT)
- `text`: 텍스트 내용 (TEXT, 최대 300자)
- `imageUrl`: 이미지 저장 경로 (TEXT, 로컬 파일 경로, NULL 가능)
- `createdAt`: 생성 시간 (TEXT, ISO8601 형식)

## 2. Flutter 프로젝트에 SQLite 설정하기

### 2.1 필요한 패키지 추가하기

pubspec.yaml 파일에 다음 패키지를 추가합니다:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # SQLite 패키지
  sqflite: ^2.3.0
  path: ^1.8.3
  path_provider: ^2.1.1
  # 유틸리티 패키지
  uuid: ^4.2.1
  provider: ^6.0.5
  image_picker: ^1.0.4
  intl: ^0.19.0
  shared_preferences: ^2.2.2
```

### 2.2 데이터베이스 헬퍼 클래스

```dart
// lib/data/helpers/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/capsule.dart';
import '../../models/content.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'time_capsule.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 테이블 생성 SQL 실행
  }

  Future<void> initDatabase() async {
    await database;
  }
}
```

## 3. 모델 클래스 구현

### 3.1 Capsule 모델 클래스

```dart
// lib/models/capsule.dart
enum CapsuleType { personal, group }

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

  const Capsule({
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

  // SQLite에서 데이터를 가져올 때 사용
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

  // SQLite에 데이터를 저장할 때 사용
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
```

### 3.2 Content 모델 클래스

```dart
// lib/models/content.dart
class Content {
  final String id;
  final String capsuleId;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;

  const Content({
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
```

## 4. 레포지토리 구현

### 4.1 캡슐 데이터 관리 함수

```dart
// lib/data/repositories/capsule_repository.dart
import '../../models/capsule.dart';
import '../helpers/database_helper.dart';

class CapsuleRepository {
  final DatabaseHelper _dbHelper;

  CapsuleRepository(this._dbHelper);

  // 캡슐 생성
  Future<void> saveCapsule(Capsule capsule) async {
    await _dbHelper.insertCapsule(capsule);
  }
  
  // 캡슐 목록 가져오기
  Future<List<Capsule>> getCapsules() async {
    return await _dbHelper.getCapsules();
  }
  
  // 캡슐 상세 정보 가져오기
  Future<Capsule?> getCapsuleById(String id) async {
    return await _dbHelper.getCapsuleById(id);
  }
  
  // 캡슐 업데이트
  Future<void> updateCapsule(Capsule capsule) async {
    await _dbHelper.updateCapsule(capsule);
  }
  
  // 캡슐 삭제
  Future<void> deleteCapsule(String id) async {
    await _dbHelper.deleteCapsule(id);
  }
}
```

### 4.2 콘텐츠 데이터 관리 함수

```dart
// lib/data/repositories/content_repository.dart
import 'dart:io';
import '../../models/content.dart';
import '../helpers/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ContentRepository {
  final DatabaseHelper _dbHelper;

  ContentRepository(this._dbHelper);
  
  // 콘텐츠 추가
  Future<String> addContent({
    required Content content,
    String? imagePath,
  }) async {
    String? savedImagePath;
    
    // 이미지가 있으면 로컬에 저장
    if (imagePath != null) {
      final file = File(imagePath);
      
      // 이미지 크기 검증 (2MB 이하)
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        throw Exception('이미지 크기는 2MB 이하여야 합니다.');
      }
      
      // 앱 문서 디렉토리에 이미지 저장
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.jpg';
      final savedFile = await file.copy('${appDir.path}/$fileName');
      savedImagePath = savedFile.path;
    }
    
    // 콘텐츠에 이미지 경로 설정
    final contentWithImage = content.copyWith(imageUrl: savedImagePath);
    
    await _dbHelper.insertContent(contentWithImage);
    
    return content.id;
  }
  
  // 캡슐별 콘텐츠 가져오기
  Future<List<Content>> getContentsByCapsuleId(String capsuleId) async {
    return await _dbHelper.getContentsByCapsuleId(capsuleId);
  }
  
  // 콘텐츠 삭제 (이미지 포함)
  Future<void> deleteContent(String contentId) async {
    // 로컬 이미지 삭제 로직 포함
    await _dbHelper.deleteContent(contentId);
  }
}
```

## 5. 더미 금융 데이터

```dart
// 하드코딩된 더미 데이터
class FinancialTransaction {
  final String name;
  final int amount;
  final String type;

  const FinancialTransaction({
    required this.name,
    required this.amount,
    required this.type,
  });

  static List<FinancialTransaction> getDummyData() {
    return [
      FinancialTransaction(name: "스타벅스", amount: -5600, type: "지출"),
      FinancialTransaction(name: "급여", amount: 2500000, type: "수입"),
      FinancialTransaction(name: "적금", amount: -300000, type: "저축"),
    ];
  }
}
```

## 6. 데이터베이스 사용 규칙

1. **데이터 일관성 유지**: 
   - 캡슐 생성 시 필수 필드(id, title, type, createdAt, openDate)를 반드시 포함해야 함
   - 콘텐츠 생성 시 필수 필드(id, capsuleId, text, createdAt)를 반드시 포함해야 함
   - 타임스탬프는 ISO8601 형식으로 저장

2. **이미지 처리**:
   - 이미지는 로컬 디렉토리에 저장하고 경로만 데이터베이스에 저장
   - 이미지 용량은 2MB 이하로 제한
   - 업로드 전 이미지 압축 처리 권장

3. **오프라인 전용**:
   - 모든 데이터는 로컬 SQLite에 저장
   - 네트워크 연결 불필요
   - 앱 삭제 시 모든 데이터 삭제됨

4. **포인트 시스템**:
   - 캡슐 생성: +100P
   - 콘텐츠 추가: +50P
   - 이미지 첨부: +20P
   - 3개 콘텐츠 추가 시: +500P 보너스

5. **데이터 로딩 최적화**:
   - 캡슐 목록 조회 시 요약 정보만 로드
   - 상세 정보는 필요할 때만 로드
   - 최대 10개 캡슐만 표시

6. **모임형 캡슐 처리**:
   - 참여자 이름은 쉼표로 구분된 문자열로 저장
   - 로컬 저장만 지원 (실제 동기화 없음)
   - 향후 확장을 위한 구조 설계

7. **타임캡슐 열람 제한**:
   - openDate와 관계없이 언제든지 열람 가능
   - isOpened 필드로 열람 여부 관리
   - 열람 시점에 자동으로 isOpened를 true로 업데이트

## 7. 의존성 주입 설정

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 데이터베이스 초기화
  final dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseHelper>.value(value: dbHelper),
        ProxyProvider<DatabaseHelper, CapsuleRepository>(
          update: (_, dbHelper, __) => CapsuleRepository(dbHelper),
        ),
        ProxyProvider<DatabaseHelper, ContentRepository>(
          update: (_, dbHelper, __) => ContentRepository(dbHelper),
        ),
        ChangeNotifierProxyProvider2<CapsuleRepository, ContentRepository, CapsuleProvider>(
          create: (context) => CapsuleProvider(
            capsuleRepository: context.read<CapsuleRepository>(),
            contentRepository: context.read<ContentRepository>(),
          ),
          update: (context, capsuleRepo, contentRepo, previous) => CapsuleProvider(
            capsuleRepository: capsuleRepo,
            contentRepository: contentRepo,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

## 8. 파일 구조

```
lib/
├── main.dart
├── app/
│   └── router.dart
├── data/
│   ├── helpers/
│   │   └── database_helper.dart
│   └── repositories/
│       ├── capsule_repository.dart
│       └── content_repository.dart
├── models/
│   ├── capsule.dart
│   └── content.dart
├── presentation/
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── create/
│   │   │   └── create_screen.dart
│   │   └── detail/
│   │       └── detail_screen.dart
│   └── providers/
│       └── capsule_provider.dart
└── assets/
    └── images/
```
