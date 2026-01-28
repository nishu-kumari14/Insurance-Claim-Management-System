import 'package:flutter/material.dart';
import 'package:insurance_claim_system/models/index.dart';
import 'package:insurance_claim_system/providers/claim_provider.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/widgets/index.dart';
import 'package:provider/provider.dart';
import 'create_claim_screen.dart';
import 'claim_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
        content: const Text('Are you sure you want to delete this claim? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await context.read<ClaimProvider>().deleteClaim(claimId);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Claim deleted successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete claim'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
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
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.dashboard),
                      text: 'Overview',
                    ),
                    Tab(
                      icon: Icon(Icons.assignment),
                      text: 'Claims',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOverviewTab(claimProvider),
                      _buildClaimsTab(claimProvider),
                    ],
                  ),
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
                _createRoute(const CreateClaimScreen()),
              );
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
          ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(ClaimProvider claimProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimens.paddingLarge),
          
          // Statistics Cards - 2x2 Grid
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
                isCurrency: false,
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
          const SizedBox(height: AppDimens.paddingXLarge),

          // Status Summary
          Text(
            'Status Summary',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: Column(
                children: [
                  _buildStatusRow('Draft', claimProvider.draftClaims, AppColors.draftColor),
                  _buildStatusRow('Submitted', claimProvider.submittedClaims, AppColors.submittedColor),
                  _buildStatusRow('Approved', claimProvider.approvedClaims, AppColors.approvedColor),
                  _buildStatusRow('Rejected', claimProvider.rejectedClaims, AppColors.rejectedColor),
                  _buildStatusRow('Settled', claimProvider.settledClaims, AppColors.settledColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'New Claim',
                  onPressed: () {
                    Navigator.push(
                      context,
                      _createRoute(const CreateClaimScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimens.paddingSmall),
              Text(
                status,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimsTab(ClaimProvider claimProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                }),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          if (claimProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (claimProvider.claims.isEmpty)
            EmptyStateWidget(
              title: 'No Claims Yet',
              message: 'Start by creating your first insurance claim. Tap the button below to get started.',
              icon: Icons.assignment_ind_outlined,
              actionButton: () {
                Navigator.push(
                  context,
                  _createRoute(const CreateClaimScreen()),
                );
              },
              actionButtonLabel: 'Create Claim',
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

                return FadeTransition(
                  opacity: AlwaysStoppedAnimation(1.0),
                  child: ClaimCard(
                    claim: claim,
                    onTap: () async {
                      await context.read<ClaimProvider>().selectClaim(claim.id);
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        _createRoute(const ClaimDetailScreen()),
                      );
                    },
                    onDelete: () => _showDeleteDialog(context, claim.id),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
