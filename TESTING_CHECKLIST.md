# Testing Checklist

Use this checklist to test all the new features and improvements.

## ✅ Pre-Testing Setup

- [ ] App builds successfully
- [ ] App launches without errors
- [ ] Firebase connection is working
- [ ] Google Sign-In is configured

## 🔐 Authentication

- [ ] Sign in with Google account
- [ ] User profile photo appears in app bar
- [ ] User name and email shown in profile menu
- [ ] Sign out works correctly

## 📝 New Item Features (Quantity & Notes)

### Adding Items

- [ ] Tap the "Add Item" floating action button
- [ ] Dialog opens with three fields: Name, Quantity, Notes
- [ ] **Test Name field**:
  - [ ] Enter item name (e.g., "Milk")
  - [ ] Try submitting empty name (should show error)
- [ ] **Test Quantity field**:
  - [ ] Enter flexible quantity (e.g., "2 liters", "500g", "1 pack")
  - [ ] Try submitting empty quantity (should show error)
- [ ] **Test Notes field**:
  - [ ] Add optional notes (e.g., "Low fat, organic")
  - [ ] Leave notes empty (should work fine)
- [ ] Submit the form
- [ ] **Verify toast notification** appears: "Added [item name]"

### Viewing Items

- [ ] Item appears in the "To Buy" section
- [ ] Item name is displayed prominently
- [ ] **Quantity badge** shows with shopping basket icon
- [ ] **Status chip** shows "Pending" in orange
- [ ] **Notes appear** below with note icon (if added)
- [ ] All text is readable and properly formatted

### Editing Items

- [ ] Swipe item to the left
- [ ] Tap "Edit" button (blue)
- [ ] Dialog opens with all three fields pre-filled
- [ ] Modify name, quantity, and/or notes
- [ ] Change status using the status selector
- [ ] Save changes
- [ ] **Verify toast notification**: "Item updated successfully"
- [ ] Changes are reflected in the list

## 🎨 Loading States & Animations

### Loading Skeleton

- [ ] Sign out and sign back in
- [ ] **Observe loading skeleton** while data loads:
  - [ ] Animated shimmer effect (fading in/out)
  - [ ] Skeleton shows stats header placeholder
  - [ ] Skeleton shows section header placeholder
  - [ ] Skeleton shows 3 item placeholders
  - [ ] No spinning circle (old loading indicator)

### Pull-to-Refresh

- [ ] On the home screen, pull down from the top
- [ ] **Verify refresh indicator** appears
- [ ] Release to refresh
- [ ] **Verify toast notification**: "List refreshed"
- [ ] List updates (if any changes were made)

### Item Animations

- [ ] Tap an item to cycle its status
- [ ] **Observe smooth animation** on status indicator circle
- [ ] **Verify toast notification** shows new status
- [ ] Status changes: Pending → Bought → Not Available → Pending
- [ ] Color changes smoothly (orange → green → red → orange)

## 🎯 Status Management

### Pending Items

- [ ] Items show orange color
- [ ] Clock icon in status indicator
- [ ] "Pending" chip displayed
- [ ] Items appear in "To Buy" section

### Bought Items

- [ ] Tap item to mark as bought
- [ ] Item moves to "Bought" section
- [ ] Green color applied
- [ ] Checkmark icon in status indicator
- [ ] Item name has strikethrough
- [ ] "Bought" chip displayed

### Not Available Items

- [ ] Tap bought item to mark as not available
- [ ] Item moves to "Not Available" section
- [ ] Red color applied
- [ ] Cancel icon in status indicator
- [ ] "Not Available" chip displayed

## 📊 Statistics Header

- [ ] Stats card shows at top of list
- [ ] **Total** count is correct
- [ ] **Pending** count is correct (orange)
- [ ] **Bought** count is correct (green)
- [ ] Counts update when items change status

## 🗑️ Deleting Items

- [ ] Swipe item to the left
- [ ] Tap "Delete" button (red)
- [ ] Confirmation dialog appears
- [ ] Confirm deletion
- [ ] **Verify toast notification**: "Deleted [item name]"
- [ ] Item removed from list
- [ ] Statistics update correctly

## 👥 Family Members

- [ ] Tap the group icon in app bar
- [ ] Members screen opens
- [ ] Add a family member by email
- [ ] **Verify toast notification** (should appear)
- [ ] Member appears in the list
- [ ] Remove a member
- [ ] **Verify toast notification** (should appear)

## 🎨 UI/UX Polish

### Snackbar Notifications

- [ ] All snackbars have rounded corners
- [ ] All snackbars float above content
- [ ] Success messages show for ~2 seconds
- [ ] Error messages show for ~3 seconds
- [ ] Snackbars are readable in both light and dark mode

### Dark Mode

- [ ] Switch device to dark mode
- [ ] App theme changes automatically
- [ ] All colors are appropriate for dark mode
- [ ] Loading skeleton works in dark mode
- [ ] Item tiles are readable
- [ ] Dialogs look good

### Keyboard Handling

- [ ] Open Add Item dialog
- [ ] Tap in a field to show keyboard
- [ ] **Verify dialog scrolls** to keep focused field visible
- [ ] All fields remain accessible
- [ ] No content is hidden behind keyboard

## 🔄 Real-time Sync

- [ ] Open app on a second device (or web browser)
- [ ] Add an item on device 1
- [ ] **Verify it appears** on device 2 instantly
- [ ] Change status on device 2
- [ ] **Verify it updates** on device 1 instantly
- [ ] Delete item on device 1
- [ ] **Verify it disappears** on device 2 instantly

## 📱 Edge Cases

### Empty States

- [ ] Delete all items
- [ ] **Verify empty state** appears:
  - [ ] Shopping cart icon
  - [ ] "Your shopping list is empty" message
  - [ ] Helpful hint about adding items

### Error States

- [ ] Turn off WiFi/data
- [ ] Try to add an item
- [ ] **Verify error message** appears in snackbar
- [ ] Error message is descriptive
- [ ] Turn WiFi/data back on
- [ ] Try again (should work)

### Long Content

- [ ] Add item with very long name
- [ ] **Verify text truncates** with ellipsis
- [ ] Add item with very long notes
- [ ] **Verify notes truncate** with ellipsis
- [ ] Tap to edit and see full content

### Multiple Items

- [ ] Add 10+ items
- [ ] **Verify scrolling** works smoothly
- [ ] Pull-to-refresh works
- [ ] All items are accessible
- [ ] Performance is good

## 🎯 Form Validation

### Add Item Dialog

- [ ] Try to submit with empty name → Error shown
- [ ] Try to submit with empty quantity → Error shown
- [ ] Submit with empty notes → Should work (optional field)
- [ ] Error messages are clear and helpful

### Edit Item Dialog

- [ ] Clear the name field → Error on submit
- [ ] Clear the quantity field → Error on submit
- [ ] Clear the notes field → Should work (optional field)

## 🚀 Performance

- [ ] App launches quickly
- [ ] Loading skeleton appears immediately
- [ ] No lag when scrolling
- [ ] Animations are smooth (60fps)
- [ ] Status changes are instant
- [ ] No memory leaks (test by using app for 5+ minutes)

## 📋 Final Checks

- [ ] No console errors in terminal
- [ ] No red error screens
- [ ] All features work as expected
- [ ] App is stable (no crashes)
- [ ] User experience feels polished

---

## 🐛 Bug Report Template

If you find any issues, note them here:

**Issue**: [Describe the problem]
**Steps to Reproduce**:
1. 
2. 
3. 

**Expected**: [What should happen]
**Actual**: [What actually happened]
**Device**: [Emulator/Physical device, Android version]

---

## ✅ Testing Complete

Once all items are checked, the app is ready for production use! 🎉

**Tested by**: _______________
**Date**: _______________
**Result**: ☐ Pass  ☐ Fail (see bugs above)
