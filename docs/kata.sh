#!/bin/bash

# Credit Card Validator Kata
#
# Goal: Build a full-stack credit card validator using TDD.
#       Validation uses the Luhn checksum algorithm and runs
#       exclusively in the backend.
#
# TDD workflow per suite:
#   RED   — write one failing test, commit it
#   GREEN — once all suite tests pass, commit the implementation
#   SQUASH — squash all suite commits into one clean commit
#
# Prerequisites:
#   - Node.js 22+ (via nvm)
#   - git with GPG signing configured (commit.gpgsign = true)
#
# Update (June 5th) - painstakingly updated to align with what
# I originally did sans the commitizen-style commits.  The 
# commitizen-style commits are here for readability

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
# 2 - Luhn algorithm — RED: one test per commit                           #
###########################################################################

cat << 'EOF' > backend/specs/luhn.spec.ts
import { luhn } from '#src/luhn';

describe('luhn', () => {
  describe('valid card numbers', () => {
    it('accepts a valid Visa number', () => {
      expect(luhn('4532015112830366')).toBe(true);
    });
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): accepts a valid Visa number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): accepts a valid Mastercard number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): accepts a valid Amex number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): accepts a valid Discover number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): accepts the canonical Luhn test number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): strips spaces before validating"

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
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): strips dashes before validating"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects a number with a wrong check digit"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects the canonical Luhn failure number"

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
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects a sequential number"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects an empty string"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects a non-numeric string"

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
  });
});
EOF
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects a number that is too short"

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
git add backend/specs/luhn.spec.ts
$COMMIT -m "test(luhn): rejects a single digit"

###########################################################################
# 3 - Luhn algorithm — GREEN: implement, verify, squash 15 commits → 1   #
###########################################################################

# Key insight: traverse digits right-to-left, doubling every second digit.
# If doubling exceeds 9, subtract 9. Sum must be divisible by 10.

cat << 'EOF' > backend/src/luhn.ts
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

cd backend && npm test   # 15 passed (14 luhn + 1 existing app spec)
cd ..

git add backend/src/luhn.ts
$COMMIT -m "impl(luhn): Luhn checksum algorithm"

# Squash 14 test commits + 1 impl commit into one clean commit
git reset --soft HEAD~15
$COMMIT -m "Implement Luhn checksum algorithm"

###########################################################################
# 4 - POST /validate — RED: one test per commit                           #
###########################################################################

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): returns valid: true for a valid card number"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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

  it('returns valid: false for an invalid card number', async () => {
    const response = await supertest(fastify.server)
      .post('/validate')
      .send({ cardNumber: '4532015112830367' })
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ valid: false });
  });
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): returns valid: false for an invalid card number"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): accepts card numbers with spaces"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): accepts card numbers with dashes"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): returns 400 when cardNumber is missing"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
});
EOF
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): returns 400 when cardNumber is not a string"

cat << 'EOF' > backend/specs/validate.spec.ts
import supertest from 'supertest';
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
git add backend/specs/validate.spec.ts
$COMMIT -m "test(validate): returns valid: false for an empty string"

###########################################################################
# 5 - POST /validate — GREEN: implement, verify, squash 8 commits → 1    #
###########################################################################

# coerceTypes: false prevents AJV from silently casting numbers to strings.
# JSON schema validation gives us the 400 responses for free.

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

cd backend && npm test   # 22 passed (14 luhn + 7 validate + 1 existing app spec)
cd ..

git add backend/src/app.ts
$COMMIT -m "impl(validate): POST /validate endpoint"

# Squash 7 test commits + 1 impl commit into one clean commit
git reset --soft HEAD~8
$COMMIT -m "add POST /validate endpoint using Luhn algorithm"

###########################################################################
# 6 - Frontend card store — RED: one test per commit                      #
###########################################################################

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): starts with null validity, not loading, and no error"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets loading to true while the request is in flight"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets isValid to true for a valid card number"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets isValid to false for an invalid card number"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): sets error and clears isValid when the request fails"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): calls POST /validate with the card number"

cat << 'EOF' > frontend/src/specs/cardStore.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/cardStore.spec.ts
$COMMIT -m "test(cardStore): clears the previous error on a new request"

###########################################################################
# 7 - Frontend card store — GREEN: implement, verify, squash 8 commits → 1
###########################################################################

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

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): renders a card number input"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): renders a validate button"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): does not show a result before any validation"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): calls validateCard with the entered card number on submit"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): disables the button and input while loading"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows a success alert when the card is valid"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows an error alert when the card is invalid"

cat << 'EOF' > frontend/src/specs/CardValidator.spec.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): shows an error alert when the request fails"

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
});
EOF
git add frontend/src/specs/CardValidator.spec.tsx
$COMMIT -m "test(CardValidator): does not submit when the input is empty"

###########################################################################
# 9 - CardValidator — GREEN: implement, verify, squash 10 commits → 1    #
###########################################################################

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

cd frontend && npm test   # 22 passed
cd ..

git add frontend/src/components/CardValidator.tsx frontend/src/pages/Home.tsx
$COMMIT -m "impl(CardValidator): credit card validator UI"

# Squash 9 test commits + 1 impl commit into one clean commit
git reset --soft HEAD~10
$COMMIT -m "Credit card validator UI with component tests"

echo "Finis."
