import 'package:flutter/material.dart';
import '../../../../models/capsule.dart';

class CapsuleCard extends StatelessWidget {
  final Capsule capsule;
  final bool isOpenable;
  final VoidCallback onTap;

  const CapsuleCard({
    super.key,
    required this.capsule,
    required this.isOpenable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final daysLeft = capsule.openDate.difference(now).inDays;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 타입별 아이콘
                  Icon(
                    capsule.type == CapsuleType.personal
                        ? Icons.person
                        : Icons.group,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      capsule.type == CapsuleType.group && capsule.groupName != null
                          ? capsule.groupName!
                          : capsule.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // D-Day 또는 열람하기 버튼
                  if (isOpenable)
                    ElevatedButton(
                      onPressed: onTap,
                      child: const Text('열람하기'),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'D-$daysLeft',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // 모임형일 때 참여자 표시
              if (capsule.type == CapsuleType.group && capsule.members.isNotEmpty)
                Text(
                  '참여자: ${capsule.members.join(", ")}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              // 포인트 표시
              Text(
                '포인트: ${capsule.points}P',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 