import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> with WidgetsBindingObserver {
  ThemeCubit() : super(ThemeInitial()) {
    WidgetsBinding.instance.addObserver(this);
  }

  void changeTheme({
    required ThemeCategory themeCategory,
    ThemeColor themeColor = ThemeColor.blue,
  }) {
    emit(ThemeSelected(
      themeCategory: themeCategory,
      themeColor: themeColor,
    ));
  }

  @override
  void didChangePlatformBrightness() {
    final currentTheme = state;
    if (currentTheme is ThemeSelected &&
        currentTheme.themeCategory == ThemeCategory.system) {
      changeTheme(
        themeCategory: ThemeCategory.system,
        themeColor: currentTheme.themeColor,
      );
    }
  }

  ThemeCategory getThemeCategory(BuildContext context) {
    if (state is ThemeSelected) {
      if ((state as ThemeSelected).themeCategory == ThemeCategory.system) {
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? ThemeCategory.dark
            : ThemeCategory.light;
      }
      return (state as ThemeSelected).themeCategory;
    }
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? ThemeCategory.dark
        : ThemeCategory.light;
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('themeCategory') && json.containsKey('themeColor')) {
        ThemeCategory themeCategory =
            ThemeCategory.values.byName(json['themeCategory']);
        ThemeColor themeColor = ThemeColor.values.byName(json['themeColor']);

        return ThemeSelected(
          themeCategory: themeCategory,
          themeColor: themeColor,
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    if (state is ThemeSelected) {
      return {
        'themeCategory': state.themeCategory.name,
        'themeColor': state.themeColor.name,
      };
    }
    return null;
  }
}
