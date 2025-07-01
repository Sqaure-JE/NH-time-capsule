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
                        _buildFinancialInsightBanner(),
                        const SizedBox(height: 20),
                        _buildFilterTabs(),
                        const SizedBox(height: 20),
                        _buildMemoryList(),
                        const SizedBox(height: 20),
                        _buildRecommendationSection(),
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
        'type': 'finance',
        'icon': '☕',
        'title': '건강한 아침 식사',
        'date': '2024년 5월 8일',
        'ago': '2개월 전',
        'content': '고모네 순대국에서 아침 식사를 했다. 농협카드로 결제하니 자동으로 포인트가 적립되었다.',
        'financeData': [
          {
            'category': '아침 식사',
            'icon': '🥪',
            'amount': '-8,500원',
            'change': '농협카드 결제'
          },
          {
            'category': '포인트 적립',
            'icon': '💳',
            'amount': '+85P',
            'change': '1% 적립'
          },
        ],
        'tags': ['#아침식사', '#농협카드', '#포인트적립'],
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
            _buildFinanceSection(memory['financeData'], memory),
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

  Widget _buildFinanceSection(
      List<Map<String, String>> financeData, Map<String, dynamic> memory) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // 투자 성과 기록에만 헤더 표시
              if (memory['title'] == '투자 성과 기록')
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.celebration,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        '🎯 목표 달성을 축하드려요!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ...financeData.map((data) {
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
            ],
          ),
        ),
        _buildFinanceRecommendationBanner(memory),
      ],
    );
  }

  Widget _buildFinanceRecommendationBanner(Map<String, dynamic> memory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF16A34A), Color(0xFF15803D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory['title'] == '투자 성과 기록'
                          ? '🎯 목표 달성을 축하드려요!'
                          : '💳 고객님께 맞춤 카드 추천!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      memory['title'] == '투자 성과 기록'
                          ? '이제 한 단계 더 높은 목표에 도전해보세요'
                          : '일상에서 더 많은 혜택을 받아보세요',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      '🚀',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '다음 단계 추천',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  memory['title'] == '투자 성과 기록'
                      ? '• 포트폴리오 다변화: 해외주식 ETF 투자\n• 세제혜택 활용: ISA 통장 개설\n• 장기투자: 연금저축펀드 추가\n• 안정자산: 국내 우량 채권형 펀드'
                      : '• 카페/베이커리 최대 5% 적립\n• 대중교통 10% 할인\n• 온라인쇼핑 2% 적립\n• 연회비 첫 해 면제\n• 쌀 구독서비스 제공(쌀/즉석밥등 정기배송)\n• 아침밥 50% 청구할인',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (memory['title'] == '투자 성과 기록') {
                        _showInvestmentAdviceDialog();
                      } else {
                        _showPersonalizedAdviceDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      memory['title'] == '투자 성과 기록' ? '맞춤 상담 받기' : '미미카드 신청하기',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
    );
  }

  void _showInvestmentAdviceDialog() {
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
                Icons.trending_up,
                color: Color(0xFF16A34A),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                '맞춤 투자 상담',
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
                '고객님의 투자 성향과 목표를 분석한 결과:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '✅ 안정적인 저축 습관 형성 완료\n✅ 투자 수익률 목표 초과 달성\n✅ 리스크 관리 능력 우수',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '전문 상담사가 고객님만의 투자 전략을 제안해드립니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '나중에',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 상담 예약 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '상담 예약',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPersonalizedAdviceDialog() {
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
                color: Color(0xFFEC4899),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                '농협카드 미미카드',
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
                '고객님께 딱 맞는 카드를 추천드려요!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '💳 카페/베이커리 최대 5% 적립\n🚇 대중교통 10% 할인\n🛒 온라인쇼핑 2% 적립\n🎁 연회비 첫 해 면제\n🍚 쌀 구독서비스 제공(쌀/즉석밥등 정기배송)\n🍚 아침밥 50% 청구할인',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '일상생활에서 더 많은 혜택을 누려보세요!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '나중에',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 카드 신청 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC4899),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '카드 신청',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
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

  Widget _buildFinancialInsightBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎉 훌륭한 금융 성장을 보여주셨네요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '지난 6개월간의 여정을 돌아보며 더 큰 목표를 세워보세요',
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
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: '💎',
                  title: '투자 수익률',
                  value: '+12.5%',
                  subtitle: '목표 대비 125%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  icon: '🎯',
                  title: '저축 달성률',
                  value: '100%',
                  subtitle: '목표 완료!',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💡 맞춤 금융상품 추천',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '과거 기록을 바탕으로 분석한 최적의 상품을 추천드려요',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecommendationCard(
                icon: '🎯',
                title: 'NH 목돈마련 적금',
                subtitle: '안정형 저축자',
                description: '적금 목표를 달성하신 고객님께 한 단계 높은 상품',
                expectedReturn: '연 3.5%',
                riskLevel: '안전',
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 16),
              _buildRecommendationCard(
                icon: '🏠',
                title: 'NH 주택청약종합저축',
                subtitle: '미래 준비형',
                description: '안정적인 자산 관리로 내 집 마련의 첫걸음',
                expectedReturn: '연 2.8%',
                riskLevel: '안전',
                color: const Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 16),
              _buildRecommendationCard(
                icon: '🚀',
                title: 'NH투자증권 ETF',
                subtitle: '성장형 투자자',
                description: '꾸준한 투자 성과를 보여주시는 고객님께 추천',
                expectedReturn: '연 8-12%',
                riskLevel: '중위험',
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 16),
              _buildRecommendationCard(
                icon: '💳',
                title: '농협카드 미미카드',
                subtitle: '스마트 소비형',
                description: '일상 소비에서 포인트 적립과 혜택을 원하는 고객님께 추천',
                expectedReturn: '최대 2% 적립',
                riskLevel: '혜택',
                color: const Color(0xFFEC4899),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildNextStepBanner(),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required String icon,
    required String title,
    required String subtitle,
    required String description,
    required String expectedReturn,
    required String riskLevel,
    required Color color,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '예상 수익률',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    expectedReturn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
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

  Widget _buildNextStepBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFF59E0B),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '다음 목표를 설정해보세요! 🎯',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '목표 달성률 100%를 기록하신 고객님! 더 큰 꿈을 향해 도전해보세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA16207),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              if (title.contains('미미카드'))
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFEC4899).withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎉 특별 혜택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBE185D),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• 카페/베이커리 최대 5% 적립\n• 대중교통 10% 할인\n• 온라인쇼핑 2% 적립\n• 연회비 첫 해 면제\n• 쌀 구독서비스 제공(쌀/즉석밥등 정기배송)\n• 아침밥 50% 청구할인',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9D174D),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF0EA5E9).withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 투자 포인트',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• 장기 투자 시 세제 혜택\n• 분산 투자 효과\n• 낮은 운용 보수\n• 전문가 운용',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0369A1),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                title.contains('미미카드')
                    ? '카드 신청 및 자세한 혜택은 농협카드 고객센터로 연락주세요.'
                    : '상담을 원하시면 NH농협은행 고객센터로 연락주세요.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 상담 신청 로직 추가 가능
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: title.contains('미미카드')
                    ? const Color(0xFFEC4899)
                    : const Color(0xFF48CC6C),
                foregroundColor: Colors.white,
              ),
              child: Text(title.contains('미미카드') ? '카드 신청' : '상담 신청'),
            ),
          ],
        );
      },
    );
  }
}
