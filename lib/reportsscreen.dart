import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
// import 'package:riverpodtest/expence.dart';
import 'package:riverpodtest/reports.dart';
import 'package:uuid/uuid.dart';

import 'report.dart';

final log = Logger('ReportsScreen');

final _currentReport = Provider<Report>((ref) => throw UnimplementedError());
var uuid = const Uuid();

class ReportsScreen extends ConsumerWidget {
  ReportsScreen({super.key});
  var userID = uuid.v7();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('レポート一覧')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('ホームへ戻る'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(reportListProvider.notifier).addReport(
                    Report(
                        name: "name3",
                        createdDate: DateTime.now(),
                        col1: "col3",
                        totalPrice: 3,
                        userID: userID,
                        reportID: uuid.v7()),
                  );
            },
            child: const Text('新しいレポート追加(constructing)'),
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
                      child: Card(
                        child: ListTile(
                          title: Text('${reports[i].name}'),
                          subtitle: Text(
                              '${reports[i].createdDate.year}-${reports[i].createdDate.month}-${reports[i].createdDate.day}'),
                          onTap: () {
                            log.info(
                                'reportsScreen : reportID ${reports[i].reportID}');
                            context.goNamed("expencescreen", queryParameters: {
                              'reportID': reports[i].reportID,
                              'userID': reports[i].userID,
                              'reportName': reports[i].name,
                            });
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
