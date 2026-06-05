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
