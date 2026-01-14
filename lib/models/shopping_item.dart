import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemStatus {
  pending,
  bought,
  notAvailable;

  String get displayName {
    switch (this) {
      case ItemStatus.pending:
        return 'Pending';
      case ItemStatus.bought:
        return 'Bought';
      case ItemStatus.notAvailable:
        return 'Not Available';
    }
  }

  String toJson() => name;

  static ItemStatus fromJson(String value) {
    switch (value) {
      case 'pending':
        return ItemStatus.pending;
      case 'bought':
        return ItemStatus.bought;
      case 'notAvailable':
      case 'not_available':
        return ItemStatus.notAvailable;
      default:
        return ItemStatus.pending;
    }
  }
}

class ShoppingItem {
  final String id;
  final String familyGroupId;
  final String name;
  final String quantity;
  final String notes;
  final ItemStatus status;
  final String createdByUid;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const ShoppingItem({
    required this.id,
    required this.familyGroupId,
    required this.name,
    this.quantity = '1',
    this.notes = '',
    required this.status,
    required this.createdByUid,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingItem(
      id: doc.id,
      familyGroupId: data['familyGroupId'] ?? '',
      name: data['name'] ?? data['description'] ?? '', // Support legacy 'description' field
      quantity: data['quantity']?.toString() ?? data['amount']?.toString() ?? '1', // Support legacy 'amount' field
      notes: data['notes'] ?? '',
      status: ItemStatus.fromJson(data['status'] ?? 'pending'),
      createdByUid: data['createdByUid'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modifiedAt: (data['modifiedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'familyGroupId': familyGroupId,
      'name': name,
      'quantity': quantity,
      'notes': notes,
      'status': status.toJson(),
      'createdByUid': createdByUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? familyGroupId,
    String? name,
    String? quantity,
    String? notes,
    ItemStatus? status,
    String? createdByUid,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      familyGroupId: familyGroupId ?? this.familyGroupId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdByUid: createdByUid ?? this.createdByUid,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem &&
        other.id == id &&
        other.familyGroupId == familyGroupId &&
        other.name == name &&
        other.quantity == quantity &&
        other.notes == notes &&
        other.status == status &&
        other.createdByUid == createdByUid;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyGroupId,
      name,
      quantity,
      notes,
      status,
      createdByUid,
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, notes: $notes, status: ${status.displayName})';
  }
}
