import 'package:flutter/material.dart';
import 'package:insurance_claim_system/models/index.dart';
import 'package:insurance_claim_system/providers/claim_provider.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/widgets/index.dart';
import 'package:provider/provider.dart';
import 'create_claim_screen.dart';
import 'claim_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  ClaimStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClaimProvider>().loadClaims();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, String claimId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Claim'),
        content: const Text('Are you sure you want to delete this claim?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ClaimProvider>().deleteClaim(claimId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Claim deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        elevation: 0,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'Insurance Claim Management System\n\n'
                    'A comprehensive solution for managing hospital insurance claims, '
                    'including bill tracking, advances, and settlements.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ClaimProvider>(
        builder: (context, claimProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppDimens.paddingSmall,
                  crossAxisSpacing: AppDimens.paddingSmall,
                  children: [
                    FinancialSummaryCard(
                      title: 'Total Claims',
                      amount: claimProvider.totalClaims.toDouble(),
                      icon: Icons.assignment,
                      color: AppColors.primary,
                    ),
                    FinancialSummaryCard(
                      title: 'Total Bills',
                      amount: claimProvider.totalBillsAmount,
                      icon: Icons.receipt,
                      color: AppColors.info,
                    ),
                    FinancialSummaryCard(
                      title: 'Total Settled',
                      amount: claimProvider.totalSettledAmount,
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                    FinancialSummaryCard(
                      title: 'Total Pending',
                      amount: claimProvider.totalPendingAmount,
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.paddingLarge),

                // Search and Filter
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search claims...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: AppDimens.paddingSmall),

                // Status Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedStatus == null,
                        onSelected: (_) {
                          setState(() => _selectedStatus = null);
                        },
                      ),
                      const SizedBox(width: AppDimens.paddingSmall),
                      ...ClaimStatus.values.map((status) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppDimens.paddingSmall),
                          child: FilterChip(
                            label: Text(status.displayName),
                            selected: _selectedStatus == status,
                            onSelected: (_) {
                              setState(() => _selectedStatus = status);
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.paddingLarge),

                // Claims List
                Text(
                  'Your Claims',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimens.paddingSmall),

                if (claimProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (claimProvider.claims.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingLarge),
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_ind_outlined,
                            size: 64,
                            color: AppColors.greyLight,
                          ),
                          const SizedBox(height: AppDimens.paddingSmall),
                          const Text(
                            'No claims yet',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppDimens.paddingLarge),
                          CustomButton(
                            label: AppStrings.newClaim,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateClaimScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: claimProvider.claims.length,
                    itemBuilder: (context, index) {
                      final claim = claimProvider.claims[index];

                      // Apply filters
                      if (_selectedStatus != null && claim.status != _selectedStatus) {
                        return const SizedBox.shrink();
                      }

                      if (_searchController.text.isNotEmpty) {
                        final query = _searchController.text.toLowerCase();
                        if (!claim.patientName.toLowerCase().contains(query) &&
                            !claim.patientId.toLowerCase().contains(query) &&
                            !claim.hospitalName.toLowerCase().contains(query)) {
                          return const SizedBox.shrink();
                        }
                      }

                      return ClaimCard(
                        claim: claim,
                        onTap: () {
                          context.read<ClaimProvider>().selectClaim(claim.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClaimDetailScreen(),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteDialog(context, claim.id),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateClaimScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
