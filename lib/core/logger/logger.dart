import 'package:flutter/foundation.dart';
import 'package:loggy/loggy.dart' as loggy;
import 'package:loggy/loggy.dart';

typedef LoggerFunction = void Function(
  String message, [
  dynamic error,
  StackTrace? stackTrace,
]);

final LoggerFunction logDebug = loggy.logDebug;
final LoggerFunction logInfo = loggy.logInfo;
final LoggerFunction logWarning = loggy.logWarning;
final LoggerFunction logError = loggy.logError;

class AnsiColor {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
}

class ColorfulLogPrinter extends loggy.LoggyPrinter {
  @override
  void onLog(loggy.LogRecord record) {
    final time = record.time.toIso8601String().split('T')[1];
    final levelPrefixes = {
      LogLevel.debug: '🐛 ',
      LogLevel.info: '👻 ',
      LogLevel.warning: '⚠️ ',
      LogLevel.error: '‼️ ',
    };
    final prefix = levelPrefixes[record.level] ?? '🤔 ';
    String color;
    switch (record.level) {
      case loggy.LogLevel.debug:
        color = AnsiColor.blue;
        break;
      case loggy.LogLevel.info:
        color = AnsiColor.green;
        break;
      case loggy.LogLevel.warning:
        color = AnsiColor.yellow;
        break;
      case loggy.LogLevel.error:
        color = AnsiColor.red;
        break;
      default:
        color = AnsiColor.reset;
    }

    if (kDebugMode) {
      print(
          "$prefix$time $color [[[${record.level}: ${record.message}]]] ${AnsiColor.reset}");
    }
  }
}
