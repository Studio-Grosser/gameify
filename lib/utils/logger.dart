import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Logger {
  static Future<void> _logAndSendToSentry(String message,
      {String? name, StackTrace? stackTrace}) async {
    log(message,
        stackTrace: stackTrace, name: name ?? '', time: DateTime.now());
    if (kReleaseMode) {
      await Sentry.captureException(message, stackTrace: stackTrace);
    }
    //throw Exception(message);
  }

  //Success
  static Future<void> s(dynamic message, [StackTrace? stackTrace]) async {
    log(message, stackTrace: stackTrace, name: ' 💚 ', time: DateTime.now());
  }

  //Info
  static Future<void> i(dynamic message, [StackTrace? stackTrace]) async {
    log(message, stackTrace: stackTrace, name: ' ℹ️ ', time: DateTime.now());
  }

  //Warning
  static Future<void> w(dynamic message, [StackTrace? stackTrace]) async {
    log(message, stackTrace: stackTrace, name: ' 🍑 ', time: DateTime.now());
  }

  //Error
  static Future<void> e(dynamic message, [StackTrace? stackTrace]) async {
    await _logAndSendToSentry(message, name: ' 💔 ', stackTrace: stackTrace);
  }

  //Fatal
  static Future<void> f(dynamic message, [StackTrace? stackTrace]) async {
    await _logAndSendToSentry(message, name: ' 🆘 ', stackTrace: stackTrace);
  }
}
