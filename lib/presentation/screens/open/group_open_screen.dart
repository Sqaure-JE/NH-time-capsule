import 'package:flutter/material.dart';
import '../../../models/capsule.dart';
import '../../../models/content.dart';

class GroupOpenScreen extends StatefulWidget {
  final Capsule capsule;

  const GroupOpenScreen({
    super.key,
    required this.capsule,
  });

  @override
  State<GroupOpenScreen> createState() => _GroupOpenScreenState();
}

class _GroupOpenScreenState extends State<GroupOpenScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _contentController;
  late Animation<double> _animation;
  late Animation<double> _contentAnimation;
  bool _opened = false;
  bool _showContent = false;
  int _currentMemoryIndex = 0;

  // 더미 메모리 데이터 (개인형과 동일한 사진 포함)
  final List<Map<String, dynamic>> _groupMemories = [
    {
      'title': '여행 계획 세우기',
      'content': '다들 어디로 여행 갈지 정말 많이 고민했어! 결국 제주도로 결정했는데 벌써부터 너무 기대돼 ✈️',
      'date': '2024.12.20',
      'author': '이정은',
      'emoji': '🏝️',
      'type': 'travel',
      'amount': '+150,000원',
      'participants': ['이정은', '김혜진', '김수름', '한지혜'],
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500',
    },
    {
      'title': '모임비 모으기',
      'content': '이번 달 모임비도 다들 잘 모았네! 이정은이 맛집도 예약해줬고, 이제 12월 송년회 준비 완료야 🎉',
      'date': '2024.12.15',
      'author': '김혜진',
      'emoji': '💰',
      'type': 'finance',
      'amount': '+45,000원',
      'participants': ['이정은', '김혜진', '김수름', '한지혜'],
      'imageUrl':
          'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500',
    },
    {
      'title': '카페에서 공부모임',
      'content': '오늘 카페에서 다들 진짜 열심히 공부했어! 수름이 케이크까지 사줘서 너무 고마웠어 🍰',
      'date': '2024.12.10',
      'author': '김수름',
      'emoji': '📚',
      'type': 'activity',
      'amount': '+12,000원',
      'participants': ['이정은', '김혜진', '김수름', '한지혜'],
      'imageUrl':
          'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=500',
    },
    {
      'title': '맛집 탐방',
      'content': '새로운 파스타집 발견! 다들 맛있다고 하니까 정말 뿌듯해 🍝',
      'date': '2024.12.05',
      'author': '한지혜',
      'emoji': '🍽️',
      'type': 'activity',
      'amount': '+32,000원',
      'participants': ['이정은', '김혜진', '김수름', '한지혜'],
      'imageUrl':
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500',
    },
    {
      'title': '쇼핑 데이',
      'content': '다들 같이 쇼핑하니까 더 재밌어! 서로 코디도 봐주고 👗',
      'date': '2024.12.01',
      'author': '이정은',
      'emoji': '🛍️',
      'type': 'activity',
      'amount': '+85,000원',
      'participants': ['이정은', '김혜진', '김수름', '한지혜'],
      'imageUrl':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _contentAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutQuart),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward();
      setState(() {
        _opened = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _showContent = true;
      });
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDF9),
      body: _showContent ? _buildContentView() : _buildOpeningAnimation(),
    );
  }

  Widget _buildOpeningAnimation() {
    return AppBar(
      backgroundColor: const Color(0xFFF8FDF9),
      foregroundColor: Colors.black,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: -0.2 + 0.2 * _animation.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/treasure_box_closed.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                          opacity: AlwaysStoppedAnimation(1 - _animation.value),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                size: 80,
                                color: Color(0xFF4CAF50),
                              ),
                            );
                          },
                        ),
                        Image.asset(
                          'assets/treasure_box_open.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                          opacity: AlwaysStoppedAnimation(_animation.value),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: Color(0xFF4CAF50),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _opened ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: const Column(
                  children: [
                    Text(
                      '따란! 타임캡슐이 열리고 있어요!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '우리의 추억을 확인해봐요!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return AnimatedBuilder(
      animation: _contentAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _contentAnimation.value)),
          child: Opacity(
            opacity: _contentAnimation.value,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF66BB6A),
                    Color(0xFF81C784),
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  _buildSliverHeader(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildGroupInsightBanner(),
                          const SizedBox(height: 20),
                          _buildFilterTabs(),
                          const SizedBox(height: 20),
                          _buildGroupMemoryList(),
                          const SizedBox(height: 20),
                          _buildGroupAnalysis(),
                          const SizedBox(height: 20),
                          _buildProductRecommendations(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: const Color(0xFF4CAF50),
      foregroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    '🌿 우리 모임의 타임캡슐',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '모임원들과 함께 만든 소중한 추억들',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildGroupStatsGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('${_groupMemories.length}', '총 기록')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('4', '모임원')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('5', '사진')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('3', '금융')),
      ],
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'id': 'all', 'icon': '🌟', 'label': '전체'},
      {'id': 'travel', 'icon': '✈️', 'label': '여행'},
      {'id': 'finance', 'icon': '💰', 'label': '금융'},
      {'id': 'activity', 'icon': '🎯', 'label': '활동'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isActive = _selectedFilter == filter['id'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter['id']!;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF4CAF50) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter['icon']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label']!,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroupInsightBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.analytics,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '모임 금융 분석',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '우리 모임의 소비 패턴과 금융 습관을 분석했어요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupMemoryList() {
    final filteredMemories = _getFilteredMemories();
    return Column(
      children: [
        for (int i = 0; i < filteredMemories.length; i++) ...[
          _buildGroupMemoryCard(filteredMemories[i]),
          if (i < filteredMemories.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredMemories() {
    if (_selectedFilter == 'all') {
      return _groupMemories;
    }
    return _groupMemories
        .where((memory) => memory['type'] == _selectedFilter)
        .toList();
  }

  String _selectedFilter = 'all';

  Widget _buildGroupMemoryCard(Map<String, dynamic> memory) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 헤더
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: memory['type'] == 'travel'
                    ? [const Color(0xFF42A5F5), const Color(0xFF1E88E5)]
                    : memory['type'] == 'finance'
                        ? [const Color(0xFF66BB6A), const Color(0xFF4CAF50)]
                        : [const Color(0xFFFF7043), const Color(0xFFFF5722)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        memory['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${memory['author']} • ${memory['date']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        memory['amount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  memory['content'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // 이미지 섹션
          if (memory['imageUrl'] != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(memory['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // 하단 정보
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 참여자 정보
                const Row(
                  children: [
                    Icon(Icons.groups, color: Color(0xFF4CAF50), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '모임 참여자',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (memory['participants'] as List<String>)
                      .map((participant) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  radius: 8,
                                  child: Text(
                                    participant[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  participant,
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),

                // 추천 상품
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            '💡',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '우리 모임에 딱 맞는 추천',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        memory['type'] == 'travel'
                            ? '✈️ 여행적금과 해외여행보험으로 더 즐거운 여행을 계획해보세요'
                            : memory['type'] == 'finance'
                                ? '💰 모임통장과 공동투자로 함께 돈을 모아보세요'
                                : '🎯 모임활동에 최적화된 카드와 혜택을 만나보세요',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (memory['type'] == 'travel') {
                              _showTravelAdviceDialog();
                            } else if (memory['type'] == 'finance') {
                              _showGroupFinanceDialog();
                            } else {
                              _showGroupActivityDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            memory['type'] == 'travel'
                                ? '여행 상품 둘러보기'
                                : memory['type'] == 'finance'
                                    ? '모임 금융상품 알아보기'
                                    : '모임 카드 신청하기',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupAnalysis() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '💝',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 12),
              Text(
                '우리 모임의 금융 패턴 분석',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '모임원들의 소비 패턴과 감정을 분석한 특별한 맞춤 서비스',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          // 모임원별 감정-금융 패턴
          Row(
            children: [
              Expanded(
                child: _buildGroupEmotionCard(
                  emotion: '😊',
                  title: '행복지수 UP시 저축률 증가',
                  description: '모임이 즐거울 때 모임비도 더 많이 모으는 패턴',
                  product: 'NH모임적금',
                  benefit: '행복보너스 연0.3%p',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGroupEmotionCard(
                  emotion: '🎯',
                  title: '목표 설정시 달성률 90%',
                  description: '모임 목표가 있을 때 달성률이 매우 높음',
                  product: 'NH목표달성통장',
                  benefit: '목표달성시 +0.5%p',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 모임 추천 상품들
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      '🎯',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '모임 맞춤 추천',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickGroupRecommendCard(
                        '💳',
                        'NH모임카드',
                        '자동정산+포인트적립',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickGroupRecommendCard(
                        '🏦',
                        'NH공동통장',
                        '모임비 통합관리',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRecommendations() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProductCard(
            '🏆 베스트',
            'NH모임통장',
            '모임원 모두가 함께 관리하는 똑똑한 통장이야!\n• 자동 정산 기능\n• 목표 금액 설정 시 우대금리\n• 모임원별 기여도 확인\n• 월 수수료 면제',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 12),
          _buildProductCard(
            '💎 추천',
            'NH여행적금',
            '여행 목표를 세우고 함께 모으는 특별한 적금!\n• 여행 달성 시 추가 보너스\n• 여행보험 무료 제공\n• 항공마일리지 연동\n• 여행 할인쿠폰 제공',
            const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  // 헬퍼 메서드들
  Widget _buildProductCard(
      String tag, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showProductDetailDialog(title, description);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '자세히 보기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupEmotionCard({
    required String emotion,
    required String title,
    required String description,
    required String product,
    required String benefit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emotion,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  benefit,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickGroupRecommendCard(
      String icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 다이얼로그 메서드들
  void _shareGroupCapsule(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모임 타임캡슐이 공유되었어! 📤')),
    );
  }

  void _showTravelAdviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.flight_takeoff,
                color: Color(0xFF2196F3),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'NH여행적금',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모임 여행을 위한 똑똑한 준비!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '✈️ 여행 목표달성시 추가 금리 혜택\n🛡️ 해외여행보험 모임원 전체 50% 할인\n💳 여행카드 해외결제 수수료 면제\n✨ 항공마일리지 모임원 통합 적립\n🎁 여행용품 할인쿠폰 제공\n📱 실시간 환율 알림 서비스',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '모임원들과 함께 꿈꾸던 여행을 현실로 만들어보자!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('상품 신청 페이지로 이동해! 🚀')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
              ),
              child: const Text('신청하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showGroupFinanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.account_balance,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'NH모임통장',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모임비 관리가 이렇게 쉬울 줄이야!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '💰 자동 정산 기능으로 간편하게\n📊 모임원별 기여도 한눈에 확인\n🎯 목표 금액 설정시 우대금리 적용\n💳 모임전용 카드 무료 발급\n📱 실시간 잔액 알림 서비스\n🎁 월 수수료 완전 면제',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '이제 모임비 관리 때문에 스트레스 받지 말자!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모임통장 개설 신청 완료! 🎉')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('신청하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showGroupActivityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.credit_card,
                color: Color(0xFFFF7043),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'NH모임카드',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모임 활동할 때 더 많은 혜택을!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '☕ 카페/디저트 최대 7% 적립\n📚 도서/문구 구매 5% 할인\n🏢 스터디카페 이용권 지원\n📍 모임공간 예약 수수료 면제\n🎭 문화생활 할인 혜택\n🍔 모임 식사비 2% 추가 적립',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '모임 활동이 더욱 알차고 경제적으로!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모임카드 신청 완료! 💳')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
              ),
              child: const Text('신청하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showProductDetailDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎉 모임 특별 혜택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• 모임원 전체 우대금리 적용\n• 첫 해 수수료 완전 면제\n• 자동 정산 기능 무료 제공\n• 모임 전용 혜택 추가 제공\n• 24시간 고객센터 지원\n• 모임 목표 달성 시 보너스 적립',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B5E20),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('상품 신청이 접수되었어! 🎉')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('신청하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
