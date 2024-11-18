import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Constant for a beautiful, decent text style
const TextStyle kWhiteTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0, // Adjust the size as needed
  fontWeight: FontWeight.w400, // Adjust the weight as needed
  fontFamily: 'Roboto', // Fallback font if GoogleFonts fails
);

final TextStyle kGoogleBlackTextStyle = GoogleFonts.roboto(
  color: Color(0xff3E7696),
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

final TextStyle kHeadingTextStyle = GoogleFonts.openSans(
    color: Color(0xff3E7696), fontSize: 25, fontWeight: FontWeight.w700);
