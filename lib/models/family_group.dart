import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyGroup {
  final String id;
  final String ownerUid;
  final String ownerEmail;
  final List<String> memberEmails;
  final DateTime createdAt;

  const FamilyGroup({
    required this.id,
    required this.ownerUid,
    required this.ownerEmail,
    required this.memberEmails,
    required this.createdAt,
  });

  factory FamilyGroup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyGroup(
      id: doc.id,
      ownerUid: data['ownerUid'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      memberEmails: List<String>.from(data['memberEmails'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerUid': ownerUid,
      'ownerEmail': ownerEmail,
      'memberEmails': memberEmails,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FamilyGroup copyWith({
    String? id,
    String? ownerUid,
    String? ownerEmail,
    List<String>? memberEmails,
    DateTime? createdAt,
  }) {
    return FamilyGroup(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      memberEmails: memberEmails ?? List.from(this.memberEmails),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get all emails that have access to this group (owner + members)
  List<String> get allMemberEmails {
    final emails = <String>{ownerEmail, ...memberEmails};
    return emails.toList();
  }

  /// Check if a user (by email) has access to this group
  bool hasAccess(String email) {
    return ownerEmail.toLowerCase() == email.toLowerCase() ||
        memberEmails.any((e) => e.toLowerCase() == email.toLowerCase());
  }

  /// Check if a user is the owner of this group
  bool isOwner(String uid) {
    return ownerUid == uid;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyGroup &&
        other.id == id &&
        other.ownerUid == ownerUid &&
        other.ownerEmail == ownerEmail;
  }

  @override
  int get hashCode {
    return Object.hash(id, ownerUid, ownerEmail);
  }

  @override
  String toString() {
    return 'FamilyGroup(id: $id, ownerEmail: $ownerEmail, members: ${memberEmails.length})';
  }
}
