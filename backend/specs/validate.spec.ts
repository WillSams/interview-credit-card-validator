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
