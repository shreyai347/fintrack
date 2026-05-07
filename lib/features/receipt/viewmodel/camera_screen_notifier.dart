import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/features/receipt/viewmodel/receipt_notifier.dart';

sealed class CameraScreenUiState {
  const CameraScreenUiState();
}

class CameraScreenLoading extends CameraScreenUiState {
  const CameraScreenLoading();
}

class CameraScreenDenied extends CameraScreenUiState {
  const CameraScreenDenied();
}

class CameraScreenReady extends CameraScreenUiState {
  const CameraScreenReady({this.showHint = true});
  final bool showHint;

  CameraScreenReady copyWith({bool? showHint}) =>
      CameraScreenReady(showHint: showHint ?? this.showHint);
}

class CameraScreenNotifier extends Notifier<CameraScreenUiState> {
  @override
  CameraScreenUiState build() => const CameraScreenLoading();

  Future<void> bootstrap() async {
    state = const CameraScreenLoading();
    final receipt = ref.read(receiptNotifierProvider.notifier);
    receipt.clearReceipt();
    final c = await receipt.initCamera();
    if (c == null) {
      state = const CameraScreenDenied();
    } else {
      state = const CameraScreenReady(showHint: true);
    }
  }

  void hideHint() {
    final s = state;
    if (s is CameraScreenReady) {
      state = s.copyWith(showHint: false);
    }
  }
}

final cameraScreenNotifierProvider =
    NotifierProvider<CameraScreenNotifier, CameraScreenUiState>(
  CameraScreenNotifier.new,
);
