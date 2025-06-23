import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/create/create_screen.dart';
import 'presentation/screens/create/capsule_create_screen.dart';
import 'presentation/screens/create/capsule_write_screen.dart';
import 'presentation/screens/detail/detail_screen.dart';
import 'presentation/screens/capsule_open_screen.dart';
import 'models/capsule.dart';

// Flutter 3.32.2 버전에서는 타입 호환성 문제가 있어 다른 방식으로 테마 설정

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 화면 방향 고정 (세로)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const TimeCapsuleApp(),
  );
}

class TimeCapsuleApp extends StatelessWidget {
  const TimeCapsuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금융 타임캡슐',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),

      // 라우트 설정
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,

      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,

      // 글로벌 네비게이터 키 (홈으로 이동할 때 사용)
      navigatorKey: AppRouter.navigatorKey,

      // 앱 생명주기 관리
      builder: (context, child) {
        return MediaQuery(
          // 텍스트 크기 고정 (사용자 설정 무시)
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      // Material Design 3 테마
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.light,
      ),

      // 타이포그래피
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),

      // 카드 설정
      cardColor: Colors.white,
      // Flutter 3.32.2에서는 cardTheme 타입 호환성 문제로 일부 설정 생략

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(88, 44), // 접근성 최소 터치 영역
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(88, 44),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),

      // 앱바 테마
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),

      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Flutter 3.32.2에서는 dialogTheme 타입 호환성 문제로 설정 생략
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ),
      // 다크 테마 추가 설정들도 라이트 테마와 동일하게 적용
    );
  }
}

// 에러 화면 위젯
class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오류'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  AppRouter.goToHome();
                },
                icon: const Icon(Icons.home),
                label: const Text('홈으로 돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 앱 라우터 클래스
class AppRouter {
  static const String home = '/';
  static const String create = '/create';
  static const String detail = '/detail';
  static const String capsuleCreate = '/capsule_create';
  static const String capsuleWrite = '/capsule_write';
  static const String capsuleOpen = '/capsule_open';

  // 글로벌 네비게이터 키 (홈으로 이동할 때 사용)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // 홈으로 이동하는 헬퍼 메소드
  static void goToHome() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      home,
      (route) => false,
    );
  }

  // 안전한 네비게이션 메소드
  static Future<void> pushNamed(String routeName, {Object? arguments}) async {
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }

  // 뒤로가기 메소드
  static void pop([Object? result]) {
    if (navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState!.pop(result);
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case create:
        return MaterialPageRoute(
          builder: (_) => const CreateScreen(),
          settings: settings,
        );

      case capsuleCreate:
        return MaterialPageRoute(
          builder: (_) => const CapsuleCreateScreen(),
          settings: settings,
        );

      case capsuleWrite:
        final args = settings.arguments as Map?;
        final CapsuleType capsuleType =
            args?['capsuleType'] ?? CapsuleType.personal;
        return MaterialPageRoute(
          builder: (_) => CapsuleWriteScreen(
            capsuleType: capsuleType,
          ),
          settings: settings,
        );

      case detail:
        final capsuleId = settings.arguments as String?;
        if (capsuleId == null) {
          return _errorRoute('캡슐 ID가 필요합니다.');
        }
        return MaterialPageRoute(
          builder: (_) => DetailScreen(capsuleId: capsuleId),
          settings: settings,
        );

      case capsuleOpen:
        final capsuleId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CapsuleOpenScreen(capsuleId: capsuleId ?? ''),
          settings: settings,
        );

      default:
        return _errorRoute('페이지를 찾을 수 없습니다.');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => ErrorScreen(message: message),
    );
  }
}

// 앱 초기화 실패 시 보여줄 에러 앱
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금융 타임캡슐 - 오류',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  '앱 초기화 중 오류가 발생했습니다',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // 앱 재시작 로직 (실제로는 사용자가 앱을 다시 실행해야 함)
                    SystemNavigator.pop();
                  },
                  child: const Text('앱 종료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
