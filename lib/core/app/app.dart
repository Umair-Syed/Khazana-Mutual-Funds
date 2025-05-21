import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/core/common_ui/theme/bloc/theme_cubit.dart';
import 'package:khazana_mutual_funds/core/common_ui/theme/theme.dart';
import 'package:khazana_mutual_funds/core/navigation/router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          ThemeData themeData = getTheme(
            ThemeCategory.dark,
            ThemeColor.blue,
            context,
          );
          return MaterialApp.router(
            title: "Khazana",
            debugShowCheckedModeBanner: false,
            theme: themeData,
            darkTheme: themeData,
            themeMode: ThemeMode.system,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
