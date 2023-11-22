import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
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

  // void addExpence(WidgetRef ref, reportID) {
  //   log.info('$userID + $reportID');
  //
  //   // ref.read(expenceListProvider.notifier).addExpence(Expence(
  //   //         userID: uuid.v7(),
  //   //         reportID: reportID,
  //   //         id: uuid.v7(),
  //   //         createdDate: DateTime.now(),
  //   //         expenceType: ExpenceType.transportation,
  //   //         expenceDate: DateTime.now(),
  //   //         col1: 'column 1',
  //   //         col2: 'column 2',
  //   //         col3: 'column 3',
  //   //         price: 123,
  //   //         taxType: TaxType.invoice,
  //   //         invoiceNumber: 'I123')
  //   //     // todo: userID
  //   //     );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expences = ref.watch(expenceListProvider);
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              '経費入力 ${reportID.substring(0, reportID.length > 8 ? 8 : reportID.length)}'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'add expence',
            onPressed: () {
              log.info('IconButton pressed');

              context.goNamed("expenceinput", queryParameters: {
                'reportID': reportID,
                'userID': userID,
                'id': uuid.v7(),
                // 'createdDate': DateTime.now(),
                'expenceTypeName': ExpenceType.transportation.name,
                // 'expencedDate': DateTime.now(),
                'taxTypeName': TaxType.invoice.name,
              });
            },
          ),

          // Icon(Icons.add),
        ],
      )),
      // appBar: AppBar(title: Text('Expences Screen ')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/listview'),
            child: const Text('Go to the Listview screen'),
          ),
          ElevatedButton(
            onPressed: () {
              log.info('${ref.watch(expenceListProvider)}');
            },
            child: const Text('log list information'),
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
                          title: Text(intl.DateFormat.yMd()
                              .format(expences[i].expenceDate!)),
                          subtitle: Text(
                              '${expences[i].expenceType!.name}  ${expences[i].col1!} ${expences[i].price}円'),

                          // 'abc$i ${reports[i].createdDate.year}-${reports[i].createdDate.month}-${reports[i].createdDate.day} ${reports[i].name} ${reports[i].col1}'),
                          // 'ExpencesScreen'),
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
