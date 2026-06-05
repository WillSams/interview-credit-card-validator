import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({
  apiClient: {
    post: vi.fn(),
  },
}));

const mockedPost = vi.mocked(apiClient.post);

describe('cardStore', () => {
  beforeEach(() => {
    useCardStore.setState({ isValid: null, loading: false, error: null });
    vi.clearAllMocks();
  });

  it('starts with null validity, not loading, and no error', () => {
    const { isValid, loading, error } = useCardStore.getState();
    expect(isValid).toBeNull();
    expect(loading).toBe(false);
    expect(error).toBeNull();
  });

  it('sets loading to true while the request is in flight', async () => {
    let resolvePromise!: (value: unknown) => void;
    mockedPost.mockReturnValue(new Promise((res) => (resolvePromise = res)));

    const validatePromise = useCardStore.getState().validateCard('4532015112830366');
    expect(useCardStore.getState().loading).toBe(true);

    resolvePromise({ data: { valid: true } });
    await validatePromise;
  });

  it('sets isValid to true for a valid card number', async () => {
    mockedPost.mockResolvedValue({ data: { valid: true } });

    await useCardStore.getState().validateCard('4532015112830366');

    const { isValid, loading, error } = useCardStore.getState();
    expect(isValid).toBe(true);
    expect(loading).toBe(false);
    expect(error).toBeNull();
  });

  it('sets isValid to false for an invalid card number', async () => {
    mockedPost.mockResolvedValue({ data: { valid: false } });

    await useCardStore.getState().validateCard('1234567890123456');

    const { isValid, loading, error } = useCardStore.getState();
    expect(isValid).toBe(false);
    expect(loading).toBe(false);
    expect(error).toBeNull();
  });

  it('sets error and clears isValid when the request fails', async () => {
    mockedPost.mockRejectedValue(new Error('Network error'));

    await useCardStore.getState().validateCard('4532015112830366');

    const { isValid, loading, error } = useCardStore.getState();
    expect(isValid).toBeNull();
    expect(loading).toBe(false);
    expect(error).toBe('Network error');
  });

  it('calls POST /validate with the card number', async () => {
    mockedPost.mockResolvedValue({ data: { valid: true } });

    await useCardStore.getState().validateCard('4532015112830366');

    expect(mockedPost).toHaveBeenCalledWith('/validate', { cardNumber: '4532015112830366' });
  });

  it('clears the previous error on a new request', async () => {
    useCardStore.setState({ error: 'previous error' });
    mockedPost.mockResolvedValue({ data: { valid: true } });

    await useCardStore.getState().validateCard('4532015112830366');

    expect(useCardStore.getState().error).toBeNull();
  });
});
