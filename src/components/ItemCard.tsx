import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';

import type { ShoppingItem } from '../types/models';

interface Props {
  item: ShoppingItem;
  onCycleStatus: (item: ShoppingItem) => void;
  onDelete: (itemId: string) => void;
}

export function ItemCard({ item, onCycleStatus, onDelete }: Props) {
  return (
    <View style={styles.card}>
      <View style={styles.topRow}>
        <Text style={styles.label}>{item.label}</Text>
        <Text style={styles.status}>{item.status}</Text>
      </View>
      <Text style={styles.amount}>Amount: {item.amount}</Text>
      {!!item.description && <Text style={styles.description}>{item.description}</Text>}
      <View style={styles.actions}>
        <Pressable onPress={() => onCycleStatus(item)} style={[styles.button, styles.secondary]}>
          <Text>Next status</Text>
        </Pressable>
        <Pressable onPress={() => onDelete(item.id)} style={[styles.button, styles.danger]}>
          <Text style={{ color: '#fff' }}>Delete</Text>
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 14, marginBottom: 10 },
  topRow: { flexDirection: 'row', justifyContent: 'space-between' },
  label: { fontWeight: '700', fontSize: 16 },
  status: { fontSize: 12, color: '#555' },
  amount: { marginTop: 8 },
  description: { marginTop: 6, color: '#666' },
  actions: { marginTop: 12, flexDirection: 'row', gap: 8 },
  button: { paddingVertical: 8, paddingHorizontal: 12, borderRadius: 8 },
  secondary: { backgroundColor: '#E8A54B' },
  danger: { backgroundColor: '#D4645C' },
});
