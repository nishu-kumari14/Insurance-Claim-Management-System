import 'package:flutter/material.dart';
import 'package:insurance_claim_system/models/index.dart';
import 'package:insurance_claim_system/providers/claim_provider.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/utils/formatters.dart';
import 'package:insurance_claim_system/widgets/custom_button.dart';
import 'package:insurance_claim_system/widgets/custom_text_field.dart';
import 'package:insurance_claim_system/widgets/financial_summary_card.dart';
import 'package:provider/provider.dart';

class ClaimDetailScreen extends StatefulWidget {
  const ClaimDetailScreen({Key? key}) : super(key: key);

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Claim? _claim;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadClaim();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadClaim() async {
    final claimProvider = context.read<ClaimProvider>();
    if (claimProvider.selectedClaim != null) {
      setState(() {
        _claim = claimProvider.selectedClaim;
        _isLoading = false;
      });
    }
  }

  void _showStatusTransitionDialog() {
    if (_claim == null) return;

    final availableStatuses = ClaimStatus.values
        .where((status) => status != _claim!.status && _claim!.status.canTransitionTo(status))
        .toList();

    if (availableStatuses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No status transitions available from current status')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableStatuses.map((status) {
              return ListTile(
                title: Text(status.displayName),
                onTap: () {
                  Navigator.pop(context);
                  _transitionStatus(status);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _transitionStatus(ClaimStatus newStatus) async {
    if (_claim == null) return;

    final updated = await context.read<ClaimProvider>().transitionStatus(
          _claim!.id,
          newStatus,
        );

    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to ${newStatus.displayName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.claimDetails),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Bills'),
            Tab(text: 'Financials'),
          ],
        ),
      ),
      body: _isLoading || _claim == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBillsTab(),
                _buildFinancialsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Claim Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Claim Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showStatusTransitionDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingSmall,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppDimens.borderRadius),
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.paddingSmall),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.padding,
                      vertical: AppDimens.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_claim!.status).withValues(alpha: 0.1),
                      border: Border.all(
                        color: _getStatusColor(_claim!.status),
                      ),
                      borderRadius:
                          BorderRadius.circular(AppDimens.borderRadius),
                    ),
                    child: Text(
                      _claim!.status.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(_claim!.status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Patient Information
          Text(
            'Patient Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: Column(
                children: [
                  _buildInfoRow('Name', _claim!.patientName),
                  _buildInfoRow('Patient ID', _claim!.patientId),
                  _buildInfoRow('Hospital', _claim!.hospitalName),
                  _buildInfoRow(
                    'Admission Date',
                    AppFormatters.formatDate(_claim!.admissionDate),
                  ),
                  if (_claim!.dischargeDate != null)
                    _buildInfoRow(
                      'Discharge Date',
                      AppFormatters.formatDate(_claim!.dischargeDate!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Notes
          if (_claim!.notes.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimens.paddingSmall),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.padding),
                    child: Text(_claim!.notes),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bills (${_claim!.bills.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              CustomButton(
                label: 'Add Bill',
                onPressed: () => _showBillDialog(),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          if (_claim!.bills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                child: Text(
                  'No bills added yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claim!.bills.length,
              itemBuilder: (context, index) {
                final bill = _claim!.bills[index];
                return Card(
                  child: ListTile(
                    title: Text(bill.description),
                    subtitle: Text(
                      AppFormatters.formatDate(bill.dateCreated),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _showBillDialog(bill: bill),
                        ),
                        PopupMenuItem(
                          child: const Text('Delete'),
                          onTap: () => _deleteBill(bill.id),
                        ),
                      ],
                    ),
                    leading: Text(
                      AppFormatters.formatCurrency(bill.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: AppDimens.paddingLarge),
          Card(
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Bills',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppFormatters.formatCurrency(_claim!.totalBills),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppDimens.paddingSmall,
            crossAxisSpacing: AppDimens.paddingSmall,
            children: [
              FinancialSummaryCard(
                title: 'Total Bills',
                amount: _claim!.totalBills,
                icon: Icons.receipt,
                color: AppColors.info,
              ),
              FinancialSummaryCard(
                title: 'Total Advances',
                amount: _claim!.totalAdvances,
                icon: Icons.money,
                color: AppColors.warning,
              ),
              FinancialSummaryCard(
                title: 'Total Settled',
                amount: _claim!.totalSettlements,
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
              FinancialSummaryCard(
                title: 'Pending Amount',
                amount: _claim!.pendingAmount,
                icon: Icons.pending_actions,
                color: _claim!.pendingAmount > 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingXLarge),

          // Advances Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advances (${_claim!.advances.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              CustomButton(
                label: 'Add Advance',
                onPressed: () => _showAdvanceDialog(),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          if (_claim!.advances.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                child: Text(
                  'No advances added yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claim!.advances.length,
              itemBuilder: (context, index) {
                final advance = _claim!.advances[index];
                return Card(
                  child: ListTile(
                    title: Text(advance.remarks),
                    subtitle: Text(
                      AppFormatters.formatDate(advance.dateCreated),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _showAdvanceDialog(advance: advance),
                        ),
                        PopupMenuItem(
                          child: const Text('Delete'),
                          onTap: () => _deleteAdvance(advance.id),
                        ),
                      ],
                    ),
                    leading: Text(
                      AppFormatters.formatCurrency(advance.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Settlements Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settlements (${_claim!.settlements.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              CustomButton(
                label: 'Add Settlement',
                onPressed: () => _showSettlementDialog(),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          if (_claim!.settlements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                child: Text(
                  'No settlements added yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claim!.settlements.length,
              itemBuilder: (context, index) {
                final settlement = _claim!.settlements[index];
                return Card(
                  child: ListTile(
                    title: Text(settlement.remarks),
                    subtitle: Text(
                      AppFormatters.formatDate(settlement.settledDate),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _showSettlementDialog(settlement: settlement),
                        ),
                        PopupMenuItem(
                          child: const Text('Delete'),
                          onTap: () => _deleteSettlement(settlement.id),
                        ),
                      ],
                    ),
                    leading: Text(
                      AppFormatters.formatCurrency(settlement.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ClaimStatus status) {
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

  // Bill Dialog
  void _showBillDialog({Bill? bill}) {
    final descriptionController = TextEditingController(text: bill?.description ?? '');
    final amountController = TextEditingController(text: bill?.amount.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bill == null ? 'Add Bill' : 'Edit Bill'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Description',
                controller: descriptionController,
              ),
              const SizedBox(height: AppDimens.paddingSmall),
              CustomTextField(
                label: 'Amount',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (descriptionController.text.isEmpty ||
                  amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              if (bill == null) {
                _addBill(
                  descriptionController.text,
                  double.parse(amountController.text),
                );
              } else {
                _updateBill(
                  bill.id,
                  descriptionController.text,
                  double.parse(amountController.text),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _addBill(String description, double amount) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().addBill(
          _claim!.id,
          description: description,
          amount: amount,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill added successfully')),
      );
    }
  }

  Future<void> _updateBill(String billId, String description, double amount) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().updateBill(
          _claim!.id,
          billId,
          description: description,
          amount: amount,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill updated successfully')),
      );
    }
  }

  Future<void> _deleteBill(String billId) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().deleteBill(
          _claim!.id,
          billId,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill deleted successfully')),
      );
    }
  }

  // Advance Dialog
  void _showAdvanceDialog({Advance? advance}) {
    final amountController = TextEditingController(text: advance?.amount.toString() ?? '');
    final remarksController = TextEditingController(text: advance?.remarks ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(advance == null ? 'Add Advance' : 'Edit Advance'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Amount',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimens.paddingSmall),
              CustomTextField(
                label: 'Remarks',
                controller: remarksController,
                maxLines: 3,
                minLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (amountController.text.isEmpty || remarksController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid positive amount')),
                );
                return;
              }

              if (advance == null) {
                _addAdvance(
                  amount,
                  remarksController.text,
                );
              } else {
                _updateAdvance(
                  advance.id,
                  amount,
                  remarksController.text,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _addAdvance(double amount, String remarks) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().addAdvance(
          _claim!.id,
          amount: amount,
          remarks: remarks,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance added successfully')),
      );
    }
  }

  Future<void> _updateAdvance(String advanceId, double amount, String remarks) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().updateAdvance(
          _claim!.id,
          advanceId,
          amount: amount,
          remarks: remarks,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance updated successfully')),
      );
    }
  }

  Future<void> _deleteAdvance(String advanceId) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().deleteAdvance(
          _claim!.id,
          advanceId,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance deleted successfully')),
      );
    }
  }

  // Settlement Dialog
  void _showSettlementDialog({Settlement? settlement}) {
    final amountController =
        TextEditingController(text: settlement?.amount.toString() ?? '');
    final remarksController = TextEditingController(text: settlement?.remarks ?? '');
    DateTime? selectedDate = settlement?.settledDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(settlement == null ? 'Add Settlement' : 'Edit Settlement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Amount',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppDimens.paddingSmall),
                CustomTextField(
                  label: 'Settlement Date',
                  controller: TextEditingController(
                    text: selectedDate != null
                        ? AppFormatters.formatDate(selectedDate!)
                        : '',
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  readOnly: true,
                ),
                const SizedBox(height: AppDimens.paddingSmall),
                CustomTextField(
                  label: 'Remarks',
                  controller: remarksController,
                  maxLines: 3,
                  minLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (amountController.text.isEmpty ||
                    remarksController.text.isEmpty ||
                    selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill all fields')),
                  );
                  return;
                }

                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid positive amount')),
                  );
                  return;
                }

                if (settlement == null) {
                  _addSettlement(
                    amount,
                    selectedDate!,
                    remarksController.text,
                  );
                } else {
                  _updateSettlement(
                    settlement.id,
                    amount,
                    selectedDate!,
                    remarksController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSettlement(
    double amount,
    DateTime settledDate,
    String remarks,
  ) async {
    if (_claim == null) return;
    
    // Validate settlement amount doesn't exceed remaining balance
    final totalAfterSettlement = _claim!.totalSettlements + amount;
    if (totalAfterSettlement > _claim!.totalBills) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Settlement amount exceeds total bills. Maximum allowed: ${(_claim!.totalBills - _claim!.totalSettlements).toStringAsFixed(2)}'
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    final updated = await context.read<ClaimProvider>().addSettlement(
          _claim!.id,
          amount: amount,
          settledDate: settledDate,
          remarks: remarks,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settlement added successfully')),
      );
    }
  }

  Future<void> _updateSettlement(
    String settlementId,
    double amount,
    DateTime settledDate,
    String remarks,
  ) async {
    if (_claim == null) return;
    
    // Get current settlement amount
    final currentSettlement = _claim!.settlements.firstWhere((s) => s.id == settlementId);
    final otherSettlementsTotal = _claim!.totalSettlements - currentSettlement.amount;
    
    // Validate new settlement amount doesn't exceed remaining balance
    if (otherSettlementsTotal + amount > _claim!.totalBills) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Settlement amount exceeds total bills. Maximum allowed: ${(_claim!.totalBills - otherSettlementsTotal).toStringAsFixed(2)}'
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    final updated = await context.read<ClaimProvider>().updateSettlement(
          _claim!.id,
          settlementId,
          amount: amount,
          settledDate: settledDate,
          remarks: remarks,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settlement updated successfully')),
      );
    }
  }

  Future<void> _deleteSettlement(String settlementId) async {
    if (_claim == null) return;
    final updated = await context.read<ClaimProvider>().deleteSettlement(
          _claim!.id,
          settlementId,
        );
    if (updated != null && mounted) {
      setState(() => _claim = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settlement deleted successfully')),
      );
    }
  }
}
