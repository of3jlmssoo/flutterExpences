import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'expence.dart';
import 'expenceproviders.dart';
import 'firebase_providers.dart';

final log = Logger('ExpencesScreenFs');
final _currentExpence = Provider<Expence>((ref) => throw UnimplementedError());
var uuid = const Uuid();

class ExpencesScreenFs extends ConsumerWidget {
  const ExpencesScreenFs(
      {super.key,
      required this.reportID,
      required this.userID,
      required this.reportName});
  final String reportID;
  final String userID;
  final String reportName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expences = ref.watch(expenceListProvider);
    final et = ref.watch(currentExpenceTypeProvider);
    final tt = ref.watch(currentTaxTypeProvider);
    final ed = ref.watch(currentExpenceDateProvider);
    final pr = ref.watch(currentPriceProvider);
    final userinstance = ref.watch(firebaseAuthProvider);

    final Stream<QuerySnapshot> _expencesStream =
        // FirebaseFirestore.instance.collection('cities').snapshots();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userinstance.currentUser!.uid)
            .collection('reports')
            .doc(reportID)
            .collection('expences')
            .snapshots();

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'add expence',
            onPressed: () {
              log.info('IconButton pressed');

              ref
                  .read(currentExpenceTypeProvider.notifier)
                  .expenceType(ExpenceType.transportation.id!);

              ref
                  .read(currentTaxTypeProvider.notifier)
                  .taxType(TaxType.invoice.id!);

              ref.read(currentPriceProvider.notifier).price(null);
              context.goNamed(
                "expenceinput",
                queryParameters: {
                  'reportID': reportID,
                  'userID': userinstance.currentUser!.uid,
                  'id': uuid.v7(),
                  'createdDateStr': DateTime.now().toString(),
                  'expenceDateStr': DateTime.now().toString(),
                  'expenceTypeName':
                      ExpenceType.transportation.index.toString(),
                  'taxTypeName': TaxType.invoice.index.toString(),
                  // 'priceStr': '',
                  'col1': '',
                  'col2': '',
                  'col3': '',
                  'invoicenumber': '',
                  'reportName': reportName,
                },
              );
            },
          ),
          Text(
              '経費一覧(firestore) ${reportName.substring(0, reportID.length > 8 ? 8 : reportID.length)}'),

          // Icon(Icons.add),
        ],
      )),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/listview'),
            child: const Text('レポート一覧へ'),
          ),
          ElevatedButton(
            onPressed: () async {
              log.info('add test data : ${ref.watch(expenceListProvider)}');
              log.info(
                  'add test data : ExpenceType.others.id ${ExpenceType.others.id}');

              var testExpence = Expence(
                  userID: userinstance.currentUser!.uid,
                  reportID: reportID,
                  id: uuid.v7(),
                  createdDate: DateTime.now(),
                  expenceDate: DateTime.now().subtract(Duration(days: 10)),
                  expenceType: ExpenceType.others.id,
                  price: 123,
                  col1: '物品を購入したという申請',
                  col3: 'しかし、それが何かについてどこに記載するのか',
                  taxType: TaxType.invoice.id,
                  invoiceNumber: '123');
              ref.read(expenceListProvider.notifier).addExpence(testExpence);

              var db = FirebaseFirestore.instance;

              log.info(
                  'add test data : userID ${testExpence.userID} vs ${userinstance.currentUser!.uid}');

              final expenceRef = db
                  .collection('users')
                  .doc(testExpence.userID)
                  .collection('reports')
                  .doc(testExpence.reportID)
                  .collection('expences')
                  .withConverter(
                    fromFirestore: Expence.fromFirestore,
                    toFirestore: (Expence expence, options) =>
                        expence.toFirestore(),
                  )
                  .doc(testExpence.id);
              await expenceRef.set(testExpence);

              testExpence = Expence(
                userID: userinstance.currentUser!.uid,
                reportID: reportID,
                id: uuid.v7(),
                createdDate: DateTime.now(),
                expenceDate: DateTime.now().subtract(Duration(days: 20)),
                expenceType: ExpenceType.transportation.id,
                price: 456,
                col1: '東京の東京駅のそばの大手町',
                col2: '神奈川東京千葉埼玉',
                col3: 'なんのための交通費か。電車かバスかタクシーか',
                taxType: TaxType.standardNoReceipt.id,
              );
              ref.read(expenceListProvider.notifier).addExpence(testExpence);
              final expenceRef2 = db
                  .collection('users')
                  .doc(testExpence.userID)
                  .collection('reports')
                  .doc(testExpence.reportID)
                  .collection('expences')
                  .withConverter(
                    fromFirestore: Expence.fromFirestore,
                    toFirestore: (Expence expence, options) =>
                        expence.toFirestore(),
                  )
                  .doc(testExpence.id);
              await expenceRef2.set(testExpence);
            },
            child: const Text('テストデータ追加'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _expencesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('_expencesStream Something went wrong');
                } else {
                  log.info('_expencesStream StreamBuilder has no error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading (経費情報待ち)");
                } else {
                  log.info('_expencesStream StreamBuilder after Loading');
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Dismissible(
                          key: ValueKey(data["id"]),
                          onDismissed: (_) {},
                          child: Card(
                            child: ListTile(
                              title: Text(
                                '${getExpenceType(data["expenceType"])} ${intl.DateFormat.yMMMd('ja').format(data["expenceDate"].toDate())} (${DateFormat.E('ja').format(data["expenceDate"].toDate())}) ${data["price"]}円',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '${data["col1"] != null ? data["col1"] : ''} ${data["col2"] != null ? data["col2"] : ''} ${data["col3"] != null ? data["col3"] : ''}'),

                              // title: Text(data['name']),
                              // // subtitle: Text(intl.DateFormat.yMd()
                              // //     .format(data['createdDate'].toDate())),

                              // subtitle: Text(
                              //     '作成日 : ${intl.DateFormat('yyyy年MM月dd日').format(data['createdDate'].toDate())}'),
                              onTap: () {
                                log.info(
                                    'expenceinputfs : data["price"].toString() : ${data["price"].toString()}');
                                ref
                                    .read(currentPriceProvider.notifier)
                                    .price(int.parse(data["price"].toString()));
                                ref
                                    .read(currentTaxTypeProvider.notifier)
                                    .taxType(
                                        int.parse(data["taxType"].toString()));
                                ref
                                    .read(currentExpenceTypeProvider.notifier)
                                    .expenceType(int.parse(
                                        data["expenceType"].toString()));
                                context.goNamed(
                                  "expenceinputfs",
                                  queryParameters: {
                                    'reportID': data["reportID"],
                                    'userID': data["userID"],
                                    'id': data["id"],
                                    'createdDateStr':
                                        data["createdDate"].toDate().toString(),
                                    'expenceDateStr':
                                        data["expenceDate"].toDate().toString(),
                                    'expenceTypeName':
                                        data["expenceType"].toString(),
                                    'priceStr': data["price"].toString(),
                                    'col1': data["col1"],
                                    'col2': data["col2"],
                                    'col3': data["col3"],
                                    'taxTypeName': data["taxType"].toString(),
                                    'invoiceNumber': data["invoiceNumber"],
                                    'reportName': reportName,
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            ),
            // child: ListView(
            //   children: [
            //     if (expences.isNotEmpty) const Divider(height: 0),
            //     for (var i = 0; i < expences.length; i++) ...[
            //       if (i > 0) const Divider(height: 0),
            //       Dismissible(
            //         key: ValueKey(expences[i].id),
            //         onDismissed: (_) {
            //           ref
            //               .read(expenceListProvider.notifier)
            //               .removeReport(expences[i]);
            //         },
            //         child: ProviderScope(
            //           overrides: [
            //             _currentExpence.overrideWithValue(expences[i]),
            //           ],
            //           // child: Text('zxc'),
            //           child: Card(
            //             child: ListTile(
            //               title: Text(
            //                 // '${expences[i].expenceType!.name} ${intl.DateFormat.yMd().format(expences[i].expenceDate!)} ',
            //                 // '${expences[i].expenceType!} ${intl.DateFormat.yMMMd('ja').format(expences[i].expenceDate!)} (${DateFormat.E('ja').format(expences[i].expenceDate!)}) ${expences[i].price}円',
            //                 '${getExpenceType(expences[i].expenceType!)} ${intl.DateFormat.yMMMd('ja').format(expences[i].expenceDate!)} (${DateFormat.E('ja').format(expences[i].expenceDate!)}) ${expences[i].price}円',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               subtitle: Text(
            //                   '${expences[i].col1 != null ? expences[i].col1 : ''} ${expences[i].col2 != null ? expences[i].col2 : ''} ${expences[i].col3 != null ? expences[i].col3 : ''}'),
            //               onTap: () {
            //                 ref
            //                     .read(currentExpenceTypeProvider.notifier)
            //                     .expenceType(expences[i].expenceType!);

            //                 ref
            //                     .read(currentTaxTypeProvider.notifier)
            //                     .taxType(expences[i].taxType!);

            //                 ref
            //                     .read(currentExpenceDateProvider.notifier)
            //                     .expenceDate(expences[i].expenceDate!);

            //                 ref
            //                     .read(currentPriceProvider.notifier)
            //                     .price(expences[i].price!);

            //                 log.info(
            //                     'Test Data 1-1 : ${expences[i].createdDate}');
            //                 log.info(
            //                     'Test Data 1-2 : ${expences[i].expenceDate}');
            //                 log.info(
            //                     'Test Data 2 : ${expences[i].expenceType}');
            //                 log.info('Test Data 3 : ${expences[i].taxType}');
            //                 log.info('Test Data 4 : ${et} and ${tt}');
            //                 log.info('Test Data 5 : ${ed}');
            //                 log.info(
            //                     'Test Data 6 : ${expences[i].invoiceNumber}');

            //                 context.goNamed(
            //                   "expenceinput",
            //                   queryParameters: {
            //                     'reportID': expences[i].reportID,
            //                     'userID': expences[i].userID,
            //                     'id': expences[i].id,
            //                     'createdDateStr':
            //                         expences[i].createdDate.toString(),
            //                     'expenceTypeName':
            //                         expences[i].expenceType.toString(),
            //                     'expenceDateStr':
            //                         expences[i].expenceDate.toString(),
            //                     'priceStr': expences[i].price.toString(),
            //                     'col1': expences[i].col1,
            //                     'col2': expences[i].col2,
            //                     'col3': expences[i].col3,
            //                     'taxTypeName': expences[i].taxType.toString(),
            //                     'invoiceNumber': expences[i].invoiceNumber,
            //                     'reportName': reportName,
            //                   },
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ],
            // ),
          )
        ],
      ),
    );
  }
}
