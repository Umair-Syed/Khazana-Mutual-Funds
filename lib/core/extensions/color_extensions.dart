import 'package:flutter/material.dart';

/// Extension methods to help with theme color mapping
extension FlexColorSchemeExtensions on BuildContext {
  /// Get standard text color with appropriate contrast against the surface
  Color get textColor => Theme.of(this).colorScheme.onSurface;

  /// Get secondary/muted text color with appropriate contrast
  Color get secondaryTextColor =>
      Theme.of(this).colorScheme.onSurface.withAlpha(178);

  /// Get a subtle border/divider color with proper contrast
  Color get dividerColor => Theme.of(this).colorScheme.outline.withAlpha(60);

  Color get borderColor => Theme.of(this).colorScheme.outline.withAlpha(90);

  /// Get a container background color with proper contrast
  Color get containerColor => Theme.of(this).colorScheme.surfaceVariant;

  /// Get a card/elevated surface color
  Color get cardColor => Theme.of(this).colorScheme.surface;

  /// Get accent button color
  Color get accentButtonColor => Theme.of(this).colorScheme.primary;

  /// Get accent button text color
  Color get accentButtonTextColor => Theme.of(this).colorScheme.onPrimary;

  /// Get warning/error color
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Get warning/error text color
  Color get errorTextColor => Theme.of(this).colorScheme.onError;

  Color get roomsHeaderCustomColor =>
      Theme.of(this).brightness == Brightness.dark
          ? Theme.of(this).colorScheme.surfaceContainerLowest
          : Theme.of(this).colorScheme.surfaceContainerLow;
}
