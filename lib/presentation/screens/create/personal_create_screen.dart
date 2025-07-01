import 'package:flutter/material.dart';

class PersonalCreateScreen extends StatelessWidget {
  const PersonalCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('나의 금융 일기'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF8F8FA),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        children: const [
          _DateSection(),
          SizedBox(height: 12),
          _FinanceActivitySection(),
          SizedBox(height: 18),
          _DiarySection(),
          SizedBox(height: 18),
          _PhotoSection(),
          SizedBox(height: 18),
          _RewardSection(),
          SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _BottomButtons(),
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2025년 5월 12일 월요일',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          SizedBox(height: 4),
          Text('오후 3:08 작성 중',
              style: TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }
}

class _FinanceActivitySection extends StatelessWidget {
  const _FinanceActivitySection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('오늘의 금융 활동',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {},
                child: const Text('더보기',
                    style: TextStyle(
                        color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _FinanceActivityItem(
            icon: Icons.arrow_upward,
            iconColor: Colors.red,
            title: '스타벅스 강남점',
            subtitle: 'NH 체크카드',
            amount: '-5,600원',
            amountColor: Colors.red,
          ),
          const _FinanceActivityItem(
            icon: Icons.arrow_downward,
            iconColor: Colors.blue,
            title: '급여',
            subtitle: 'NH 통장',
            amount: '+2,450,000원',
            amountColor: Colors.blue,
          ),
          const _FinanceActivityItem(
            icon: Icons.camera,
            iconColor: Colors.green,
            title: '적금 자동이체',
            subtitle: 'NH 적금',
            amount: '500,000원',
            amountColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _FinanceActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  const _FinanceActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                  fontSize: 16)),
        ],
      ),
    );
  }
}

class _DiarySection extends StatelessWidget {
  const _DiarySection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘의 일기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const Text('제목',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: '월요병 때문에 힘든 하루',
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: const Color(0xFFF8F8FA),
            ),
          ),
          const SizedBox(height: 12),
          const Text('내용',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            maxLines: 5,
            initialValue:
                '월요일이라 정말 피곤하고 힘들다. 주말이 너무 짧게 느껴지고 일주일이 또 시작된다는 생각에 우울하다. 스트레스를 풀고 싶어서 카페에서 비싼 음료를 마시고 배달음식도 시켰다. 계획 없이 소비하는 내 모습이 걱정되지만, 오늘만큼은 나를 위로해주고 싶었다.',
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: const Color(0xFFF8F8FA),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('사진 추가',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Color(0xFF4CAF50), size: 36),
                    SizedBox(height: 8),
                    Text('사진이나 영상을 추가해보세요',
                        style: TextStyle(color: Colors.black38, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardSection extends StatelessWidget {
  const _RewardSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_money, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Text('타임캡슐 작성 리워드',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 6),
          const Text('작성 시 NH멤버스 50포인트 적립', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('연속 작성 중 - 5일째',
                  style: TextStyle(fontSize: 13, color: Colors.black87)),
              const Spacer(),
              Text('7일 (+200P)',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber[800],
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0일', style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text('5일', style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text('7일', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                side: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              child: const Text('임시저장'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showPointsDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('작성완료'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPointsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF8E1), Color(0xFFFFF3C4)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 포인트 아이콘과 애니메이션
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    size: 48,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 16),

                // 축하 메시지
                const Text(
                  '🎉 작성 완료!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),

                // 포인트 적립 메시지
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/treasure_box_closed.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.account_balance_wallet,
                                size: 24,
                                color: Color(0xFF4CAF50),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'NH멤버스 포인트',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '50P 적립!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 추가 정보
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '연속 작성 보너스',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '7일 연속 작성 시 +200P 추가!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 확인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // 일기 작성 화면도 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}
