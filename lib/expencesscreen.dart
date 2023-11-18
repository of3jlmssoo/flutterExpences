import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'expence.dart';

final log = Logger('ExpencesScreen');
final _currentExpence = Provider<Expence>((ref) => throw UnimplementedError());
var uuid = const Uuid();

class ExpencesScreen extends ConsumerWidget {
  // const ExpencesScreen({super.key});

  const ExpencesScreen(
      {super.key, required this.reportID, required this.userID});
  final String reportID;
  final String userID;

  void addExpence(WidgetRef ref, reportID) {
    log.info('$userID + $reportID');
    ref.read(expenceListProvider.notifier).addExpence(Expence(
            userID: uuid.v7(),
            reportID: reportID,
            id: uuid.v7(),
            createdDate: DateTime.now(),
            expenceType: ExpenceType.transportation,
            expenceDate: DateTime.now(),
            col1: 'column 1',
            col2: 'column 2',
            col3: 'column 3',
            price: 123,
            taxType: TaxType.invoice,
            invoiceNumber: 'I123')
        // todo: userID
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expences = ref.watch(expenceListProvider);
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Expences Screen $reportID'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'add expence',
            onPressed: () {
              log.info('IconButton pressed');
              addExpence(ref, reportID);
              // ref.read(expenceListProvider.notifier).addExpence(expence)
            },
          ),
          Icon(Icons.add),
        ],
      )),
      // appBar: AppBar(title: Text('Expences Screen ')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/listview'),
            child: const Text('Go to the Listview screen'),
          ),
          Expanded(
            child: ListView(
              children: [
                if (expences.isNotEmpty) const Divider(height: 0),
                for (var i = 0; i < expences.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  Dismissible(
                    key: ValueKey(expences[i].id),
                    onDismissed: (_) {
                      ref
                          .read(expenceListProvider.notifier)
                          .removeReport(expences[i]);
                    },
                    child: ProviderScope(
                      overrides: [
                        _currentExpence.overrideWithValue(expences[i]),
                      ],
                      // child: Text('zxc'),
                      child: Card(
                        child: ListTile(
                          title: Text(
                              // 'abc$i ${reports[i].createdDate.year}-${reports[i].createdDate.month}-${reports[i].createdDate.day} ${reports[i].name} ${reports[i].col1}'),
                              'abc'),
                          onTap: () {
                            context.go('/expenceinput');
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
