import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/services/camera/camera_service.dart';

import 'receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl(this._camera);

  final CameraService _camera;

  final ImageCropper _cropper = ImageCropper();

  @override
  Future<String?> captureAndSave(CameraController controller) async {
    try {
      final x = await controller.takePicture();
      return await _camera.saveImageToAppDirectory(x);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> cropImage(String imagePath) async {
    final cropped = await _cropper.cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 92,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: AppColors.cardDark,
          toolbarWidgetColor: AppColors.textPrimaryDark,
          activeControlsWidgetColor: AppColors.accentDark,
          backgroundColor: AppColors.scaffoldDark,
          dimmedLayerColor: AppColors.inputDark,
        ),
        IOSUiSettings(
          title: 'Crop',
          minimumAspectRatio: 0.5,
        ),
      ],
    );
    if (cropped == null) return null;
    final outPath = cropped.path;
    if (outPath == imagePath) return imagePath;
    final saved = await _camera.copyFileIntoReceipts(outPath);
    try {
      await File(outPath).delete();
    } catch (_) {}
    try {
      if (imagePath != saved) await File(imagePath).delete();
    } catch (_) {}
    return saved;
  }

  @override
  Future<bool> receiptExists(String? path) async {
    if (path == null || path.isEmpty) return false;
    return File(path).exists();
  }

  @override
  Future<void> deleteReceipt(String? path) async {
    if (path == null || path.isEmpty) return;
    await _camera.deleteReceiptFile(path);
  }
}

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  return ReceiptRepositoryImpl(ref.watch(cameraServiceProvider));
});
