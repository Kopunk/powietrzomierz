import 'package:flutter/material.dart';

Color primaryRed = Color(0xFFb71c1c);
Color primaryGreen = Color(0xFF4bb5ab);
Color secondary = Color(0xFF4b4b4b);

ColorScheme greenColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light, seedColor: primaryGreen, secondary: secondary);

ColorScheme redColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light, seedColor: primaryRed, secondary: secondary);

ColorScheme greenDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: primaryGreen, secondary: primaryGreen);

ColorScheme redDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: primaryRed, secondary: primaryRed);
