import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fintrack/core/services/camera/camera_service.dart';
import 'package:fintrack/features/receipt/repository/receipt_repository_impl.dart';

class ReceiptNotifier extends Notifier<String?> {
  CameraController? _camera;

  CameraController? get cameraController => _camera;

  @override
  String? build() => null;

  Future<void> disposeCamera() async {
    await _camera?.dispose();
    _camera = null;
  }

  Future<CameraController?> initCamera() async {
    await disposeCamera();
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;
    final cameras = await ref.read(cameraServiceProvider).initializeCameras();
    if (cameras.isEmpty) return null;
    final ctrl = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await ctrl.initialize();
    _camera = ctrl;
    return ctrl;
  }

  Future<void> capture(CameraController controller) async {
    final repo = ref.read(receiptRepositoryProvider);
    final raw = await repo.captureAndSave(controller);
    if (raw == null) return;
    final cropped = await repo.cropImage(raw);
    state = cropped ?? raw;
  }

  void clearReceipt() => state = null;
}

final receiptNotifierProvider =
    NotifierProvider<ReceiptNotifier, String?>(ReceiptNotifier.new);
