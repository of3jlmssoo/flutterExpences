// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'expence.dart';

part 'expences.g.dart';

final uuid = const Uuid();

// @riverpod
@Riverpod(keepAlive: true)
class ExpenceList extends _$ExpenceList {
  final userID = uuid.v7();
  @override
  List<Expence> build() => [];

  void addExpence(Expence expence) {
    state = [
      ...state,
      expence,
    ];
  }

  void removeReport(Expence target) {
    state = state.where((report) => report.id != target.id).toList();
  }
}
