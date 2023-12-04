import 'package:intl/intl.dart' as intl;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpodtest/enums.dart';

part 'expenceproviders.g.dart';

// @riverpod
// class CurrentTaxType extends _$CurrentTaxType {
//   @override
//   TaxType build() {
//     return TaxType.invoice;
//   }

//   void taxType(TaxType tt) {
//     state = tt;
//   }
// }
@riverpod
class CurrentTaxType extends _$CurrentTaxType {
  @override
  int? build() {
    return TaxType.invoice.id;
  }

  void taxType(int tt) {
    state = tt;
  }

  String? name(int i) {
    switch (i) {
      case TaxType.invoice:
        return TaxType.invoice.name;
      case TaxType.standardNoReceipt:
        return TaxType.standardNoReceipt.name;
      case TaxType.others:
        return TaxType.others.name;
      default:
        return 'default value';
    }
  }
}

// @riverpod
// class CurrentExpenceType extends _$CurrentExpenceType {
//   @override
//   ExpenceType build() {
//     return ExpenceType.transportation;
//   }

//   void expenceType(ExpenceType et) {
//     state = et;
//   }
// }
@riverpod
class CurrentExpenceType extends _$CurrentExpenceType {
  @override
  int? build() {
    return ExpenceType.transportation.id;
  }

  void expenceType(int et) {
    state = et;
  }

  // String? name(int i) {
  //   print('CurrentExpenceType ---> i:$i ${ExpenceType.transportation.name}');
  //   switch (i) {
  //     case ExpenceType.transportation.id:
  //       return ExpenceType.transportation.name;
  //     case ExpenceType.others.id:
  //       return ExpenceType.others.name;
  //     case ExpenceType.test.id:
  //       return ExpenceType.test.name;
  //     default:
  //       return 'default value';
  //   }
  // }
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
