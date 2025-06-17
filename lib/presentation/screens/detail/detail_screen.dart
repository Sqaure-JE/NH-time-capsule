import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/capsule_provider.dart';
import '../../../models/capsule.dart';
import '../../../models/content.dart';
import '../create/capsule_write_screen.dart';
import 'dart:io';

class DetailScreen extends StatefulWidget {
  final String capsuleId;

  const DetailScreen({
    super.key,
    required this.capsuleId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Capsule? capsule;
  List<Content> contents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<CapsuleProvider>();
    
    try {
      final loadedCapsule = await provider.getCapsuleById(widget.capsuleId);
      final loadedContents = await provider.getContentsByCapsuleId(widget.capsuleId);
      
      setState(() {
        capsule = loadedCapsule;
        contents = loadedContents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock: if capsuleId == '3', show the latest written content
    final bool isLatest = widget.capsuleId == '3';
    final String mockText = '오늘 드디어 첫 월급이 입금되었다! 취업 준비하며 고생했던 시간들이 주마등처럼 스쳐 지나간다. 이제 금융적으로 독립할 수 있게 되어서 너무 기쁘다. 월급의 절반은 미래를 위해 저축하고, 나머지는 현명하게 사용해야겠다. 6개월 후 이 타임캡슐을 열어볼 날이 기대된다!';
    final File? mockImage = null; // 실제로는 이미지 경로를 저장해야 함

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (capsule == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('타임캡슐')),
        body: const Center(child: Text('타임캡슐을 찾을 수 없습니다.')),
      );
    }

    final daysUntilOpen = capsule!.openDate.difference(DateTime.now()).inDays;
    final canOpen = daysUntilOpen <= 0 || capsule!.isOpened;

    return Scaffold(
      appBar: AppBar(
        title: Text(capsule!.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLatest
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('내가 쓴 최근 타임캡슐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16),
                  Text(mockText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  mockImage == null
                      ? Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
                        )
                      : Image.file(mockImage, width: 120, height: 120),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 캡슐 정보
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                capsule!.type == CapsuleType.personal ? Icons.person : Icons.group,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                capsule!.type == CapsuleType.personal ? '개인 타임캡슐' : '그룹 타임캡슐',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (capsule!.type == CapsuleType.group && capsule!.groupName != null)
                            Text('그룹명: ${capsule!.groupName}'),
                          if (capsule!.type == CapsuleType.group && capsule!.members.isNotEmpty)
                            Text('참여자: ${capsule!.members.join(', ')}'),
                          const SizedBox(height: 8),
                          Text('생성일: ${_formatDate(capsule!.createdAt)}'),
                          Text('개봉일: ${_formatDate(capsule!.openDate)}'),
                          Text('포인트: ${capsule!.points}원'),
                          const SizedBox(height: 8),
                          Text(
                            canOpen ? '열기 가능' : 'D-$daysUntilOpen',
                            style: TextStyle(
                              color: canOpen ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 더미 금융 데이터
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('오늘의 금융 활동', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('스타벅스'),
                              Text('-5,600원', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('급여'),
                              Text('+2,500,000원', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('적금'),
                              Text('-300,000원', style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 콘텐츠 목록
                  const Text('저장된 추억', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: contents.isEmpty
                        ? const Center(child: Text('아직 저장된 추억이 없습니다.'))
                        : ListView.builder(
                            itemCount: contents.length,
                            itemBuilder: (context, index) {
                              final content = contents[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(content.createdAt),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(content.text),
                                      if (content.imageUrl != null) ...[
                                        const SizedBox(height: 8),
                                        const Text('📷 이미지 첨부됨', style: TextStyle(color: Colors.blue)),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 타임캡슐 열기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canOpen ? _openCapsule : null,
                      child: Text(capsule!.isOpened ? '이미 열린 타임캡슐' : '타임캡슐 열기'),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContent,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _openCapsule() async {
    try {
      await context.read<CapsuleProvider>().openCapsule(widget.capsuleId);
      setState(() {
        capsule = capsule!.copyWith(isOpened: true);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('타임캡슐이 열렸습니다! 🎉')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _addContent() {
    showDialog(
      context: context,
      builder: (context) => _AddContentDialog(
        capsuleId: widget.capsuleId,
        onContentAdded: _loadData,
      ),
    );
  }
}

class _AddContentDialog extends StatefulWidget {
  final String capsuleId;
  final VoidCallback onContentAdded;

  const _AddContentDialog({
    required this.capsuleId,
    required this.onContentAdded,
  });

  @override
  State<_AddContentDialog> createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<_AddContentDialog> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('추억 추가'),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: '추억을 적어보세요...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _addContent,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _addContent() async {
    if (_textController.text.trim().isEmpty) return;

    try {
      await context.read<CapsuleProvider>().addContent(
        capsuleId: widget.capsuleId,
        text: _textController.text.trim(),
      );
      
      widget.onContentAdded();
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추억이 추가되었습니다!')),
        );
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