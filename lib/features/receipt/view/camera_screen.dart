import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/features/receipt/viewmodel/camera_screen_notifier.dart';
import 'package:fintrack/features/receipt/viewmodel/receipt_notifier.dart';

import 'image_preview_screen.dart';
import 'widgets/camera_capture_button.dart';
import 'widgets/crop_overlay.dart';
import 'widgets/flash_toggle_button.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraScreenNotifierProvider.notifier).bootstrap();
    });
  }

  @override
  void dispose() {
    ref.read(receiptNotifierProvider.notifier).disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.scaffoldDark;
    final path = ref.watch(receiptNotifierProvider);
    final ui = ref.watch(cameraScreenNotifierProvider);
    final controller =
        ref.read(receiptNotifierProvider.notifier).cameraController;

    return Scaffold(
      backgroundColor: bg,
      body: switch (ui) {
        CameraScreenLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.accentDark),
          ),
        CameraScreenDenied() => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.cameraPermissionRequired,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textPrimaryDark),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: openAppSettings,
                    child: Text(AppStrings.openSettings),
                  ),
                ],
              ),
            ),
          ),
        CameraScreenReady(:final showHint) =>
          controller == null || !controller.value.isInitialized
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.accentDark),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(controller),
                    if (showHint) const CropOverlay(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        color: AppColors.scaffoldDark.withValues(alpha: 0.75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlashToggleButton(controller: controller),
                            CameraCaptureButton(
                              onTap: () async {
                                ref
                                    .read(cameraScreenNotifierProvider.notifier)
                                    .hideHint();
                                await ref
                                    .read(receiptNotifierProvider.notifier)
                                    .capture(controller);
                                final p = ref.read(receiptNotifierProvider);
                                if (!context.mounted || p == null) return;
                                if (!await File(p).exists()) return;
                                if (!context.mounted) return;
                                final nav = Navigator.of(context);
                                final result = await nav.push<String?>(
                                  MaterialPageRoute(
                                    builder: (_) => ImagePreviewScreen(
                                      imagePath: p,
                                    ),
                                  ),
                                );
                                if (!context.mounted) return;
                                if (result != null) {
                                  nav.pop(result);
                                }
                              },
                            ),
                            _ThumbOrSpacer(path: path),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      },
    );
  }
}

class _ThumbOrSpacer extends StatelessWidget {
  const _ThumbOrSpacer({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return const SizedBox(width: 48, height: 48);
    }
    return FutureBuilder<bool>(
      future: File(path!).exists(),
      builder: (context, snap) {
        if (snap.data != true) {
          return const SizedBox(width: 48, height: 48);
        }
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push<String?>(
              MaterialPageRoute(
                builder: (_) => ImagePreviewScreen(imagePath: path!),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(path!),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
