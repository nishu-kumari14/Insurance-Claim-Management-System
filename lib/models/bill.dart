class Bill {
  final String id;
  final String claimId;
  final String description;
  final double amount;
  final DateTime dateCreated;
  final DateTime? dateModified;

  Bill({
    required this.id,
    required this.claimId,
    required this.description,
    required this.amount,
    required this.dateCreated,
    this.dateModified,
  });

  Bill copyWith({
    String? id,
    String? claimId,
    String? description,
    double? amount,
    DateTime? dateCreated,
    DateTime? dateModified,
  }) {
    return Bill(
      id: id ?? this.id,
      claimId: claimId ?? this.claimId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'claimId': claimId,
    'description': description,
    'amount': amount,
    'dateCreated': dateCreated.toIso8601String(),
    'dateModified': dateModified?.toIso8601String(),
  };

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      claimId: json['claimId'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: json['dateModified'] != null ? DateTime.parse(json['dateModified']) : null,
    );
  }
}
