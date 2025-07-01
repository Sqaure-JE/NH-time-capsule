import 'package:flutter/material.dart';
import '../../../models/capsule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // 새로 만든 캡슐을 저장하기 위한 static 변수와 메서드
  static Map<String, dynamic>? _newCapsule;

  static void addNewCapsule(Map<String, dynamic> capsule) {
    _newCapsule = capsule;
  }

  static Map<String, dynamic>? getAndClearNewCapsule() {
    final capsule = _newCapsule;
    _newCapsule = null;
    return capsule;
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _capsules = [
    {
      'capsule': Capsule(
        id: '1',
        title: '나의 첫 월급 기념',
        type: CapsuleType.personal,
        members: ['user1'],
        createdAt: DateTime(2025, 5, 1),
        openDate: DateTime(2025, 8, 12),
        points: 0,
        isOpened: false,
      ),
      'contentCount': 3,
    },
    {
      'capsule': Capsule(
        id: '2',
        title: '대학 동기 여행 계획',
        type: CapsuleType.group,
        members: ['user1', 'user2'],
        createdAt: DateTime(2025, 5, 8),
        openDate: DateTime(2025, 12, 25),
        points: 0,
        isOpened: false,
      ),
      'contentCount': 6,
    },
    {
      'capsule': Capsule(
        id: '3',
        title: '내가 쓴 최근 타임캡슐',
        type: CapsuleType.personal,
        members: ['user1'],
        createdAt: DateTime.now(),
        openDate: DateTime.now().add(const Duration(days: 100)),
        points: 0,
        isOpened: false,
      ),
      'contentCount': 1,
      'showOpenButton': true,
    },
  ];

  void _increaseContentCount(String capsuleId) {
    setState(() {
      final idx = _capsules.indexWhere((c) => c['capsule'].id == capsuleId);
      if (idx != -1) {
        _capsules[idx]['contentCount'] =
            (_capsules[idx]['contentCount'] ?? 0) + 1;
      }
    });
  }

  void _onAddButtonPressed() async {
    final result = await Navigator.pushNamed(context, '/capsule_create');
    if (result is Map<String, dynamic>) {
      addCapsuleToList(result);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForNewCapsule();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면이 다시 포커스를 받을 때마다 새 캡슐 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForNewCapsule();
    });
  }

  void _checkForNewCapsule() {
    // 라우트 arguments 확인
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['capsule'] != null) {
      addCapsuleToList(args);
    }

    // static 변수에서 새 캡슐 확인
    final newCapsule = HomeScreen.getAndClearNewCapsule();
    if (newCapsule != null) {
      addCapsuleToList(newCapsule);
    }
  }

  // 캡슐을 리스트에 추가하는 헬퍼 메서드
  void addCapsuleToList(Map<String, dynamic> capsuleData) {
    setState(() {
      // 중복 추가 방지를 위해 같은 ID의 캡슐이 있는지 확인
      final existingIndex = _capsules
          .indexWhere((c) => c['capsule'].id == capsuleData['capsule'].id);
      if (existingIndex >= 0) {
        _capsules[existingIndex] = capsuleData;
      } else {
        // 새 캡슐을 리스트의 맨 앞에 추가
        _capsules.insert(0, capsuleData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {}, // TODO: 뒤로가기
        ),
        title: const Text('금융 타임캡슐'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {}, // TODO: 홈 이동
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // TODO: 메뉴
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF8F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBanner(),
                const SizedBox(height: 24),
                const _CapsuleTypeSection(),
                const SizedBox(height: 24),
                _ServiceInfoSection(),
                const SizedBox(height: 24),
                _MyCapsulesSection(
                    capsules: _capsules, onContentAdded: _increaseContentCount),
                const SizedBox(height: 16),
                _PointBanner(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance),
            label: '금융',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: '쇼핑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '마이',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50),
        onPressed: _onAddButtonPressed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TopBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('타임캡슐 만들고, 추억을 저장!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('노릇하게 구워진 추억 저장소',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 2),
                Text('2,000포인트 적립 중!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('1/3',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }
}

class _CapsuleTypeSection extends StatelessWidget {
  const _CapsuleTypeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('타임캡슐 유형',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _TypeCard(
              icon: Icons.person_outline,
              label: '개인형',
              description: '나만의 일기와\n금융생활을 기록해요',
              color: const Color(0xFFF3EDFF),
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/capsule_create');
                if (result is Map<String, dynamic> && context.mounted) {
                  // HomeScreenState의 _addCapsuleToList 메서드를 호출하기 위해 context를 통해 접근
                  final homeState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.addCapsuleToList(result);
                }
              },
            ),
            _TypeCard(
              icon: Icons.groups_outlined,
              label: '모임형',
              description: '친구들과 함께\n계비를 관리해요',
              color: const Color(0xFFEAF3FF),
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/capsule_create');
                if (result is Map<String, dynamic> && context.mounted) {
                  // HomeScreenState의 _addCapsuleToList 메서드를 호출하기 위해 context를 통해 접근
                  final homeState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.addCapsuleToList(result);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(description,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ServiceInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('금융 타임캡슐 서비스',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          _ServiceInfoRow('금융활동과 일상의 추억을 함께 저장', '은행 거래 내역과 함께 사진, 영상 기록'),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '7일 연속 타임캡슐 작성 시\n200P 추가적립',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _ServiceInfoRow('3개월, 6개월, 1년 등 보관 기간 설정', '원하는 미래 시점에 추억 확인'),
          _ServiceInfoRow('단계별 서비스 확장 예정', '카드, 마이데이터 등 연계 예정'),
        ],
      ),
    );
  }
}

class _ServiceInfoRow extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ServiceInfoRow(this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCapsulesSection extends StatelessWidget {
  final List<Map<String, dynamic>> capsules;
  final void Function(String capsuleId)? onContentAdded;
  const _MyCapsulesSection({required this.capsules, this.onContentAdded});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('나의 타임캡슐',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...capsules
            .map((c) => _MyCapsuleCard(
                  capsule: c['capsule'] as Capsule,
                  contentCount: c['contentCount'] as int,
                  showOpenButton: c['showOpenButton'] == true,
                  onContentAdded: onContentAdded,
                ))
            .toList(),
      ],
    );
  }
}

class _MyCapsuleCard extends StatelessWidget {
  final Capsule capsule;
  final int contentCount;
  final bool showOpenButton;
  final void Function(String capsuleId)? onContentAdded;

  const _MyCapsuleCard({
    required this.capsule,
    required this.contentCount,
    this.showOpenButton = false,
    this.onContentAdded,
  });

  @override
  Widget build(BuildContext context) {
    final dDay = capsule.openDate.difference(DateTime.now()).inDays;
    final color = capsule.type == CapsuleType.personal
        ? const Color(0xFF4CAF50)
        : const Color(0xFF3B7BFF);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, '/detail',
            arguments: capsule.id);
        if (result == 'contentAdded' && onContentAdded != null) {
          onContentAdded!(capsule.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(25), // 0.1 * 255 ≈ 25
                  child: Icon(
                    capsule.type == CapsuleType.personal
                        ? Icons.visibility
                        : Icons.groups,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(capsule.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: color)),
                      const SizedBox(height: 4),
                      Text(
                          '${capsule.openDate.year}년 ${capsule.openDate.month}월 ${capsule.openDate.day}일 오픈 예정',
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text('마지막 추억 저장: 2025.05.0${capsule.id}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('D-${dDay > 0 ? dDay : 0}',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('콘텐츠 $contentCount개',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.deepPurple)),
                  ],
                ),
              ],
            ),
            if (showOpenButton)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                        context, '/capsule_open',
                        arguments: capsule.id);
                    if (result == 'contentAdded' && onContentAdded != null) {
                      onContentAdded!(capsule.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('타임캡슐 열기'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PointBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.attach_money, color: Colors.amber, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Text('NH멤버스 포인트 적립 중!\n7일 연속 타임캡슐 작성 시 200P 추가 적립',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
