import 'package:uuid/uuid.dart';
import '../models/index.dart';
import 'storage_service.dart';

class ClaimService {
  final StorageService storageService;

  ClaimService(this.storageService);

  Future<List<Claim>> getAllClaims() async {
    return await storageService.getAllClaims();
  }

  Future<Claim?> getClaimById(String id) async {
    return await storageService.getClaimById(id);
  }

  Future<Claim> createClaim({
    required String patientName,
    required String patientId,
    required String hospitalName,
    required DateTime admissionDate,
    DateTime? dischargeDate,
    required String notes,
  }) async {
    final claim = Claim(
      id: const Uuid().v4(),
      patientName: patientName,
      patientId: patientId,
      hospitalName: hospitalName,
      admissionDate: admissionDate,
      dischargeDate: dischargeDate,
      status: ClaimStatus.draft,
      bills: [],
      advances: [],
      settlements: [],
      dateCreated: DateTime.now(),
      notes: notes,
    );

    await storageService.saveClaim(claim);
    return claim;
  }

  Future<Claim> updateClaim(Claim claim) async {
    final updatedClaim = claim.copyWith(
      dateModified: DateTime.now(),
    );
    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<void> deleteClaim(String claimId) async {
    await storageService.deleteClaim(claimId);
  }

  // Bill operations
  Future<Claim> addBill(
    String claimId, {
    required String description,
    required double amount,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final bill = Bill(
      id: const Uuid().v4(),
      claimId: claimId,
      description: description,
      amount: amount,
      dateCreated: DateTime.now(),
    );

    final updatedBills = [...claim.bills, bill];
    final updatedClaim = claim.copyWith(
      bills: updatedBills,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> updateBill(
    String claimId,
    String billId, {
    required String description,
    required double amount,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final billIndex = claim.bills.indexWhere((b) => b.id == billId);
    if (billIndex == -1) throw Exception('Bill not found');

    final updatedBills = [...claim.bills];
    updatedBills[billIndex] = updatedBills[billIndex].copyWith(
      description: description,
      amount: amount,
      dateModified: DateTime.now(),
    );

    final updatedClaim = claim.copyWith(
      bills: updatedBills,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> deleteBill(String claimId, String billId) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final updatedBills = claim.bills.where((b) => b.id != billId).toList();
    final updatedClaim = claim.copyWith(
      bills: updatedBills,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  // Advance operations
  Future<Claim> addAdvance(
    String claimId, {
    required double amount,
    required String remarks,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final advance = Advance(
      id: const Uuid().v4(),
      claimId: claimId,
      amount: amount,
      dateCreated: DateTime.now(),
      remarks: remarks,
    );

    final updatedAdvances = [...claim.advances, advance];
    final updatedClaim = claim.copyWith(
      advances: updatedAdvances,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> updateAdvance(
    String claimId,
    String advanceId, {
    required double amount,
    required String remarks,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final advanceIndex = claim.advances.indexWhere((a) => a.id == advanceId);
    if (advanceIndex == -1) throw Exception('Advance not found');

    final updatedAdvances = [...claim.advances];
    updatedAdvances[advanceIndex] = updatedAdvances[advanceIndex].copyWith(
      amount: amount,
      remarks: remarks,
    );

    final updatedClaim = claim.copyWith(
      advances: updatedAdvances,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> deleteAdvance(String claimId, String advanceId) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final updatedAdvances = claim.advances.where((a) => a.id != advanceId).toList();
    final updatedClaim = claim.copyWith(
      advances: updatedAdvances,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  // Settlement operations
  Future<Claim> addSettlement(
    String claimId, {
    required double amount,
    required DateTime settledDate,
    required String remarks,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final settlement = Settlement(
      id: const Uuid().v4(),
      claimId: claimId,
      amount: amount,
      settledDate: settledDate,
      remarks: remarks,
    );

    final updatedSettlements = [...claim.settlements, settlement];
    final updatedClaim = claim.copyWith(
      settlements: updatedSettlements,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> updateSettlement(
    String claimId,
    String settlementId, {
    required double amount,
    required DateTime settledDate,
    required String remarks,
  }) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final settlementIndex = claim.settlements.indexWhere((s) => s.id == settlementId);
    if (settlementIndex == -1) throw Exception('Settlement not found');

    final updatedSettlements = [...claim.settlements];
    updatedSettlements[settlementIndex] = updatedSettlements[settlementIndex].copyWith(
      amount: amount,
      settledDate: settledDate,
      remarks: remarks,
    );

    final updatedClaim = claim.copyWith(
      settlements: updatedSettlements,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  Future<Claim> deleteSettlement(String claimId, String settlementId) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    final updatedSettlements = claim.settlements.where((s) => s.id != settlementId).toList();
    final updatedClaim = claim.copyWith(
      settlements: updatedSettlements,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  // Status transitions
  Future<Claim> transitionClaimStatus(String claimId, ClaimStatus newStatus) async {
    final claim = await storageService.getClaimById(claimId);
    if (claim == null) throw Exception('Claim not found');

    if (!claim.status.canTransitionTo(newStatus)) {
      throw Exception('Invalid status transition from ${claim.status.displayName} to ${newStatus.displayName}');
    }

    final updatedClaim = claim.copyWith(
      status: newStatus,
      dateModified: DateTime.now(),
    );

    await storageService.saveClaim(updatedClaim);
    return updatedClaim;
  }

  // Query operations
  Future<List<Claim>> getClaimsByStatus(ClaimStatus status) async {
    final claims = await storageService.getAllClaims();
    return claims.where((claim) => claim.status == status).toList();
  }

  Future<List<Claim>> getClaimsByPatientId(String patientId) async {
    final claims = await storageService.getAllClaims();
    return claims.where((claim) => claim.patientId == patientId).toList();
  }

  Future<List<Claim>> searchClaims(String query) async {
    final claims = await storageService.getAllClaims();
    final queryLower = query.toLowerCase();
    return claims
        .where((claim) =>
            claim.patientName.toLowerCase().contains(queryLower) ||
            claim.patientId.toLowerCase().contains(queryLower) ||
            claim.hospitalName.toLowerCase().contains(queryLower))
        .toList();
  }
}
