// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A base class for an hybrid clock analog widgets.
///
abstract class Analog extends StatelessWidget {
  const Analog({
    @required this.timeValue,
    @required this.angleRadians,
    @required this.colorPrimary,
    this.colorAccent,
  })  : assert(timeValue != null),
        assert(colorPrimary != null),
        assert(angleRadians != null);

  final Color colorPrimary;
  final Color colorAccent;

  final int timeValue;

  /// The angle, in radians representing the time.
  ///
  /// This angle is measured from the 12 o'clock position.
  final double angleRadians;
}
