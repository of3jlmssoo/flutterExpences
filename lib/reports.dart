// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'report.dart';

part 'reports.g.dart';

@riverpod
class ReportList extends _$ReportList {
  @override
  List<Report> build() => [];

  void addExpence(Report report) {
    state = [
      ...state,
      report,
    ];
  }

  void remove(Report target) {
    state = state.where((report) => report.id != target.id).toList();
  }
}
