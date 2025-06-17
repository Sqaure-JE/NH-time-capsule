import '../../models/capsule.dart';
import '../helpers/database_helper.dart';

class CapsuleRepository {
  final DatabaseHelper _dbHelper;

  CapsuleRepository(this._dbHelper);

  Future<List<Capsule>> getCapsules() async {
    return await _dbHelper.getCapsules();
  }

  Future<Capsule?> getCapsuleById(String id) async {
    return await _dbHelper.getCapsuleById(id);
  }

  Future<void> saveCapsule(Capsule capsule) async {
    await _dbHelper.insertCapsule(capsule);
  }

  Future<void> updateCapsule(Capsule capsule) async {
    await _dbHelper.updateCapsule(capsule);
  }

  Future<void> deleteCapsule(String id) async {
    await _dbHelper.deleteCapsule(id);
  }
} 