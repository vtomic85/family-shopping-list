import React, { useMemo, useState } from 'react';
import { Alert, FlatList, Pressable, SafeAreaView, StyleSheet, Text, TextInput, View } from 'react-native';

import { ItemCard } from './src/components/ItemCard';
import { useFamilyShopping } from './src/hooks/useFamilyShopping';
import type { ItemStatus, ShoppingItem } from './src/types/models';

const statusOrder: ItemStatus[] = ['NEEDED', 'BOUGHT', 'NOT_AVAILABLE'];

function nextStatus(status: ItemStatus): ItemStatus {
  const idx = statusOrder.indexOf(status);
  return statusOrder[(idx + 1) % statusOrder.length];
}

export default function App() {
  const app = useFamilyShopping();

  const [label, setLabel] = useState('');
  const [amount, setAmount] = useState('1');
  const [description, setDescription] = useState('');
  const [inviteEmail, setInviteEmail] = useState('');

  const sections = useMemo(
    () => ({
      NEEDED: app.items.filter((i) => i.status === 'NEEDED'),
      BOUGHT: app.items.filter((i) => i.status === 'BOUGHT'),
      NOT_AVAILABLE: app.items.filter((i) => i.status === 'NOT_AVAILABLE'),
    }),
    [app.items],
  );

  const onAddItem = async () => {
    if (!label.trim() || !amount.trim()) {
      Alert.alert('Validation', 'Label and Amount are required.');
      return;
    }
    await app.addItem(label, amount, description);
    setLabel('');
    setAmount('1');
    setDescription('');
  };

  const renderGroup = (title: string, items: ShoppingItem[]) => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{title} ({items.length})</Text>
      {items.map((item) => (
        <ItemCard
          key={item.id}
          item={item}
          onDelete={app.deleteItem}
          onCycleStatus={(i) => app.updateItemStatus(i.id, nextStatus(i.status))}
        />
      ))}
    </View>
  );

  if (app.loading) {
    return <SafeAreaView style={styles.container}><Text>Loading...</Text></SafeAreaView>;
  }

  if (!app.user) {
    return (
      <SafeAreaView style={styles.container}>
        <Text style={styles.title}>Family Shopping List</Text>
        <Text style={styles.subtitle}>Sign in with Google to create or join your family list.</Text>
        <Pressable disabled={!app.request} onPress={app.signIn} style={styles.primaryButton}>
          <Text style={styles.primaryButtonText}>Continue with Google</Text>
        </Pressable>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        ListHeaderComponent={(
          <View>
            <Text style={styles.title}>Shared Family List</Text>
            <Text style={styles.subtitle}>Logged in as {app.user.email}</Text>

            <View style={styles.card}>
              <Text style={styles.cardTitle}>Add item</Text>
              <TextInput style={styles.input} placeholder="Label" value={label} onChangeText={setLabel} />
              <TextInput style={styles.input} placeholder="Amount" value={amount} onChangeText={setAmount} />
              <TextInput style={styles.input} placeholder="Description (optional)" value={description} onChangeText={setDescription} />
              <Pressable onPress={onAddItem} style={styles.primaryButton}><Text style={styles.primaryButtonText}>Add</Text></Pressable>
            </View>

            <View style={styles.card}>
              <Text style={styles.cardTitle}>Invite family member</Text>
              <TextInput style={styles.input} placeholder="Email" value={inviteEmail} onChangeText={setInviteEmail} />
              <Pressable onPress={() => app.addMember(inviteEmail).then(() => setInviteEmail(''))} style={styles.primaryButton}><Text style={styles.primaryButtonText}>Invite</Text></Pressable>
              <Text style={styles.helper}>Owner: {app.group?.ownerEmail}</Text>
              <Text style={styles.helper}>Members: {app.group?.memberEmails.join(', ') || 'None yet'}</Text>
            </View>

            <Pressable onPress={app.signOut} style={[styles.primaryButton, { backgroundColor: '#444' }]}><Text style={styles.primaryButtonText}>Sign out</Text></Pressable>
          </View>
        )}
        data={[]}
        renderItem={null}
        ListFooterComponent={(
          <View>
            {renderGroup('NEEDED', sections.NEEDED)}
            {renderGroup('BOUGHT', sections.BOUGHT)}
            {renderGroup('NOT AVAILABLE', sections.NOT_AVAILABLE)}
          </View>
        )}
      />
      {app.error ? <Text style={styles.error}>{app.error}</Text> : null}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F7F4EF', padding: 16 },
  title: { fontSize: 26, fontWeight: '700', marginBottom: 8 },
  subtitle: { color: '#444', marginBottom: 14 },
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 12, marginBottom: 12 },
  cardTitle: { fontWeight: '700', marginBottom: 8 },
  input: { backgroundColor: '#F2F2F2', borderRadius: 8, paddingHorizontal: 10, paddingVertical: 9, marginBottom: 8 },
  section: { marginTop: 8, marginBottom: 6 },
  sectionTitle: { fontSize: 15, fontWeight: '700', marginBottom: 8 },
  primaryButton: { backgroundColor: '#D4896A', padding: 12, borderRadius: 10, alignItems: 'center' },
  primaryButtonText: { color: '#fff', fontWeight: '600' },
  helper: { color: '#666', marginTop: 6, fontSize: 12 },
  error: { color: '#B00020', marginTop: 8 },
});
