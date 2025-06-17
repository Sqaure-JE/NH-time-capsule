import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/capsule_provider.dart';
import '../../../models/capsule.dart';
import '../../../models/content.dart';

class OpenScreen extends StatelessWidget {
  final String capsuleId;

  const OpenScreen({
    super.key,
    required this.capsuleId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타임캡슐 열기'),
      ),
      body: FutureBuilder<Capsule?>(
        future: context.read<CapsuleProvider>().getCapsuleById(capsuleId),
        builder: (context, capsuleSnapshot) {
          if (capsuleSnapshot.hasError) {
            return Center(
              child: Text('오류가 발생했습니다: ${capsuleSnapshot.error}'),
            );
          }

          if (!capsuleSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final capsule = capsuleSnapshot.data!;

          return FutureBuilder<List<Content>>(
            future: context.read<CapsuleProvider>().getContentsByCapsuleId(capsuleId),
            builder: (context, contentsSnapshot) {
              if (contentsSnapshot.hasError) {
                return Center(
                  child: Text('오류가 발생했습니다: ${contentsSnapshot.error}'),
                );
              }

              if (!contentsSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final contents = contentsSnapshot.data!;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCapsuleInfo(context, capsule),
                  const SizedBox(height: 24),
                  if (contents.isEmpty)
                    const Center(
                      child: Text(
                        '아직 추가된 추억이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...contents.map((content) => _buildContentCard(context, content)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCapsuleInfo(BuildContext context, Capsule capsule) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capsule.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (capsule.type == CapsuleType.group) ...[
              Text(
                '그룹: ${capsule.groupName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '참여자: ${capsule.members.join(", ")}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '생성일: ${_formatDate(capsule.createdAt)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '개봉일: ${_formatDate(capsule.openDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, Content content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                content.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(content.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
} 