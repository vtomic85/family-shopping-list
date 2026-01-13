import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/family_group.dart';
import '../services/firestore_service.dart';

class FamilyGroupProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  FamilyGroup? _familyGroup;
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  StreamSubscription<FamilyGroup?>? _groupSubscription;

  FamilyGroupProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // Getters
  FamilyGroup? get familyGroup => _familyGroup;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOwner => 
      _familyGroup != null && 
      _currentUser != null && 
      _familyGroup!.isOwner(_currentUser!.uid);
  List<String> get members => _familyGroup?.memberEmails ?? [];
  String? get ownerEmail => _familyGroup?.ownerEmail;

  /// Called when the authenticated user changes
  void updateUser(User? user) {
    if (user == null) {
      _clear();
      return;
    }

    if (_currentUser?.uid != user.uid) {
      _currentUser = user;
      _loadFamilyGroup();
    }
  }

  void _clear() {
    _groupSubscription?.cancel();
    _familyGroup = null;
    _currentUser = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFamilyGroup() async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get or create family group
      final group = await _firestoreService.getOrCreateFamilyGroup(_currentUser!);
      
      // Subscribe to real-time updates
      _groupSubscription?.cancel();
      _groupSubscription = _firestoreService
          .streamFamilyGroup(group.id)
          .listen(
            (updatedGroup) {
              _familyGroup = updatedGroup;
              _isLoading = false;
              notifyListeners();
            },
            onError: (e) {
              _error = e.toString();
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new member to the family group
  Future<bool> addMember(String email) async {
    if (_familyGroup == null) return false;

    final normalizedEmail = email.toLowerCase().trim();
    
    // Check if already a member
    if (_familyGroup!.hasAccess(normalizedEmail)) {
      _error = 'This person is already a member of your family group.';
      notifyListeners();
      return false;
    }

    try {
      _error = null;
      await _firestoreService.addMember(_familyGroup!.id, normalizedEmail);
      return true;
    } catch (e) {
      _error = 'Failed to add member: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Remove a member from the family group
  Future<bool> removeMember(String email) async {
    if (_familyGroup == null) return false;

    // Cannot remove owner
    if (email.toLowerCase() == _familyGroup!.ownerEmail.toLowerCase()) {
      _error = 'Cannot remove the owner of the family group.';
      notifyListeners();
      return false;
    }

    try {
      _error = null;
      await _firestoreService.removeMember(_familyGroup!.id, email);
      return true;
    } catch (e) {
      _error = 'Failed to remove member: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Clear any error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _groupSubscription?.cancel();
    super.dispose();
  }
}
