import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xffC35BD1);
  static Color get focus => const Color(0xffD9519D);
  static Color get focusSecondary => const Color.fromARGB(255, 197, 73, 143);
  static Color get unfocused => const Color(0xff63666E);
  static Color get focusStart => const Color(0xffED8770);

  static Color get secondaryStart => primary;
  static Color get secondaryEnd => const Color(0xff657DDF);

  static Color get org => const Color(0xffE1914B);
  static Color get green => const Color(0xff4BE04B);

  static Color get primaryText => const Color(0xffFFFFFF);
  static Color get primaryText80 =>
      const Color(0xffFFFFFF).withValues(alpha: 0.8);
  static Color get primaryText60 =>
      const Color(0xffFFFFFF).withValues(alpha: 0.6);
  static Color get primaryText35 =>
      const Color(0xffFFFFFF).withValues(alpha: 0.35);
  static Color get primaryText28 =>
      const Color(0xffFFFFFF).withValues(alpha: 0.28);
  static Color get secondaryText => const Color.fromARGB(255, 128, 131, 150);
  static Color get thirdText => const Color(0xff585A66);

  static List<Color> get primaryG => [focusStart, focus];
  static List<Color> get secondaryG => [secondaryStart, secondaryEnd];

  static Color get bg => const Color(0xff181B2C);
  static Color get bgMiniPlayer => const Color.fromARGB(255, 32, 38, 65);
  static Color get darkGray => const Color(0xff383B49);
  static Color get darkGraySecond => const Color.fromARGB(255, 41, 43, 54);
  static Color get lightGray => const Color(0xffD0D1D4);
}
