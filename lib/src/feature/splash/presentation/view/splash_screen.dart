import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/gen/assets.gen.dart';
import '../../../../../core/routes/route_const.dart';
import 'widgets/ambient_background.dart';
import 'widgets/splash_brand_text.dart';
import 'widgets/splash_loading_dots.dart';
import 'widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _brand = Color(0xFFE1217E);

  late final AnimationController _logoCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _textCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoY;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.4, end: 1.0));
    _logoFade = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _logoY = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: 30.0, end: 0.0));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = CurvedAnimation(
      parent: _textCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: const Offset(0, 0.4), end: Offset.zero));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await _logoCtrl.forward();
    _textCtrl.forward();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) context.go(RouteConst.search);
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        brand: _brand,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashLogo(
                    logoCtrl: _logoCtrl,
                    pulseCtrl: _pulseCtrl,
                    particleCtrl: _particleCtrl,
                    logoScale: _logoScale,
                    logoFade: _logoFade,
                    logoY: _logoY,
                    brand: _brand,
                    icon: Assets.images.appIcon.image(
                      width: 88.r,
                      height: 88.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SplashBrandText(textFade: _textFade, textSlide: _textSlide),
                ],
              ),
            ),
            SplashLoadingDots(particleCtrl: _particleCtrl, brand: _brand),
          ],
        ),
      ),
    );
  }
}
