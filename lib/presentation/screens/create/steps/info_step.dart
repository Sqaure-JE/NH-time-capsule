import 'package:flutter/material.dart';
import '../../../../models/capsule.dart';

class InfoStep extends StatelessWidget {
  final CapsuleType? type;
  final String? title;
  final String? groupName;
  final List<String>? members;
  final Function(String) onTitleChanged;
  final Function(String) onGroupNameChanged;
  final Function(List<String>) onMembersChanged;

  const InfoStep({
    super.key,
    required this.type,
    required this.title,
    required this.groupName,
    required this.members,
    required this.onTitleChanged,
    required this.onGroupNameChanged,
    required this.onMembersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: title,
          decoration: const InputDecoration(
            labelText: '타임캡슐 제목',
            hintText: '타임캡슐의 제목을 입력해주세요',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '제목을 입력해주세요';
            }
            return null;
          },
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 16),
        if (type == CapsuleType.group) ...[
          TextFormField(
            initialValue: groupName,
            decoration: const InputDecoration(
              labelText: '그룹 이름',
              hintText: '그룹의 이름을 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '그룹 이름을 입력해주세요';
              }
              return null;
            },
            onChanged: onGroupNameChanged,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: members?.join(', '),
            decoration: const InputDecoration(
              labelText: '참여자',
              hintText: '참여자 이메일을 쉼표(,)로 구분하여 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '참여자를 입력해주세요';
              }
              final emails = value.split(',').map((e) => e.trim()).toList();
              for (final email in emails) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(email)) {
                  return '올바른 이메일 형식이 아닙니다';
                }
              }
              return null;
            },
            onChanged: (value) {
              final emails = value
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              onMembersChanged(emails);
            },
          ),
        ],
      ],
    );
  }
} 