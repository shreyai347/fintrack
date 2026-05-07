import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({super.key});

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final a = dark ? AppColors.cardDark : AppColors.cardLight;
    final b = dark ? AppColors.borderDark : AppColors.borderLight;
    final blockFill = dark ? AppColors.inputDark : AppColors.inputLight;

    Widget block({required double height, required double radius, double? width}) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: blockFill,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [a, b, a],
              stops: const [0.25, 0.5, 0.75],
              begin: Alignment(-1.5 + 3 * t, 0),
              end: Alignment(-0.5 + 3 * t, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block(height: 96, radius: 14),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: block(height: 72, radius: 10)),
              const SizedBox(width: 12),
              Expanded(child: block(height: 72, radius: 10)),
            ],
          ),
          const SizedBox(height: 20),
          Center(child: block(height: 130, width: 130, radius: 65)),
          const SizedBox(height: 20),
          block(height: 56, radius: 10),
          const SizedBox(height: 10),
          block(height: 56, radius: 10),
          const SizedBox(height: 10),
          block(height: 56, radius: 10),
        ],
      ),
    );
  }
}
