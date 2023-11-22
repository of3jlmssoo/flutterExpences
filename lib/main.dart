import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expencesscreen.dart';
import 'package:riverpodtest/expenceinput.dart';
import 'package:riverpodtest/reportsscreen.dart';

// void main() => runApp(const MyApp());
final log = Logger('MainLogger');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

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
        // return ReportsScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'listview',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportsScreen();
          },
        ),
        GoRoute(
          name: 'expenceinput',
          path: 'expenceinput',
          builder: (context, state) => ExpenceInput(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
            id: state.uri.queryParameters['id']!,
            // createdDate: state.uri.queryParameters['createdDate']!,
            expenceTypeName: state.uri.queryParameters['expenceTypeName']!,
            // expenceDate: state.uri.queryParameters['expenceDate']!,
            taxTypeName: state.uri.queryParameters['taxTypeName']!,
          ),
        ),
        GoRoute(
          name: "expencescreen",
          path: "expencescreen",
          builder: (context, state) => ExpencesScreen(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
          ),
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
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
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/listview'),
          child: const Text('Go to the ListView screen'),
        ),
      ),
    );
  }
}

/// The details screen
// class DetailsScreen extends StatelessWidget {
//   /// Constructs a [DetailsScreen]
//   const DetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Details Screen')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => context.go('/'),
//           child: const Text('Go back to the Home screen'),
//         ),
//       ),
//     );
//   }
// }
