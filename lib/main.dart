import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expenceinput.dart';
import 'package:riverpodtest/expencesscreen.dart';
import 'package:riverpodtest/reportsscreen.dart';

final log = Logger('MainLogger');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  initializeDateFormatting("ja");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'listview',
          builder: (BuildContext context, GoRouterState state) {
            return ReportsScreen();
          },
        ),
        GoRoute(
          name: 'expenceinput',
          path: 'expenceinput',
          builder: (context, state) => ExpenceInput(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
            id: state.uri.queryParameters['id']!,
            createdDateStr: state.uri.queryParameters['createdDateStr']!,
            expenceTypeName: state.uri.queryParameters['expenceTypeName'],
            expenceDateStr: state.uri.queryParameters['expenceDateStr'],
            priceStr: state.uri.queryParameters['priceStr'],
            col1: state.uri.queryParameters['col1'],
            col2: state.uri.queryParameters['col2'],
            col3: state.uri.queryParameters['col3'],
            taxTypeName: state.uri.queryParameters['taxTypeName'],
            invoiceNumber: state.uri.queryParameters['invoiceNumber'],
            reportName: state.uri.queryParameters['reportName']!,
          ),
        ),
        GoRoute(
          name: "expencescreen",
          path: "expencescreen",
          builder: (context, state) => ExpencesScreen(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
            reportName: state.uri.queryParameters['reportName']!,
          ),
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'MPLUSRounded',
      ),
      routerConfig: _router,
    );
  }
}

// The home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/listview'),
          child: const Text('レポート一覧画面へ'),
        ),
      ),
    );
  }
}
