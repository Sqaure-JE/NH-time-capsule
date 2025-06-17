import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/capsule.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class CapsuleCreateScreen extends StatelessWidget {
  const CapsuleCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CapsuleCreateScreen();
  }
}

class _CapsuleCreateScreen extends StatefulWidget {
  const _CapsuleCreateScreen();

  @override
  State<_CapsuleCreateScreen> createState() => _CapsuleCreateScreenState();
}

class _CapsuleCreateScreenState extends State<_CapsuleCreateScreen> {
  bool isPersonal = true;
  int personalPurpose = 0; // 0: 일기, 1: 편지, 2: 목표달성
  int period = 0; // 0: 3개월, 1: 6개월, 2: 1년
  File? _firstMemoryImage;
  final _titleController = TextEditingController();

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
          if (!isPersonal || isPersonal) ...[
            const SizedBox(height: 12),
            _TitleInputSection(controller: _titleController),
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
        title: _titleController.text,
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const _StepCircle(active: true, label: '유형'),
          _StepLine(),
          const _StepCircle(active: false, label: '목적'),
          _StepLine(),
          const _StepCircle(active: false, label: '기간'),
          _StepLine(),
          const _StepCircle(active: false, label: '완료'),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final bool active;
  final String label;
  const _StepCircle({required this.active, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF7B4FFF) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            label.substring(0, 1),
            style: TextStyle(
              color: active ? Colors.white : Colors.black38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: active ? const Color(0xFF7B4FFF) : Colors.black38)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 2,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 2),
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
          color: selected ? const Color(0xFFF8F4FF) : Colors.white,
          border: Border.all(
              color: selected ? const Color(0xFF7B4FFF) : Colors.grey.shade300,
              width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? const Color(0xFF7B4FFF) : Colors.grey),
            const SizedBox(width: 12),
            Icon(icon,
                color: selected ? const Color(0xFF7B4FFF) : Colors.grey,
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
                  color: Color(0xFF7B4FFF))),
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
  const _TitleInputSection({required this.controller});

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
          const Text('캡슐 제목을 입력하세요',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
          color: selected ? const Color(0xFF7B4FFF) : const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? const Color(0xFF7B4FFF) : Colors.grey.shade300,
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
  XFile? _xfile;
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
            _xfile = image;
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
          Icon(Icons.add_a_photo, color: Color(0xFF7B4FFF), size: 32),
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
  final File? imageFile;
  final ValueChanged<File?> onImageSelected;
  const _ImageUploadSection({
    this.imageFile,
    required this.onImageSelected,
  });
  @override
  State<_ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<_ImageUploadSection> {
  File? _imageFile;
  XFile? _xfile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
            _xfile = image;
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
          Icon(Icons.add_a_photo, color: Color(0xFF7B4FFF), size: 32),
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
  final String title;

  const _NextButton({
    this.imageFile,
    required this.title,
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
          onPressed: () {
            if (title.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('캡슐 제목을 입력해주세요')),
              );
              return;
            }

            final capsuleInfo = {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': title,
              'type': CapsuleType.personal,
              'members': ['user1'],
              'createdAt': DateTime.now(),
              'openDate': DateTime.now().add(const Duration(days: 100)),
              'points': 0,
              'isOpened': false,
            };

            Navigator.pushNamed(
              context,
              '/capsule_write',
              arguments: {
                'capsuleInfo': capsuleInfo,
                'imageFile': imageFile,
              },
            ).then((result) {
              if (result is Map<String, dynamic>) {
                Navigator.pop(context, result);
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B4FFF),
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('다음 단계로'),
        ),
      ),
    );
  }
}
