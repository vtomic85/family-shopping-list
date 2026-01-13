import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/family_group.dart';
import '../models/shopping_item.dart';
import '../services/firestore_service.dart';

class ShoppingListProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  List<ShoppingItem> _items = [];
  bool _isLoading = false;
  String? _error;
  FamilyGroup? _familyGroup;
  StreamSubscription<List<ShoppingItem>>? _itemsSubscription;

  ShoppingListProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // Getters
  List<ShoppingItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;

  // Filtered lists
  List<ShoppingItem> get pendingItems =>
      _items.where((item) => item.status == ItemStatus.pending).toList();
  
  List<ShoppingItem> get boughtItems =>
      _items.where((item) => item.status == ItemStatus.bought).toList();
  
  List<ShoppingItem> get notAvailableItems =>
      _items.where((item) => item.status == ItemStatus.notAvailable).toList();

  // Statistics
  int get totalItems => _items.length;
  int get pendingCount => pendingItems.length;
  int get boughtCount => boughtItems.length;
  int get notAvailableCount => notAvailableItems.length;

  /// Called when the family group changes
  void updateFamilyGroup(FamilyGroup? group) {
    if (group == null) {
      _clear();
      return;
    }

    if (_familyGroup?.id != group.id) {
      _familyGroup = group;
      _subscribeToItems();
    }
  }

  void _clear() {
    _itemsSubscription?.cancel();
    _items = [];
    _familyGroup = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  void _subscribeToItems() {
    if (_familyGroup == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _itemsSubscription?.cancel();
    _itemsSubscription = _firestoreService
        .streamItems(_familyGroup!.id)
        .listen(
          (items) {
            _items = items;
            _isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// Add a new item to the shopping list
  Future<bool> addItem({
    required String description,
    required int amount,
    required String userId,
  }) async {
    if (_familyGroup == null) {
      _error = 'No family group available';
      notifyListeners();
      return false;
    }

    if (description.trim().isEmpty) {
      _error = 'Description cannot be empty';
      notifyListeners();
      return false;
    }

    if (amount < 1) {
      _error = 'Amount must be at least 1';
      notifyListeners();
      return false;
    }

    try {
      _error = null;
      await _firestoreService.addItem(
        familyGroupId: _familyGroup!.id,
        description: description,
        amount: amount,
        createdByUid: userId,
      );
      return true;
    } catch (e) {
      _error = 'Failed to add item: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing item
  Future<bool> updateItem({
    required String itemId,
    String? description,
    int? amount,
    ItemStatus? status,
  }) async {
    if (description != null && description.trim().isEmpty) {
      _error = 'Description cannot be empty';
      notifyListeners();
      return false;
    }

    if (amount != null && amount < 1) {
      _error = 'Amount must be at least 1';
      notifyListeners();
      return false;
    }

    try {
      _error = null;
      await _firestoreService.updateItem(
        itemId: itemId,
        description: description,
        amount: amount,
        status: status,
      );
      return true;
    } catch (e) {
      _error = 'Failed to update item: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Quick update status
  Future<bool> updateItemStatus(String itemId, ItemStatus status) async {
    try {
      _error = null;
      await _firestoreService.updateItemStatus(itemId, status);
      return true;
    } catch (e) {
      _error = 'Failed to update status: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Cycle through statuses: pending -> bought -> notAvailable -> pending
  Future<bool> cycleItemStatus(String itemId) async {
    final item = _items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw Exception('Item not found'),
    );

    final nextStatus = switch (item.status) {
      ItemStatus.pending => ItemStatus.bought,
      ItemStatus.bought => ItemStatus.notAvailable,
      ItemStatus.notAvailable => ItemStatus.pending,
    };

    return updateItemStatus(itemId, nextStatus);
  }

  /// Delete an item
  Future<bool> deleteItem(String itemId) async {
    try {
      _error = null;
      await _firestoreService.deleteItem(itemId);
      return true;
    } catch (e) {
      _error = 'Failed to delete item: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Clear all items from the list
  Future<bool> clearAllItems() async {
    if (_familyGroup == null) return false;

    try {
      _error = null;
      await _firestoreService.clearAllItems(_familyGroup!.id);
      return true;
    } catch (e) {
      _error = 'Failed to clear items: ${e.toString()}';
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
    _itemsSubscription?.cancel();
    super.dispose();
  }
}
