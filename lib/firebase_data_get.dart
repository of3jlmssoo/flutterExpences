import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpodtest/reports.dart';

import 'firebase_providers.dart';
import 'report.dart';

// todo: hambuger menuを作成しテストデータ作成を移動
// todo: 新規レポートはfloatingactionbuttonへ

final log = Logger('firebase_data_get');

// class FireStoreSet {
//   final String userID;
//   final String name;
//   final DateTime createdDate;
//   final String col1;
//   final int totalPrice;
//   final String reportID;
//   final Status status;
//
//   FireStoreSet(this.userID, this.name, this.createdDate, this.col1,
//       this.totalPrice, this.reportID, this.status);
// }

void FireStoreSetData(
    {required String userID,
    required String name,
    required DateTime createdDate,
    required String col1,
    required int totalPrice,
    required String reportID,
    required Status status}) {
  var db = FirebaseFirestore.instance;

  final docData = {
    "userID": userID,
    "reportID": reportID,
    "name": name,
    "createdDate": createdDate,
    "col1": col1,
    "totalPriceStr": totalPrice.toString(),
    "status": status.en,
  };

  db
      .collection("users")
      .doc(userID)
      .collection("reports")
      .doc(reportID)
      .set(docData)
      .onError((e, _) => log.info("Error writing document: $e"));
}

class GetSampleData extends ConsumerStatefulWidget {
  const GetSampleData({super.key});

  @override
  _GetSampleDataState createState() => _GetSampleDataState();
}

class _GetSampleDataState extends ConsumerState<GetSampleData> {
  // userID: FirebaseAuth.instance.currentUser!.uid,
  // name: "2023年10月国内交通費精算",
  // createdDate: DateTime.now(),
  // col1: "col1",
  // totalPrice: 1,
  // reportID: uuid.v7(),
  // status: Status.making,
  //

  @override
  Widget build(BuildContext context) {
    final userinstance = ref.watch(firebaseAuthProvider);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userinstance.currentUser!.uid)
        .collection('reports')
        .snapshots();
    // final reportlist = ref.watch(reportListProvider);
    String reportName = 'abc';

    return Scaffold(
      appBar: AppBar(title: const Text('経費レポート一覧')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // var db = FirebaseFirestore.instance;
              // log.info("firebase_data_get db: $db");
              FireStoreSetData(
                userID: FirebaseAuth.instance.currentUser!.uid,
                name: '2024年1月',
                createdDate: DateTime.now(),
                col1: "",
                totalPrice: 0,
                reportID: uuid.v7(),
                status: Status.making,
              );
              FireStoreSetData(
                userID: FirebaseAuth.instance.currentUser!.uid,
                name: '2024年2月',
                createdDate: DateTime.now(),
                col1: "",
                totalPrice: 0,
                reportID: uuid.v7(),
                status: Status.making,
              );
              // firestore_set()
              // for (var v in reportlist) {
              // log.info("firebase_data_get v: ${v}");
              // final docData = {
              //   "userID": v.userID,
              //   "reportID": v.reportID,
              //   "name": v.name,
              //   "createdDate": v.createdDate,
              //   "col1": v.col1,
              //   "totalPriceStr": v.totalPrice.toString(),
              //   "status": v.status.name,
              // };
              // db
              //     .collection("users")
              //     .doc(userinstance.currentUser!.uid)
              //     .collection("reports")
              //     .doc(v.reportID)
              //     .set(docData)
              //     .onError((e, _) => log.info("Error writing document: $e"));
              // }
            },
            child: const Text('テストデータ作成 (put data, reports, to firestore'),
          ),
          ElevatedButton(
              onPressed: () {
                log.info('firebase_data_get : ===');
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext cotext) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          height: 200,
                          color: Colors.blue[200],
                          child: Center(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 5.0),
                                Text('レポート名称'),
                                TextFormField(
                                  onChanged: (value) {
                                    log.info(
                                        'col1(then) : input: value:$value');
                                    reportName = value;
                                  },
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      FireStoreSetData(
                                        userID: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        name: reportName,
                                        createdDate: DateTime.now(),
                                        col1: "",
                                        totalPrice: 0,
                                        reportID: uuid.v7(),
                                        status: Status.making,
                                      );

                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK')),
                              ],
                            ),
                          )),
                        ),
                      );
                    });
                // BottomSheetSample();
                // showModalBottomSheet<void>(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return SizedBox(
                //       height: 200,
                //       child: Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           mainAxisSize: MainAxisSize.min,
                //           children: <Widget>[
                //             TextFormField(
                //               //
                //               // validator: (value) {
                //               //   if (value == null ||
                //               //       value.isEmpty ||
                //               //       num.tryParse(value) == null) {
                //               //     return '半角数字を入力してください';
                //               //   }
                //               //   return null;
                //               // },
                //               // initialValue: expence.price == null
                //               //     ? ''
                //               //     : expence.price.toString(),
                //
                //               textAlign: TextAlign.right,
                //               decoration: const InputDecoration(
                //                 // filled: true,
                //                 border: OutlineInputBorder(),
                //               ),
                //               onChanged: (value) {
                //                 log.info(
                //                     'firebase_data_get : bottom sheet value $value');
                //               },
                //             ),
                //             ElevatedButton(
                //               child: const Text('Close BottomSheet'),
                //               onPressed: () => Navigator.pop(context),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
                log.info('firebase_data_get : ---');
              },
              child: Text('新規レポート')),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else {
                  log.info('StreamBuilder has no error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                } else {
                  log.info('StreamBuilder after Loading');
                }

                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Dismissible(
                          key: ValueKey(data["reportID"]),
                          onDismissed: (_) async {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data["userID"])
                                .collection("reports")
                                .doc(data["reportID"])
                                .delete()
                                .then(
                                  (doc) => log.info(
                                      "firebase_data_get :Document deleted"),
                                  onError: (e) => log.info(
                                      "firebase_data_get :Error updating document $e"),
                                );
                            ///////////////////////////////////////
                            int result = 0;
                            var expencesRef = FirebaseFirestore.instance
                                .collection("users")
                                .doc(data["userID"])
                                .collection('reports')
                                .doc(data["reportID"])
                                .collection('expences');
                            var allExpences = await expencesRef.get();
                            for (var doc in allExpences.docs) {
                              result += doc.data()['price'] as int;
                            }

                            log.info('=======> $result');

                            final reportRef = FirebaseFirestore.instance
                                .collection("users")
                                .doc(data["userID"])
                                .collection("reports")
                                .doc(data["reportID"]);
                            reportRef.update({
                              "totalPriceStr": result.toString()
                            }).then(
                                (value) => log.info(
                                    "firebase_data_get : DocumentSnapshot successfully updated!"),
                                onError: (e) => log.info(
                                    "firebase_data_get : Error updating document $e"));

                            ///////////////////////////////////////
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data['name']),
                              // subtitle: Text(intl.DateFormat.yMd()
                              //     .format(data['createdDate'].toDate())),

                              subtitle: Text(
                                  '作成日 : ${intl.DateFormat('yyyy年MM月dd日').format(data['createdDate'].toDate())} '
                                  '${data['status'] == 'submitted' ? "申請済み" : data['status'] == 'making' ? '作成中' : 'その他'}'),
                              onTap: () async {
                                ///////////////////////////////////////
                                int result = 0;
                                var expencesRef = FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(data["userID"])
                                    .collection('reports')
                                    .doc(data["reportID"])
                                    .collection('expences');
                                var allExpences = await expencesRef.get();
                                for (var doc in allExpences.docs) {
                                  result += doc.data()['price'] as int;
                                }

                                log.info('=======> $result');

                                final reportRef = FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(data["userID"])
                                    .collection("reports")
                                    .doc(data["reportID"]);
                                reportRef.update({
                                  "totalPriceStr": result.toString()
                                }).then(
                                    (value) => log.info(
                                        "firebase_data_get : DocumentSnapshot successfully updated!"),
                                    onError: (e) => log.info(
                                        "firebase_data_get : Error updating document $e"));

                                ///////////////////////////////////////

                                log.info(
                                    'reportsScreen : reportID ${data['reportID']}');
                                log.info(
                                    'reportsScreen : status ${data['status']}');
                                context.goNamed("expencescreenfs",
                                    queryParameters: {
                                      'reportID': data['reportID'],
                                      'userID': data['userID'],
                                      'reportName': data['name'],
                                      'reportStatus': data['status'],
                                    });
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
          ),
        ],
      ),
    );
  }
}

class BottomSheetSample extends StatefulWidget {
  const BottomSheetSample({super.key});

  @override
  State<BottomSheetSample> createState() => _BottomSheetSampleState();
}

class _BottomSheetSampleState extends State<BottomSheetSample> {
  final TextEditingController _textEditingController = TextEditingController();
  String? text1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: null, child: Text('abc')),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //         decoration: BoxDecoration(
        //           color: Colors.blue[200],
        //           border: Border.all(
        //             color: Colors.black,
        //             width: 1,
        //           ),
        //           borderRadius: const BorderRadius.all(
        //             Radius.circular(10.0),
        //           ),
        //         ),
        //         width: 200,
        //         padding: const EdgeInsets.all(16.0),
        //         margin: const EdgeInsets.only(bottom: 16.0),
        //         child: Text(text1 ?? ' ')),
        //     ElevatedButton(
        //         onPressed: () {
        //           showModalBottomSheet(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return Container(
        //                 height: 250 + MediaQuery.of(context).viewInsets.bottom,
        //                 decoration: BoxDecoration(
        //                   color: Colors.blue[200],
        //                   borderRadius: const BorderRadius.only(
        //                     topLeft: Radius.circular(20.0),
        //                     topRight: Radius.circular(20.0),
        //                   ),
        //                 ),
        //                 child: Center(
        //                     child: Padding(
        //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //                   child: Column(
        //                     children: [
        //                       const SizedBox(height: 32.0),
        //                       TextField(
        //                         controller: _textEditingController,
        //                         decoration: const InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           labelText: 'テキスト',
        //                         ),
        //                       ),
        //                       ElevatedButton(
        //                           onPressed: () {
        //                             setState(() {
        //                               text1 = _textEditingController.text;
        //                             });
        //                             _textEditingController.clear();
        //                             Navigator.pop(context);
        //                           },
        //                           child: const Text('OK')),
        //                     ],
        //                   ),
        //                 )),
        //               );
        //             },
        //           );
        //         },
        //         child: const Text('Show Bottom Sheet')),
        //   ],
        // ),
      ),
    );
  }
}
