import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/capsule.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../home/widgets/emoji_selector.dart';

class CapsuleCreateScreen extends StatelessWidget {
  final bool? initialIsPersonal;

  const CapsuleCreateScreen({super.key, this.initialIsPersonal});

  @override
  Widget build(BuildContext context) {
    return _CapsuleCreateScreen(initialIsPersonal: initialIsPersonal);
  }
}

class _CapsuleCreateScreen extends StatefulWidget {
  final bool? initialIsPersonal;

  const _CapsuleCreateScreen({this.initialIsPersonal});

  @override
  State<_CapsuleCreateScreen> createState() => _CapsuleCreateScreenState();
}

class _CapsuleCreateScreenState extends State<_CapsuleCreateScreen> {
  late bool isPersonal;
  int personalPurpose = 0; // 0: 일기, 1: 편지, 2: 목표달성
  int period = 0; // 0: 3개월, 1: 6개월, 2: 1년
  File? _firstMemoryImage;
  final _titleController = TextEditingController();
  String selectedThemeEmoji = '⭐';
  List<String> groupMembers = ['이정은', '김혜진', '김수름', '한지혜']; // 기본 멤버

  @override
  void initState() {
    super.initState();
    // initialIsPersonal이 제공되면 그 값을 사용, 아니면 기본값 true 사용
    isPersonal = widget.initialIsPersonal ?? true;
    _titleController.addListener(() {
      setState(() {}); // 제목 변경 시 UI 업데이트
    });
  }

  void _onFirstMemoryImageChanged(File? file) {
    setState(() {
      _firstMemoryImage = file;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('새 금융캡슐 만들기', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: const Color(0xFFF8F8FA),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        children: [
          _TypeSelectSection(
            isPersonal: isPersonal,
            onSelect: (val) => setState(() => isPersonal = val),
          ),
          const SizedBox(height: 12),
          if (isPersonal)
            _PersonalPurposeSection(
              selected: personalPurpose,
              onSelect: (idx) => setState(() => personalPurpose = idx),
            ),
          if (!isPersonal) ...[
            _FriendsSection(
              members: groupMembers,
              onMembersChanged: (newMembers) {
                setState(() {
                  groupMembers = newMembers;
                });
              },
            ),
            const SizedBox(height: 12),
          ],
          if (!isPersonal || isPersonal) ...[
            const SizedBox(height: 12),
            EmojiSelector(
              title: '주제 선택하기 ✨',
              selectedEmoji: selectedThemeEmoji,
              emojis: EmojiCategories.capsuleThemes,
              onSelected: (emoji) {
                setState(() {
                  selectedThemeEmoji = emoji;
                });
              },
            ),
            const SizedBox(height: 12),
            _TitleInputSection(
              controller: _titleController,
              selectedEmoji: selectedThemeEmoji,
            ),
            const SizedBox(height: 12),
            _PeriodSection(
              selected: period,
              onSelect: (idx) => setState(() => period = idx),
            ),
            const SizedBox(height: 16),
            const _RewardBanner(),
            const SizedBox(height: 16),
            _FirstMemorySection(
              onImageChanged: _onFirstMemoryImageChanged,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
      bottomNavigationBar: _NextButton(
        imageFile: _firstMemoryImage,
        titleController: _titleController,
        isPersonal: isPersonal,
        groupMembers: groupMembers,
      ),
    );
  }
}

class _TypeSelectSection extends StatelessWidget {
  final bool isPersonal;
  final ValueChanged<bool> onSelect;
  const _TypeSelectSection({required this.isPersonal, required this.onSelect});
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
          const Text('타임캡슐 유형을 선택해주세요',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('어떤 종류의 타임캡슐을 만들고 싶으신가요?',
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 16),
          _RadioCard(
            selected: isPersonal,
            icon: Icons.person,
            title: '개인형',
            subtitle: '나만의 추억과 금융 생활을 기록해요',
            onTap: () => onSelect(true),
          ),
          const SizedBox(height: 10),
          _RadioCard(
            selected: !isPersonal,
            icon: Icons.groups,
            title: '모임형',
            subtitle: '친구, 가족과 함께 추억을 공유해요',
            onTap: () => onSelect(false),
          ),
        ],
      ),
    );
  }
}

class _RadioCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _RadioCard(
      {required this.selected,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F5E9) : Colors.white,
          border: Border.all(
              color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? const Color(0xFF4CAF50) : Colors.grey),
            const SizedBox(width: 12),
            Icon(icon,
                color: selected ? const Color(0xFF4CAF50) : Colors.grey,
                size: 28),
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
                          const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalPurposeSection extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _PersonalPurposeSection(
      {required this.selected, required this.onSelect});
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
          const Text('개인형 타임캡슐',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF4CAF50))),
          const SizedBox(height: 12),
          _RadioCard(
            selected: selected == 0,
            icon: Icons.edit,
            title: '나의 금융 일기',
            subtitle: '일상 속 금융활동에 감정과 의미를 기록해요',
            onTap: () => onSelect(0),
          ),
          const SizedBox(height: 8),
          _RadioCard(
            selected: selected == 1,
            icon: Icons.mail_outline,
            title: '나에게 쓰는 편지',
            subtitle: '미래의 나에게 전하는 메시지와 현재 금융상황 저장',
            onTap: () => onSelect(1),
          ),
          const SizedBox(height: 8),
          _RadioCard(
            selected: selected == 2,
            icon: Icons.flag,
            title: '목표 달성 기념',
            subtitle: '금융 목표 달성 시 그 순간의 감정과 성취감 기록',
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}

class _TitleInputSection extends StatelessWidget {
  final TextEditingController controller;
  final String selectedEmoji;
  const _TitleInputSection({
    required this.controller,
    required this.selectedEmoji,
  });

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
                selectedEmoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Text('캡슐 제목을 입력하세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '제목을 입력해주세요',
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

class _PeriodSection extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _PeriodSection({required this.selected, required this.onSelect});
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
          const Text('보관 기간',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              _PeriodChip(
                  label: '3개월',
                  selected: selected == 0,
                  onTap: () => onSelect(0)),
              const SizedBox(width: 8),
              _PeriodChip(
                  label: '6개월',
                  selected: selected == 1,
                  onTap: () => onSelect(1)),
              const SizedBox(width: 8),
              _PeriodChip(
                  label: '1년',
                  selected: selected == 2,
                  onTap: () => onSelect(2)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PeriodChip(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4CAF50) : const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              width: 2),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _RewardBanner extends StatelessWidget {
  const _RewardBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.attach_money, color: Colors.amber, size: 24),
          SizedBox(width: 10),
          Text('100포인트 적립 예정',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class _FirstMemorySection extends StatefulWidget {
  final ValueChanged<File?>? onImageChanged;
  const _FirstMemorySection({this.onImageChanged});
  @override
  State<_FirstMemorySection> createState() => _FirstMemorySectionState();
}

class _FirstMemorySectionState extends State<_FirstMemorySection> {
  File? _imageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

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
          widget.onImageChanged?.call(_imageFile);
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
            fit: BoxFit.cover, width: double.infinity, height: 120),
      );
    } else if (!kIsWeb && _imageFile != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_imageFile!,
            fit: BoxFit.cover, width: double.infinity, height: 120),
      );
    } else {
      imageWidget = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, color: Color(0xFF4CAF50), size: 32),
          SizedBox(height: 8),
          Text('사진/영상 추가하기',
              style: TextStyle(color: Colors.black38, fontSize: 13)),
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
          const Text('첫 번째 추억 저장하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(child: imageWidget),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '이 추억에 대한 내용을 자유롭게 작성해주세요',
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

class _ImageUploadSection extends StatefulWidget {
  final ValueChanged<File?> onImageSelected;
  const _ImageUploadSection({
    required this.onImageSelected,
  });
  @override
  State<_ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<_ImageUploadSection> {
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
          widget.onImageSelected(_imageFile);
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
            fit: BoxFit.cover, width: double.infinity, height: 120),
      );
    } else if (!kIsWeb && _imageFile != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_imageFile!,
            fit: BoxFit.cover, width: double.infinity, height: 120),
      );
    } else {
      imageWidget = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, color: Color(0xFF4CAF50), size: 32),
          SizedBox(height: 8),
          Text('사진/영상 추가하기',
              style: TextStyle(color: Colors.black38, fontSize: 13)),
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
          const Text('첫 번째 추억 저장하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(child: imageWidget),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '이 추억에 대한 내용을 자유롭게 작성해주세요',
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

class _NextButton extends StatelessWidget {
  final File? imageFile;
  final TextEditingController titleController;
  final bool isPersonal;
  final List<String> groupMembers;

  const _NextButton({
    this.imageFile,
    required this.titleController,
    required this.isPersonal,
    required this.groupMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: titleController.text.trim().isEmpty
              ? null
              : () async {
                  // CapsuleWriteScreen으로 이동하고 결과를 받음
                  final result = await Navigator
                      .pushNamed(context, '/capsule_write', arguments: {
                    'capsuleType':
                        isPersonal ? CapsuleType.personal : CapsuleType.group,
                    'imageFile': imageFile,
                    'capsuleInfo': {
                      'title': titleController.text.trim(),
                      'type':
                          isPersonal ? CapsuleType.personal : CapsuleType.group,
                      'members': isPersonal ? ['user1'] : groupMembers,
                      'createdAt': DateTime.now(),
                      'openDate': DateTime.now().add(const Duration(days: 30)),
                      'isOpened': false,
                    },
                  });

                  // CapsuleWriteScreen에서 결과가 있으면 홈 화면으로 전달
                  if (result is Map<String, dynamic> && context.mounted) {
                    Navigator.of(context).pop(result);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            disabledBackgroundColor: Colors.grey[300],
            foregroundColor: Colors.white, // 활성화 상태에서 텍스트 색상을 흰색으로 설정
            disabledForegroundColor: Colors.black54, // 비활성화 상태에서는 어두운 회색으로 설정
          ),
          child: const Text('다음'),
        ),
      ),
    );
  }
}

class _FriendsSection extends StatelessWidget {
  final List<String> members;
  final ValueChanged<List<String>> onMembersChanged;

  const _FriendsSection({
    required this.members,
    required this.onMembersChanged,
  });

  // 추가 가능한 친구 목록
  final List<String> availableFriends = const [
    '이정은',
    '김혜진',
    '김수름',
    '한지혜',
    '박민수',
    '최영희',
    '김준호',
    '이선미'
  ];

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
              const Text('친구 선택하기',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddFriendDialog(context),
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text('추가', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${members.length}명이 선택되었습니다',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          if (members.isEmpty)
            const Text(
              '친구를 추가해주세요',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: members
                  .map((member) => _FriendChip(
                        member: member,
                        onRemove: () {
                          final newMembers = List<String>.from(members);
                          newMembers.remove(member);
                          onMembersChanged(newMembers);
                        },
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final unselectedFriends =
        availableFriends.where((friend) => !members.contains(friend)).toList();

    if (unselectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추가할 수 있는 친구가 없습니다')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('친구 추가하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: unselectedFriends.map((friend) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF4CAF50),
                child: Text(friend[0],
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(friend),
              trailing: const Icon(Icons.add_circle, color: Color(0xFF4CAF50)),
              onTap: () {
                final newMembers = List<String>.from(members);
                newMembers.add(friend);
                onMembersChanged(newMembers);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
}

class _FriendChip extends StatelessWidget {
  final String member;
  final VoidCallback onRemove;

  const _FriendChip({
    required this.member,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6, right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF4CAF50),
            radius: 10,
            child: Text(
              member[0],
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            member,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
