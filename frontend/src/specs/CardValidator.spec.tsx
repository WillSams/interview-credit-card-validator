import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();

const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return {
    ...actual,
    useCardStore: vi.fn(),
  };
});

const mockedUseCardStore = vi.mocked(useCardStore);
const mockValidateCard = vi.fn();

beforeEach(() => {
  mockValidateCard.mockReset();
  mockedUseCardStore.mockReturnValue({
    isValid: null,
    loading: false,
    error: null,
    validateCard: mockValidateCard,
  });
});

describe('CardValidator', () => {
  it('renders a card number input', () => {
    renderWithProviders(<CardValidator />);
    expect(screen.getByRole('textbox', { name: /card number/i })).toBeInTheDocument();
  });

  it('renders a validate button', () => {
    renderWithProviders(<CardValidator />);
    expect(screen.getByRole('button', { name: /validate/i })).toBeInTheDocument();
  });

  it('does not show a result before any validation', () => {
    renderWithProviders(<CardValidator />);
    expect(screen.queryByRole('alert')).not.toBeInTheDocument();
  });

  it('calls validateCard with the entered card number on submit', async () => {
    renderWithProviders(<CardValidator />);

    await userEvent.type(screen.getByRole('textbox', { name: /card number/i }), '4532015112830366');
    fireEvent.click(screen.getByRole('button', { name: /validate/i }));

    expect(mockValidateCard).toHaveBeenCalledWith('4532015112830366');
  });

  it('disables the button and input while loading', () => {
    mockedUseCardStore.mockReturnValue({
      isValid: null,
      loading: true,
      error: null,
      validateCard: mockValidateCard,
    });

    renderWithProviders(<CardValidator />);

    expect(screen.getByRole('button', { name: /validating/i })).toBeDisabled();
    expect(screen.getByRole('textbox', { name: /card number/i })).toBeDisabled();
  });

  it('shows a success alert when the card is valid', () => {
    mockedUseCardStore.mockReturnValue({
      isValid: true,
      loading: false,
      error: null,
      validateCard: mockValidateCard,
    });

    renderWithProviders(<CardValidator />);

    expect(screen.getByRole('alert')).toBeInTheDocument();
    expect(screen.getByText(/valid card number/i)).toBeInTheDocument();
  });

  it('shows an error alert when the card is invalid', () => {
    mockedUseCardStore.mockReturnValue({
      isValid: false,
      loading: false,
      error: null,
      validateCard: mockValidateCard,
    });

    renderWithProviders(<CardValidator />);

    expect(screen.getByRole('alert')).toBeInTheDocument();
    expect(screen.getByText(/invalid/i)).toBeInTheDocument();
  });

  it('shows an error alert when the request fails', () => {
    mockedUseCardStore.mockReturnValue({
      isValid: null,
      loading: false,
      error: 'Network error',
      validateCard: mockValidateCard,
    });

    renderWithProviders(<CardValidator />);

    expect(screen.getByRole('alert')).toBeInTheDocument();
    expect(screen.getByText(/network error/i)).toBeInTheDocument();
  });

  it('does not submit when the input is empty', async () => {
    renderWithProviders(<CardValidator />);

    fireEvent.click(screen.getByRole('button', { name: /validate/i }));

    await waitFor(() => {
      expect(mockValidateCard).not.toHaveBeenCalled();
    });
  });
});
