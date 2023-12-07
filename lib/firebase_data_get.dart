import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'expence.dart';
import 'firebase_providers.dart';

final log = Logger('Firestore get data');

class GetSampleData extends ConsumerStatefulWidget {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Firestore get data')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var db = FirebaseFirestore.instance;
              log.info('get data test1 : ${userinstance.currentUser!.uid}');
              log.info('get data test2 : ${db}');
              final docRef = db
                  .collection("users")
                  .doc("Z03K3uR3GXH5eoN9Mh52TaAaJKVn")
                  .collection("reports")
                  .doc("018c4343-b6cd-7f2e-b973-9487b87bb860")
                  .collection("expences")
                  .doc("018c4345-7377-7a1b-89db-35b008224564");

              var postDoc = await docRef.get();
              if (postDoc.exists) {
                log.info(
                    'get data test 3 : data exists ${postDoc.data()?.length}');
                log.info('get data test 3 : data exists ${postDoc.data()}');
              } else {
                log.info('get data test 3 : data does not exist');
              }

              // docRef.get().then(
              //   (DocumentSnapshot doc) {
              //     log.info('get data test3 $doc.data()');
              //     // final data = doc.data() as Map<String, dynamic>;
              //     // log.info('get data test : $data');
              //   },
              //   onError: (e) => print("Error getting document: $e"),
              // );
              //
              //
              //
              // final ref = db
              //     .collection("users")
              //     .doc(userinstance.currentUser!.uid)
              //     .collection('reports')
              //     .doc('018c42e5-69e5-73b1-a84a-13dc8b5779b7')
              //     .withConverter(
              //       fromFirestore: Expence.fromFirestore,
              //       toFirestore: (Expence expence, _) => expence.toFirestore(),
              //     );
              // final docSnap = await ref.get();
              // final expence = docSnap.data(); // Convert to City object
              // if (expence != null) {
              //   log.info(expence);
              // } else {
              //   log.info("No such document.");
              // }
            },
            child: const Text('test'),
          ),
          ElevatedButton(
            onPressed: () async {
              var db = FirebaseFirestore.instance;
              log.info('get data test4 : ${userinstance.currentUser!.uid}');
              log.info('get data test5 : ${db}');

              log.info(
                  'get data test6 : ${db.collectionGroup("report").where("userId", isEqualTo: userinstance.currentUser!.uid).get()}');
              db
                  .collectionGroup("reports")
                  .where("userID", isEqualTo: userinstance.currentUser!.uid)
                  .get()
                  .then((value) => {log.info('${value.docs.first}')});
            },
            child: const Text('test2'),
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
                        return ListTile(
                          // title: Text(data['userID']),
                          title: Text('userID'),
                          subtitle: Text(data['reortID']),
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
