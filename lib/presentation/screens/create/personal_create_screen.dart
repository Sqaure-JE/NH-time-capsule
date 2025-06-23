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
            initialValue: '첫 월급 입금! 드디어 시작된 직장생활',
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
                '오늘 드디어 첫 월급이 입금되었다! 취업 준비하며 고생했던 시간들이 주마등처럼 스쳐 지나간다. 이제 금융적으로 독립할 수 있게 되어서 너무 기쁘다. 월급의 절반은 미래를 위해 저축하고, 나머지는 현명하게 사용해야겠다. 6개월 후 이 타',
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
              onPressed: () {},
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
}
