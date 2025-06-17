
enum StorageType { sqlite, firebase }

class DatabaseProvider {
  // PRD에 따라 기본값은 SQLite
  static StorageType _type = StorageType.sqlite;
  
  // 설정 함수
  static void setStorageType(StorageType type) {
    _type = type;
  }
  
  // 현재 스토리지 타입 확인
  static StorageType get storageType => _type;
  
  // SQLite와 Firebase 사이의 전환을 위한 플래그
  static bool get isFirebaseEnabled => _type == StorageType.firebase;
} 