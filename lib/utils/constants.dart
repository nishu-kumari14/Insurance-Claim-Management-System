import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFFFF4081);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color outline = Color(0xFFBDBDBD);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);
  static const Color text = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Status colors
  static const Color draftColor = Color(0xFF9E9E9E);
  static const Color submittedColor = Color(0xFF2196F3);
  static const Color approvedColor = Color(0xFF4CAF50);
  static const Color rejectedColor = Color(0xFFF44336);
  static const Color partiallySettledColor = Color(0xFFFFC107);
  static const Color settledColor = Color(0xFF8BC34A);
}

class AppDimens {
  static const double paddingXXSmall = 4.0;
  static const double paddingXSmall = 8.0;
  static const double paddingSmall = 12.0;
  static const double padding = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  static const double iconSizeSmall = 18.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;

  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
}

class AppStrings {
  // App
  static const String appTitle = 'Insurance Claim Management';
  static const String appSubtitle = 'Hospital Claim System';

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String newClaim = 'New Claim';
  static const String claimDetails = 'Claim Details';

  // Claim
  static const String claim = 'Claim';
  static const String claims = 'Claims';
  static const String patientName = 'Patient Name';
  static const String patientId = 'Patient ID';
  static const String hospitalName = 'Hospital Name';
  static const String admissionDate = 'Admission Date';
  static const String dischargeDate = 'Discharge Date';
  static const String status = 'Status';
  static const String notes = 'Notes';

  // Bills
  static const String bill = 'Bill';
  static const String bills = 'Bills';
  static const String billDescription = 'Bill Description';
  static const String billAmount = 'Amount';
  static const String addBill = 'Add Bill';
  static const String editBill = 'Edit Bill';
  static const String deleteBill = 'Delete Bill';
  static const String totalBills = 'Total Bills';

  // Advances
  static const String advance = 'Advance';
  static const String advances = 'Advances';
  static const String addAdvance = 'Add Advance';
  static const String editAdvance = 'Edit Advance';
  static const String deleteAdvance = 'Delete Advance';
  static const String totalAdvances = 'Total Advances';
  static const String advanceAmount = 'Advance Amount';
  static const String advanceRemarks = 'Remarks';

  // Settlements
  static const String settlement = 'Settlement';
  static const String settlements = 'Settlements';
  static const String addSettlement = 'Add Settlement';
  static const String editSettlement = 'Edit Settlement';
  static const String deleteSettlement = 'Delete Settlement';
  static const String totalSettlements = 'Total Settlements';
  static const String settlementAmount = 'Settlement Amount';
  static const String settlementDate = 'Settlement Date';
  static const String settlementRemarks = 'Settlement Remarks';

  // Financial
  static const String totalAmount = 'Total Amount';
  static const String pendingAmount = 'Pending Amount';
  static const String remainingBalance = 'Remaining Balance';
  static const String amount = 'Amount';

  // Actions
  static const String create = 'Create';
  static const String save = 'Save';
  static const String update = 'Update';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String edit = 'Edit';
  static const String submit = 'Submit';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  static const String back = 'Back';
  static const String add = 'Add';
  static const String remove = 'Remove';

  // Messages
  static const String claimCreatedSuccess = 'Claim created successfully';
  static const String claimUpdatedSuccess = 'Claim updated successfully';
  static const String claimDeletedSuccess = 'Claim deleted successfully';
  static const String operationSuccess = 'Operation successful';
  static const String operationFailed = 'Operation failed';
  static const String fillAllFields = 'Please fill all required fields';
  static const String confirmDelete = 'Are you sure you want to delete this?';
  static const String noClaimsFound = 'No claims found';
  static const String errorLoadingData = 'Error loading data';
  static const String invalidAmount = 'Please enter a valid amount';

  // Validation
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Invalid email format';
  static const String invalidPhoneNumber = 'Invalid phone number';
}
