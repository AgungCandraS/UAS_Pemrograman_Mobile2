import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/app.dart';
import 'package:bisnisku/bootstrap/app_bootstrap.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  // Bootstrap the app
  const bootstrap = AppBootstrap();
  final container = await bootstrap.initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const BisniskuApp()),
  );
}
