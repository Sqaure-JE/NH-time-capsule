import 'package:flutter/material.dart';
import 'dart:math' as math;
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
                      capsule.type == CapsuleType.group &&
                              capsule.groupName != null
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
              if (capsule.type == CapsuleType.group &&
                  capsule.members.isNotEmpty)
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

class EggCapsuleCard extends StatefulWidget {
  final Capsule capsule;
  final int contentCount;
  final VoidCallback onTap;

  const EggCapsuleCard({
    super.key,
    required this.capsule,
    required this.contentCount,
    required this.onTap,
  });

  @override
  State<EggCapsuleCard> createState() => _EggCapsuleCardState();
}

class _EggCapsuleCardState extends State<EggCapsuleCard>
    with TickerProviderStateMixin {
  late AnimationController _fireAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _fireAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fireAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fireAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _fireAnimationController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
          parent: _pulseAnimationController, curve: Curves.easeInOut),
    );

    final dDay = widget.capsule.openDate.difference(DateTime.now()).inDays;
    if (dDay <= 0) {
      _fireAnimationController.repeat();
      _pulseAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _fireAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  String _getEmojiForTitle(String title) {
    final titleLower = title.toLowerCase();

    // 금융 관련
    if (titleLower.contains('월급') ||
        titleLower.contains('급여') ||
        titleLower.contains('salary')) return '💰';
    if (titleLower.contains('적금') ||
        titleLower.contains('저축') ||
        titleLower.contains('saving')) return '🏦';
    if (titleLower.contains('투자') ||
        titleLower.contains('주식') ||
        titleLower.contains('invest')) return '📈';
    if (titleLower.contains('대출') || titleLower.contains('loan')) return '💳';

    // 여행 관련
    if (titleLower.contains('여행') ||
        titleLower.contains('travel') ||
        titleLower.contains('trip')) return '✈️';
    if (titleLower.contains('휴가') || titleLower.contains('vacation'))
      return '🏖️';
    if (titleLower.contains('바다') ||
        titleLower.contains('beach') ||
        titleLower.contains('ocean')) return '🌊';
    if (titleLower.contains('산') ||
        titleLower.contains('mountain') ||
        titleLower.contains('hiking')) return '⛰️';

    // 관계 관련
    if (titleLower.contains('연인') ||
        titleLower.contains('사랑') ||
        titleLower.contains('love') ||
        titleLower.contains('couple')) return '💕';
    if (titleLower.contains('결혼') ||
        titleLower.contains('wedding') ||
        titleLower.contains('marriage')) return '💒';
    if (titleLower.contains('가족') || titleLower.contains('family'))
      return '👨‍👩‍👧‍👦';
    if (titleLower.contains('친구') ||
        titleLower.contains('friend') ||
        titleLower.contains('동기')) return '👫';
    if (titleLower.contains('생일') || titleLower.contains('birthday'))
      return '🎂';

    // 학업/업무 관련
    if (titleLower.contains('졸업') || titleLower.contains('graduation'))
      return '🎓';
    if (titleLower.contains('취업') ||
        titleLower.contains('job') ||
        titleLower.contains('work')) return '💼';
    if (titleLower.contains('승진') || titleLower.contains('promotion'))
      return '📊';
    if (titleLower.contains('공부') ||
        titleLower.contains('study') ||
        titleLower.contains('시험')) return '📚';

    // 취미/활동 관련
    if (titleLower.contains('운동') ||
        titleLower.contains('헬스') ||
        titleLower.contains('fitness') ||
        titleLower.contains('gym')) return '💪';
    if (titleLower.contains('음식') ||
        titleLower.contains('맛집') ||
        titleLower.contains('food') ||
        titleLower.contains('restaurant')) return '🍽️';
    if (titleLower.contains('영화') ||
        titleLower.contains('movie') ||
        titleLower.contains('cinema')) return '🎬';
    if (titleLower.contains('음악') ||
        titleLower.contains('music') ||
        titleLower.contains('concert')) return '🎵';
    if (titleLower.contains('책') ||
        titleLower.contains('book') ||
        titleLower.contains('reading')) return '📖';
    if (titleLower.contains('게임') || titleLower.contains('game')) return '🎮';

    // 성취/목표 관련
    if (titleLower.contains('목표') ||
        titleLower.contains('goal') ||
        titleLower.contains('dream')) return '🎯';
    if (titleLower.contains('성공') ||
        titleLower.contains('success') ||
        titleLower.contains('achieve')) return '🏆';
    if (titleLower.contains('건강') || titleLower.contains('health')) return '💊';

    // 계절/시간 관련
    if (titleLower.contains('새해') || titleLower.contains('new year'))
      return '🎊';
    if (titleLower.contains('크리스마스') || titleLower.contains('christmas'))
      return '🎄';
    if (titleLower.contains('봄') || titleLower.contains('spring')) return '🌸';
    if (titleLower.contains('여름') || titleLower.contains('summer')) return '☀️';
    if (titleLower.contains('가을') ||
        titleLower.contains('autumn') ||
        titleLower.contains('fall')) return '🍂';
    if (titleLower.contains('겨울') || titleLower.contains('winter')) return '❄️';

    // 기본값
    return widget.capsule.type == CapsuleType.personal ? '⭐' : '👥';
  }

  Color _getEggColor() {
    final dDay = widget.capsule.openDate.difference(DateTime.now()).inDays;

    if (dDay <= 0) {
      // D-DAY인 경우 황금색 그라데이션
      return const Color(0xFFFFD700);
    } else if (widget.capsule.type == CapsuleType.personal) {
      // 개인 캡슐 - 파스텔 블루
      return const Color(0xFF87CEEB);
    } else {
      // 그룹 캡슐 - 파스텔 핑크
      return const Color(0xFFFFB6C1);
    }
  }

  Widget _buildSparkleEffect() {
    return AnimatedBuilder(
      animation: _fireAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            child: CustomPaint(
              painter: SparklePainter(_fireAnimation.value),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dDay = widget.capsule.openDate.difference(DateTime.now()).inDays;
    final isOpenable = dDay <= 0;
    final eggColor = _getEggColor();
    final emoji = _getEmojiForTitle(widget.capsule.title);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation:
            isOpenable ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          return Transform.scale(
            scale: isOpenable ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 120,
              height: 150,
              margin: const EdgeInsets.all(8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 메인 알 모양
                  Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          eggColor.withOpacity(0.8),
                          eggColor,
                          eggColor.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: eggColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이모티콘
                        Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        // 제목
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            widget.capsule.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // D-Day 또는 날짜
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOpenable
                                ? Colors.white.withOpacity(0.95)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isOpenable
                                ? [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.5),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            isOpenable ? '✨ 열어보세요!' : 'D-$dDay',
                            style: TextStyle(
                              fontSize: isOpenable ? 9 : 10,
                              fontWeight: FontWeight.bold,
                              color: isOpenable
                                  ? const Color(0xFFFF6B00)
                                  : eggColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 반짝이는 효과 (D-DAY인 경우)
                  if (isOpenable) _buildSparkleEffect(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SparklePainter extends CustomPainter {
  final double animationValue;

  SparklePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 반짝이 색상들
    final colors = [
      const Color(0xFFFFD700).withOpacity(0.9),
      const Color(0xFFFFA500).withOpacity(0.7),
      const Color(0xFFFFFFFF).withOpacity(0.8),
      const Color(0xFFFFE55C).withOpacity(0.6),
    ];

    // 여러 개의 반짝이 그리기
    for (int i = 0; i < 8; i++) {
      paint.color = colors[i % colors.length];

      final angle = (animationValue * 360 + i * 45) % 360;
      final radius = 30 + (animationValue * 15);
      final sparkleSize = 2 + (animationValue * 3);

      final x = size.width / 2 + radius * math.cos(angle * 3.14159 / 180);
      final y = size.height / 2 + radius * math.sin(angle * 3.14159 / 180);

      // 별 모양 반짝이 그리기
      _drawStar(canvas, paint, Offset(x, y), sparkleSize);
    }

    // 중앙의 큰 반짝이
    paint.color = const Color(0xFFFFD700).withOpacity(0.9);
    _drawStar(canvas, paint, Offset(size.width / 2, size.height / 2),
        6 + animationValue * 3);
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
