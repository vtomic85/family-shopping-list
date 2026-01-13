import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/family_group_provider.dart';
import 'providers/shopping_list_provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final authService = AuthService();
  final firestoreService = FirestoreService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, FamilyGroupProvider>(
          create: (_) => FamilyGroupProvider(firestoreService: firestoreService),
          update: (_, authProvider, familyGroupProvider) {
            familyGroupProvider?.updateUser(authProvider.user);
            return familyGroupProvider ?? FamilyGroupProvider(firestoreService: firestoreService);
          },
        ),
        ChangeNotifierProxyProvider<FamilyGroupProvider, ShoppingListProvider>(
          create: (_) => ShoppingListProvider(firestoreService: firestoreService),
          update: (_, familyGroupProvider, shoppingListProvider) {
            shoppingListProvider?.updateFamilyGroup(familyGroupProvider.familyGroup);
            return shoppingListProvider ?? ShoppingListProvider(firestoreService: firestoreService);
          },
        ),
      ],
      child: const FamilyShoppingListApp(),
    ),
  );
}
