import 'package:insurance_claim_system/models/claim_status.dart';
import 'bill.dart';
import 'settlement.dart';
import 'advance.dart';

class Claim {
  final String id;
  final String patientName;
  final String patientId;
  final String hospitalName;
  final DateTime admissionDate;
  final DateTime? dischargeDate;
  final ClaimStatus status;
  final List<Bill> bills;
  final List<Advance> advances;
  final List<Settlement> settlements;
  final DateTime dateCreated;
  final DateTime? dateModified;
  final String notes;

  Claim({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.hospitalName,
    required this.admissionDate,
    this.dischargeDate,
    required this.status,
    required this.bills,
    required this.advances,
    required this.settlements,
    required this.dateCreated,
    this.dateModified,
    required this.notes,
  });

  // Calculate total bills
  double get totalBills {
    return bills.fold(0.0, (sum, bill) => sum + bill.amount);
  }

  // Calculate total advances
  double get totalAdvances {
    return advances.fold(0.0, (sum, advance) => sum + advance.amount);
  }

  // Calculate total settlements
  double get totalSettlements {
    return settlements.fold(0.0, (sum, settlement) => sum + settlement.amount);
  }

  // Calculate pending amount
  double get pendingAmount {
    double pending = totalBills - totalAdvances - totalSettlements;
    return pending > 0 ? pending : 0;
  }

  // Calculate balance after settlements
  double get remainingBalance {
    return totalBills - totalSettlements;
  }

  Claim copyWith({
    String? id,
    String? patientName,
    String? patientId,
    String? hospitalName,
    DateTime? admissionDate,
    DateTime? dischargeDate,
    ClaimStatus? status,
    List<Bill>? bills,
    List<Advance>? advances,
    List<Settlement>? settlements,
    DateTime? dateCreated,
    DateTime? dateModified,
    String? notes,
  }) {
    return Claim(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      hospitalName: hospitalName ?? this.hospitalName,
      admissionDate: admissionDate ?? this.admissionDate,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      status: status ?? this.status,
      bills: bills ?? this.bills,
      advances: advances ?? this.advances,
      settlements: settlements ?? this.settlements,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientName': patientName,
    'patientId': patientId,
    'hospitalName': hospitalName,
    'admissionDate': admissionDate.toIso8601String(),
    'dischargeDate': dischargeDate?.toIso8601String(),
    'status': status.name,
    'bills': bills.map((b) => b.toJson()).toList(),
    'advances': advances.map((a) => a.toJson()).toList(),
    'settlements': settlements.map((s) => s.toJson()).toList(),
    'dateCreated': dateCreated.toIso8601String(),
    'dateModified': dateModified?.toIso8601String(),
    'notes': notes,
  };

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'],
      patientName: json['patientName'],
      patientId: json['patientId'],
      hospitalName: json['hospitalName'],
      admissionDate: DateTime.parse(json['admissionDate']),
      dischargeDate: json['dischargeDate'] != null ? DateTime.parse(json['dischargeDate']) : null,
      status: ClaimStatus.values.firstWhere((e) => e.name == json['status']),
      bills: (json['bills'] as List).map((b) => Bill.fromJson(b)).toList(),
      advances: (json['advances'] as List).map((a) => Advance.fromJson(a)).toList(),
      settlements: (json['settlements'] as List).map((s) => Settlement.fromJson(s)).toList(),
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: json['dateModified'] != null ? DateTime.parse(json['dateModified']) : null,
      notes: json['notes'] ?? '',
    );
  }
}
