import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthSpikeTheme {
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);

  static const Color mainGreen = Color(0xFF94D242);

  static const Color mainRed = Color(0xFFFD5D5D);
  static const Color redWhitened = Color(0xFFFF8080);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static ThemeData get lightTheme {
    //1

    return ThemeData(
      //// 2
      primaryColor: mainGreen,
      brightness: Brightness.light,
      scaffoldBackgroundColor: nearlyWhite,
      fontFamily: fontName, //3
      buttonTheme: ButtonThemeData(
        // 4
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: mainGreen,
      ),
    );
  }

  static TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static TextStyle headline = GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      textStyle: const TextStyle(
        fontSize: 22,
        letterSpacing: 0.5,
        color: darkerText,
      ));

  static TextStyle title = GoogleFonts.roboto(
      textStyle: const TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.5,
    color: grey,
  ));

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static TextStyle body2 = GoogleFonts.roboto(
      textStyle: const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  ));

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
