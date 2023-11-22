// enum TaxType { standardNoReceipt, invoice }
enum TaxType {
  invoice(id: 0, name: "インボイス対象"),
  standardNoReceipt(id: 1, name: "レシート無し"),
  others(id: 2, name: "その他(直)");

  const TaxType({required this.id, required this.name});
  final int id;
  final String name;
}

enum ExpenceType {
  transportation(id: 0, name: "交通費"),
  others(id: 1, name: "その他"),
  test(id: 2, name: "直");

  const ExpenceType({required this.id, required this.name});
  final int id;
  final String name;
}
