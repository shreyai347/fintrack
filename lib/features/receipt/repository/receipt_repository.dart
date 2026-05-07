import 'package:camera/camera.dart';

abstract class ReceiptRepository {
  Future<String?> captureAndSave(CameraController controller);

  Future<String?> cropImage(String imagePath);

  Future<bool> receiptExists(String? path);

  Future<void> deleteReceipt(String? path);
}
