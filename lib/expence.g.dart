// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenceImpl _$$ExpenceImplFromJson(Map<String, dynamic> json) =>
    _$ExpenceImpl(
      userID: json['userID'] as String,
      reportID: json['reportID'] as String,
      id: json['id'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      expenceType:
          $enumDecodeNullable(_$ExpenceTypeEnumMap, json['expenceType']),
      expenceDate: json['expenceDate'] == null
          ? null
          : DateTime.parse(json['expenceDate'] as String),
      col1: json['col1'] as String?,
      col2: json['col2'] as String?,
      col3: json['col3'] as String?,
      price: json['price'] as int?,
      taxType: $enumDecodeNullable(_$TaxTypeEnumMap, json['taxType']),
      invoiceNumber: json['invoiceNumber'] as String?,
    );

Map<String, dynamic> _$$ExpenceImplToJson(_$ExpenceImpl instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'reportID': instance.reportID,
      'id': instance.id,
      'createdDate': instance.createdDate.toIso8601String(),
      'expenceType': _$ExpenceTypeEnumMap[instance.expenceType],
      'expenceDate': instance.expenceDate?.toIso8601String(),
      'col1': instance.col1,
      'col2': instance.col2,
      'col3': instance.col3,
      'price': instance.price,
      'taxType': _$TaxTypeEnumMap[instance.taxType],
      'invoiceNumber': instance.invoiceNumber,
    };

const _$ExpenceTypeEnumMap = {
  ExpenceType.transportation: 'transportation',
  ExpenceType.others: 'others',
  ExpenceType.test: 'test',
};

const _$TaxTypeEnumMap = {
  TaxType.invoice: 'invoice',
  TaxType.standardNoReceipt: 'standardNoReceipt',
  TaxType.others: 'others',
};
