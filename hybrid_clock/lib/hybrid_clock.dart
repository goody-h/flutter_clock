// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import './hour_stack.dart';
import './minute_stack.dart';
import './seconds_stack.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A Hybrid clock having an hybrid and digital look.
///
/// You can do better than this!
class HybridClock extends StatefulWidget {
  const HybridClock(this.model);

  final ClockModel model;

  @override
  _HybridClockState createState() => _HybridClockState();
}

class _HybridClockState extends State<HybridClock> {
  var _now = DateTime.now();

  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(HybridClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFF4285F4),
            highlightColor: Color(0xFF8AB4F8),
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Hybrid clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            HourStack(
              hour: Hour(
                hour: _now.hour,
                is24HourFormat: widget.model.is24HourFormat,
                colorPrimary: customTheme.primaryColor,
                colorAccent: customTheme.accentColor,
              ),
            ),
            SecondsStack(
              timeValue: _now.second,
              angleRadians: _now.second * radiansPerTick,
              colorPrimary: customTheme.highlightColor,
            ),
            MinuteStack(
              timeValue: _now.minute,
              angleRadians: _now.minute * radiansPerTick,
              colorPrimary: customTheme.highlightColor,
              colorAccent: customTheme.highlightColor,
            ),
          ],
        ),
      ),
    );
  }
}
