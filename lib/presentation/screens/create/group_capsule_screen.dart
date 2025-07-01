import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/capsule.dart';
import '../home/widgets/emoji_selector.dart';
import '../open/group_open_screen.dart';

class GroupCapsuleScreen extends StatefulWidget {
  final Capsule capsule;

  const GroupCapsuleScreen({super.key, required this.capsule});

  @override
  State<GroupCapsuleScreen> createState() => _GroupCapsuleScreenState();
}

class _GroupCapsuleScreenState extends State<GroupCapsuleScreen> {
  String selectedMood = '😊';
  String selectedSituation = '💰';

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
  Widget build(BuildContext context) {
    final dDay = widget.capsule.openDate.difference(DateTime.now()).inDays;
    final isOpenable = dDay <= 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.capsule.groupName ?? '모임 타임캡슐'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareWithMembers,
          ),
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
          _buildGroupInfo(),
          const SizedBox(height: 12),
          _buildMemberActivities(),
          const SizedBox(height: 18),
          if (!isOpenable) ...[
            EmojiSelector(
              title: '오늘 모임 기분은? 😊',
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
              title: '우리 모임 상황은? 💰',
              selectedEmoji: selectedSituation,
              emojis: EmojiCategories.financialSituations,
              onSelected: (emoji) {
                setState(() {
                  selectedSituation = emoji;
                });
              },
            ),
            const SizedBox(height: 18),
            _GroupDiarySection(
              selectedMood: selectedMood,
              selectedSituation: selectedSituation,
            ),
            const SizedBox(height: 18),
            const _PhotoSection(),
            const SizedBox(height: 18),
          ] else ...[
            _buildOpenableCapsuleContent(),
          ],
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: isOpenable
          ? _OpenCapsuleButtons(capsule: widget.capsule)
          : _GroupBottomButtons(capsule: widget.capsule),
    );
  }

  Widget _buildGroupInfo() {
    final dDay = widget.capsule.openDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.group, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.capsule.groupName ?? '모임 타임캡슐',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dDay <= 0 ? '✨ 열람 가능!' : 'D-$dDay',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '참여 멤버: ${widget.capsule.members.join(", ")}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '개봉일: ${_formatDate(widget.capsule.openDate)}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberActivities() {
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
            radius: 20,
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

  Widget _buildOpenableCapsuleContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.card_giftcard,
            size: 48,
            color: Colors.amber,
          ),
          const SizedBox(height: 16),
          const Text(
            '🎉 타임캡슐을 열 시간이에요!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '모임원들과 함께 저장한 추억들을 확인해보세요.\n총 ${memberActivities.length + 5}개의 소중한 기록이 담겨있어요.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _shareWithMembers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모임원들과 공유'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('작성한 내용을 모임원들과 공유하시겠습니까?'),
            const SizedBox(height: 16),
            ...widget.capsule.members.map(
              (member) => CheckboxListTile(
                title: Text(member),
                value: true,
                onChanged: (value) {},
                dense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모임원들에게 공유되었습니다! 📤')),
              );
            },
            child: const Text('공유하기'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}

class _GroupDiarySection extends StatefulWidget {
  final String selectedMood;
  final String selectedSituation;

  const _GroupDiarySection({
    required this.selectedMood,
    required this.selectedSituation,
  });

  @override
  State<_GroupDiarySection> createState() => _GroupDiarySectionState();
}

class _GroupDiarySectionState extends State<_GroupDiarySection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            children: [
              Text(
                '${widget.selectedMood} ${widget.selectedSituation}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                '오늘 우리 모임은?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText:
                  '모임원들과 함께한 오늘의 이야기를 적어보세요.\n\n예: 오늘은 모두 함께 점심을 먹고 여행 계획을 세웠어요. 각자 용돈을 모아서 여행 경비 통장에 넣기로 했답니다! 💰✈️',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, height: 1.4),
            ),
            style: const TextStyle(fontSize: 15, height: 1.5),
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
  File? _image;

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
          const Text(
            '📸 모임 사진 추가',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('모임 사진을 추가해보세요',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}

class _GroupBottomButtons extends StatelessWidget {
  final Capsule capsule;

  const _GroupBottomButtons({required this.capsule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('임시저장'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모임 일기가 저장되었습니다! ✨')),
                );
                Navigator.pop(context, 'contentAdded');
              },
              icon: const Icon(Icons.people),
              label: const Text('모임원들과 공유'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenCapsuleButtons extends StatelessWidget {
  final Capsule capsule;

  const _OpenCapsuleButtons({required this.capsule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // 공유 기능
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('타임캡슐이 공유되었습니다! 📤')),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('공유하기'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupOpenScreen(capsule: capsule),
                  ),
                );
              },
              icon: const Icon(Icons.card_giftcard),
              label: const Text('타임캡슐 열기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
