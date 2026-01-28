import 'package:flutter/material.dart';
import 'package:insurance_claim_system/models/index.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/utils/formatters.dart';

class ClaimCard extends StatelessWidget {
  final Claim claim;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ClaimCard({
    super.key,
    required this.claim,
    required this.onTap,
    this.onDelete,
  });

  Color getStatusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.draft:
        return AppColors.draftColor;
      case ClaimStatus.submitted:
        return AppColors.submittedColor;
      case ClaimStatus.approved:
        return AppColors.approvedColor;
      case ClaimStatus.rejected:
        return AppColors.rejectedColor;
      case ClaimStatus.partiallySettled:
        return AppColors.partiallySettledColor;
      case ClaimStatus.settled:
        return AppColors.settledColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimens.cardElevation,
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimens.padding),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                claim.patientName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: getStatusColor(claim.status).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                border: Border.all(color: getStatusColor(claim.status)),
              ),
              child: Text(
                claim.status.displayName,
                style: TextStyle(
                  color: getStatusColor(claim.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Patient ID: ${claim.patientId}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Hospital: ${claim.hospitalName}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${AppFormatters.formatCurrency(claim.totalBills)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Pending: ${AppFormatters.formatCurrency(claim.pendingAmount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: claim.pendingAmount > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
        trailing: onDelete != null
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Text('Delete'),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
