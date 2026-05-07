import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CameraService {
  Future<List<CameraDescription>> initializeCameras() => availableCameras();

  Future<Directory> _receiptsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'receipts'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<String> saveImageToAppDirectory(XFile image) async {
    final dir = await _receiptsDir();
    final name = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final dest = p.join(dir.path, name);
    await File(image.path).copy(dest);
    return dest;
  }

  Future<String> copyFileIntoReceipts(String sourcePath) async {
    final dir = await _receiptsDir();
    final name = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final dest = p.join(dir.path, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  Future<void> deleteReceiptFile(String path) async {
    final f = File(path);
    if (await f.exists()) await f.delete();
  }
}

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});
