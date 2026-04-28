class Expense {
  int? id;
  double amount;
  String note;
  int categoryId;
  String? categoryName;

  Expense({
    this.id,
    required this.amount,
    required this.note,
    required this.categoryId,
    this.categoryName,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'note': note,
        'categoryId': categoryId,
      };

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      note: map['note'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
    );
  }
}