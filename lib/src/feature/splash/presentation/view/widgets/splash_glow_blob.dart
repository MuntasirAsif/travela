import 'package:flutter/material.dart';

class SplashGlowBlob extends StatelessWidget {
  const SplashGlowBlob({
    super.key,
    required this.radius,
    required this.brand,
    required this.pulseValue,
  });

  final double radius;
  final Color brand;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: brand.withValues(alpha: 0.15 + 0.08 * pulseValue),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

class AmbientGlowBlob extends StatelessWidget {
  const AmbientGlowBlob({super.key, required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          radius: 0.5,
        ),
      ),
    );
  }
}
