// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'expence.dart';
import 'package:collection/collection.dart';
part 'expences.g.dart';

final uuid = const Uuid();

final List<Expence> _expences = [];

// final sortedExpencesProvider = Provider<List<Expence>>((ref) {
//   return _products.sorted((a, b) => a.price.compareTo(b.price));
// });

// @riverpod
@Riverpod(keepAlive: true)
class ExpenceList extends _$ExpenceList {
  // final userID = uuid.v7();
  @override
  // List<Expence> build() => [];
  // List<Expence> build() => <Expence>[];

  // List<Expence> build() {
  //   return _expences.sorted((a, b) => a.expenceDate!.compareTo(b.expenceDate!));
  // }

  List<Expence> build() => [];
  // <Expence>[].sorted((a, b) => a.expenceDate!.compareTo(b.expenceDate!));

  void addExpence(Expence expence) {
    state = state.where((report) => report.id != expence.id).toList();

    state = [
      ...state,
      expence,
    ];
    state = state.sorted((a, b) => a.expenceDate!.compareTo(b.expenceDate!));
  }

  void removeReport(Expence expence) {
    state = state.where((report) => report.id != expence.id).toList();
  }
}
