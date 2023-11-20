// dart run build_runner build currentexpence.dart
//
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpodtest/expence.dart';
import 'package:uuid/uuid.dart';

part 'currentexpence.g.dart';

@riverpod
class CurrentExpence extends _$CurrentExpence {
  @override
  Expence build() {
    return Expence(
      userID: uuid.v7(),
      reportID: uuid.v7(),
      id: uuid.v7(),
      createdDate: DateTime.now(),
      expenceType: ExpenceType.transportation,
      expenceDate: DateTime.now(),
      taxType: TaxType.invoice,
    );
  }

  void setExpenceType(ExpenceType expenceType) {
    state = state.copyWith(expenceType: expenceType);
  }
}

var uuid = const Uuid();
