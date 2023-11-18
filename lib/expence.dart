// dart run build_runner build
import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'expence.freezed.dart';

/// The response of the `GET /api/Expence` endpoint.
///
/// It is defined using `freezed` and `json_serializable`.
//
// レポートID
// ID
// 入力日付
// 経費種別
// 日付
// 費用項目/乗車地
// 降車地
// 金額
// メモ
// 税タイプ
enum ExpenceType { transportation, others }

enum TaxType { standardNoReceipt, invoice }

@freezed
class Expence with _$Expence {
  factory Expence({
    required String reportID,
    required String id,
    required DateTime createdDate,
    // required String Expence,
    required ExpenceType expenceType,
    required DateTime expenceDate,
    required String col1,
    required String col2,
    required String col3,
    required int price,
    required TaxType taxType,
    required String invoiceNumber,
  }) = _Expence;

  /// Convert a JSON object into an [Expence] instance.
  /// This enables type-safe reading of the API response.
  // factory Expence.fromJson(Map<String, dynamic> json) =>
  //     _$ExpenceFromJson(json);
}
