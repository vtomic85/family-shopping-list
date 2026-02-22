import { GoogleAuthProvider, onAuthStateChanged, signInWithCredential, signOut, type User } from 'firebase/auth';
import * as WebBrowser from 'expo-web-browser';
import * as Google from 'expo-auth-session/providers/google';
import { useEffect, useMemo, useState } from 'react';

import { auth } from '../config/firebase';
import type { FamilyGroup, ItemStatus, ShoppingItem } from '../types/models';
import {
  addFamilyMember,
  addItem,
  deleteItem,
  getOrCreateFamilyGroup,
  removeFamilyMember,
  subscribeToItems,
  updateItem,
} from '../services/firestoreService';

WebBrowser.maybeCompleteAuthSession();

export function useFamilyShopping() {
  const [user, setUser] = useState<User | null>(null);
  const [group, setGroup] = useState<FamilyGroup | null>(null);
  const [items, setItems] = useState<ShoppingItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [request, response, promptAsync] = Google.useIdTokenAuthRequest({
    clientId: process.env.EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID,
    androidClientId: process.env.EXPO_PUBLIC_GOOGLE_ANDROID_CLIENT_ID,
  });

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (nextUser) => {
      setUser(nextUser);
      if (!nextUser?.email) {
        setGroup(null);
        setItems([]);
        setLoading(false);
        return;
      }

      const nextGroup = await getOrCreateFamilyGroup(nextUser.uid, nextUser.email);
      setGroup(nextGroup);
      setLoading(false);
    });

    return unsub;
  }, []);

  useEffect(() => {
    if (response?.type !== 'success') return;
    const idToken = response.authentication?.idToken;
    if (!idToken) return;

    const credential = GoogleAuthProvider.credential(idToken);
    signInWithCredential(auth, credential).catch((e) => setError(e.message));
  }, [response]);

  useEffect(() => {
    if (!group) return;
    const unsubscribe = subscribeToItems(group.id, setItems);
    return unsubscribe;
  }, [group]);

  const actions = useMemo(() => ({
    signIn: async () => {
      setError(null);
      await promptAsync();
    },
    signOut: async () => signOut(auth),
    addItem: async (label: string, amount: string, description?: string) => {
      if (!group || !user) return;
      await addItem({ familyGroupId: group.id, label, amount, description, createdByUid: user.uid });
    },
    updateItemStatus: async (itemId: string, status: ItemStatus) => {
      await updateItem(itemId, { status });
    },
    updateItem: async (itemId: string, payload: { label: string; amount: string; description?: string; status: ItemStatus }) => {
      await updateItem(itemId, payload);
    },
    deleteItem,
    addMember: async (email: string) => {
      if (!group) return;
      await addFamilyMember(group.id, email);
    },
    removeMember: async (email: string) => {
      if (!group) return;
      await removeFamilyMember(group.id, email);
    },
  }), [group, promptAsync, user]);

  return {
    request,
    user,
    group,
    items,
    loading,
    error,
    ...actions,
  };
}
