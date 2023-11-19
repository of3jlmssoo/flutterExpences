import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expence.dart';
import 'package:riverpodtest/reports.dart';
import 'package:uuid/uuid.dart';

import 'report.dart';

final log = Logger('ReportsScreen');

final _currentReport = Provider<Report>((ref) => throw UnimplementedError());
var uuid = const Uuid();

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reports Screen')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/expenceinput'),
            child: const Text('Go to the expence input screen'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to the root screen'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(reportListProvider.notifier).addReport(
                    Report(
                        name: "name3",
                        createdDate: DateTime.now(),
                        col1: "col3",
                        totalPrice: 3,
                        userID: uuid.v7(),
                        reportID: uuid.v7()),
                  );
            },
            child: const Text('add new record'),
          ),
          Expanded(
            child: ListView(
              children: [
                if (reports.isNotEmpty) const Divider(height: 0),
                for (var i = 0; i < reports.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  Dismissible(
                    key: ValueKey(reports[i].reportID),
                    onDismissed: (_) {
                      ref
                          .read(reportListProvider.notifier)
                          .removeReport(reports[i]);
                    },
                    child: ProviderScope(
                      overrides: [
                        _currentReport.overrideWithValue(reports[i]),
                      ],
                      // child: Text('zxc'),
                      child: Card(
                        child: ListTile(
                          title: Text(
                              'abc$i ${reports[i].createdDate.year}-${reports[i].createdDate.month}-${reports[i].createdDate.day} ${reports[i].name} ${reports[i].col1}'),
                          onTap: () {
                            // log.info('--> ${reports[i].reportID}');
                            // context.go(
                            //   '/expencesscreen',
                            //   extra: reports[i].reportID,
                            // );
                            Expence expence = Expence(
                                userID: reports[i].userID,
                                reportID: reports[i].reportID,
                                id: uuid.v7(),
                                createdDate: DateTime.now());
                            context.goNamed("expencescreen", queryParameters: {
                              'reportID': reports[i].reportID,
                              'userID': reports[i].userID,
                              // 'expence': expence,
                            });

                            print('hello');
                          },
                        ),
                      ),
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
