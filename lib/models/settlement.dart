class Settlement {
  final String id;
  final String claimId;
  final double amount;
  final DateTime settledDate;
  final String remarks;

  Settlement({
    required this.id,
    required this.claimId,
    required this.amount,
    required this.settledDate,
    required this.remarks,
  });

  Settlement copyWith({
    String? id,
    String? claimId,
    double? amount,
    DateTime? settledDate,
    String? remarks,
  }) {
    return Settlement(
      id: id ?? this.id,
      claimId: claimId ?? this.claimId,
      amount: amount ?? this.amount,
      settledDate: settledDate ?? this.settledDate,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'claimId': claimId,
    'amount': amount,
    'settledDate': settledDate.toIso8601String(),
    'remarks': remarks,
  };

  factory Settlement.fromJson(Map<String, dynamic> json) {
    return Settlement(
      id: json['id'],
      claimId: json['claimId'],
      amount: (json['amount'] as num).toDouble(),
      settledDate: DateTime.parse(json['settledDate']),
      remarks: json['remarks'],
    );
  }
}
