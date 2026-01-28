import 'package:flutter/material.dart';
import 'package:insurance_claim_system/providers/claim_provider.dart';
import 'package:insurance_claim_system/utils/constants.dart';
import 'package:insurance_claim_system/utils/validators.dart';
import 'package:insurance_claim_system/widgets/custom_button.dart';
import 'package:insurance_claim_system/widgets/custom_text_field.dart';
import 'package:insurance_claim_system/screens/claim_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateClaimScreen extends StatefulWidget {
  const CreateClaimScreen({Key? key}) : super(key: key);

  @override
  State<CreateClaimScreen> createState() => _CreateClaimScreenState();
}

class _CreateClaimScreenState extends State<CreateClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _patientNameController;
  late TextEditingController _patientIdController;
  late TextEditingController _hospitalNameController;
  late TextEditingController _admissionDateController;
  late TextEditingController _dischargeDateController;
  late TextEditingController _notesController;
  bool _isLoading = false;
  DateTime? _selectedAdmissionDate;
  DateTime? _selectedDischargeDate;

  @override
  void initState() {
    super.initState();
    _patientNameController = TextEditingController();
    _patientIdController = TextEditingController();
    _hospitalNameController = TextEditingController();
    _admissionDateController = TextEditingController();
    _dischargeDateController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientIdController.dispose();
    _hospitalNameController.dispose();
    _admissionDateController.dispose();
    _dischargeDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectAdmissionDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedAdmissionDate = date;
        _admissionDateController.text = DateFormat('MMM dd, yyyy').format(date);
      });
    }
  }

  Future<void> _selectDischargeDate() async {
    if (_selectedAdmissionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select admission date first')),
      );
      return;
    }
    
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedAdmissionDate ?? DateTime.now(),
      firstDate: _selectedAdmissionDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDischargeDate = date;
        _dischargeDateController.text = DateFormat('MMM dd, yyyy').format(date);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAdmissionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select admission date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final claim = await context.read<ClaimProvider>().createClaim(
        patientName: _patientNameController.text,
        patientId: _patientIdController.text,
        hospitalName: _hospitalNameController.text,
        admissionDate: _selectedAdmissionDate!,
        dischargeDate: _selectedDischargeDate,
        notes: _notesController.text,
      );

      if (claim != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim created successfully')),
        );
        await context.read<ClaimProvider>().selectClaim(claim.id);
        Navigator.pop(context);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClaimDetailScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.newClaim),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Claim Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimens.paddingLarge),
              CustomTextField(
                label: AppStrings.patientName,
                hint: 'Enter patient name',
                controller: _patientNameController,
                validator: AppValidators.validatePatientName,
              ),
              const SizedBox(height: AppDimens.padding),
              CustomTextField(
                label: AppStrings.patientId,
                hint: 'Enter patient ID',
                controller: _patientIdController,
                validator: AppValidators.validatePatientId,
              ),
              const SizedBox(height: AppDimens.padding),
              CustomTextField(
                label: AppStrings.hospitalName,
                hint: 'Enter hospital name',
                controller: _hospitalNameController,
                validator: AppValidators.validateHospitalName,
              ),
              const SizedBox(height: AppDimens.padding),
              CustomTextField(
                label: AppStrings.admissionDate,
                hint: 'Select admission date',
                controller: _admissionDateController,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: _selectAdmissionDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Admission date is required';
                  }
                  return null;
                },
                readOnly: true,
              ),
              const SizedBox(height: AppDimens.padding),
              CustomTextField(
                label: AppStrings.dischargeDate,
                hint: 'Select discharge date (optional)',
                controller: _dischargeDateController,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: _selectDischargeDate,
                readOnly: true,
              ),
              const SizedBox(height: AppDimens.padding),
              CustomTextField(
                label: AppStrings.notes,
                hint: 'Add any notes...',
                controller: _notesController,
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: AppDimens.paddingXLarge),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: AppStrings.cancel,
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: AppDimens.padding),
                  Expanded(
                    child: CustomButton(
                      label: AppStrings.create,
                      onPressed: _submitForm,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
