import 'package:cloud_firestore/cloud_firestore.dart';
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
            child: const Text('user status check'),
          ),
          ElevatedButton(
            onPressed: () {
              log.info('sample add data1');
              sample_add_data1();
            },
            child: const Text('sample add data1'),
          ),
          ElevatedButton(
            onPressed: () {
              log.info('sample add data2');
              sample_add_data2();
            },
            child: const Text('sample add data2'),
          ),
        ],
      ),
    );
  }
}

void sample_add_data1() {
  var db = FirebaseFirestore.instance;

  log.info('sample 1 start');

  final docData = {
    "stringExample": "Hello world!",
    "booleanExample": true,
    "numberExample": 3.14159265,
    "dateExample": Timestamp.now(),
    "listExample": [1, 2, 3],
    "nullExample": null
  };

  final nestedData = {
    "a": 5,
    "b": true,
  };

  docData["objectExample"] = nestedData;

  db
      .collection("data")
      .doc("one")
      .set(docData)
      .onError((e, _) => print("Error writing document: $e"));
  log.info('sample 1 end');
}

class City {
  final String? name;
  final String? state;
  final String? country;
  final bool? capital;
  final int? population;
  final List<String>? regions;

  City({
    this.name,
    this.state,
    this.country,
    this.capital,
    this.population,
    this.regions,
  });

  factory City.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return City(
      name: data?['name'],
      state: data?['state'],
      country: data?['country'],
      capital: data?['capital'],
      population: data?['population'],
      regions:
          data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (state != null) "state": state,
      if (country != null) "country": country,
      if (capital != null) "capital": capital,
      if (population != null) "population": population,
      if (regions != null) "regions": regions,
    };
  }
}

Future<void> sample_add_data2() async {
  var db = FirebaseFirestore.instance;
  final city = City(
    name: "Los Angeles",
    state: "CA",
    country: "USA",
    capital: false,
    population: 5000000,
    regions: ["west_coast", "socal"],
  );
  final docRef = db
      .collection("cities")
      .withConverter(
        fromFirestore: City.fromFirestore,
        toFirestore: (City city, options) => city.toFirestore(),
      )
      .doc("LA");
  await docRef.set(city);
}
