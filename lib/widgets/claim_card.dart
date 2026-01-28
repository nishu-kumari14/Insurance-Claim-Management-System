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
    final settlementPercentage = claim.totalBills > 0 
        ? (claim.totalSettlements / claim.totalBills) * 100 
        : 0.0;
    final isFullySettled = settlementPercentage >= 100;

    return Card(
      elevation: AppDimens.cardElevation,
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      claim.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: AppDimens.paddingSmall),

              // Hospital and Patient ID
              Text(
                'Patient ID: ${claim.patientId}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hospital: ${claim.hospitalName}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.paddingSmall),

              // Settlement Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Settlement Progress',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${settlementPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isFullySettled 
                              ? AppColors.success 
                              : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: settlementPercentage / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.greyLight,
                      valueColor: AlwaysStoppedAnimation(
                        isFullySettled ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingSmall),

              // Financial Summary
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingSmall,
                  vertical: AppDimens.paddingXSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Bills',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            AppFormatters.formatCurrency(claim.totalBills),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Settled',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            AppFormatters.formatCurrency(claim.totalSettlements),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            AppFormatters.formatCurrency(claim.pendingAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: claim.pendingAmount > 0 
                                  ? AppColors.warning 
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.paddingSmall),

              // Action button
              if (onDelete != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onDelete,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
