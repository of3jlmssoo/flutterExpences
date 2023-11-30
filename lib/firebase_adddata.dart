import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/firebase_providers.dart';

import 'package:uuid/uuid.dart';

final log = Logger('Firebase Firestore add data');

var uuid = const Uuid();

class firebaseAddData extends ConsumerStatefulWidget {
  const firebaseAddData({super.key});

  @override
  ConsumerState createState() => _firebaseAddDataState();
}

class _firebaseAddDataState extends ConsumerState<firebaseAddData> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Firestore add data')),
      body: Column(
        children: [
          Text('abc'),
          ElevatedButton(
              onPressed: () {
                if (user == null) {
                  log.info('user is null');
                } else {
                  log.info('user is not null');
                }
              },
              child: Text('add data')),
        ],
      ),
    );
  }
}
