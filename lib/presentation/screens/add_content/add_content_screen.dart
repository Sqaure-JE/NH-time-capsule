import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/capsule_provider.dart';
import '../home/widgets/emoji_selector.dart';

class AddContentScreen extends StatefulWidget {
  final String capsuleId;

  const AddContentScreen({
    super.key,
    required this.capsuleId,
  });

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  String selectedMood = '😊';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 2 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이미지 크기는 2MB 이하여야 합니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedImage = file;
      });
    }
  }

  Future<void> _submitContent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<CapsuleProvider>().addContent(
            capsuleId: widget.capsuleId,
            text: _textController.text,
            imagePath: _selectedImage?.path,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추억 추가하기'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '추억을 입력해주세요',
                hintText: '최소 10자 이상 입력해주세요',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '추억을 입력해주세요';
                }
                if (value.length < 10) {
                  return '최소 10자 이상 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            EmojiSelector(
              title: '기분 선택하기 😊',
              selectedEmoji: selectedMood,
              emojis: EmojiCategories.moods,
              onSelected: (emoji) {
                setState(() {
                  selectedMood = emoji;
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이미지/영상 추가 (선택사항)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• 최대 2MB까지 업로드 가능\n'
                      '• 이미지 추가 시 +20P 지급',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedImage != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text(
                            _selectedImage == null ? '이미지 선택하기' : '이미지 변경하기'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitContent,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('추억 저장하기'),
          ),
        ),
      ),
    );
  }
}
