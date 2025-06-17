import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/capsule.dart';
import '../../models/content.dart';
import '../../data/repositories/capsule_repository.dart';
import '../../data/repositories/content_repository.dart';

class CapsuleProvider extends ChangeNotifier {
  final CapsuleRepository _capsuleRepository;
  final ContentRepository _contentRepository;
  final _uuid = const Uuid();
  
  List<Capsule> _capsules = [];
  bool _isLoading = false;
  String? _error;

  CapsuleProvider({
    required CapsuleRepository capsuleRepository,
    required ContentRepository contentRepository,
  })  : _capsuleRepository = capsuleRepository,
        _contentRepository = contentRepository;

  List<Capsule> get capsules => _capsules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCapsules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _capsules = await _capsuleRepository.getCapsules();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Capsule?> getCapsuleById(String id) async {
    return await _capsuleRepository.getCapsuleById(id);
  }

  Future<List<Content>> getContentsByCapsuleId(String id) async {
    return await _contentRepository.getContentsByCapsuleId(id);
  }

  Future<void> createCapsule({
    required String title,
    required CapsuleType type,
    String? groupName,
    required List<String> members,
    required DateTime openDate,
    String? firstContent,
  }) async {
    final capsule = Capsule(
      id: _uuid.v4(),
      title: title,
      type: type,
      groupName: groupName,
      members: members,
      createdAt: DateTime.now(),
      openDate: openDate,
      points: 100, // 기본 포인트 100원
      isOpened: false,
    );

    await _capsuleRepository.saveCapsule(capsule);

    // 첫 번째 콘텐츠가 있으면 추가
    if (firstContent != null && firstContent.isNotEmpty) {
      final content = Content(
        id: _uuid.v4(),
        capsuleId: capsule.id,
        text: firstContent,
        imageUrl: null,
        createdAt: DateTime.now(),
      );
      await _contentRepository.addContent(content: content);
    }

    await loadCapsules();
  }

  Future<void> addContent({
    required String capsuleId,
    required String text,
    String? imagePath,
  }) async {
    final content = Content(
      id: _uuid.v4(),
      capsuleId: capsuleId,
      text: text,
      imageUrl: null,
      createdAt: DateTime.now(),
    );

    await _contentRepository.addContent(
      content: content,
      imagePath: imagePath,
    );

    // 콘텐츠 개수에 따른 보너스 포인트 계산
    final contents = await _contentRepository.getContentsByCapsuleId(capsuleId);
    if (contents.length == 3) {
      final capsule = await _capsuleRepository.getCapsuleById(capsuleId);
      if (capsule != null) {
        final updatedCapsule = capsule.copyWith(
          points: capsule.points + 500, // 3개의 콘텐츠 추가 시 500원 보너스
        );
        await _capsuleRepository.updateCapsule(updatedCapsule);
      }
    }

    await loadCapsules();
  }

  Future<void> openCapsule(String id) async {
    final capsule = await _capsuleRepository.getCapsuleById(id);
    if (capsule != null) {
      final updatedCapsule = capsule.copyWith(isOpened: true);
      await _capsuleRepository.updateCapsule(updatedCapsule);
      await loadCapsules();
    }
  }
} 