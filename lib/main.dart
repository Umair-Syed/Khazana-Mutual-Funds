import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/app/app.dart';
import 'package:khazana_mutual_funds/core/app/app_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  _initLoggy();
  HydratedBloc.storage = await _initHydratedBloc();
  Bloc.observer = const AppBlocObserver(); // TODO: RELEASE: remove logs
  runApp(AppView());
}

void _initLoggy() {
  Loggy.initLoggy(
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.warning,
    ),
    logPrinter: const PrettyPrinter(),
  );
}

Future<HydratedStorage> _initHydratedBloc() async {
  return await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
}
