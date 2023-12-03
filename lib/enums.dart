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
  static final names = {
    TaxType.invoice: 'インボイス対象',
    TaxType.standardNoReceipt: 'レシート無し対象',
    TaxType.others: 'その他',
  };
  String? get name => names[this];

  static final ids = {
    TaxType.invoice: TaxType.invoice.index,
    TaxType.standardNoReceipt: TaxType.standardNoReceipt.index,
    TaxType.others: TaxType.others.index,
  };
  int? get id => ids[this];
}

enum ExpenceType {
  transportation,
  others,
  test,
}

extension ExpenceTypeExt on ExpenceType {
  static final names = {
    ExpenceType.transportation: '交通費',
    ExpenceType.others: 'その他',
    ExpenceType.test: '直',
  };

  String? get name => names[this];

  static final ids = {
    ExpenceType.transportation: ExpenceType.transportation.index,
    ExpenceType.others: ExpenceType.others.index,
    ExpenceType.test: ExpenceType.test.index,
  };

  int? get id => ids[this];
}
