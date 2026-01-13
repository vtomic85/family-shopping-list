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
  final String description;
  final int amount;
  final ItemStatus status;
  final String createdByUid;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const ShoppingItem({
    required this.id,
    required this.familyGroupId,
    required this.description,
    required this.amount,
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
      description: data['description'] ?? '',
      amount: data['amount'] ?? 1,
      status: ItemStatus.fromJson(data['status'] ?? 'pending'),
      createdByUid: data['createdByUid'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modifiedAt: (data['modifiedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'familyGroupId': familyGroupId,
      'description': description,
      'amount': amount,
      'status': status.toJson(),
      'createdByUid': createdByUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? familyGroupId,
    String? description,
    int? amount,
    ItemStatus? status,
    String? createdByUid,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      familyGroupId: familyGroupId ?? this.familyGroupId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
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
        other.description == description &&
        other.amount == amount &&
        other.status == status &&
        other.createdByUid == createdByUid;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyGroupId,
      description,
      amount,
      status,
      createdByUid,
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, description: $description, amount: $amount, status: ${status.displayName})';
  }
}
