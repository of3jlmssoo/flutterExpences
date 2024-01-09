import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpodtest/reports.dart';

import 'firebase_providers.dart';

final log = Logger('Firestore');

class GetSampleData extends ConsumerStatefulWidget {
  const GetSampleData({super.key});

  @override
  _GetSampleDataState createState() => _GetSampleDataState();
}

class _GetSampleDataState extends ConsumerState<GetSampleData> {
  @override
  Widget build(BuildContext context) {
    final userinstance = ref.watch(firebaseAuthProvider);
    final Stream<QuerySnapshot> _usersStream =
        // FirebaseFirestore.instance.collection('cities').snapshots();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userinstance.currentUser!.uid)
            .collection('reports')
            .snapshots();
    final reportlist = ref.watch(reportListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase版')),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () async {
          //     var db = FirebaseFirestore.instance;
          //     log.info('get data test1 : ${userinstance.currentUser!.uid}');
          //     log.info('get data test2 : ${db}');
          //     final docRef = db
          //         .collection("users")
          //         .doc("Z03K3uR3GXH5eoN9Mh52TaAaJKVn")
          //         .collection("reports")
          //         .doc("018c4343-b6cd-7f2e-b973-9487b87bb860")
          //         .collection("expences")
          //         .doc("018c4345-7377-7a1b-89db-35b008224564");
          //
          //     var postDoc = await docRef.get();
          //     if (postDoc.exists) {
          //       log.info(
          //           'get data test 3 : data exists ${postDoc.data()?.length}');
          //       log.info('get data test 3 : data exists ${postDoc.data()}');
          //     } else {
          //       log.info('get data test 3 : data does not exist');
          //     }
          //   },
          //   child: const Text('test'),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     var db = FirebaseFirestore.instance;
          //     log.info('get data test4 : ${userinstance.currentUser!.uid}');
          //     log.info('get data test5 : ${db}');
          //
          //     log.info(
          //         'get data test6 : ${db.collectionGroup("report").where("userId", isEqualTo: userinstance.currentUser!.uid).get()}');
          //     db
          //         .collection("users")
          //         .doc(userinstance.currentUser!.uid)
          //         .collection("reports")
          //         // .doc("018c42e5-69e5-73b1-a84a-13dc8b5779b7")
          //         // .collection("expences")
          //         .get()
          //         .then(
          //       (querySnapshot) {
          //         log.info("Successfully completed : ${querySnapshot.size}");
          //         for (var docSnapshot in querySnapshot.docs) {
          //           log.info('in the querySnapshot loop');
          //           log.info('${docSnapshot.id} => ${docSnapshot.data()}');
          //         }
          //         log.info('after querySnapshot loop');
          //       },
          //       onError: (e) => log.info("Error completing: $e"),
          //     );
          //   },
          //   child: const Text('test2'),
          // ),
          ElevatedButton(
            onPressed: () async {
              var db = FirebaseFirestore.instance;
              log.info("firebase_data_get db: $db");
              for (var v in reportlist) {
                log.info("firebase_data_get v: ${v}");
                final docData = {
                  "userID": v.userID,
                  "reportID": v.reportID,
                  "name": v.name,
                  "createdDate": v.createdDate,
                  "col1": v.col1,
                  "totalPriceStr": v.totalPrice.toString(),
                  "status": v.status.name,
                };
                db
                    .collection("users")
                    .doc(userinstance.currentUser!.uid)
                    .collection("reports")
                    .doc(v.reportID)
                    .set(docData)
                    .onError((e, _) => log.info("Error writing document: $e"));
              }
            },
            child: const Text('テストデータ作成 (put data, reports, to firestore'),
          ),
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
                          onDismissed: (_) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data["userID"])
                                .collection("reports")
                                .doc(data["reportID"])
                                .delete()
                                .then(
                                  (doc) => log.info(
                                      "expencesscreenfs :Document deleted"),
                                  onError: (e) => log.info(
                                      "expencesscreenfs :Error updating document $e"),
                                );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data['name']),
                              // subtitle: Text(intl.DateFormat.yMd()
                              //     .format(data['createdDate'].toDate())),

                              subtitle: Text(
                                  '作成日 : ${intl.DateFormat('yyyy年MM月dd日').format(data['createdDate'].toDate())}'),
                              onTap: () {
                                log.info(
                                    'reportsScreen : reportID ${data['reportID']}');
                                context.goNamed("expencescreenfs",
                                    queryParameters: {
                                      'reportID': data['reportID'],
                                      'userID': data['userID'],
                                      'reportName': data['name'],
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
