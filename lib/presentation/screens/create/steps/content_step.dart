import 'package:flutter/material.dart';

class ContentStep extends StatelessWidget {
  final String? content;
  final Function(String) onContentChanged;

  const ContentStep({
    super.key,
    required this.content,
    required this.onContentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '첫 번째 추억을 남겨주세요',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '타임캡슐을 열 때 가장 먼저 보게 될 추억입니다',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: content,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '추억을 입력해주세요...',
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
          onChanged: onContentChanged,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '추억 작성 팁',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• 현재의 감정과 생각을 자유롭게 표현해보세요\n'
                  '• 미래의 자신에게 전하고 싶은 메시지를 남겨보세요\n'
                  '• 특별한 순간이나 기억에 남는 일을 기록해보세요',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 