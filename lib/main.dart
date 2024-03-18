import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gisogs_greenspacesapp/data/api/service/hive_service.dart';
import 'package:gisogs_greenspacesapp/domain/utils/media_service.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/firebase_options.dart';
import 'package:gisogs_greenspacesapp/internal/application.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/image_preload.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

// Необходимо для отображения splash_screen до тех пор, пока это необходимо
  binding.deferFirstFrame();

// Загрузим заранее все необходимые картинки, чтобы избежать лишних "скачков"
  binding.addPostFrameCallback((_) async {
    await loadImage(const AssetImage(AppImages.authBg));

    await AppMediaService.initCameraAndGallery();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Отлов ошибок вне среды Flutter
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);

    binding.allowFirstFrame();
  });

  await SharedStorageService.init();
  await HiveService.init();

  // Проверим установлено ли значение для rememberMe
  // Если нет, то зададим по умолчанию true
  final bool? rememberMe = SharedStorageService.getBool(PreferenceKey.remeberMe);
  if (rememberMe == null) {
    await SharedStorageService.setBool(PreferenceKey.remeberMe, true);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const Application());
}
