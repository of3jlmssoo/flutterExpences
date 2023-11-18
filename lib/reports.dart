// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'report.dart';

part 'reports.g.dart';

var uuid = Uuid();

@riverpod
class ReportList extends _$ReportList {
  @override
  List<Report> build() => [
        Report(
          userID: uuid.v7(),
          name: "name1",
          createdDate: DateTime.now(),
          col1: "col1",
          totalPrice: 1,
          reportID: uuid.v7(),
        ),
        Report(
          userID: uuid.v7(),
          name: "name2",
          createdDate: DateTime.now(),
          col1: "col2",
          totalPrice: 2,
          reportID: uuid.v7(),
        )
      ];

  // required String name,
  // required String id,
  // required DateTime createdDate,
  // // required String Expence,
  // required String col1,
  // required int totalPrice,

  void addReport(Report report) {
    state = [
      ...state,
      report,
    ];
  }

  void removeReport(Report target) {
    state =
        state.where((report) => report.reportID != target.reportID).toList();
  }
}
