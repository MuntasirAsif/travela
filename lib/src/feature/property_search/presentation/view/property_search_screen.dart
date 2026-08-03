import 'package:flutter/material.dart';

import '../../../../../core/static/theme/theme.dart';

class PropertySearchScreen extends StatelessWidget {
  const PropertySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(title: const Text('Search')),
      body: const SizedBox.shrink(),
    );
  }
}
