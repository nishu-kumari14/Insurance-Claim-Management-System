class Advance {
  final String id;
  final String claimId;
  final double amount;
  final DateTime dateCreated;
  final String remarks;

  Advance({
    required this.id,
    required this.claimId,
    required this.amount,
    required this.dateCreated,
    required this.remarks,
  });

  Advance copyWith({
    String? id,
    String? claimId,
    double? amount,
    DateTime? dateCreated,
    String? remarks,
  }) {
    return Advance(
      id: id ?? this.id,
      claimId: claimId ?? this.claimId,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'claimId': claimId,
    'amount': amount,
    'dateCreated': dateCreated.toIso8601String(),
    'remarks': remarks,
  };

  factory Advance.fromJson(Map<String, dynamic> json) {
    return Advance(
      id: json['id'],
      claimId: json['claimId'],
      amount: (json['amount'] as num).toDouble(),
      dateCreated: DateTime.parse(json['dateCreated']),
      remarks: json['remarks'],
    );
  }
}
