import 'package:flutter/material.dart';
import '../../../core/gen/assets.gen.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final String? backgroundImage;
  final bool useSafeArea;

  const BackgroundWrapper({
    super.key,
    required this.body,
    this.backgroundImage,
    this.useSafeArea = true,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                backgroundImage ??
                    Assets.images.splashOnboardingBackground.path,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            // Main content
            if (useSafeArea)
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar ?? const SizedBox.shrink(),
                    Expanded(child: body),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar ?? const SizedBox.shrink(),
                  Expanded(child: body),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
