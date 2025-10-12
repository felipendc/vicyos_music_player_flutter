import 'dart:math';

import 'package:flutter/material.dart';

bool isNotSmartphoneScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final diagonal = sqrt(size.width * size.width + size.height * size.height);
  return diagonal > 1100; // limit in pixels, ajustable
}
