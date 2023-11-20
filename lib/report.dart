// dart run build_runner build
import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';
// enum ExpenceType { transportation, others }

// enum TaxType { standardNoReceipt, invoice }

@freezed
class Report with _$Report {
  factory Report({
    required String userID,
    required String reportID,
    required String name,
    required DateTime createdDate,
    // required String Expence,
    required String col1,
    required int totalPrice,
  }) = _Report;

  /// Convert a JSON object into an [Expence] instance.
  /// This enables type-safe reading of the API response.
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
