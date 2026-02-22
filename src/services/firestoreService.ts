import {
  addDoc,
  arrayRemove,
  arrayUnion,
  collection,
  deleteDoc,
  doc,
  getDocs,
  limit,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
  updateDoc,
  where,
} from 'firebase/firestore';

import { db } from '../config/firebase';
import type { FamilyGroup, ItemStatus, ShoppingItem } from '../types/models';

const familyGroupsCollection = collection(db, 'familyGroups');
const shoppingItemsCollection = collection(db, 'shoppingItems');

const mapFamilyGroup = (id: string, data: any): FamilyGroup => ({
  id,
  ownerUid: data.ownerUid,
  ownerEmail: data.ownerEmail,
  memberEmails: data.memberEmails ?? [],
  createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? new Date().toISOString(),
  updatedAt: data.updatedAt?.toDate?.()?.toISOString?.() ?? new Date().toISOString(),
});

const mapItem = (id: string, data: any): ShoppingItem => ({
  id,
  familyGroupId: data.familyGroupId,
  label: data.label ?? data.name ?? '',
  amount: data.amount ?? data.quantity ?? '1',
  description: data.description ?? data.notes ?? '',
  status: (data.status ?? 'NEEDED') as ItemStatus,
  createdByUid: data.createdByUid,
  createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? new Date().toISOString(),
  updatedAt: data.updatedAt?.toDate?.()?.toISOString?.() ?? new Date().toISOString(),
});

export async function getOrCreateFamilyGroup(userUid: string, userEmail: string): Promise<FamilyGroup> {
  const normalizedEmail = userEmail.toLowerCase();

  const ownerQ = query(familyGroupsCollection, where('ownerUid', '==', userUid), limit(1));
  const ownerSnapshot = await getDocs(ownerQ);
  if (!ownerSnapshot.empty) {
    const d = ownerSnapshot.docs[0];
    return mapFamilyGroup(d.id, d.data());
  }

  const memberQ = query(familyGroupsCollection, where('memberEmails', 'array-contains', normalizedEmail), limit(1));
  const memberSnapshot = await getDocs(memberQ);
  if (!memberSnapshot.empty) {
    const d = memberSnapshot.docs[0];
    return mapFamilyGroup(d.id, d.data());
  }

  const newDoc = await addDoc(familyGroupsCollection, {
    ownerUid: userUid,
    ownerEmail: normalizedEmail,
    memberEmails: [],
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  return {
    id: newDoc.id,
    ownerUid: userUid,
    ownerEmail: normalizedEmail,
    memberEmails: [],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
}

export function subscribeToItems(groupId: string, onData: (items: ShoppingItem[]) => void) {
  const q = query(
    shoppingItemsCollection,
    where('familyGroupId', '==', groupId),
    orderBy('createdAt', 'desc'),
  );

  return onSnapshot(q, (snapshot) => {
    onData(snapshot.docs.map((d) => mapItem(d.id, d.data())));
  });
}

export async function addItem(params: {
  familyGroupId: string;
  label: string;
  amount: string;
  description?: string;
  createdByUid: string;
}) {
  await addDoc(shoppingItemsCollection, {
    familyGroupId: params.familyGroupId,
    label: params.label.trim(),
    amount: params.amount.trim(),
    description: params.description?.trim() ?? '',
    status: 'NEEDED',
    createdByUid: params.createdByUid,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
}

export async function updateItem(itemId: string, updates: Partial<Pick<ShoppingItem, 'label' | 'amount' | 'description' | 'status'>>) {
  await updateDoc(doc(db, 'shoppingItems', itemId), {
    ...updates,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteItem(itemId: string) {
  await deleteDoc(doc(db, 'shoppingItems', itemId));
}

export async function addFamilyMember(groupId: string, email: string) {
  await updateDoc(doc(db, 'familyGroups', groupId), {
    memberEmails: arrayUnion(email.toLowerCase().trim()),
    updatedAt: serverTimestamp(),
  });
}

export async function removeFamilyMember(groupId: string, email: string) {
  await updateDoc(doc(db, 'familyGroups', groupId), {
    memberEmails: arrayRemove(email.toLowerCase().trim()),
    updatedAt: serverTimestamp(),
  });
}
