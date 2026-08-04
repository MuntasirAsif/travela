import 'dart:math' show pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashLoadingDots extends StatelessWidget {
  const SplashLoadingDots({
    super.key,
    required this.particleCtrl,
    required this.brand,
  });

  final AnimationController particleCtrl;
  final Color brand;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60.h,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: particleCtrl,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final raw = particleCtrl.value - i * 0.18;
              final t = (raw % 1.0).clamp(0.0, 1.0);
              final pulse = 0.35 + 0.65 * ((sin(t * 2 * pi) + 1) / 2);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Opacity(
                  opacity: pulse,
                  child: Container(
                    width: 5.r,
                    height: 5.r,
                    decoration: BoxDecoration(
                      color: brand,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
