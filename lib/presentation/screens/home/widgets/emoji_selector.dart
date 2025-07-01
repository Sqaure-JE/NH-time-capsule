import 'package:flutter/material.dart';

class EmojiSelector extends StatefulWidget {
  final String title;
  final String selectedEmoji;
  final List<EmojiData> emojis;
  final Function(String emoji) onSelected;
  final bool showTitle;

  const EmojiSelector({
    super.key,
    required this.title,
    required this.selectedEmoji,
    required this.emojis,
    required this.onSelected,
    this.showTitle = true,
  });

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) ...[
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.emojis.length > 12 ? 6 : 5,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: widget.emojis.length,
            itemBuilder: (context, index) {
              final emojiData = widget.emojis[index];
              final isSelected = widget.selectedEmoji == emojiData.emoji;

              return GestureDetector(
                onTap: () => widget.onSelected(emojiData.emoji),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6C63FF).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6C63FF)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emojiData.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (emojiData.label.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          emojiData.label,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EmojiData {
  final String emoji;
  final String label;

  const EmojiData(this.emoji, this.label);
}

class EmojiCategories {
  // 캡슐 주제 이모티콘
  static const List<EmojiData> capsuleThemes = [
    EmojiData('💰', '월급'),
    EmojiData('🏦', '저축'),
    EmojiData('📈', '투자'),
    EmojiData('✈️', '여행'),
    EmojiData('💕', '연인'),
    EmojiData('👫', '친구'),
    EmojiData('🎂', '생일'),
    EmojiData('🎓', '졸업'),
    EmojiData('💼', '취업'),
    EmojiData('💪', '운동'),
    EmojiData('🍽️', '음식'),
    EmojiData('🎬', '영화'),
    EmojiData('🎵', '음악'),
    EmojiData('🎯', '목표'),
    EmojiData('🏆', '성공'),
    EmojiData('🎊', '새해'),
    EmojiData('🎄', '크리스마스'),
    EmojiData('🌸', '봄'),
    EmojiData('☀️', '여름'),
    EmojiData('🍂', '가을'),
    EmojiData('❄️', '겨울'),
    EmojiData('⭐', '기타'),
  ];

  // 기분 이모티콘
  static const List<EmojiData> moods = [
    EmojiData('😊', '행복'),
    EmojiData('🥰', '사랑'),
    EmojiData('😎', '멋짐'),
    EmojiData('🤗', '기쁨'),
    EmojiData('😌', '평온'),
    EmojiData('🤔', '생각'),
    EmojiData('😴', '피곤'),
    EmojiData('😢', '슬픔'),
    EmojiData('😤', '화남'),
    EmojiData('😰', '걱정'),
    EmojiData('🤯', '놀람'),
    EmojiData('😵', '혼란'),
  ];

  // 금융 상황 이모티콘
  static const List<EmojiData> financialSituations = [
    EmojiData('💰', '돈벌기'),
    EmojiData('💸', '소비'),
    EmojiData('💳', '카드결제'),
    EmojiData('🏦', '은행업무'),
    EmojiData('📊', '투자'),
    EmojiData('📈', '수익'),
    EmojiData('📉', '손실'),
    EmojiData('🛒', '쇼핑'),
    EmojiData('🍽️', '식비'),
    EmojiData('🚗', '교통비'),
    EmojiData('🏠', '주거비'),
    EmojiData('👕', '의류'),
    EmojiData('🎮', '오락'),
    EmojiData('📚', '교육'),
    EmojiData('💊', '의료'),
    EmojiData('🎁', '선물'),
  ];
}
