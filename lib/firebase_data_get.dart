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

// DONE: hambuger menuを作成しテストデータ作成を移動
// DONE: 新規レポートはfloatingactionbuttonへ

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

  void addTestReports() {
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
  }

  void addNewReport() {
    String reportName = '';
    log.info('firebase_data_get : addNewReport');
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5.0),
                    const Text('レポート名称'),
                    TextFormField(
                      onChanged: (value) {
                        log.info('col1(then) : input: value:$value');
                        reportName = value;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          FireStoreSetData(
                            userID: FirebaseAuth.instance.currentUser!.uid,
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
    log.info('firebase_data_get : ---');
  }

  @override
  Widget build(BuildContext context) {
    final userinstance = ref.watch(firebaseAuthProvider);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userinstance.currentUser!.uid)
        .collection('reports')
        .snapshots();
    // final reportlist = ref.watch(reportListProvider);
    // String reportName = 'abc';

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.density_medium),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(
                child: const Text('テストデータ追加'),
                onPressed: () {
                  log.info('firebase_data_get : テストデータ追加');
                  addTestReports();
                  // addTestData(ref, userinstance);
                },
              ),
              MenuItemButton(
                child: const Text('firebase_data_get'),
                onPressed: () {
                  log.info('firebase_data_get : firebase_data_get pressed');
                },
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
        title: const Text('経費レポート一覧'),
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () async {
          //     // var db = FirebaseFirestore.instance;
          //     // log.info("firebase_data_get db: $db");
          //     addTestReports();
          //   },
          //   child: const Text('テストデータ作成 (put data, reports, to firestore'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     addNewReport();
          //   },
          //   child: Text('新規レポート'),
          // ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue.shade200,
        onPressed: () {
          addNewReport();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
