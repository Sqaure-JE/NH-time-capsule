import 'package:flutter/material.dart';

class CapsuleOpenScreen extends StatefulWidget {
  final String capsuleId;
  const CapsuleOpenScreen({super.key, required this.capsuleId});

  @override
  State<CapsuleOpenScreen> createState() => _CapsuleOpenScreenState();
}

class _CapsuleOpenScreenState extends State<CapsuleOpenScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _contentController;
  late Animation<double> _animation;
  late Animation<double> _contentAnimation;
  bool _opened = false;
  bool _showContent = false;
  String _selectedFilter = 'all';

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
                      '따란! 타임캡슐이 열렸어요',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '소중한 추억들을 확인해보세요',
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
            child: CustomScrollView(
              slivers: [
                _buildHeader(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildFilterTabs(),
                        const SizedBox(height: 20),
                        _buildMemoryList(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: const Color(0xFF48CC6C),
      foregroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF48CC6C), Color(0xFF5DC77C)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    '🌿 나의 타임캡슐',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '그때의 소중한 추억들을 다시 만나보세요',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildStatsGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('28', '총 기록')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('12', '텍스트')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('9', '사진')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('7', '금융')),
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
      {'id': 'text', 'icon': '📝', 'label': '글'},
      {'id': 'photo', 'icon': '📸', 'label': '사진'},
      {'id': 'finance', 'icon': '💰', 'label': '금융'},
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
                color: isActive ? const Color(0xFF48CC6C) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF48CC6C)
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF48CC6C).withOpacity(0.3),
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

  Widget _buildMemoryList() {
    final memories = _getFilteredMemories();
    return Column(
      children: memories.map((memory) => _buildMemoryCard(memory)).toList(),
    );
  }

  List<Map<String, dynamic>> _getFilteredMemories() {
    final allMemories = [
      {
        'type': 'text',
        'icon': '✍️',
        'title': '새해 다짐',
        'date': '2024년 1월 1일',
        'ago': '6개월 전',
        'content':
            '올해는 꼭 건강한 습관을 만들어서 지속하고 싶다. 매일 30분씩 운동하고, 독서도 꾸준히 하면서 내 자신을 더 발전시키는 한 해로 만들겠다.',
        'tags': ['#새해다짐', '#건강', '#성장'],
      },
      {
        'type': 'photo',
        'icon': '🌸',
        'title': '벚꽃 여행',
        'date': '2024년 4월 15일',
        'ago': '3개월 전',
        'content': '경주로 벚꽃 여행을 다녀왔다. 분홍빛 벚꽃이 흩날리는 길을 걸으며 힐링하는 시간이었다.',
        'photos': ['🌸', '📷', '☕', '🌿'],
        'tags': ['#벚꽃', '#경주', '#힐링'],
      },
      {
        'type': 'finance',
        'icon': '📈',
        'title': '투자 성과 기록',
        'date': '2024년 3월 30일',
        'ago': '4개월 전',
        'content': '1분기 투자 수익률과 적금 목표 달성을 기록했다.',
        'financeData': [
          {
            'category': '주식 투자',
            'icon': '💎',
            'amount': '+1,850,000원',
            'change': '+12.5%'
          },
          {
            'category': '적금',
            'icon': '🏦',
            'amount': '+3,000,000원',
            'change': '목표 완료'
          },
        ],
        'tags': ['#투자성과', '#적금완료', '#목표달성'],
      },
      {
        'type': 'text',
        'icon': '💭',
        'title': '졸업 소감',
        'date': '2024년 2월 20일',
        'ago': '5개월 전',
        'content':
            '드디어 졸업했다! 4년간의 대학생활이 끝났다는 게 아직도 실감이 안 난다. 힘들었지만 값진 경험들이었고, 이제 새로운 시작을 앞두고 있다.',
        'tags': ['#졸업', '#새시작', '#성취'],
      },
      {
        'type': 'photo',
        'icon': '🎓',
        'title': '졸업식 사진',
        'date': '2024년 2월 15일',
        'ago': '5개월 전',
        'content': '가족들과 함께한 졸업식. 힘들었던 시간들이 모두 보람으로 바뀌는 순간이었다.',
        'photos': ['🎓', '👨‍👩‍👧‍👦', '📸', '🌟'],
        'tags': ['#졸업식', '#가족', '#감동'],
      },
    ];

    if (_selectedFilter == 'all') {
      return allMemories;
    }
    return allMemories
        .where((memory) => memory['type'] == _selectedFilter)
        .toList();
  }

  Widget _buildMemoryCard(Map<String, dynamic> memory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMemoryHeader(memory),
          _buildMemoryContent(memory),
        ],
      ),
    );
  }

  Widget _buildMemoryHeader(Map<String, dynamic> memory) {
    Color iconColor;
    switch (memory['type']) {
      case 'photo':
        iconColor = const Color(0xFF38BDF8);
        break;
      case 'finance':
        iconColor = const Color(0xFFFBBF24);
        break;
      default:
        iconColor = const Color(0xFF48CC6C);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                memory['icon'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  memory['date'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              memory['ago'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryContent(Map<String, dynamic> memory) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (memory['photos'] != null) _buildPhotoSection(memory['photos']),
          if (memory['financeData'] != null)
            _buildFinanceSection(memory['financeData']),
          Text(
            memory['content'],
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF475569),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          _buildTags(memory['tags']),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(List<String> photos) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent, width: 2),
            ),
            child: Center(
              child: Text(
                photos[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinanceSection(List<Map<String, String>> financeData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: financeData.map((data) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      data['icon']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data['category']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['amount']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      data['change']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
