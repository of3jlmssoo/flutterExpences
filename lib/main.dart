// cd projects/flutter-work/riverpodtest
//
// firebase emulators:start --import ./emulators_data --export-on-exit

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expenceinput.dart';
import 'package:riverpodtest/expenceinputfs.dart';
import 'package:riverpodtest/expencesscreen.dart';
import 'package:riverpodtest/expencesscreenfs.dart';
import 'package:riverpodtest/firebase_data_add.dart';
import 'package:riverpodtest/firebase_data_get.dart';
import 'package:riverpodtest/firebase_providers.dart';
import 'package:riverpodtest/reportsscreen.dart';

import 'firebase_login.dart';
import 'firebase_options.dart';

final log = Logger('MainLogger');

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  initializeDateFormatting("ja");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

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
            expenceDateStr: state.uri.queryParameters['expenceDateStr']!,
            priceStr: state.uri.queryParameters['priceStr']!,
            col1: state.uri.queryParameters['col1']!,
            col2: state.uri.queryParameters['col2']!,
            col3: state.uri.queryParameters['col3']!,
            taxTypeName: state.uri.queryParameters['taxTypeName'],
            invoiceNumber: state.uri.queryParameters['invoiceNumber']!,
            reportName: state.uri.queryParameters['reportName']!,
          ),
        ),
        GoRoute(
          name: 'expenceinputfs',
          path: 'expenceinputfs',
          builder: (context, state) => ExpenceInputFs(
              reportID: state.uri.queryParameters['reportID']!,
              userID: state.uri.queryParameters['userID']!,
              id: state.uri.queryParameters['id']!,
              createdDateStr: state.uri.queryParameters['createdDateStr']!,
              expenceTypeName: state.uri.queryParameters['expenceTypeName'],
              expenceDateStr: state.uri.queryParameters['expenceDateStr']!,
              // priceStr: state.uri.queryParameters['priceStr']!,
              priceStr: state.uri.queryParameters['priceStr'] == null
                  ? ""
                  : state.uri.queryParameters['priceStr']!,
              col1: state.uri.queryParameters['col1']!,
              col2: state.uri.queryParameters['col2']!,
              col3: state.uri.queryParameters['col3']!,
              taxTypeName: state.uri.queryParameters['taxTypeName'],
              // invoiceNumber: state.uri.queryParameters['invoiceNumber']!,
              invoiceNumber: state.uri.queryParameters['invoiceNumber'] == null
                  ? ""
                  : state.uri.queryParameters['invoiceNumber']!,
              reportName: state.uri.queryParameters['reportName']!,
              reportStatus: state.uri.queryParameters['status']!),
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
        GoRoute(
          name: "expencescreenfs",
          path: "expencescreenfs",
          builder: (context, state) => ExpencesScreenFs(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
            reportName: state.uri.queryParameters['reportName']!,
            reportStatus: state.uri.queryParameters['reportStatus']!,
          ),
        ),
        GoRoute(
          name: "fbdataadd",
          path: "fbdataadd",
          builder: (context, state) => const firebaseAddData(),
        ),
        GoRoute(
          name: "fbdataget",
          path: "fbdataget",
          builder: (context, state) => const GetSampleData(),
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

bool loggedin = false;

// The home screen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userinstance = ref.watch(firebaseAuthProvider);
    // final authrepo = ref.watch(authRepositoryProvider);
    final authstatechanges = ref.watch(authStateChangesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: Column(
          children: [
            Text(
              // 'user is ${ref.read(firebaseAuthProvider).authStateChanges()} '),
              authstatechanges.value == null
                  ? "please login"
                  : "user is  ${userinstance.currentUser!.displayName!}",
            ),
            Text(
                '\n${userinstance.currentUser != null ? userinstance.currentUser?.uid : "please login again"}'),
            // Text('\n${userinstance.currentUser}'),

            // ElevatedButton(
            //   onPressed: () => context.go('/listview'),
            //   child: const Text('レポート一覧画面へ'),
            // ),
            ElevatedButton(
              child: const Text('ログイン'),
              onPressed: () async {
                log.info('Firebase login Button Pressed');
                loggedin = await firebaseLoginController(context);
                if (!loggedin) {
                  log.info('loggedin == null $loggedin');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('Please login again'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                } else {
                  log.info('loggedin != null $loggedin');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('You are logged in!'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
                onPressed: () {
                  userinstance.signOut();
                },
                child: const Text('ログアウト')),
            // ElevatedButton(
            //   child: const Text('Firebase add data'),
            //   onPressed: () {
            //     context.go("/fbdataadd");
            //   },
            // ),
            ElevatedButton(
              child: const Text('レポート一覧'),
              onPressed: () async {
                if (userinstance.currentUser == null) {
                  loggedin = await firebaseLoginController(context);
                } else {
                  context.go("/fbdataget");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
