import 'package:flutter/material.dart';
import 'package:project_moviles/extensions/text_theme_x.dart';

import '../../models/place.dart';

class GradientStatusTag extends StatelessWidget {
  const GradientStatusTag({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    String text;
    List<Color> colors;
    switch (type) {
      case 'popular':
        text = 'Popular places';
        colors = [Colors.amber, Colors.orange.shade600];
        break;
      case 'event':
        text = 'Evento';
        colors = [Colors.cyan, Colors.blue.shade600];
        break;
      default:
        text = 'sin tipo';
        colors = [Colors.cyan, Colors.blue.shade600];
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
      child: Text(
        text,
        style: context.subtitle1.copyWith(color: Colors.white),
      ),
    );
  }
}
