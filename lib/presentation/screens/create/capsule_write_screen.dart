import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/capsule.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../home/widgets/emoji_selector.dart';

class CapsuleWriteScreen extends StatefulWidget {
  final CapsuleType capsuleType;
  const CapsuleWriteScreen({super.key, required this.capsuleType});

  @override
  State<CapsuleWriteScreen> createState() => _CapsuleWriteScreenState();
}

class _CapsuleWriteScreenState extends State<CapsuleWriteScreen> {
  String selectedMood = '😊';
  String selectedSituation = '💰';
  final TextEditingController _titleController = TextEditingController();

  // 모임 멤버들의 최근 활동 (더미 데이터)
  final List<Map<String, dynamic>> memberActivities = [
    {
      'member': '이정은',
      'emoji': '😊',
      'activity': '점심값 공동 결제',
      'amount': '-15,000원',
      'time': '2시간 전',
    },
    {
      'member': '김혜진',
      'emoji': '🤗',
      'activity': '여행 경비 적금',
      'amount': '+50,000원',
      'time': '4시간 전',
    },
    {
      'member': '김수름',
      'emoji': '💪',
      'activity': '카페 간식비',
      'amount': '-8,500원',
      'time': '6시간 전',
    },
    {
      'member': '한지혜',
      'emoji': '🌟',
      'activity': '영화 관람비',
      'amount': '-12,000원',
      'time': '1일 전',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.capsuleType == CapsuleType.personal
            ? '나의 금융 일기'
            : '모임 금융 일기'),
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
        children: [
          const _DateSection(),
          const SizedBox(height: 12),
          if (widget.capsuleType == CapsuleType.group) ...[
            _buildGroupMemberActivities(),
            const SizedBox(height: 12),
            _buildGroupTitleInput(),
            const SizedBox(height: 18),
          ] else ...[
            const _FinanceActivitySection(),
            const SizedBox(height: 18),
          ],
          EmojiSelector(
            title: widget.capsuleType == CapsuleType.personal
                ? '기분 선택하기 😊'
                : '오늘 모임 기분은? 😊',
            selectedEmoji: selectedMood,
            emojis: EmojiCategories.moods,
            onSelected: (emoji) {
              setState(() {
                selectedMood = emoji;
              });
            },
          ),
          const SizedBox(height: 12),
          EmojiSelector(
            title: widget.capsuleType == CapsuleType.personal
                ? '내 상황 선택하기 💰'
                : '우리 모임 상황은? 💰',
            selectedEmoji: selectedSituation,
            emojis: EmojiCategories.financialSituations,
            onSelected: (emoji) {
              setState(() {
                selectedSituation = emoji;
              });
            },
          ),
          const SizedBox(height: 18),
          _DiarySection(
            selectedMood: selectedMood,
            selectedSituation: selectedSituation,
            capsuleType: widget.capsuleType,
            titleController: _titleController,
          ),
          const SizedBox(height: 18),
          const _PhotoSection(),
          const SizedBox(height: 18),
          const _RewardSection(),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _BottomButtons(),
    );
  }

  Widget _buildGroupMemberActivities() {
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
              const Text(
                '모임원들의 최근 활동',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${memberActivities.length}개 업데이트',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...memberActivities
              .map((activity) => _buildMemberActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildMemberActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
            child: Text(
              activity['emoji'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      activity['member'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activity['time'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity['activity'],
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            activity['amount'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color:
                  activity['amount'].startsWith('+') ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTitleInput() {
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
          const Row(
            children: [
              Icon(Icons.edit, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                '모임 타임캡슐 제목',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '예: 우리들의 소중한 추억 만들기',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F8FA),
            ),
          ),
        ],
      ),
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
  final String selectedMood;
  final String selectedSituation;
  final CapsuleType capsuleType;
  final TextEditingController titleController;

  const _DiarySection({
    required this.selectedMood,
    required this.selectedSituation,
    required this.capsuleType,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final capsuleInfo = args?['capsuleInfo'] as Map?;
    final title = capsuleInfo?['title'] as String? ??
        (capsuleType == CapsuleType.personal ? '월요병 때문에 힘든 하루' : '우리들의 즐거운 모임');

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
            children: [
              Text(
                '$selectedMood $selectedSituation',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                capsuleType == CapsuleType.personal ? '오늘의 일기' : '우리 모임 이야기',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          if (capsuleType == CapsuleType.personal) ...[
            const SizedBox(height: 12),
            const Text('제목',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 4),
            TextFormField(
              controller: titleController,
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
          const SizedBox(height: 12),
          Text(
            capsuleType == CapsuleType.personal ? '내용' : '오늘 우리 모임은?',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 4),
          TextFormField(
            maxLines: 5,
            initialValue: capsuleType == CapsuleType.personal
                ? '월요일이라 정말 피곤하고 힘들다. 주말이 너무 짧게 느껴지고 일주일이 또 시작된다는 생각에 우울하다. 스트레스를 풀고 싶어서 카페에서 비싸지만 맛있는 음료를 마시고 배달음식도 시켰다. 계획 없이 소비하는 내 모습이 걱정되지만, 오늘만큼은 나를 위로해주고 싶었다.'
                : '오늘은 모두 함께 점심을 먹고 즐거운 시간을 보냈어요! 이정은님이 맛있는 카페를 추천해주셔서 다같이 갔는데 정말 좋았답니다. 김혜진님과 김수름님은 다음 모임 계획을 세워주시고, 한지혜님은 사진을 정말 잘 찍어주셨어요. 우리 모임이 이렇게 즐거운 줄 몰랐네요! 💕',
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

class _PhotoSection extends StatefulWidget {
  const _PhotoSection();

  @override
  State<_PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<_PhotoSection> {
  File? _imageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
          });
        } else {
          setState(() {
            _imageFile = File(image.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (kIsWeb && _webImageBytes != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(_webImageBytes!,
            fit: BoxFit.cover, width: double.infinity),
      );
    } else if (!kIsWeb && _imageFile != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity),
      );
    } else {
      imageWidget = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, color: Color(0xFF4CAF50), size: 36),
          SizedBox(height: 8),
          Text('사진/영상 추가하기', style: TextStyle(color: Color(0xFF4CAF50))),
        ],
      );
    }

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
          const Text('사진/영상 추가하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(child: imageWidget),
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

class MockCapsuleContentStore {
  static int contentCount = 4;
  static void addContent() {
    contentCount++;
  }
}

class _BottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final capsuleInfo = args?['capsuleInfo'] as Map?;
    final capsuleType =
        args?['capsuleType'] as CapsuleType? ?? CapsuleType.personal;

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
              onPressed: () =>
                  _showPointsDialog(context, capsuleInfo, capsuleType),
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

  void _showPointsDialog(
      BuildContext context, Map? capsuleInfo, CapsuleType capsuleType) {
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
                      Navigator.of(context).pop(); // 팝업 닫기

                      // 기존 로직 실행
                      if (capsuleInfo != null) {
                        final newCapsule = {
                          'capsule': Capsule(
                            id: capsuleInfo['id'] ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            title: capsuleInfo['title'] ?? '새 타임캡슐',
                            type: capsuleInfo['type'] ?? capsuleType,
                            members: List<String>.from(
                                capsuleInfo['members'] ?? ['user1']),
                            createdAt:
                                capsuleInfo['createdAt'] ?? DateTime.now(),
                            openDate: capsuleInfo['openDate'] ??
                                DateTime(2025, 10, 31),
                            points: capsuleInfo['points'] ?? 0,
                            isOpened: capsuleInfo['isOpened'] ?? false,
                          ),
                          'contentCount': 1,
                          'showOpenButton': false,
                        };

                        // CapsuleCreateScreen으로 돌아가서 결과 전달
                        Navigator.of(context).pop(newCapsule);
                      } else {
                        // 캡슐 정보가 없으면 그냥 뒤로가기
                        Navigator.of(context).pop();
                      }
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
