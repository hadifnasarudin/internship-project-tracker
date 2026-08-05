import dotenv from 'dotenv';

dotenv.config();

const port = Number(process.env.PORT ?? 5001);

if (Number.isNaN(port)) {
    throw new Error('Port must be a valid number');
}

export const env = {
    port,
    nodeEnv: process.env.NODE_ENV ?? 'development',
};  