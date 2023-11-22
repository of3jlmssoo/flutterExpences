// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'report.dart';

part 'reports.g.dart';

var uuid = const Uuid();

@Riverpod(keepAlive: true)
class ReportList extends _$ReportList {
  final userID = uuid.v7();
  @override
  List<Report> build() => [
        Report(
          userID: userID,
          name: "name1",
          createdDate: DateTime.now(),
          col1: "col1",
          totalPrice: 1,
          reportID: uuid.v7(),
        ),
        Report(
          userID: userID,
          name: "name2",
          createdDate: DateTime.now(),
          col1: "col2",
          totalPrice: 2,
          reportID: uuid.v7(),
        )
      ];

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
