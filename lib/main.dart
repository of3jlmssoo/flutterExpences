// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'main.g.dart';

// // We create a "provider", which will store a value (here "Hello world").
// // By using a provider, this allows us to mock/override the value exposed.
// @riverpod
// String helloWorld(HelloWorldRef ref) {
//   return 'Hello world';
// }

// void main() {
//   runApp(
//     // For widgets to be able to read providers, we need to wrap the entire
//     // application in a "ProviderScope" widget.
//     // This is where the state of our providers will be stored.
//     ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// // Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String value = ref.watch(helloWorldProvider);

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Example')),
//         body: Center(
//           child: Text(value),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'reportsscreen.dart';

void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // return const ReportsScreen();
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => const ReportsScreen(),
              child: const Text('Go to the reportsScreen screen'),
            ),
          ],
        );
      },
      // routes: <RouteBase>[
      //   GoRoute(
      //     path: 'details',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const DetailsScreen();
      //     },
      //   ),
      // ],
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
      routerConfig: _router,
    );
  }
}

/// The home screen
// class HomeScreen extends StatelessWidget {
//   /// Constructs a [HomeScreen]
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home Screen')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => context.go('/details'),
//           child: const Text('Go to the Details screen'),
//         ),
//       ),
//     );
//   }
// }

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
