import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/capsule.dart';
import '../../providers/capsule_provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _membersController = TextEditingController();
  final _contentController = TextEditingController();
  
  CapsuleType _selectedType = CapsuleType.personal;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleController.dispose();
    _groupNameController.dispose();
    _membersController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타임캡슐 만들기'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 타입 선택
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('타입 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      RadioListTile<CapsuleType>(
                        title: const Text('개인'),
                        value: CapsuleType.personal,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      RadioListTile<CapsuleType>(
                        title: const Text('그룹'),
                        value: CapsuleType.group,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 제목 입력
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 그룹 정보 (그룹 타입일 때만)
              if (_selectedType == CapsuleType.group) ...[
                TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    labelText: '그룹 이름',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_selectedType == CapsuleType.group && (value == null || value.isEmpty)) {
                      return '그룹 이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _membersController,
                  decoration: const InputDecoration(
                    labelText: '참여자 (쉼표로 구분)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // 날짜 선택
              Card(
                child: ListTile(
                  title: const Text('개봉 날짜'),
                  subtitle: Text('${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // 첫 번째 콘텐츠
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: '첫 번째 추억을 적어보세요',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 16),
              
              // 생성 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createCapsule,
                  child: const Text('타임캡슐 만들기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCapsule() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CapsuleProvider>();
      
      final members = _selectedType == CapsuleType.group
          ? _membersController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : <String>[];

      try {
        await provider.createCapsule(
          title: _titleController.text,
          type: _selectedType,
          groupName: _selectedType == CapsuleType.group ? _groupNameController.text : null,
          members: members,
          openDate: _selectedDate,
          firstContent: _contentController.text.isNotEmpty ? _contentController.text : null,
        );
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류가 발생했습니다: $e')),
          );
        }
      }
    }
  }
} 