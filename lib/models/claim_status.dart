enum ClaimStatus {
  draft,
  submitted,
  approved,
  rejected,
  partiallySettled,
  settled;

  String get displayName {
    switch (this) {
      case ClaimStatus.draft:
        return 'Draft';
      case ClaimStatus.submitted:
        return 'Submitted';
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.rejected:
        return 'Rejected';
      case ClaimStatus.partiallySettled:
        return 'Partially Settled';
      case ClaimStatus.settled:
        return 'Settled';
    }
  }

  bool canTransitionTo(ClaimStatus nextStatus) {
    switch (this) {
      case ClaimStatus.draft:
        return nextStatus == ClaimStatus.submitted;
      case ClaimStatus.submitted:
        return nextStatus == ClaimStatus.approved ||
            nextStatus == ClaimStatus.rejected;
      case ClaimStatus.approved:
        return nextStatus == ClaimStatus.partiallySettled ||
            nextStatus == ClaimStatus.settled;
      case ClaimStatus.rejected:
        return false;
      case ClaimStatus.partiallySettled:
        return nextStatus == ClaimStatus.settled;
      case ClaimStatus.settled:
        return false;
    }
  }
}
