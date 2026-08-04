import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBrandText extends StatelessWidget {
  const SplashBrandText({
    super.key,
    required this.textFade,
    required this.textSlide,
  });

  final Animation<double> textFade;
  final Animation<Offset> textSlide;

  static const _pink = Color(0xFFFF6EB4);
  static const _brand = Color(0xFFE1217E);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: textFade,
      child: SlideTransition(
        position: textSlide,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [_pink, _brand],
              ).createShader(bounds),
              child: Text(
                'travela',
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Find your perfect stay',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.45),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
