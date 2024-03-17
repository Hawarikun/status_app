import 'dart:ui';

import 'package:flutter/material.dart';

int getMaxLines(String text, TextStyle style, double maxWidth) {
  final paragraphBuilder = ParagraphBuilder(
    ParagraphStyle(
      textAlign: TextAlign.left,
      fontWeight: style.fontWeight,
      fontStyle: style.fontStyle,
      fontSize: style.fontSize,
      fontFamily: style.fontFamily,
    ),
  )
    ..pushStyle(style.getTextStyle())
    ..addText(text);
  final paragraph = paragraphBuilder.build()
    ..layout(ParagraphConstraints(width: maxWidth));

  final lines = paragraph.computeLineMetrics();
  return lines.length;
}