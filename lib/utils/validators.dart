class AppValidators {
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  static String? validatePatientId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Patient ID is required';
    }
    if (value.length < 3) {
      return 'Patient ID must be at least 3 characters';
    }
    return null;
  }

  static String? validatePatientName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Patient name is required';
    }
    if (value.length < 2) {
      return 'Patient name must be at least 2 characters';
    }
    return null;
  }

  static String? validateHospitalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital name is required';
    }
    if (value.length < 2) {
      return 'Hospital name must be at least 2 characters';
    }
    return null;
  }
}
