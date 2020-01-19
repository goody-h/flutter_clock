// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import './analog.dart';

class SecondsStack extends Analog {
  const SecondsStack({
    @required Color colorPrimary,
    @required int timeValue,
    @required double angleRadians,
  })  : assert(colorPrimary != null),
        assert(timeValue != null),
        assert(angleRadians != null),
        super(
          timeValue: timeValue,
          colorPrimary: colorPrimary,
          angleRadians: angleRadians,
        );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _SecondsStackPainter(
            color: colorPrimary,
            angleRadians: angleRadians,
          ),
        ),
      ),
    );
  }
}

class _SecondsStackPainter extends CustomPainter {
  _SecondsStackPainter({
    @required this.angleRadians,
    @required this.color,
  })  : assert(angleRadians != null),
        assert(color != null);

  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final length = (size.shortestSide * 0.5) - 20;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(center: center, radius: length);

    canvas.drawArc(rect, -math.pi / 2.0, angleRadians, false, linePaint);
  }

  @override
  bool shouldRepaint(_SecondsStackPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
