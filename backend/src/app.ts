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
