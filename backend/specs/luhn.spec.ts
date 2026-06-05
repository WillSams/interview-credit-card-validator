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
