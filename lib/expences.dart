// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'expence.dart';
import 'report.dart';

part 'expences.g.dart';

var uuid = Uuid();

@riverpod
class ExpenceList extends _$ExpenceList {
  final userID = uuid.v7();
  @override
  List<Report> build() => [
        // Report(
        //   userID: userID,
        //   name: "name1",
        //   createdDate: DateTime.now(),
        //   col1: "col1",
        //   totalPrice: 1,
        //   reportID: uuid.v7(),
        // ),
        // Report(
        //   userID: userID,
        //   name: "name2",
        //   createdDate: DateTime.now(),
        //   col1: "col2",
        //   totalPrice: 2,
        //   reportID: uuid.v7(),
        // )
      ];

  void addExpence(Expence exp) {
    state = [
      ...state,
      exp,
    ];
  }

  void removeReport(Expence target) {
    state = state.where((report) => report.id != target.id).toList();
  }
}
