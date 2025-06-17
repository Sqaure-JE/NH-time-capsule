import 'dart:io';
import '../../models/content.dart';
import '../helpers/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ContentRepository {
  final DatabaseHelper _dbHelper;

  ContentRepository(this._dbHelper);

  Future<String> addContent({
    required Content content,
    String? imagePath,
  }) async {
    String? savedImagePath;
    
    // 이미지가 있으면 로컬에 저장
    if (imagePath != null) {
      final file = File(imagePath);
      
      // 이미지 크기 검증 (2MB 이하)
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        throw Exception('이미지 크기는 2MB 이하여야 합니다.');
      }
      
      // 앱 문서 디렉토리에 이미지 저장
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.jpg';
      final savedFile = await file.copy('${appDir.path}/$fileName');
      savedImagePath = savedFile.path;
    }
    
    // 콘텐츠에 이미지 경로 설정
    final contentWithImage = content.copyWith(imageUrl: savedImagePath);
    
    await _dbHelper.insertContent(contentWithImage);
    
    return content.id;
  }

  Future<List<Content>> getContentsByCapsuleId(String capsuleId) async {
    return await _dbHelper.getContentsByCapsuleId(capsuleId);
  }

  Future<void> deleteContent(String contentId) async {
    // 데이터베이스에서 콘텐츠 삭제
    await _dbHelper.deleteContent(contentId);
  }
} 