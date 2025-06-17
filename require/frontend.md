# project-overview (프로젝트 개요)

## 1. 프로젝트 정보
- **프로젝트명**: 금융 타임캡슐 프로토타입 (MVP)
- **개발 프레임워크**: Flutter 3.16+
- **개발 기간**: 6주 (2025.01.01 ~ 2025.02.15)
- **타겟 플랫폼**: iOS, Android
- **최소 지원 버전**: 
  - iOS: 12.0 이상
  - Android: API Level 21 (Android 5.0) 이상

## 2. 기술 스택
- **상태관리**: Provider
- **로컬 데이터베이스**: SQLite (sqflite)
- **이미지 저장**: 로컬 디렉토리
- **로컬 스토리지**: SharedPreferences
- **이미지 처리**: image_picker
- **애니메이션**: Flutter Animation (기본)
- **유틸리티**: uuid, intl, path_provider, path

## 3. 디자인 시스템
- **테마**: Material Design 3 기본 팔레트
- **타이포그래피**: 시스템 폰트 (Roboto/SF Pro)
- **스페이싱**: 8dp 그리드 시스템
- **아이콘**: Material Icons

## 4. MVP 범위
- **포함**: 개인형/모임형 타임캡슐, 기본 애니메이션, 간단한 리워드
- **애니메이션**: Flutter Animation
- **이미지 처리**: image_picker, 로컬 저장
- **데이터 저장**: SQLite (오프라인 전용)

# feature-requirements (기능요구사항)

## 1. 핵심 기능 구현

### 1.1 타임캡슐 생성 플로우
- **단일 화면 구성**
  - 유형 선택 (개인형/모임형) - 라디오 버튼
  - 제목 및 모임 정보 입력 - 텍스트 필드
  - 보관 기간 선택 - 날짜 선택기
  - 첫 번째 추억 저장 - 텍스트 에리어
- **진행 상태 표시**
  - 스크롤 가능한 단일 화면
  - 조건부 UI (그룹 선택 시 추가 필드 표시)

### 1.2 모임형 타임캡슐 (간단 버전)
- **구현 방식**: 로컬 저장만, 실제 동기화 없음
- **입력 항목**:
  - 모임 이름 (최대 30자)
  - 참여자 이름 (쉼표 구분, 텍스트 저장)
- **UI 차이점**:
  - 홈 화면: 그룹 아이콘으로 구분
  - 상세 화면: 참여자 목록 표시
  - 열람 화면: "모임 총 포인트" 표시

### 1.3 홈 화면
- **타임캡슐 카드 리스트**
  - 개인형/모임형 아이콘 구분
  - 카드 디자인 (썸네일/제목/D-Day)
  - 최대 10개 제한
  - 카드 상태별 UI (대기/열람가능)
- **새 캡슐 생성**: 상단 + 버튼

### 1.4 상세 화면
- **오늘의 금융 활동**
  - 고정된 3개 더미 데이터
  - 입/출금 금액 색상 구분
- **콘텐츠 영역**
  - 텍스트 (최대 300자)
  - 이미지 (1개, 최대 2MB)
- **모임형 추가 정보**
  - 참여자 목록 표시
- **타임캡슐 열기**: 언제든지 열기 가능한 버튼

### 1.5 열람 화면
- **통합 화면**: 상세 화면에서 바로 열람
- **콘텐츠 표시**: 시간순 정렬
- **포인트 표시**: 누적 포인트 강조

### 1.6 리워드 시스템
- **포인트 적립**:
  - 캡슐 생성: +100P
  - 콘텐츠 추가: +50P
  - 이미지 첨부: +20P
  - 3개 콘텐츠 추가 시: +500P 보너스
- **표시**: 간단한 숫자 카운터

## 2. 공통 컴포넌트

### 2.1 버튼
- Primary Button (생성/완료)
- Secondary Button (취소/뒤로)
- 상단 + 버튼 (새 캡슐 생성)

### 2.2 입력 폼
- Text Field (제목, 모임명)
- Text Area (콘텐츠 작성)
- Image Picker (이미지 선택)
- Radio Group (유형 선택)
- Date Picker (날짜 선택)

### 2.3 카드
- 타임캡슐 카드 (개인형/모임형 구분)
- 콘텐츠 카드

### 2.4 다이얼로그
- 콘텐츠 추가 다이얼로그
- 확인 다이얼로그
- 로딩 다이얼로그

# relevant-code (관련 코드)

## 1. 주요 데이터 모델

```dart
// 캡슐 모델 (SQLite 기반)
enum CapsuleType { personal, group }

class Capsule {
  final String id;
  final String title;
  final CapsuleType type;
  final String? groupName; // 모임형일 때만
  final List<String> members; // 모임형 참여자 (로컬 저장)
  final DateTime createdAt;
  final DateTime openDate;
  final bool isOpened;
  final int points;

  const Capsule({
    required this.id,
    required this.title,
    required this.type,
    this.groupName,
    required this.members,
    required this.createdAt,
    required this.openDate,
    required this.isOpened,
    required this.points,
  });
  
  // SQLite 데이터베이스에서 데이터를 가져올 때 사용
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

  // SQLite 데이터베이스에 데이터를 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'groupName': groupName,
      'members': members,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'openDate': openDate.millisecondsSinceEpoch,
      'isOpened': isOpened,
      'points': points,
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

// 콘텐츠 모델
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

// 금융 거래 데이터 모델
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

## 2. 주요 위젯 코드

```dart
// 타임캡슐 카드 위젯 (개인형/모임형 구분)
class CapsuleCard extends StatelessWidget {
  final Capsule capsule;

  const CapsuleCard({
    super.key,
    required this.capsule,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilOpen = capsule.openDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(capsule.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capsule.type == CapsuleType.personal ? '개인' : '그룹',
              style: const TextStyle(color: Colors.blue),
            ),
            Text(
              daysUntilOpen > 0
                  ? 'D-$daysUntilOpen'
                  : '열기 가능',
              style: TextStyle(
                color: daysUntilOpen > 0 ? Colors.grey : Colors.green,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${capsule.points}원'),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.detail,
                  arguments: capsule.id,
                );
              },
              child: const Text('타임캡슐 열기'),
            ),
          ],
        ),
      ),
    );
  }
}

// 콘텐츠 추가 다이얼로그
class AddContentDialog extends StatefulWidget {
  final String capsuleId;
  final VoidCallback onContentAdded;

  const AddContentDialog({
    super.key,
    required this.capsuleId,
    required this.onContentAdded,
  });

  @override
  State<AddContentDialog> createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<AddContentDialog> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('추억 추가'),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: '추억을 적어보세요...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _addContent,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _addContent() async {
    if (_textController.text.trim().isEmpty) return;

    try {
      await context.read<CapsuleProvider>().addContent(
        capsuleId: widget.capsuleId,
        text: _textController.text.trim(),
      );
      
      widget.onContentAdded();
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추억이 추가되었습니다!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }
}
```

## 3. 생성 플로우 관련 위젯

```dart
// 단일 화면 생성 폼
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _membersController = TextEditingController();
  final _contentController = TextEditingController();
  
  CapsuleType _selectedType = CapsuleType.personal;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타임캡슐 만들기'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 타입 선택 (라디오 버튼)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('타입 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      RadioListTile<CapsuleType>(
                        title: const Text('개인'),
                        value: CapsuleType.personal,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      RadioListTile<CapsuleType>(
                        title: const Text('그룹'),
                        value: CapsuleType.group,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 제목 입력
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 그룹 정보 (조건부 표시)
              if (_selectedType == CapsuleType.group) ...[
                TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    labelText: '그룹 이름',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_selectedType == CapsuleType.group && (value == null || value.isEmpty)) {
                      return '그룹 이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _membersController,
                  decoration: const InputDecoration(
                    labelText: '참여자 (쉼표로 구분)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // 날짜 선택
              Card(
                child: ListTile(
                  title: const Text('개봉 날짜'),
                  subtitle: Text('${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // 첫 번째 콘텐츠
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: '첫 번째 추억을 적어보세요',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 16),
              
              // 생성 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createCapsule,
                  child: const Text('타임캡슐 만들기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCapsule() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CapsuleProvider>();
      
      final members = _selectedType == CapsuleType.group
          ? _membersController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : <String>[];

      try {
        await provider.createCapsule(
          title: _titleController.text,
          type: _selectedType,
          groupName: _selectedType == CapsuleType.group ? _groupNameController.text : null,
          members: members,
          openDate: _selectedDate,
          firstContent: _contentController.text.isNotEmpty ? _contentController.text : null,
        );
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류가 발생했습니다: $e')),
          );
        }
      }
    }
  }
}
```

## 4. 저장소 및 서비스 클래스

### 4.1 SQLite 서비스

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
    await db.execute('''
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
    ''');

    await db.execute('''
      CREATE TABLE contents(
        id TEXT PRIMARY KEY,
        capsuleId TEXT NOT NULL,
        text TEXT NOT NULL,
        imageUrl TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (capsuleId) REFERENCES capsules (id)
      )
    ''');
  }

  Future<void> initDatabase() async {
    await database;
  }
}
```

### 4.2 상태 관리 (SQLite 기반)

```dart
// 캡슐 프로바이더 (SQLite 기반)
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/capsule.dart';
import '../../models/content.dart';
import '../../data/repositories/capsule_repository.dart';
import '../../data/repositories/content_repository.dart';

class CapsuleProvider extends ChangeNotifier {
  final CapsuleRepository _capsuleRepository;
  final ContentRepository _contentRepository;
  final _uuid = const Uuid();

  List<Capsule> _capsules = [];
  bool _isLoading = false;
  String? _error;

  CapsuleProvider({
    required CapsuleRepository capsuleRepository,
    required ContentRepository contentRepository,
  })  : _capsuleRepository = capsuleRepository,
        _contentRepository = contentRepository;

  List<Capsule> get capsules => _capsules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCapsules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _capsules = await _capsuleRepository.getCapsules();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Capsule?> getCapsuleById(String id) async {
    return await _capsuleRepository.getCapsuleById(id);
  }

  Future<List<Content>> getContentsByCapsuleId(String id) async {
    return await _contentRepository.getContentsByCapsuleId(id);
  }

  Future<void> createCapsule({
    required String title,
    required CapsuleType type,
    String? groupName,
    required List<String> members,
    required DateTime openDate,
    String? firstContent,
  }) async {
    final capsule = Capsule(
      id: _uuid.v4(),
      title: title,
      type: type,
      groupName: groupName,
      members: members,
      createdAt: DateTime.now(),
      openDate: openDate,
      points: 100, // 기본 포인트 100원
      isOpened: false,
    );

    await _capsuleRepository.saveCapsule(capsule);

    // 첫 번째 콘텐츠가 있으면 추가
    if (firstContent != null && firstContent.isNotEmpty) {
      final content = Content(
        id: _uuid.v4(),
        capsuleId: capsule.id,
        text: firstContent,
        imageUrl: null,
        createdAt: DateTime.now(),
      );
      await _contentRepository.addContent(content: content);
    }

    await loadCapsules();
  }

  Future<void> addContent({
    required String capsuleId,
    required String text,
    String? imagePath,
  }) async {
    final content = Content(
      id: _uuid.v4(),
      capsuleId: capsuleId,
      text: text,
      imageUrl: null,
      createdAt: DateTime.now(),
    );

    await _contentRepository.addContent(
      content: content,
      imagePath: imagePath,
    );

    // 콘텐츠 개수에 따른 보너스 포인트 계산
    final contents = await _contentRepository.getContentsByCapsuleId(capsuleId);
    if (contents.length == 3) {
      final capsule = await _capsuleRepository.getCapsuleById(capsuleId);
      if (capsule != null) {
        final updatedCapsule = capsule.copyWith(
          points: capsule.points + 500, // 3개의 콘텐츠 추가 시 500원 보너스
        );
        await _capsuleRepository.updateCapsule(updatedCapsule);
      }
    }

    await loadCapsules();
  }

  Future<void> openCapsule(String id) async {
    final capsule = await _capsuleRepository.getCapsuleById(id);
    if (capsule != null) {
      final updatedCapsule = capsule.copyWith(isOpened: true);
      await _capsuleRepository.updateCapsule(updatedCapsule);
      await loadCapsules();
    }
  }
}
```

# Current-file-instructor (현재파일구조)

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

### 주요 디렉토리 설명

1. **app/**
   - 앱의 진입점과 전역 설정
   - 라우팅 설정

2. **data/**
   - 데이터 계층 구현
   - SQLite 헬퍼 및 저장소 관리

3. **models/**
   - 데이터 모델 정의
   - JSON 직렬화 코드 포함

4. **presentation/**
   - UI 관련 모든 구현체
   - 화면별 위젯과 프로바이더

5. **assets/**
   - 이미지 리소스

# rules (규칙)

## 1. 개발 규칙 (MVP 중심)

### 1.1 네이밍
- **파일명**: snake_case
- **클래스명**: PascalCase
- **변수/함수**: camelCase

### 1.2 구조
- 한 파일당 한 클래스 원칙
- 위젯은 200줄 이하로 제한
- Provider 의존성 최소화

### 1.3 MVP 제약사항
- 복잡한 애니메이션 금지
- 외부 라이브러리 최소화
- SQLite 기반 오프라인 전용

## 2. 성능 최적화

### 2.1 렌더링
- const 생성자 활용
- ListView.builder 사용
- 이미지 최적화 (2MB 제한)

### 2.2 상태 관리
- Provider 범위 최소화
- 불필요한 리빌드 방지
- SQLite 쿼리 최적화

## 3. 접근성

### 3.1 필수 요구사항
- 터치 영역 44x44 이상
- 기본 색상 대비 준수

### 3.2 사용성
- 로딩 상태 표시
- 에러 처리 UI
- 간단한 피드백 제공
- 오프라인 모드 지원

## 4. 개발 우선순위

### 4.1 Week 1-2: 기본 구조 ✅
- 프로젝트 셋업
- 데이터 모델 구현
- 데이터베이스 연결 (SQLite)
- 기본 화면 구현

### 4.2 Week 3-4: 핵심 기능 ✅
- 생성 플로우 구현
- 상세 화면 구현
- 이미지 처리 구현
- 데이터 로컬 저장 완료

### 4.3 Week 5-6: 완성
- 열람 기능 구현 ✅
- 애니메이션 추가 ✅
- 통합 테스트 및 버그 수정
- 테스트 및 폴리싱