# 금융 타임캡슐 📱💰

NH 회원을 위한 타임캡슐 앱입니다. 미래의 자신에게 메시지를 남기고, 목표를 설정하여 추억을 보관할 수 있습니다.

## 🌟 주요 기능

- **개인 타임캡슐**: 개인적인 메시지와 목표를 미래의 자신에게 전달
- **공통 타임캡슐**: 다른 사용자들과 함께 만드는 타임캡슐
- **개봉 시스템**: 설정한 날짜에 타임캡슐 자동 개봉
- **직관적인 UI**: 사용자 친화적인 인터페이스

## 🚀 라이브 데모

웹 버전을 여기서 체험해보세요: [https://sqaure-je.github.io/NH-time-capsule/](https://sqaure-je.github.io/NH-time-capsule/)

## 🛠 기술 스택

- **Flutter**: 크로스 플랫폼 모바일 앱 개발
- **Dart**: 프로그래밍 언어
- **SQLite**: 로컬 데이터베이스
- **Provider**: 상태 관리
- **GitHub Actions**: CI/CD 자동화

## 📱 지원 플랫폼

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🏃‍♂️ 로컬 실행 방법

### 사전 요구사항

- Flutter SDK (3.32.2 이상)
- Dart SDK
- Android Studio / VS Code
- Git

### 설치 및 실행

```bash
# 저장소 클론
git clone https://github.com/Sqaure-JE/NH-time-capsule.git
cd NH-time-capsule

# 의존성 설치
flutter pub get

# 웹에서 실행
flutter run -d chrome

# 모바일에서 실행 (에뮬레이터 또는 실제 기기)
flutter run
```

## 🌐 배포

### GitHub Pages 자동 배포

이 프로젝트는 GitHub Actions를 사용하여 자동으로 배포됩니다:

1. `main` 브랜치에 푸시되면 자동으로 빌드가 시작됩니다
2. Flutter 웹 앱이 빌드됩니다
3. GitHub Pages에 자동으로 배포됩니다

### 수동 빌드

```bash
# 웹 앱 빌드
flutter build web --release --base-href /NH-time-capsule/

# Android APK 빌드
flutter build apk --release

# iOS 앱 빌드 (macOS에서만)
flutter build ios --release
```

## 📄 라이선스

이 프로젝트는 MIT 라이선스로 배포됩니다.

## 👥 기여

기여를 환영합니다! Pull Request를 보내주세요.

---

**NH Digital X - 금융 타임캡슐** 🏦⏰
