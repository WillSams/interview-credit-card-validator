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
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
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
