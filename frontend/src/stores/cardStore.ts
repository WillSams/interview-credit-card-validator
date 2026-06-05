import { create } from 'zustand';
import { apiClient } from '../api/client';

interface CardState {
  isValid: boolean | null;
  loading: boolean;
  error: string | null;
  validateCard: (cardNumber: string) => Promise<void>;
}

export const useCardStore = create<CardState>((set) => ({
  isValid: null,
  loading: false,
  error: null,

  validateCard: async (cardNumber: string) => {
    set({ loading: true, error: null });
    try {
      const { data } = await apiClient.post<{ valid: boolean }>('/validate', { cardNumber });
      set({ isValid: data.valid, loading: false });
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error';
      set({ isValid: null, error: message, loading: false });
    }
  },
}));
