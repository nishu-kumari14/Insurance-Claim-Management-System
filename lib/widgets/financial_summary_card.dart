import 'package:flutter/material.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/utils/formatters.dart';

class FinancialSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color? color;
  final IconData icon;
  final bool isCurrency;

  const FinancialSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    required this.icon,
    this.isCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimens.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  icon,
                  color: color ?? AppColors.primary,
                  size: AppDimens.iconSizeLarge,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.paddingSmall),
            Text(
              isCurrency 
                  ? AppFormatters.formatCurrency(amount)
                  : amount.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
