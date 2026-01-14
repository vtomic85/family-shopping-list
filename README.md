# 🛒 Family Shopping List

A beautiful, real-time collaborative shopping list app built with Flutter and Firebase. Perfect for families who want to stay synchronized while shopping together or separately.

![Flutter](https://img.shields.io/badge/Flutter-3.2.0+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🔐 Secure Authentication
- **Google Sign-In** for quick and secure access
- No passwords to remember, just use your Google account

### 👨‍👩‍👧‍👦 Family Groups
- Create or join a family shopping group
- Add family members by email
- Owner-based permission system
- All members share the same shopping list in real-time

### 📝 Smart Shopping Lists
- **Add items** with name, quantity, and optional notes
- **Three status types**: Pending, Bought, Not Available
- **Real-time synchronization** across all family members' devices
- **Visual statistics** showing total, pending, and bought items
- **Organized sections** grouped by item status
- **Swipe actions** for quick status updates and deletion

### 🎨 Beautiful Design
- Modern Material Design 3 UI
- Warm terracotta and sage color theme
- Dark mode support (follows system preference)
- Smooth animations and transitions
- Loading skeletons for better perceived performance

### 🔄 Real-time Sync
- Instant updates when any family member makes changes
- No manual refresh needed
- Works seamlessly across multiple devices

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.2.0 or later
- Firebase account
- Android Studio (for Android development)
- A Google account for authentication

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/vtomic85/family-shopping-list.git
   cd family-shopping-list
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   
   Follow the detailed instructions in [SETUP.md](SETUP.md) to:
   - Create a Firebase project
   - Enable Google Sign-In authentication
   - Set up Cloud Firestore
   - Configure Android app
   - Deploy security rules

4. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your Firebase configuration values.

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Home Screen
- View all shopping items organized by status
- See statistics at a glance
- Quick access to add new items

### Members Management
- Add family members by email
- View all group members
- Remove members (owner only)

### Item Management
- Add items with quantity and notes
- Edit existing items
- Swipe to change status or delete
- Visual indicators for each status

## 🏗️ Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                    # App entry point with providers
├── app.dart                     # MaterialApp configuration
├── models/                      # Data models
│   ├── family_group.dart
│   └── shopping_item.dart
├── services/                    # Business logic
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/                   # State management (Provider pattern)
│   ├── auth_provider.dart
│   ├── family_group_provider.dart
│   └── shopping_list_provider.dart
├── screens/                     # UI screens
│   ├── auth/
│   ├── home/
│   └── settings/
├── widgets/                     # Reusable widgets
└── theme/                       # App theming
    └── app_theme.dart
```

## 🔒 Security

- Comprehensive Firestore security rules ensure data privacy
- Only family group owners and members can access their shopping list
- Email-based member verification
- Secure Google authentication

## 🛠️ Tech Stack

- **Framework**: Flutter 3.2.0+
- **Language**: Dart
- **Backend**: Firebase
  - Authentication (Google Sign-In)
  - Cloud Firestore (Database)
- **State Management**: Provider
- **UI Components**: 
  - Material Design 3
  - flutter_slidable for swipe actions
- **Environment**: flutter_dotenv for configuration

## 📋 Firestore Data Structure

### Family Groups Collection
```
familyGroups/{groupId}
├── ownerUid: string
├── ownerEmail: string
├── memberEmails: string[]
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Shopping Items Collection
```
shoppingItems/{itemId}
├── name: string
├── quantity: string
├── notes: string
├── status: string (pending|bought|notAvailable)
├── familyGroupId: string
├── createdByUid: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Vladimir Tomic**

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend infrastructure
- Material Design for the design system
- Google Fonts for typography

## 📞 Support

For detailed setup instructions, see [SETUP.md](SETUP.md)

For issues and questions, please open an issue on GitHub.

---

Made with ❤️ using Flutter
