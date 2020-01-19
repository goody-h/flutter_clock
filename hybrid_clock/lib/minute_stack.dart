// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import './analog.dart';


class MinuteStack extends Analog {
  /// All of the parameters are required and must not be null.
  const MinuteStack({
    @required Color colorPrimary,
    @required Color colorAccent,
    @required int timeValue,
    @required double angleRadians,
  })  : assert(colorPrimary != null),
        assert(colorAccent != null),
        assert(timeValue != null),
        assert(angleRadians != null),
        super(
          timeValue: timeValue,
          colorPrimary: colorPrimary,
          colorAccent: colorAccent,
          angleRadians: angleRadians,
        );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: MinuteStackPainter(
            timeValue: timeValue,
            colorPrimary: colorPrimary,
            colorAccent: colorAccent,
            angleRadians: angleRadians,
          ),
        ),
      ),
    );
  }
}

class MinuteStackPainter extends CustomPainter {
  MinuteStackPainter({
    @required this.angleRadians,
    @required this.colorPrimary,
    @required this.colorAccent,
    @required this.timeValue,
  })  : assert(angleRadians != null),
        assert(colorPrimary != null),
        assert(timeValue != null),
        assert(colorAccent != null);

  double angleRadians;
  Color colorPrimary;
  Color colorAccent;
  int timeValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = (size.shortestSide * 0.5) - 20;

    final cPaint = Paint()
      ..color = colorPrimary
      ..strokeCap = StrokeCap.square;

    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;

    canvas.drawCircle(position, 20, cPaint);
    final text = TextPainter(
        text: TextSpan(text: "$timeValue", semanticsLabel: "text"),
        textDirection: TextDirection.ltr);

    text.layout();
    final textP = position - Offset(text.size.width / 2, text.size.height / 2);
    text.paint(canvas, textP);
  }

  @override
  bool shouldRepaint(MinuteStackPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.colorPrimary != colorPrimary ||
        oldDelegate.colorAccent != colorAccent ||
        oldDelegate.timeValue != timeValue;
  }
}
