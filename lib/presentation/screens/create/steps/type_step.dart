import 'package:flutter/material.dart';
import '../../../../models/capsule.dart';

class CapsuleTypeStep extends StatelessWidget {
  final CapsuleType? selectedType;
  final Function(CapsuleType) onTypeSelected;

  const CapsuleTypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTypeCard(
          context,
          type: CapsuleType.personal,
          title: '개인 타임캡슐',
          description: '나만의 추억을 담아두는 타임캡슐',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildTypeCard(
          context,
          type: CapsuleType.group,
          title: '그룹 타임캡슐',
          description: '함께 만드는 추억의 타임캡슐',
          icon: Icons.group,
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required CapsuleType type,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;

    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: () => onTypeSelected(type),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 