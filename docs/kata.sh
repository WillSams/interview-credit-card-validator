#!/bin/bash

# Credit Card Validator Kata
#
# Goal: Build a full-stack credit card validator using TDD.
#       Validation uses the Luhn checksum algorithm and runs
#       exclusively in the backend.
#
# TDD workflow per suite:
#   RED   — write one failing test (wrong expected value forces failure)
#   GREEN — fix the expected value with sed, or fix the implementation
#   SQUASH — squash all suite commits into one clean commit
#
# Prerequisites:
#   - Node.js 22+ (via nvm)
#   - git with GPG signing configured (commit.gpgsign = true)


set -e

COMMIT="git commit -S"

#############################################
# 1 - Bootstrap from the fullstack template #
#############################################

git clone https://github.com/WillSams/fullstack-typescript-template credit-card-validator
cd credit-card-validator

git symbolic-ref HEAD refs/heads/main

npm install
cd frontend && npm install && cd ..
cd backend  && npm install && cd ..

###########################################################################
# 2 - Luhn algorithm                                                      #
###########################################################################

# Test - accepts a valid Visa number
echo "export function luhn(): boolean {
  return false;
}" > backend/src/luhn.ts

echo "import { luhn } from '#src/luhn';

describe('luhn', () => {
  describe('valid card numbers', () => {
    it('accepts a valid Visa number', () => {
      expect(luhn('4532015112830366')).toBe(true);
    });

    // second valid card test
  });

  describe('invalid card numbers', () => {
    // first invalid card test
  });

  describe('invalid input', () => {
    // first invalid input test
  });
});" > backend/specs/luhn.spec.ts

npm run test:backend  # fails

echo "export function luhn(input: string): boolean {
  const digits = input.replace(/[\s-]/g, '');
  if (!/^\d+\$/.test(digits) || digits.length < 9) return false;
  let sum = 0;
  let double = false;
  for (let i = digits.length - 1; i >= 0; i--) {
    let digit = parseInt(digits[i], 10);
    if (double) { digit *= 2; if (digit > 9) digit -= 9; }
    sum += digit;
    double = !double;
  }
  return sum % 10 === 0;
}" > backend/src/luhn.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Implement Luhn checksum algorithm that accepts a valid Visa number"

# Test - accepts a valid Mastercard number
sed -e "/second valid card test/r"<(echo "
    it('accepts a valid Mastercard number', () => {
      expect(luhn('5425233430109903')).toBe(false);
    });

    // third valid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/5425233430109903')).toBe(false)/5425233430109903')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts a valid Mastercard number"

# Test - accepts a valid Amex number
sed -e "/third valid card test/r"<(echo "
    it('accepts a valid Amex number', () => {
      expect(luhn('378282246310005')).toBe(false);
    });

    // fourth valid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/378282246310005')).toBe(false)/378282246310005')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts a valid Amex number"

# Test - accepts a valid Discover number
sed -e "/fourth valid card test/r"<(echo "
    it('accepts a valid Discover number', () => {
      expect(luhn('6011111111111117')).toBe(false);
    });

    // fifth valid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/6011111111111117')).toBe(false)/6011111111111117')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts a valid Discover number"

# Test - accepts the canonical Luhn test number
sed -e "/fifth valid card test/r"<(echo "
    it('accepts the canonical Luhn test number', () => {
      expect(luhn('79927398713')).toBe(false);
    });

    // sixth valid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/79927398713')).toBe(false)/79927398713')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts the canonical Luhn test number"

# Test - strips spaces before validating
sed -e "/sixth valid card test/r"<(echo "
    it('strips spaces before validating', () => {
      expect(luhn('4532 0151 1283 0366')).toBe(false);
    });

    // seventh valid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/4532 0151 1283 0366')).toBe(false)/4532 0151 1283 0366')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Strips spaces before validating"

# Test - strips dashes before validating
sed -e "/seventh valid card test/r"<(echo "
    it('strips dashes before validating', () => {
      expect(luhn('4532-0151-1283-0366')).toBe(false);
    });") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/4532-0151-1283-0366')).toBe(false)/4532-0151-1283-0366')).toBe(true)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Strips dashes before validating"

# Test - rejects a number with a wrong check digit
sed -e "/first invalid card test/r"<(echo "
    it('rejects a number with a wrong check digit', () => {
      expect(luhn('4532015112830367')).toBe(true);
    });

    // second invalid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/4532015112830367')).toBe(true)/4532015112830367')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects a number with the wrong check digit"

# Test - rejects the canonical Luhn failure number
sed -e "/second invalid card test/r"<(echo "
    it('rejects the canonical Luhn failure number', () => {
      expect(luhn('79927398714')).toBe(true);
    });

    // third invalid card test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/79927398714')).toBe(true)/79927398714')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects the canonical Luhn failure number"

# Test - rejects a sequential number
sed -e "/third invalid card test/r"<(echo "
    it('rejects a sequential number', () => {
      expect(luhn('1234567890123456')).toBe(true);
    });") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/1234567890123456')).toBe(true)/1234567890123456')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects a sequential number"

# Test - rejects an empty string
sed -e "/first invalid input test/r"<(echo "
    it('rejects an empty string', () => {
      expect(luhn('')).toBe(true);
    });

    // second invalid input test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/luhn('')).toBe(true)/luhn('')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects an empty string"

# Test - rejects a non-numeric string
sed -e "/second invalid input test/r"<(echo "
    it('rejects a non-numeric string', () => {
      expect(luhn('abcd')).toBe(true);
    });

    // third invalid input test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/luhn('abcd')).toBe(true)/luhn('abcd')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects a non-numeric string"

# Test - rejects a number fewer than 9 digits
sed -e "/third invalid input test/r"<(echo "
    it('rejects a number that is too short (fewer than 9 digits)', () => {
      expect(luhn('1234')).toBe(true);
    });

    // fourth invalid input test") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/luhn('1234')).toBe(true)/luhn('1234')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects a number that is fewer than 9 digits"

# Test - rejects a single digit
sed -e "/fourth invalid input test/r"<(echo "
    it('rejects a single digit', () => {
      expect(luhn('4')).toBe(true);
    });") -i -- backend/specs/luhn.spec.ts

npm run test:backend  # fails

sed -i "s/luhn('4')).toBe(true)/luhn('4')).toBe(false)/" backend/specs/luhn.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Rejects a single digit"

###########################################################################
# 3 - Luhn algorithm — squash 14 commits                                  #
###########################################################################

git reset --soft HEAD~14
$COMMIT -m "Implement Luhn checksum algorithm"

###########################################################################
# 4 - POST /validate — RED: one test per commit                           #
###########################################################################

# Test - returns valid: true for a valid card number
echo "import Fastify, { FastifyRequest, FastifyReply } from 'fastify';
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

const validator = async (_request: FastifyRequest<{ Body: unknown }>, _reply: FastifyReply) => {
  return { valid: false };
};

fastify.post('/validate', {}, validator);" > backend/src/app.ts

echo "import supertest from 'supertest';
import { fastify } from '#src/app';

describe('POST /validate', () => {
  beforeAll(async () => { await fastify.ready(); });
  afterAll(async () => { await fastify.close(); });

  it('returns valid: true for a valid card number', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532015112830366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });

  // second validate test
});" > backend/specs/validate.spec.ts

npm run test:backend  # fails

echo "import Fastify, { FastifyRequest, FastifyReply } from 'fastify';
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

const bodySchema = {
  body: {
    type: 'object',
    required: ['cardNumber'],
    properties: {
      cardNumber: { type: 'string' },
    },
    additionalProperties: false,
  },
};

const validator = async (request: FastifyRequest<{ Body: { cardNumber: string } }>, _reply: FastifyReply) => {
  return { valid: luhn(request.body.cardNumber) };
};

fastify.post('/validate', { schema: bodySchema }, validator);" > backend/src/app.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Returns 'valid: true' for a valid card number"

# Test - returns valid: false for an invalid card number
sed -e "/second validate test/r"<(echo "
  it('returns valid: false for an invalid card number', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532015112830367' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });

  // third validate test") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/returns valid: false for an invalid card number/,/toEqual/{s/{ valid: true }/{ valid: false }/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Returns 'valid: false' for an invalid card number"

# Test - accepts card numbers with spaces
sed -e "/third validate test/r"<(echo "
  it('accepts card numbers with spaces', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532 0151 1283 0366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: false });
  });

  // fourth validate test") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/accepts card numbers with spaces/,/toEqual/{s/{ valid: false }/{ valid: true }/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts card numbers with spaces"

# Test - accepts card numbers with dashes
sed -e "/fourth validate test/r"<(echo "
  it('accepts card numbers with dashes', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532-0151-1283-0366' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: false });
  });

  // fifth validate test") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/accepts card numbers with dashes/,/toEqual/{s/{ valid: false }/{ valid: true }/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Accepts card numbers with dashes"

# Test - returns 400 when cardNumber is missing
sed -e "/fifth validate test/r"<(echo "
  it('returns 400 when cardNumber is missing', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({})
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
  });

  // sixth validate test") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/returns 400 when cardNumber is missing/,/toBe/{s/toBe(200)/toBe(400)/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Returns 400 when card number is missing"

# Test - returns 400 when cardNumber is not a string
sed -e "/sixth validate test/r"<(echo "
  it('returns 400 when cardNumber is not a string', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: 12345 })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
  });

  // seventh validate test") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/returns 400 when cardNumber is not a string/,/toBe/{s/toBe(200)/toBe(400)/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Returns 400 when card number is not a string"

# Test - returns valid: false for an empty string
sed -e "/seventh validate test/r"<(echo "
  it('returns valid: false for an empty string', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: true });
  });") -i -- backend/specs/validate.spec.ts

npm run test:backend  # fails

sed -i "/returns valid: false for an empty string/,/toEqual/{s/{ valid: true }/{ valid: false }/}" backend/specs/validate.spec.ts

npm run test:backend  # passes

git add .
$COMMIT -m "Returns valid: false for an empty string"

###########################################################################
# 5 - POST /validate — squash 7 commits                                   #
###########################################################################

git reset --soft HEAD~7
$COMMIT -m "Add POST /validate endpoint using Luhn algorithm"

###########################################################################
# 6 - Frontend card store                                                 #
###########################################################################

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): starts with null validity, not loading, and no error"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets loading to true while the request is in flight"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets isValid to true for a valid card number"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets isValid to false for an invalid card number"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets error and clears isValid when the request fails"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): calls POST /validate with the card number"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useCardStore } from '../stores/cardStore';
import { apiClient } from '../api/client';

vi.mock('../api/client', () => ({ apiClient: { post: vi.fn() } }));

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
});" > frontend/src/specs/cardStore.spec.ts
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): clears the previous error on a new request"

###########################################################################
# 7 - Frontend card store — GREEN: implement, verify, squash 8 commits → 1
###########################################################################

echo "import { create } from 'zustand';
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
}));" > frontend/src/stores/cardStore.ts

cd frontend && npm test   # 13 passed (7 cardStore + 4 appStore + 2 App routing)
cd ..

git add frontend/src/stores/cardStore.ts
$COMMIT -m "impl(cardStore): credit card validation store"

# Squash 7 test commits + 1 impl commit into one clean commit
git reset --soft HEAD~8
$COMMIT -m "Implement credit card validation store"

###########################################################################
# 8 - CardValidator component — RED: one test per commit                  #
###########################################################################

# Note: getByText(/valid/i) would collide with the "Validate" button text.
# Use getByText(/valid card number/i) — lesson learned.

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): renders a card number input"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): renders a validate button"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): does not show a result before any validation"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): calls validateCard with the entered card number on submit"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): disables the button and input while loading"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows a success alert when the card is valid"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows an error alert when the card is invalid"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider, createTheme } from '@mui/material';
import CardValidator from '../components/CardValidator';
import { useCardStore } from '../stores/cardStore';

const theme = createTheme();
const renderWithProviders = (ui: React.ReactElement) =>
  render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>);

vi.mock('../stores/cardStore', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../stores/cardStore')>();
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows an error alert when the request fails"

echo "import { describe, it, expect, vi, beforeEach } from 'vitest';
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
  return { ...actual, useCardStore: vi.fn() };
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
});" > frontend/src/specs/CardValidator.spec.tsx
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): does not submit when the input is empty"

###########################################################################
# 9 - CardValidator — GREEN: implement, verify, squash 10 commits → 1    #
###########################################################################

# Note: MUI v9 uses slotProps={{ htmlInput: ... }} not inputProps={{ ... }}

mkdir -p frontend/src/components

echo "import { useState } from 'react';
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
      component=\"form\"
      onSubmit={handleSubmit}
      noValidate
      sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}
    >
      <TextField
        label=\"Card Number\"
        value={cardNumber}
        onChange={(e) => setCardNumber(e.target.value)}
        disabled={loading}
        fullWidth
        placeholder=\"e.g. 4532 0151 1283 0366\"
        slotProps={{ htmlInput: { maxLength: 19 } }}
      />
      <Button type=\"submit\" variant=\"contained\" disabled={loading} sx={{ alignSelf: 'flex-start' }}>
        {loading ? (
          <>
            <CircularProgress size={16} color=\"inherit\" sx={{ mr: 1 }} />
            Validating...
          </>
        ) : (
          'Validate'
        )}
      </Button>
      {isValid === true && <Alert severity=\"success\">Valid card number.</Alert>}
      {isValid === false && <Alert severity=\"error\">Invalid card number.</Alert>}
      {error && <Alert severity=\"error\">{error}</Alert>}
    </Box>
  );
}" > frontend/src/components/CardValidator.tsx

echo "import { Container, Typography } from '@mui/material';
import CardValidator from '../components/CardValidator';

export default function Home() {
  return (
    <Container maxWidth=\"sm\" sx={{ mt: 6 }}>
      <Typography variant=\"h4\" gutterBottom>
        Credit Card Validator
      </Typography>
      <CardValidator />
    </Container>
  );
}" > frontend/src/pages/Home.tsx

cd frontend && npm test   # 22 passed
cd ..

git add frontend/src/components/CardValidator.tsx frontend/src/pages/Home.tsx
$COMMIT -m "impl(CardValidator): credit card validator UI"

# Squash 9 test commits + 1 impl commit into one clean commit
git reset --soft HEAD~10
$COMMIT -m "Credit card validator UI with component tests"

echo "Finis."
