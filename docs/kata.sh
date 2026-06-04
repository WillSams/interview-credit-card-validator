#!/bin/bash

# Credit Card Validator Kata
#
# Goal: Build a full-stack credit card validator using TDD.
#       Validation uses the Luhn checksum algorithm and runs
#       exclusively in the backend.
#
# Prerequisites:
#   - Node.js 22+ (via nvm)
#   - git

#############################################
# 1 - Bootstrap from the fullstack template #
#############################################

git clone https://github.com/WillSams/fullstack-typescript-template credit-card-validator
cd credit-card-validator

# Switch the default branch name
git symbolic-ref HEAD refs/heads/main

# Install dependencies
npm install
cd frontend && npm install && cd ..
cd backend  && npm install && cd ..

###################################################################
# 2 - Luhn algorithm — write the failing tests first (RED)        #
###################################################################

cat << 'EOF' > backend/specs/luhn.spec.ts
import { luhn } from '#src/luhn';

describe('luhn', () => {
  describe('valid card numbers', () => {
    it('accepts a valid Visa number', () => {
      expect(luhn('4532015112830366')).toBe(true);
    });

    it('accepts a valid Mastercard number', () => {
      expect(luhn('5425233430109903')).toBe(true);
    });

    it('accepts a valid Amex number', () => {
      expect(luhn('378282246310005')).toBe(true);
    });

    it('accepts a valid Discover number', () => {
      expect(luhn('6011111111111117')).toBe(true);
    });

    it('accepts the canonical Luhn test number', () => {
      expect(luhn('79927398713')).toBe(true);
    });

    it('strips spaces before validating', () => {
      expect(luhn('4532 0151 1283 0366')).toBe(true);
    });

    it('strips dashes before validating', () => {
      expect(luhn('4532-0151-1283-0366')).toBe(true);
    });
  });

  describe('invalid card numbers', () => {
    it('rejects a number with a wrong check digit', () => {
      expect(luhn('4532015112830367')).toBe(false);
    });

    it('rejects the canonical Luhn failure number', () => {
      expect(luhn('79927398714')).toBe(false);
    });

    it('rejects a sequential number', () => {
      expect(luhn('1234567890123456')).toBe(false);
    });
  });

  describe('invalid input', () => {
    it('rejects an empty string', () => {
      expect(luhn('')).toBe(false);
    });

    it('rejects a non-numeric string', () => {
      expect(luhn('abcd')).toBe(false);
    });

    it('rejects a number that is too short (fewer than 9 digits)', () => {
      expect(luhn('1234')).toBe(false);
    });

    it('rejects a single digit', () => {
      expect(luhn('4')).toBe(false);
    });
  });
});
EOF

cd backend && npm test   # 14 failed — #src/luhn does not exist yet

###################################################################
# 3 - Luhn algorithm — implement (GREEN)                          #
###################################################################

# Key insight: traverse digits right-to-left, doubling every second digit.
# If doubling exceeds 9, subtract 9. Sum must be divisible by 10.

cat << 'EOF' > backend/src/luhn.ts
/**
 * Validates a credit card number using the Luhn checksum algorithm.
 * Accepts spaces and dashes as formatting characters.
 * Returns false for non-numeric input or numbers shorter than 9 digits.
 */
export function luhn(input: string): boolean {
  const digits = input.replace(/[\s-]/g, '');

  if (!/^\d+$/.test(digits) || digits.length < 9) return false;

  let sum = 0;
  let double = false;

  for (let i = digits.length - 1; i >= 0; i--) {
    let digit = parseInt(digits[i], 10);

    if (double) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }

    sum += digit;
    double = !double;
  }

  return sum % 10 === 0;
}
EOF

npm test   # 15 passed (14 luhn + 1 existing app spec)

cd ..
git add .
git commit -m "Implement Luhn checksum algorithm"

###################################################################
# 4 - POST /validate endpoint — write the failing tests (RED)     #
###################################################################

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
import { fastify } from '#src/app';

describe('POST /validate', () => {
  beforeAll(async () => {
    await fastify.ready();
  });

  afterAll(async () => {
    await fastify.close();
  });

  it('returns valid: true for a valid card number', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532015112830366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });

  it('returns valid: false for an invalid card number', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532015112830367' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: false });
  });

  it('accepts card numbers with spaces', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532 0151 1283 0366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });

  it('accepts card numbers with dashes', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532-0151-1283-0366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });

  it('returns 400 when cardNumber is missing', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({})
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(400);
  });

  it('returns 400 when cardNumber is not a string', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: 12345 })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(400);
  });

  it('returns valid: false for an empty string', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: false });
  });
});
EOF

cd backend && npm test   # 7 failed — route returns 404

###################################################################
# 5 - POST /validate endpoint — implement (GREEN)                 #
###################################################################

# Two things to note:
#   - coerceTypes: false prevents AJV from silently casting numbers to strings
#   - JSON schema validation gives us the 400 for free

cat << 'EOF' > backend/src/app.ts
import Fastify, { FastifyRequest, FastifyReply } from 'fastify';
import cors from '@fastify/cors';
import { luhn } from '#src/luhn';

export const fastify = Fastify({
  logger: process.env.ENV !== 'test',
  ajv: { customOptions: { coerceTypes: false } },
});

await fastify.register(cors, {
  origin: process.env.ALLOWED_ORIGINS?.split(',') ?? true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
});

fastify.get('/', async (_request: FastifyRequest, _reply: FastifyReply) => {
  return {
    status: 'Success',
    result: process.env.ABOUT_MESSAGE ?? '',
  };
});

interface ValidateBody {
  cardNumber: string;
}

fastify.post(
  '/validate',
  {
    schema: {
      body: {
        type: 'object',
        required: ['cardNumber'],
        properties: {
          cardNumber: { type: 'string' },
        },
        additionalProperties: false,
      },
    },
  },
  async (request: FastifyRequest<{ Body: ValidateBody }>, _reply: FastifyReply) => {
    return { valid: luhn(request.body.cardNumber) };
  },
);
EOF

npm test   # 22 passed (14 luhn + 7 validate + 1 existing app spec)

cd ..
git add .
git commit -m "feat: add POST /validate endpoint using Luhn algorithm"

###################################################################
# 6 - Frontend card store — write the failing tests (RED)         #
###################################################################

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
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
EOF

cd frontend && npm test   # 7 failed — cardStore does not exist yet

###################################################################
# 7 - Frontend card store — implement (GREEN)                     #
###################################################################

cat << 'EOF' > frontend/src/stores/cardStore.ts
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
EOF

npm test   # 13 passed (7 cardStore + 4 appStore + 2 App routing)

cd ..
git add .
git commit -m "feat: credit card validation store with unit tests"

###################################################################
# 8 - CardValidator component — write the failing tests (RED)     #
###################################################################

# Note: getByText(/valid/i) would collide with the "Validate" button text.
# Use getByText(/valid card number/i) instead — lesson learned.

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
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
EOF

cd frontend && npm test   # 9 failed — CardValidator component does not exist yet

###################################################################
# 9 - CardValidator component — implement (GREEN)                 #
###################################################################

# Note: MUI v9 uses slotProps={{ htmlInput: ... }} not inputProps={{ ... }}

mkdir -p frontend/src/components

cat << 'EOF' > frontend/src/components/CardValidator.tsx
import { useState } from 'react';
import { Alert, Box, Button, CircularProgress, TextField } from '@mui/material';
import { useCardStore } from '../stores/cardStore';

export default function CardValidator() {
  const [cardNumber, setCardNumber] = useState('');
  const { isValid, loading, error, validateCard } = useCardStore();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!cardNumber.trim()) return;
    validateCard(cardNumber.trim());
  };

  return (
    <Box
      component="form"
      onSubmit={handleSubmit}
      noValidate
      sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}
    >
      <TextField
        label="Card Number"
        value={cardNumber}
        onChange={(e) => setCardNumber(e.target.value)}
        disabled={loading}
        fullWidth
        placeholder="e.g. 4532 0151 1283 0366"
        slotProps={{ htmlInput: { maxLength: 19 } }}
      />
      <Button type="submit" variant="contained" disabled={loading} sx={{ alignSelf: 'flex-start' }}>
        {loading ? (
          <>
            <CircularProgress size={16} color="inherit" sx={{ mr: 1 }} />
            Validating...
          </>
        ) : (
          'Validate'
        )}
      </Button>
      {isValid === true && <Alert severity="success">Valid card number.</Alert>}
      {isValid === false && <Alert severity="error">Invalid card number.</Alert>}
      {error && <Alert severity="error">{error}</Alert>}
    </Box>
  );
}
EOF

cat << 'EOF' > frontend/src/pages/Home.tsx
import { Container, Typography } from '@mui/material';
import CardValidator from '../components/CardValidator';

export default function Home() {
  return (
    <Container maxWidth="sm" sx={{ mt: 6 }}>
      <Typography variant="h4" gutterBottom>
        Credit Card Validator
      </Typography>
      <CardValidator />
    </Container>
  );
}
EOF

npm test   # 22 passed

cd ..
git add .
git commit -m "feat: credit card validator UI with component tests"

echo "Finis."
