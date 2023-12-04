// enum TaxType { standardNoReceipt, invoice }
// enum TaxType {
//   invoice(id: 0, name: "インボイス対象"),
//   standardNoReceipt(id: 1, name: "レシート無し"),
//   others(id: 2, name: "その他(直)");

//   const TaxType({required this.id, required this.name});
//   final int id;
//   final String name;
// }

enum TaxType {
  invoice,
  standardNoReceipt,
  others,
}

extension TaxTypeExt on TaxType {
  String get name {
    switch (this) {
      case TaxType.invoice:
        return 'インボイス対象';
      case TaxType.standardNoReceipt:
        return 'レシート無し対象';
      case TaxType.others:
        return 'その他';
    }
  }

  int get id {
    switch (this) {
      case TaxType.invoice:
        return TaxType.invoice.index;
      case TaxType.standardNoReceipt:
        return TaxType.standardNoReceipt.index;
      case TaxType.others:
        return TaxType.others.index;
    }
  }
}

//
// static final names = {
//   TaxType.invoice: 'インボイス対象',
//   TaxType.standardNoReceipt: 'レシート無し対象',
//   TaxType.others: 'その他',
// };
// String? get name => names[this];

// static final ids = {
//   TaxType.invoice: TaxType.invoice.index,
//   TaxType.standardNoReceipt: TaxType.standardNoReceipt.index,
//   TaxType.others: TaxType.others.index,
// };
// int? get id => ids[this];

enum ExpenceType {
  transportation,
  others,
  test,
}

extension ExpenceTypeExt on ExpenceType {
  String get name {
    switch (this) {
      case ExpenceType.transportation:
        return '交通費';
      case ExpenceType.others:
        return 'その他';
      case ExpenceType.test:
        return 'テスト(直)';
    }
  }

  static final ids = {
    ExpenceType.transportation: ExpenceType.transportation.index,
    ExpenceType.others: ExpenceType.others.index,
    ExpenceType.test: ExpenceType.test.index,
  };

  int? get id => ids[this];
}
