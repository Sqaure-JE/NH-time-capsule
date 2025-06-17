class FinancialTransaction {
  final String name;
  final int amount;
  final String type;

  const FinancialTransaction({
    required this.name,
    required this.amount,
    required this.type,
  });

  factory FinancialTransaction.fromMap(Map<String, dynamic> map) {
    return FinancialTransaction(
      name: map['name'] as String,
      amount: map['amount'] as int,
      type: map['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'type': type,
    };
  }

  static List<FinancialTransaction> getDummyData() {
    return const [
      FinancialTransaction(name: "스타벅스", amount: -5600, type: "지출"),
      FinancialTransaction(name: "급여", amount: 2500000, type: "수입"),
      FinancialTransaction(name: "적금", amount: -300000, type: "저축"),
    ];
  }
} 