import 'package:intl/intl.dart' as intl;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpodtest/enums.dart';

part 'expenceproviders.g.dart';

@riverpod
// @Riverpod(keepAlive: true)
class CurrentTaxType extends _$CurrentTaxType {
  @override
  TaxType build() {
    return TaxType.invoice;
  }

  void taxType(TaxType tt) {
    state = tt;
  }
}

@riverpod
// @Riverpod(keepAlive: true)
class CurrentExpenceType extends _$CurrentExpenceType {
  @override
  ExpenceType build() {
    return ExpenceType.transportation;
  }

  void expenceType(ExpenceType et) {
    state = et;
  }
}

@riverpod
// @Riverpod(keepAlive: true)
class CurrentExpenceDate extends _$CurrentExpenceDate {
  @override
  String build() {
    return intl.DateFormat.yMd().format(DateTime.now());
  }

  void expenceDate(DateTime dt) {
    state = intl.DateFormat.yMd().format(dt);
  }
}

@riverpod
class CurrentPrice extends _$CurrentPrice {
  @override
  int? build() {
    return null;
  }

  void price(int? price) {
    state = price;
  }
}
