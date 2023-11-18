import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpodtest/expence.dart';
import 'package:riverpodtest/reports.dart';
import 'report.dart';

final _currentExpence = Provider<Report>((ref) => throw UnimplementedError());

class ReportsScreen extends ConsumerWidget {
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
          ElevatedButton(
            onPressed: () {
              ref.read(reportListProvider.notifier).addReport(Report(
                  name: "name3",
                  id: "id3",
                  createdDate: DateTime.now(),
                  col1: "col3",
                  totalPrice: 3));
            },
            child: const Text('add new record'),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     padding: const EdgeInsets.all(8),
          //     itemCount: 2,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Container(
          //         height: 50,
          //         // color: Colors.amber[colorCodes[index]],
          //         child: Center(child: Text('Entry ${index}')),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView(
              children: [
                const Text('this is the title'),
                TextField(
                  // key: addTodoKey,
                  // controller: newTodoController,
                  decoration: const InputDecoration(
                    labelText: 'What needs to be done?',
                  ),
                  onSubmitted: (value) {
                    // ref.read(todoListProvider.notifier).add(value);
                    // newTodoController.clear();
                    print('value:$value');
                  },
                ),
                const SizedBox(height: 42),
                // const Toolbar(),
                if (reports.isNotEmpty) const Divider(height: 0),
                for (var i = 0; i < reports.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  // Text('abc$i ${reports[i].name} ${reports[i].col1}'),
                  Dismissible(
                    key: ValueKey(reports[i].id),
                    onDismissed: (_) {
                      // ref.read(todoListProvider.notifier).remove(todos[i]);
                      ref
                          .read(reportListProvider.notifier)
                          .removeReport(reports[i]);
                    },
                    child: ProviderScope(
                      overrides: [
                        _currentExpence.overrideWithValue(reports[i]),
                      ],
                      // child: Text('zxc'),
                      child:
                          Text('abc$i ${reports[i].name} ${reports[i].col1}'),
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}
