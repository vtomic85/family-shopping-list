# Changelog

All notable changes to the Family Shopping List project.

## [Unreleased] - 2026-01-14

### Added

#### 📚 Documentation
- **README.md**: Comprehensive project documentation including:
  - Feature overview with badges
  - Installation and setup instructions
  - Architecture explanation
  - Tech stack details
  - Firestore data structure
  - Contributing guidelines
  
- **ICON_SETUP.md**: Complete guide for setting up custom app icons and splash screens
  - Design specifications and color references
  - Step-by-step instructions for flutter_launcher_icons
  - Step-by-step instructions for flutter_native_splash
  - Manual setup alternatives
  - Testing procedures

#### 🎨 UI/UX Improvements

- **Enhanced Shopping Items**:
  - Added `quantity` field (replaces numeric `amount` with flexible string like "2 liters", "500g")
  - Added `notes` field for additional item details
  - Updated item tile to display notes with icon when present
  - Better visual hierarchy with quantity badge

- **Loading States**:
  - Created `LoadingSkeleton` widget with animated shimmer effect
  - Replaced circular progress indicators with skeleton screens
  - Improved perceived performance during data loading

- **Pull-to-Refresh**:
  - Added `RefreshIndicator` to home screen
  - Provides user feedback with snackbar notification
  - Works seamlessly with real-time Firestore updates

- **Animations**:
  - Added smooth transitions for item status changes
  - Animated container for status indicator
  - Fade animation for loading skeleton
  - Status selector with animated selection feedback

- **User Feedback**:
  - Toast notifications for all user actions:
    - Item added/updated/deleted
    - Status changed
    - Member added/removed
  - Improved error messages with better context
  - Snackbars with rounded corners and floating behavior
  - Consistent 2-second duration for success messages

#### 🔧 Technical Improvements

- **Data Model Updates**:
  - Migrated from `description`/`amount` to `name`/`quantity`/`notes`
  - Backward compatibility for legacy data (supports old field names)
  - Updated `ShoppingItem` model with new fields
  - Updated `copyWith`, `toFirestore`, `fromFirestore` methods

- **Service Layer**:
  - Updated `FirestoreService.addItem()` with new parameters
  - Updated `FirestoreService.updateItem()` with new parameters
  - Maintained backward compatibility in Firestore queries

- **Provider Layer**:
  - Updated `ShoppingListProvider.addItem()` signature
  - Updated `ShoppingListProvider.updateItem()` signature
  - Enhanced validation messages

- **Widget Updates**:
  - Refactored `AddItemDialog` with three input fields
  - Refactored `EditItemDialog` with three input fields
  - Enhanced `ShoppingItemTile` to display all item information
  - Added `SingleChildScrollView` to dialogs for keyboard handling

#### 📦 Dependencies

- **Development Dependencies**:
  - `flutter_launcher_icons: ^0.13.1` - For generating app icons
  - `flutter_native_splash: ^2.3.5` - For generating splash screens

- **Configuration**:
  - Added `assets/icon/` to asset paths
  - Added flutter_launcher_icons configuration (ready for custom icons)
  - Added flutter_native_splash configuration with brand colors

### Changed

- **Field Naming**:
  - `description` → `name` (clearer intent)
  - `amount` (int) → `quantity` (string) (more flexible)
  - Added `notes` field (optional)

- **UI Components**:
  - Dialog forms now use `SingleChildScrollView` for better keyboard handling
  - Item tiles show more information in a compact layout
  - Status changes now show immediate feedback via snackbar

- **Loading Experience**:
  - Skeleton screens instead of spinners
  - More engaging and modern loading states

### Fixed

- Keyboard overlap issues in dialogs (added `SingleChildScrollView`)
- Improved form validation messages
- Better error handling throughout the app

### Migration Notes

**Backward Compatibility**: The app supports both old and new field names in Firestore:
- Old `description` field maps to new `name` field
- Old `amount` field maps to new `quantity` field (converted to string)
- Missing `notes` field defaults to empty string

**No Data Migration Required**: Existing Firestore data will work seamlessly with the new version.

## [1.0.0] - Initial Release

### Features

- Google Sign-In authentication
- Family group management
- Real-time shopping list synchronization
- Three item statuses: Pending, Bought, Not Available
- Swipe actions for quick edits and deletion
- Member management (add/remove by email)
- Beautiful Material Design 3 UI
- Dark mode support
- Firestore security rules
- Environment variable configuration

---

## Future Enhancements

Potential features for future releases:

- [ ] Search and filter functionality
- [ ] Item categories/tags
- [ ] Shopping history
- [ ] Frequently bought items
- [ ] Multiple shopping lists per family
- [ ] Item priority levels
- [ ] Shopping list templates
- [ ] Export/import functionality
- [ ] Offline mode improvements
- [ ] Custom fonts (Outfit family)
