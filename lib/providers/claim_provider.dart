import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class ClaimProvider extends ChangeNotifier {
  final ClaimService _claimService;
  List<Claim> _claims = [];
  Claim? _selectedClaim;
  bool _isLoading = false;
  String? _error;

  ClaimProvider(this._claimService);

  // Getters
  List<Claim> get claims => _claims;
  Claim? get selectedClaim => _selectedClaim;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize
  Future<void> initialize() async {
    await loadClaims();
  }

  // Load all claims
  Future<void> loadClaims() async {
    try {
      _isLoading = true;
      _error = null;
      _claims = await _claimService.getAllClaims();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get claim by ID
  Future<void> selectClaim(String claimId) async {
    try {
      _selectedClaim = await _claimService.getClaimById(claimId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Create claim
  Future<Claim?> createClaim({
    required String patientName,
    required String patientId,
    required String hospitalName,
    required DateTime admissionDate,
    DateTime? dischargeDate,
    required String notes,
  }) async {
    try {
      final claim = await _claimService.createClaim(
        patientName: patientName,
        patientId: patientId,
        hospitalName: hospitalName,
        admissionDate: admissionDate,
        dischargeDate: dischargeDate,
        notes: notes,
      );
      _claims.add(claim);
      notifyListeners();
      return claim;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Update claim
  Future<Claim?> updateClaim(Claim claim) async {
    try {
      final updated = await _claimService.updateClaim(claim);
      final index = _claims.indexWhere((c) => c.id == claim.id);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Delete claim
  Future<bool> deleteClaim(String claimId) async {
    try {
      await _claimService.deleteClaim(claimId);
      _claims.removeWhere((c) => c.id == claimId);
      if (_selectedClaim?.id == claimId) {
        _selectedClaim = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Bill operations
  Future<Claim?> addBill(
    String claimId, {
    required String description,
    required double amount,
  }) async {
    try {
      final updated = await _claimService.addBill(
        claimId,
        description: description,
        amount: amount,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> updateBill(
    String claimId,
    String billId, {
    required String description,
    required double amount,
  }) async {
    try {
      final updated = await _claimService.updateBill(
        claimId,
        billId,
        description: description,
        amount: amount,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> deleteBill(String claimId, String billId) async {
    try {
      final updated = await _claimService.deleteBill(claimId, billId);
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Advance operations
  Future<Claim?> addAdvance(
    String claimId, {
    required double amount,
    required String remarks,
  }) async {
    try {
      final updated = await _claimService.addAdvance(
        claimId,
        amount: amount,
        remarks: remarks,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> updateAdvance(
    String claimId,
    String advanceId, {
    required double amount,
    required String remarks,
  }) async {
    try {
      final updated = await _claimService.updateAdvance(
        claimId,
        advanceId,
        amount: amount,
        remarks: remarks,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> deleteAdvance(String claimId, String advanceId) async {
    try {
      final updated = await _claimService.deleteAdvance(claimId, advanceId);
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Settlement operations
  Future<Claim?> addSettlement(
    String claimId, {
    required double amount,
    required DateTime settledDate,
    required String remarks,
  }) async {
    try {
      final updated = await _claimService.addSettlement(
        claimId,
        amount: amount,
        settledDate: settledDate,
        remarks: remarks,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> updateSettlement(
    String claimId,
    String settlementId, {
    required double amount,
    required DateTime settledDate,
    required String remarks,
  }) async {
    try {
      final updated = await _claimService.updateSettlement(
        claimId,
        settlementId,
        amount: amount,
        settledDate: settledDate,
        remarks: remarks,
      );
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Claim?> deleteSettlement(String claimId, String settlementId) async {
    try {
      final updated = await _claimService.deleteSettlement(claimId, settlementId);
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Status transitions
  Future<Claim?> transitionStatus(String claimId, ClaimStatus newStatus) async {
    try {
      final updated = await _claimService.transitionClaimStatus(claimId, newStatus);
      final index = _claims.indexWhere((c) => c.id == claimId);
      if (index != -1) {
        _claims[index] = updated;
      }
      _selectedClaim = updated;
      notifyListeners();
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Query operations
  Future<List<Claim>> getClaimsByStatus(ClaimStatus status) async {
    try {
      return await _claimService.getClaimsByStatus(status);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<List<Claim>> searchClaims(String query) async {
    try {
      return await _claimService.searchClaims(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Stats
  int get totalClaims => _claims.length;
  int get draftClaims => _claims.where((c) => c.status == ClaimStatus.draft).length;
  int get submittedClaims => _claims.where((c) => c.status == ClaimStatus.submitted).length;
  int get approvedClaims => _claims.where((c) => c.status == ClaimStatus.approved).length;
  int get rejectedClaims => _claims.where((c) => c.status == ClaimStatus.rejected).length;
  int get settledClaims => _claims.where((c) => c.status == ClaimStatus.settled || c.status == ClaimStatus.partiallySettled).length;

  double get totalBillsAmount => _claims.fold(0.0, (sum, claim) => sum + claim.totalBills);
  double get totalSettledAmount => _claims.fold(0.0, (sum, claim) => sum + claim.totalSettlements);
  double get totalPendingAmount => _claims.fold(0.0, (sum, claim) => sum + claim.pendingAmount);

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
