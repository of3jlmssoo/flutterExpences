// dart run build_runner build
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'expence.freezed.dart';
part 'expence.g.dart';

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

@freezed
class Expence with _$Expence {
  factory Expence({
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
  factory Expence.fromJson(Map<String, dynamic> json) =>
      _$ExpenceFromJson(json);

  factory Expence.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Expence(
      userID: data?['userID'],
      reportID: data?['reportID'],
      id: data?['id'],
      createdDate: data?['createdDate'],
      expenceType: data?['expenceType'],
      expenceDate: data?['expenceDate'],
      col1: data?['col1'],
      col2: data?['col2'],
      col3: data?['col3'],
      price: data?['price'],
      taxType: data?['taxType'],
      invoiceNumber: data?['invoiceNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userID != null) "userID": userID,
      if (reportID != null) "reportID": reportID,
      if (id != null) "id": id,
      if (createdDate != null) "createdDate": createdDate,
      if (expenceType != null) "expenceType": expenceType,
      if (expenceDate != null) "expenceDate": expenceDate,
      if (col1 != null) "col1": col1,
      if (col2 != null) "col2": col2,
      if (col3 != null) "col3": col3,
      if (price != null) "price": price,
      if (taxType != null) "taxType": taxType,
      if (invoiceNumber != null) "invoiceNumber": invoiceNumber,
    };
  }
}
