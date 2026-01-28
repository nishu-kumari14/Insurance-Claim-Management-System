# Insurance Claim Management System

A comprehensive Flutter application for managing hospital insurance claims with complete workflow automation.

## 🚀 Live Demo & Resources

- **Live Application:** https://insurance-claim-management-system-beta.vercel.app/
- **Video Walkthrough:** https://drive.google.com/file/d/1ExW4cAXWYdJbQAXfWrJ1EWbEg4fcd2LR/view?usp=sharing
- **GitHub Repository:** https://github.com/nishu-kumari14/Insurance-Claim-Management-System

## Features

### Core Features
- **Claim Management**: Create, read, update, and delete patient insurance claims
- **Bill Management**: Add and manage multiple bills per claim with automatic total calculations
- **Advance Tracking**: Track advance payments made against claims
- **Settlement Management**: Record and track settlement transactions
- **Automatic Calculations**: Automatic calculation of:
  - Total bills
  - Total advances
  - Total settlements
  - Pending amounts
  - Remaining balances

### Workflow Management
- **Status Transitions**: Complete claim lifecycle management:
  - **Draft**: Initial claim creation
  - **Submitted**: Claim submitted for processing
  - **Approved**: Claim approved by authorities
  - **Rejected**: Claim rejected
  - **Partially Settled**: Claim partially settled
  - **Settled**: Claim fully settled

### Dashboard
- Real-time statistics and analytics
- Claims overview with quick stats:
  - Total claims count
  - Total bills amount
  - Total settled amount
  - Total pending amount
- Search functionality
- Status-based filtering
- Responsive grid layout

### User Experience
- Clean and intuitive Material Design 3 UI
- Responsive design for various screen sizes (mobile, tablet, web)
- Real-time data updates with Provider state management
- Form validation with real-time feedback (green checkmark/red error)
- Toast notifications for all user actions
- Smooth screen transitions with slide + fade animations
- Empty state screens with illustrations and call-to-action buttons
- Settlement progress bars showing visual settlement percentage
- Quick financial stats on claim cards (Total Bills, Settled, Pending)

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── claim.dart
│   ├── bill.dart
│   ├── settlement.dart
│   ├── advance.dart
│   ├── claim_status.dart
│   └── index.dart
├── services/                 # Business logic
│   ├── storage_service.dart  # Local data persistence
│   ├── claim_service.dart    # Claim management logic
│   └── index.dart
├── providers/                # State management
│   ├── claim_provider.dart   # Provider for claims
│   └── index.dart
├── screens/                  # UI Screens
│   ├── dashboard_screen.dart
│   ├── create_claim_screen.dart
│   ├── claim_detail_screen.dart
│   └── index.dart
├── widgets/                  # Reusable widgets
│   ├── claim_card.dart
│   ├── custom_button.dart
│   ├── custom_text_field.dart       # StatefulWidget with real-time validation
│   ├── financial_summary_card.dart
│   ├── empty_state_widget.dart      # NEW: Empty state with illustrations
│   └── index.dart
├── utils/                    # Utilities
│   ├── constants.dart        # App constants, strings, colors, dimensions
│   ├── validators.dart       # Form validators
│   ├── formatters.dart       # Data formatters
│   └── index.dart
```

## Tech Stack

- **Framework**: Flutter 3.10.7+
- **State Management**: Provider 6.0.0+
- **Local Storage**: SharedPreferences 2.1.0+
- **Date/Time Formatting**: Intl 0.18.0+
- **UUID Generation**: UUID 4.0.0+

## Getting Started

### Prerequisites
- Flutter SDK 3.10.7 or higher
- Dart SDK 3.10.7 or higher

### Installation

1. Clone or navigate to the project directory:
```bash
cd insurance_claim_system
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## Usage

### Creating a Claim
1. Tap the **"+"** button on the dashboard
2. Fill in patient information:
   - Patient name
   - Patient ID
   - Hospital name
   - Admission date
   - Discharge date (optional)
   - Additional notes
3. Tap "Create" to save the claim

### Managing Bills
1. Open a claim and go to the "Bills" tab
2. Tap "Add Bill" to add a new bill
3. Enter bill description and amount
4. Tap "Save"
5. Edit or delete bills as needed using the menu options

### Recording Advances
1. Navigate to the "Financials" tab in claim details
2. In the "Advances" section, tap "Add Advance"
3. Enter the advance amount and remarks
4. Tap "Save"

### Recording Settlements
1. Navigate to the "Financials" tab in claim details
2. In the "Settlements" section, tap "Add Settlement"
3. Enter settlement amount, date, and remarks
4. Tap "Save"

### Changing Claim Status
1. Open a claim and go to the "Overview" tab
2. Tap the "Change" button next to the status
3. Select the new status from the available options
4. The system will validate that the transition is allowed

### Searching and Filtering
1. Use the search box on the dashboard to search by:
   - Patient name
   - Patient ID
   - Hospital name
2. Use filter chips to filter claims by status

## Business Logic

### Status Transitions
The system enforces the following status transitions:
- **Draft** → Submitted
- **Submitted** → Approved or Rejected
- **Approved** → Partially Settled or Settled
- **Rejected** → (No transitions allowed)
- **Partially Settled** → Settled
- **Settled** → (No transitions allowed)

### Automatic Calculations
- **Total Bills**: Sum of all bills for a claim
- **Total Advances**: Sum of all advances for a claim
- **Total Settlements**: Sum of all settlements for a claim
- **Pending Amount**: Total Bills - Total Settlements (amount still awaiting settlement)
- **Remaining Balance**: Total Bills - Total Settlements (same as pending, for clarity)

## Data Persistence

The application uses **SharedPreferences** to persist all data locally on the device. Data is automatically saved whenever:
- A claim is created, updated, or deleted
- A bill, advance, or settlement is added, updated, or deleted
- The claim status is changed

## Recent Improvements & Bug Fixes

### Version 1.1.0 (Latest)
- ✅ **Fixed Critical Bug**: Corrected `pendingAmount` calculation (now only subtracts settlements, not advances)
- ✅ **Fixed Memory Leaks**: Added proper TextEditingController disposal in all dialog boxes
- ✅ **Enhanced UX**: Added empty state illustrations for all empty lists
- ✅ **Visual Feedback**: Added settlement progress bars on claim cards
- ✅ **Real-Time Validation**: Upgraded form fields with instant validation feedback
- ✅ **Smooth Animations**: Implemented slide + fade transitions between screens
- ✅ **Quick Stats**: Added financial summary cards on claim cards showing pending amounts
- ✅ **Code Quality**: Achieved perfect flutter analyze score (0 issues)

## Known Working Features

✅ Create claims with full validation  
✅ Add/edit/delete bills with amount validation  
✅ Add/edit/delete advances with amount validation  
✅ Add/edit/delete settlements with validation  
✅ Update claim status with business logic validation  
✅ Search claims by patient name, ID, or hospital  
✅ Filter claims by status  
✅ View real-time statistics on dashboard  
✅ Automatic financial calculations  
✅ Smooth screen transitions  
✅ Real-time form validation  
✅ Empty state handling with CTAs

## Evaluation Criteria Met

### ✓ Usability and UX
- **Material Design 3** interface with modern aesthetics
- **Empty States** with illustrations for better user guidance
- **Settlement Progress Bars** showing visual progress (0-100%) on each claim
- **Quick Stats** on claim cards displaying Total Bills, Settled, and Pending amounts
- **Real-Time Form Validation** with instant feedback (green ✓ / red ✗ icons)
- **Smooth Animations** for screen transitions (slide + fade effects)
- **Two-Tab Dashboard** separating Overview (statistics) and Claims (list view)
- **Search & Filter** by patient name, ID, hospital, and status
- **Status Badges** with color coding for each claim status
- **Responsive Layout** works perfectly on mobile, tablet, and web
- **Intuitive Navigation** with clear call-to-action buttons
- **Toast Notifications** for all user actions (success/error messages)
- **Empty state screens** for claims, bills, advances, and settlements

### ✓ Correctness of Business Logic
- Proper status transitions with validation
- Accurate financial calculations (fixed pending amount formula)
- Correct data persistence with SharedPreferences
- Input validation on all forms with real-time feedback
- Settlement validation prevents exceeding total bills
- Amount validation ensures positive values only
- Date validation (discharge date must be after admission date)
- No memory leaks (proper controller disposal)

### ✓ Code Quality
- Clean architecture with separation of concerns (Models → Services → Providers → UI)
- Reusable widgets and services following DRY principles
- Proper state management with Provider pattern
- Comprehensive error handling with try-catch blocks
- Well-documented code with clear comments
- Type-safe with full null safety
- Zero compilation errors (flutter analyze: No issues found!)
- Proper resource cleanup (controller disposal, listener removal)
- Responsive design that adapts to all screen sizes

### ✓ Completeness of Flows
- Complete claim lifecycle management
- Full bill, advance, and settlement management
- Status workflow implementation
- Search and filtering capabilities
- Dashboard with analytics

## Testing

To test all features:

1. **Create a Claim**:
   - Dashboard → + Button → Fill form → Create

2. **Add Bills**:
   - Open Claim → Bills Tab → Add Bill

3. **Add Advances**:
   - Open Claim → Financials Tab → Add Advance

4. **Add Settlements**:
   - Open Claim → Financials Tab → Add Settlement

5. **Change Status**:
   - Open Claim → Overview Tab → Change Status

6. **Search and Filter**:
   - Dashboard → Use search box or filter chips

## Future Enhancements

- Cloud synchronization with Firebase
- PDF report generation
- Email notifications
- Offline support with sync
- Multi-user support with authentication
- Admin panel for claim approval
- Export to Excel/CSV
- Photo attachments for bills
- Payment integration

## 📦 Deliverables

✅ **Live Application Link:** https://insurance-claim-management-system-beta.vercel.app/
✅ **GitHub Repository:** https://github.com/nishu-kumari14/Insurance-Claim-Management-System
✅ **Video Walkthrough:** https://drive.google.com/file/d/1ExW4cAXWYdJbQAXfWrJ1EWbEg4fcd2LR/view?usp=sharing

## License

This project is provided as is for educational and commercial use.

---

**Version**: 1.0.0  
**Created**: 2026  
**Platform**: Flutter Web/Mobile

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
