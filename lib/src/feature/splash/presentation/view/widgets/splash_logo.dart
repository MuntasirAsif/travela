import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'particle_ring_painter.dart';
import 'splash_glow_blob.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
    required this.logoCtrl,
    required this.pulseCtrl,
    required this.particleCtrl,
    required this.logoScale,
    required this.logoFade,
    required this.logoY,
    required this.brand,
    required this.icon,
  });

  final AnimationController logoCtrl;
  final AnimationController pulseCtrl;
  final AnimationController particleCtrl;
  final Animation<double> logoScale;
  final Animation<double> logoFade;
  final Animation<double> logoY;
  final Color brand;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([logoCtrl, pulseCtrl, particleCtrl]),
      builder: (context, _) {
        final glowRadius = 70.r + 10.r * pulseCtrl.value;
        return Transform.translate(
          offset: Offset(0, -logoY.value),
          child: Opacity(
            opacity: logoFade.value,
            child: Transform.scale(
              scale: logoScale.value,
              child: SizedBox(
                width: 180.r,
                height: 180.r,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SplashGlowBlob(
                      radius: glowRadius,
                      brand: brand,
                      pulseValue: pulseCtrl.value,
                    ),
                    CustomPaint(
                      size: Size(160.r, 160.r),
                      painter: ParticleRingPainter(
                        angle: particleCtrl.value * 2 * pi,
                        color: brand,
                      ),
                    ),
                    Container(
                      width: 110.r,
                      height: 110.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: brand.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                      ),
                    ),
                    ClipOval(child: icon),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
