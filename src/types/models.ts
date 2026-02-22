export type ItemStatus = 'NEEDED' | 'BOUGHT' | 'NOT_AVAILABLE';

export interface ShoppingItem {
  id: string;
  familyGroupId: string;
  label: string;
  amount: string;
  description?: string;
  status: ItemStatus;
  createdByUid: string;
  createdAt: string;
  updatedAt: string;
}

export interface FamilyGroup {
  id: string;
  ownerUid: string;
  ownerEmail: string;
  memberEmails: string[];
  createdAt: string;
  updatedAt: string;
}
