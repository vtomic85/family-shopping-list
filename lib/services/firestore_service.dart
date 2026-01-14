import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/family_group.dart';
import '../models/shopping_item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _familyGroupsCollection =>
      _firestore.collection('familyGroups');
  
  CollectionReference<Map<String, dynamic>> get _shoppingItemsCollection =>
      _firestore.collection('shoppingItems');

  // ==================== Family Group Operations ====================

  /// Get or create a family group for the current user
  /// If user is a member of an existing group, returns that group
  /// Otherwise creates a new group with the user as owner
  Future<FamilyGroup> getOrCreateFamilyGroup(User user) async {
    final email = user.email?.toLowerCase();
    if (email == null) {
      throw Exception('User email is required');
    }

    // First, check if user owns a group
    final ownedGroupQuery = await _familyGroupsCollection
        .where('ownerUid', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (ownedGroupQuery.docs.isNotEmpty) {
      return FamilyGroup.fromFirestore(ownedGroupQuery.docs.first);
    }

    // Check if user is a member of any group
    final memberGroupQuery = await _familyGroupsCollection
        .where('memberEmails', arrayContains: email)
        .limit(1)
        .get();

    if (memberGroupQuery.docs.isNotEmpty) {
      return FamilyGroup.fromFirestore(memberGroupQuery.docs.first);
    }

    // No group found, create a new one
    final newGroup = FamilyGroup(
      id: '', // Will be set by Firestore
      ownerUid: user.uid,
      ownerEmail: email,
      memberEmails: [],
      createdAt: DateTime.now(),
    );

    final docRef = await _familyGroupsCollection.add(newGroup.toFirestore());
    return newGroup.copyWith(id: docRef.id);
  }

  /// Stream the family group for real-time updates
  Stream<FamilyGroup?> streamFamilyGroup(String groupId) {
    return _familyGroupsCollection
        .doc(groupId)
        .snapshots()
        .map((doc) => doc.exists ? FamilyGroup.fromFirestore(doc) : null);
  }

  /// Add a member to the family group
  Future<void> addMember(String groupId, String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    
    // Validate email format
    if (!_isValidEmail(normalizedEmail)) {
      throw Exception('Invalid email format');
    }

    await _familyGroupsCollection.doc(groupId).update({
      'memberEmails': FieldValue.arrayUnion([normalizedEmail]),
    });
  }

  /// Remove a member from the family group
  Future<void> removeMember(String groupId, String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    
    await _familyGroupsCollection.doc(groupId).update({
      'memberEmails': FieldValue.arrayRemove([normalizedEmail]),
    });
  }

  // ==================== Shopping Item Operations ====================

  /// Stream shopping items for a family group
  Stream<List<ShoppingItem>> streamItems(String familyGroupId) {
    return _shoppingItemsCollection
        .where('familyGroupId', isEqualTo: familyGroupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShoppingItem.fromFirestore(doc))
            .toList());
  }

  /// Add a new shopping item
  Future<ShoppingItem> addItem({
    required String familyGroupId,
    required String name,
    required String quantity,
    String notes = '',
    required String createdByUid,
  }) async {
    final now = DateTime.now();
    final item = ShoppingItem(
      id: '', // Will be set by Firestore
      familyGroupId: familyGroupId,
      name: name.trim(),
      quantity: quantity.trim(),
      notes: notes.trim(),
      status: ItemStatus.pending,
      createdByUid: createdByUid,
      createdAt: now,
      modifiedAt: now,
    );

    final docRef = await _shoppingItemsCollection.add(item.toFirestore());
    return item.copyWith(id: docRef.id);
  }

  /// Update an existing shopping item
  Future<void> updateItem({
    required String itemId,
    String? name,
    String? quantity,
    String? notes,
    ItemStatus? status,
  }) async {
    final updates = <String, dynamic>{
      'modifiedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (name != null) {
      updates['name'] = name.trim();
    }
    if (quantity != null) {
      updates['quantity'] = quantity.trim();
    }
    if (notes != null) {
      updates['notes'] = notes.trim();
    }
    if (status != null) {
      updates['status'] = status.toJson();
    }

    await _shoppingItemsCollection.doc(itemId).update(updates);
  }

  /// Update only the status of an item (convenience method)
  Future<void> updateItemStatus(String itemId, ItemStatus status) async {
    await updateItem(itemId: itemId, status: status);
  }

  /// Delete a shopping item
  Future<void> deleteItem(String itemId) async {
    await _shoppingItemsCollection.doc(itemId).delete();
  }

  /// Delete all items in a family group (useful for clearing the list)
  Future<void> clearAllItems(String familyGroupId) async {
    final batch = _firestore.batch();
    
    final snapshot = await _shoppingItemsCollection
        .where('familyGroupId', isEqualTo: familyGroupId)
        .get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ==================== Utility Methods ====================

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
