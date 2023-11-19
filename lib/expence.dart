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
// enum ExpenceType { transportation, others }
enum ExpenceType {
  transportation(id: 0, name: "交通費"),
  others(id: 1, name: "その他"),
  test(id: 2, name: "直");

  const ExpenceType({required this.id, required this.name});
  final int id;
  final String name;
}

enum TaxType { standardNoReceipt, invoice }

@freezed
class Expence with _$Expence {
  factory Expence({
    // required String userID,
    // required String reportID,
    // required String id,
    // required DateTime createdDate,
    // required ExpenceType expenceType,
    // required DateTime expenceDate,
    // required String col1,
    // required String col2,
    // required  col3,
    // required int price,
    // required TaxType taxType,
    // required String invoiceNumber,
    //
    required String userID,
    required String reportID,
    required String id,
    required DateTime createdDate,
    
    ExpenceType? expenceType,
    DateTime? expenceDate,
    String? col1,
    String? col2,
    String? col3,
    int? price,
    TaxType? taxType,
    String? invoiceNumber,
  }) = _Expence;

  /// Convert a JSON object into an [Expence] instance.
  /// This enables type-safe reading of the API response.
  // factory Expence.fromJson(Map<String, dynamic> json) =>
  //     _$ExpenceFromJson(json);
}
