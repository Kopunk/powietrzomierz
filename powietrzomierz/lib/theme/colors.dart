import 'package:flutter/material.dart';

Color primaryRed = const Color(0xFFb71c1c);
Color primaryGreen = const Color(0xFF4bb5ab);
Color secondary = const Color(0xFF455a64);

ColorScheme greenColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light, seedColor: primaryGreen, secondary: secondary);

ColorScheme redColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light, seedColor: primaryRed, secondary: secondary);

ColorScheme greenDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: secondary, secondary: primaryGreen);

ColorScheme redDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: secondary, secondary: primaryRed);
