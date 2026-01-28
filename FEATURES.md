# Features Documentation

## Complete Feature List

### 1. Dashboard
The dashboard is the central hub of the application providing:

#### Statistics Overview
- **Total Claims**: Real-time count of all claims
- **Total Bills Amount**: Sum of all bill amounts across all claims
- **Total Settled Amount**: Total amount settled across all claims
- **Total Pending Amount**: Outstanding amount pending across all claims

#### Search Functionality
- Search claims by:
  - Patient name
  - Patient ID
  - Hospital name
- Real-time search with instant results
- Case-insensitive search

#### Filter System
- Filter by claim status:
  - All claims
  - Draft
  - Submitted
  - Approved
  - Rejected
  - Partially Settled
  - Settled
- Visual filter chips for easy status selection
- Combine search with filters

#### Claims List
- Card-based layout for each claim
- Shows key information:
  - Patient name
  - Patient ID
  - Hospital name
  - Claim status (color-coded)
  - Total bills amount
  - Pending amount
- Quick actions menu on each card
- Tap to view full details

---

### 2. Claim Management

#### Create New Claim
Navigate to create claim by tapping the floating action button (+)

**Required Information:**
- Patient Name (min 2 characters)
- Patient ID (min 3 characters)
- Hospital Name (min 2 characters)
- Admission Date (must select from calendar)

**Optional Information:**
- Discharge Date
- Notes/Remarks

**Validation:**
- All required fields must be filled
- Patient name and hospital name must be at least 2 characters
- Patient ID must be at least 3 characters
- Admission date must be selected

**Initial Status:**
- All new claims start in "Draft" status

#### View Claim Details
Opens detailed view with three tabs:
1. Overview Tab
2. Bills Tab
3. Financials Tab

#### Edit Claim
- Update patient information
- Modify hospital details
- Change dates
- Update notes

#### Delete Claim
- Accessible from dashboard
- Confirmation dialog before deletion
- Permanently removes claim and all associated data

---

### 3. Bill Management

#### Add Bill
- Description (required)
- Amount (required, must be > 0)
- Automatically timestamped
- Linked to claim

#### Edit Bill
- Update description
- Modify amount
- Maintains creation timestamp
- Adds modification timestamp

#### Delete Bill
- Accessible from bill list
- Confirmation required
- Updates claim totals automatically

#### Bill List View
- Shows all bills for a claim
- Displays:
  - Bill description
  - Amount (formatted as currency)
  - Creation date
  - Edit/Delete actions

#### Automatic Calculations
- **Total Bills**: Automatically calculated and displayed
- Updates in real-time when bills are added/edited/deleted
- Shown in claim details and dashboard

---

### 4. Advance Management

#### Add Advance
- Amount (required, must be > 0)
- Remarks (required)
- Automatically timestamped
- Linked to claim

#### Edit Advance
- Update amount
- Modify remarks
- Maintains creation timestamp

#### Delete Advance
- Accessible from advance list
- Confirmation required
- Updates pending amount automatically

#### Advance List View
- Shows all advances for a claim
- Displays:
  - Advance amount (formatted as currency)
  - Remarks
  - Creation date
  - Edit/Delete actions

#### Automatic Calculations
- **Total Advances**: Automatically calculated
- Affects pending amount calculation
- Updates in real-time

---

### 5. Settlement Management

#### Add Settlement
- Amount (required, must be > 0)
- Settlement Date (required, select from calendar)
- Remarks (required)
- Linked to claim

#### Edit Settlement
- Update amount
- Change settlement date
- Modify remarks

#### Delete Settlement
- Accessible from settlement list
- Confirmation required
- Updates financial calculations

#### Settlement List View
- Shows all settlements for a claim
- Displays:
  - Settlement amount (formatted as currency)
  - Settlement date
  - Remarks
  - Edit/Delete actions

#### Automatic Calculations
- **Total Settlements**: Automatically calculated
- Affects pending amount and remaining balance
- Updates in real-time

---

### 6. Status Workflow

#### Draft Status
- Initial status for new claims
- Can be edited freely
- **Allowed Transitions**: → Submitted

#### Submitted Status
- Claim submitted for processing
- **Allowed Transitions**: → Approved, Rejected

#### Approved Status
- Claim approved by authorities
- **Allowed Transitions**: → Partially Settled, Settled

#### Rejected Status
- Claim rejected
- **Allowed Transitions**: None (terminal state)

#### Partially Settled Status
- Claim partially settled
- **Allowed Transitions**: → Settled

#### Settled Status
- Claim fully settled
- **Allowed Transitions**: None (terminal state)

#### Status Transition
- Tap "Change" button in Overview tab
- System validates allowed transitions
- Only shows valid next statuses
- Prevents invalid transitions
- Updates claim immediately

---

### 7. Financial Calculations

#### Total Bills
- Sum of all bill amounts for a claim
- Formula: `Σ(bill.amount)`
- Displayed in:
  - Bills tab
  - Financials tab
  - Dashboard summary

#### Total Advances
- Sum of all advance amounts for a claim
- Formula: `Σ(advance.amount)`
- Displayed in Financials tab

#### Total Settlements
- Sum of all settlement amounts for a claim
- Formula: `Σ(settlement.amount)`
- Displayed in Financials tab

#### Pending Amount
- Amount still pending after advances and settlements
- Formula: `max(0, Total Bills - Total Advances - Total Settlements)`
- Never negative (floor at 0)
- Color-coded:
  - Warning (yellow) if pending > 0
  - Success (green) if pending = 0

#### Remaining Balance
- Balance after settlements (excluding advances)
- Formula: `Total Bills - Total Settlements`
- Displayed in Financials tab

---

### 8. Data Persistence

#### Local Storage
- Uses SharedPreferences for web/mobile
- All data stored locally on device
- JSON serialization for complex objects
- Automatic save on:
  - Claim creation/update/delete
  - Bill add/edit/delete
  - Advance add/edit/delete
  - Settlement add/edit/delete
  - Status change

#### Data Structure
```json
{
  "id": "uuid",
  "patientName": "string",
  "patientId": "string",
  "hospitalName": "string",
  "admissionDate": "ISO8601",
  "dischargeDate": "ISO8601?",
  "status": "enum",
  "bills": [...],
  "advances": [...],
  "settlements": [...],
  "dateCreated": "ISO8601",
  "dateModified": "ISO8601?",
  "notes": "string"
}
```

---

### 9. User Interface

#### Material Design
- Follows Material Design 3 guidelines
- Consistent color scheme
- Proper elevation and shadows
- Responsive layouts

#### Color Coding
- **Draft**: Grey (#9E9E9E)
- **Submitted**: Blue (#2196F3)
- **Approved**: Green (#4CAF50)
- **Rejected**: Red (#F44336)
- **Partially Settled**: Yellow/Amber (#FFC107)
- **Settled**: Light Green (#8BC34A)

#### Responsive Design
- Works on mobile, tablet, and desktop
- Adaptive layouts
- Grid layouts adjust to screen size
- Touch-friendly tap targets

#### Navigation
- Bottom navigation or side drawer (based on screen size)
- Back button support
- Breadcrumb navigation
- Deep linking support

---

### 10. Form Validation

#### Patient Name
- Required
- Minimum 2 characters
- No special characters restriction

#### Patient ID
- Required
- Minimum 3 characters
- Unique identifier per patient

#### Hospital Name
- Required
- Minimum 2 characters

#### Amounts (Bills, Advances, Settlements)
- Required
- Must be numeric
- Must be greater than 0
- Validated on input

#### Dates
- Must be selected from calendar picker
- Admission date: up to current date
- Discharge date: after admission date
- Settlement date: flexible range

---

### 11. User Feedback

#### Toast Notifications
- Success messages for:
  - Claim created
  - Bill/Advance/Settlement added
  - Status updated
  - Item deleted
- Error messages for:
  - Validation failures
  - Invalid transitions
  - Delete confirmations

#### Loading States
- Loading indicators during:
  - Data fetch
  - Save operations
  - Delete operations
- Prevents duplicate submissions

#### Confirmation Dialogs
- Confirm before:
  - Deleting claims
  - Deleting bills/advances/settlements
- Clear action buttons
- Cancel option always available

---

### 12. Search and Filter

#### Search Capabilities
- Real-time search
- Searches across:
  - Patient name
  - Patient ID
  - Hospital name
- Case-insensitive
- Partial matching
- Instant results

#### Filter Options
- Filter by status
- Combine with search
- Visual chips
- Clear active filters
- "All" option to reset

---

## Technical Features

### State Management
- Provider pattern
- Reactive updates
- Efficient re-renders
- Memory management

### Code Organization
- Clean architecture
- Separation of concerns
- Modular components
- Reusable widgets

### Performance
- Lazy loading
- Efficient list rendering
- Optimized rebuilds
- Tree-shaking for web

### Accessibility
- Semantic labels
- Screen reader support
- Keyboard navigation
- High contrast support

---

## Future Enhancements

### Planned Features
- [ ] Cloud sync with Firebase
- [ ] PDF report generation
- [ ] Export to Excel/CSV
- [ ] Email notifications
- [ ] Multi-user support
- [ ] Role-based access control
- [ ] Approval workflows
- [ ] Document attachments
- [ ] Payment gateway integration
- [ ] Analytics dashboard
- [ ] Audit trail
- [ ] Advanced reporting

---

**Last Updated**: January 2026
