import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'splash_glow_blob.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({
    super.key,
    required this.brand,
    required this.child,
  });

  final Color brand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A12), Color(0xFF2D0E1F), Color(0xFF0D0D0D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80.h,
            left: -60.w,
            child: AmbientGlowBlob(
              color: brand.withValues(alpha: 0.18),
              size: 320.r,
            ),
          ),
          Positioned(
            bottom: -100.h,
            right: -80.w,
            child: AmbientGlowBlob(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.12),
              size: 280.r,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
