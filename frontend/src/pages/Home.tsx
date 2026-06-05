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
