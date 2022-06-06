import 'package:flutter/material.dart';

Color primaryRed = Color(0xFFb71c1c);
Color primaryGreen = Color(0xFF4bb5ab);
Color secondary = Color(0xFF4b4b4b);

Color buttonRed = Color(0xFFf05545);
Color buttonGreen = Color(0xFF80e8dd);

ColorScheme greenColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: primaryGreen,
    secondary: secondary,
    onSurface: Color.fromARGB(255, 0, 0, 0));

ColorScheme redColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: primaryRed,
    secondary: secondary,
    onSurface: Color.fromARGB(255, 0, 0, 0));

ColorScheme greenDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primaryGreen,
    secondary: primaryGreen,
    onSurface: Color.fromARGB(255, 255, 255, 255));

ColorScheme redDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primaryRed,
    secondary: primaryRed,
    onSurface: Color.fromARGB(255, 255, 255, 255));
