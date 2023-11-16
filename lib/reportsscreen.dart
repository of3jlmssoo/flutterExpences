import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'reports.dart';

class ReportsScreen extends ConsumerWidget {
  /// Constructs a [HomeScreen]
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to the root screen'),
          ),
        ],
      ),
    );
  }
}
