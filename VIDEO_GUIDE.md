# Video Walkthrough Guide

## Recording Instructions for 2-3 Minute Demo

### Preparation (Before Recording)

1. **Clean the database** (start fresh):
   - Open browser developer tools
   - Go to Application → Local Storage
   - Clear all data OR just start the app fresh

2. **Setup recording software**:
   - Use OBS Studio, QuickTime, or built-in screen recording
   - Set resolution: 1920x1080 (Full HD)
   - Enable microphone for narration

3. **Open the application**:
   - Web: `flutter run -d chrome` or deployed URL
   - Mobile: Launch on emulator/device

### Video Script (2-3 Minutes)

---

#### **Intro (15 seconds)**
```
Hello! This is the Insurance Claim Management System - a complete solution 
for managing hospital insurance claims. Let me walk you through its features.
```

**Show**: Dashboard (empty state)

---

#### **Scene 1: Create a Claim (30 seconds)**
```
First, let's create a new claim. I'll tap the plus button...
```

**Actions**:
1. Tap floating action button (+)
2. Fill in the form:
   - Patient Name: "John Doe"
   - Patient ID: "PAT-2024-001"
   - Hospital Name: "City General Hospital"
   - Admission Date: Select today's date
   - Notes: "Routine checkup and surgery"
3. Tap "Create"

```
As you can see, the form validates all inputs. Once created, the claim 
starts in Draft status.
```

---

#### **Scene 2: Dashboard Overview (20 seconds)**
```
Back on the dashboard, we can see our new claim with real-time statistics 
at the top showing total claims, bills, settlements, and pending amounts.
```

**Show**:
- Dashboard with the new claim card
- Point out the statistics cards
- Hover over the search and filter options

---

#### **Scene 3: Add Bills (30 seconds)**
```
Let's open the claim and add some bills. I'll go to the Bills tab...
```

**Actions**:
1. Tap the claim card
2. Navigate to "Bills" tab
3. Tap "Add Bill"
4. Add first bill:
   - Description: "Consultation Fee"
   - Amount: 500
   - Save
5. Add second bill:
   - Description: "Surgery Charges"
   - Amount: 5000
   - Save

```
Notice how the total bills amount updates automatically. We can edit 
or delete any bill using the menu.
```

**Show**: Updated total at bottom

---

#### **Scene 4: Financial Management (25 seconds)**
```
Now let's manage the financials. I'll switch to the Financials tab...
```

**Actions**:
1. Navigate to "Financials" tab
2. Show financial summary cards
3. Add an advance:
   - Amount: 2000
   - Remarks: "Initial advance payment"
   - Save
4. Add a settlement:
   - Amount: 3000
   - Date: Today
   - Remarks: "Partial settlement"
   - Save

```
The system automatically calculates pending amounts. We can see 
we have $500 still pending after the advance and partial settlement.
```

---

#### **Scene 5: Status Workflow (25 seconds)**
```
Let's update the claim status. I'll go to the Overview tab...
```

**Actions**:
1. Navigate to "Overview" tab
2. Tap "Change" button next to status
3. Select "Submitted"
4. Show the status changed
5. Tap "Change" again
6. Select "Approved"

```
The system enforces a proper workflow. We can only transition to 
valid statuses. From Approved, we can move to Partially Settled or Settled.
```

**Actions**:
7. Change to "Partially Settled"

---

#### **Scene 6: Search and Filter (20 seconds)**
```
Back on the dashboard, let's create one more claim quickly...
```

**Actions**:
1. Create second claim (fast-forward or quick create):
   - Patient: "Jane Smith"
   - Hospital: "Metro Hospital"
   - Status: Leave as Draft
2. Show dashboard with 2 claims

```
Now we can use search to find specific claims, or filter by status. 
Let me filter by Partially Settled status...
```

**Actions**:
3. Tap "Partially Settled" filter chip
4. Show only one claim displayed
5. Clear filter / select "All"
6. Use search box: type "John"
7. Show filtered result

---

#### **Scene 7: Edit and Delete (15 seconds)**
```
We can also edit claims by tapping on them and updating any information, 
or delete them using the menu option.
```

**Actions**:
1. Tap menu on a claim card
2. Show delete option
3. Cancel (don't actually delete)

---

#### **Conclusion (10 seconds)**
```
That's the Insurance Claim Management System! It handles the complete 
claim lifecycle from creation to settlement, with automatic calculations, 
status workflows, and real-time analytics. Thank you for watching!
```

**Show**: Dashboard with all statistics

---

### Recording Tips

1. **Audio Quality**:
   - Use a good microphone
   - Record in a quiet environment
   - Speak clearly and at moderate pace
   - Add background music (optional, low volume)

2. **Visual Quality**:
   - Use Full HD resolution (1920x1080)
   - Ensure good lighting if recording mobile device
   - Keep cursor movements smooth
   - Highlight important UI elements

3. **Editing**:
   - Cut out any mistakes
   - Speed up repetitive actions (2x)
   - Add text annotations for key features
   - Include transitions between scenes
   - Add intro/outro cards (optional)

4. **Timing**:
   - Aim for 2:30 - 2:45 total length
   - Keep intro and outro brief
   - Spend most time on core features
   - Show, don't just tell

### What to Highlight

✅ **Must Show**:
- Creating a claim
- Adding bills with automatic totals
- Adding advances
- Adding settlements
- Pending amount calculation
- Status transitions
- Dashboard statistics
- Search functionality

✅ **Nice to Show**:
- Form validation
- Edit functionality
- Filter by status
- Responsive design
- Real-time updates

❌ **Can Skip**:
- Deep dive into each field
- Every single menu option
- Detailed error handling
- Code structure

### Platform Recommendations

**Recording Software**:
- **Mac**: QuickTime Player, OBS Studio, ScreenFlow
- **Windows**: OBS Studio, Camtasia, Windows Game Bar
- **Online**: Loom, Screen-o-Matic

**Video Editing**:
- **Free**: DaVinci Resolve, iMovie, Shotcut
- **Paid**: Adobe Premiere, Final Cut Pro, Camtasia

**Screen Recording Settings**:
- Resolution: 1920x1080 (Full HD)
- Frame Rate: 30 fps minimum
- Format: MP4 (H.264)
- Audio: AAC, 128 kbps minimum

### Upload Destinations

- YouTube (unlisted or public)
- Vimeo
- Google Drive (with sharing enabled)
- Loom
- Direct file sharing

### Checklist Before Recording

- [ ] App is running smoothly
- [ ] Database is clean (or has sample data as needed)
- [ ] Recording software is configured
- [ ] Microphone is working
- [ ] Script is ready
- [ ] Screen resolution is set correctly
- [ ] Notifications are disabled
- [ ] Browser bookmarks/extensions hidden (if recording web)

### Checklist After Recording

- [ ] Video is 2-3 minutes long
- [ ] Audio is clear and audible
- [ ] All key features are demonstrated
- [ ] No sensitive information visible
- [ ] Video quality is good (Full HD)
- [ ] Transitions are smooth
- [ ] Uploaded and accessible via link

---

**Good luck with your recording!**
