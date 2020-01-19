// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class HourStack extends StatelessWidget {
  ///
  /// All of the parameters are required and must not be null.
  const HourStack({
    @required this.hour,
  }) : assert(hour != null);

  final Hour hour;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HourStackPainter(
            hour: hour,
          ),
        ),
      ),
    );
  }
}

class Hour {
  Hour({
    @required this.hour,
    @required this.colorPrimary,
    @required this.colorAccent,
    @required this.is24HourFormat,
  })  : assert(hour != null),
        assert(colorPrimary != null),
        assert(colorAccent != null),
        assert(is24HourFormat != null);

  final int hour;
  final bool is24HourFormat;
  final Color colorPrimary;
  final Color colorAccent;
}

class _HourStackPainter extends CustomPainter {
  _HourStackPainter({
    @required this.hour,
  });

  final Hour hour;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.

    final length = (size.shortestSide * 0.5) - 20;

    for (var i = 1; i < 61; i++) {
      final angle = (6 * i * math.pi) / 180;
      final position1 = center +
          Offset(math.cos(angle), math.sin(angle)) *
              (length - (i % 5 == 0 ? 10 : 3));
      final position2 =
          center + Offset(math.cos(angle), math.sin(angle)) * length;
      final linePaint = Paint()
        ..color =
            (i % 5 == 0 ? hour.colorAccent : hour.colorAccent.withOpacity(0.5))
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(position1, position2, linePaint);
    }
    final text = TextPainter(
        text: TextSpan(
            children: hour.is24HourFormat
                ? [
                    TextSpan(
                        text: "${hour.hour}", style: TextStyle(fontSize: 100)),
                  ]
                : [
                    TextSpan(
                        text: "${hour.hour % 12 != 0 ? hour.hour % 12 : 12}",
                        style: TextStyle(fontSize: 80)),
                    TextSpan(
                        text: hour.hour > 11 ? "PM" : "AM",
                        style: TextStyle(fontSize: 20))
                  ]),
        textDirection: TextDirection.ltr);

    text.layout();
    final textP = center - Offset(text.size.width / 2, text.size.height / 2);
    text.paint(canvas, textP);
  }

  @override
  bool shouldRepaint(_HourStackPainter oldDelegate) {
    return oldDelegate.hour != hour;
  }
}
