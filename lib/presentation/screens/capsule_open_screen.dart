import 'package:flutter/material.dart';

class CapsuleOpenScreen extends StatefulWidget {
  final String capsuleId;
  const CapsuleOpenScreen({super.key, required this.capsuleId});

  @override
  State<CapsuleOpenScreen> createState() => _CapsuleOpenScreenState();
}

class _CapsuleOpenScreenState extends State<CapsuleOpenScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward();
      setState(() {
        _opened = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text('타임캡슐 열기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -0.2 + 0.2 * _animation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/treasure_box_closed.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        opacity: AlwaysStoppedAnimation(1 - _animation.value),
                      ),
                      Image.asset(
                        'assets/treasure_box_open.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        opacity: AlwaysStoppedAnimation(_animation.value),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: _opened ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  const Text(
                    '따란! 타임캡슐이 열렸어요',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 16),
                  // 실제 타임캡슐 내용은 capsuleId로 불러와서 표시
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      '여기에 타임캡슐의 추억, 사진, 메시지 등이 표시됩니다.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
