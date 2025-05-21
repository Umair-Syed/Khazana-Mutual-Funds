part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

enum ThemeCategory { system, light, dark }

enum ThemeColor { blue, green, purple, orange, pink }

final class ThemeInitial extends ThemeState {}

final class ThemeSelected extends ThemeState {
  final ThemeCategory themeCategory;
  final ThemeColor themeColor;

  ThemeSelected({
    this.themeCategory = ThemeCategory.system,
    this.themeColor = ThemeColor.blue,
  });
}
