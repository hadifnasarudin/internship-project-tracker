import cors from 'cors';
import express from 'express';

import { errorHandler } from './middleware/error-handler.middleware.js';
import { notFoundHandler } from './middleware/not-found.middleware.js';
import apiRouter from './routes/index.js';

const app = express();

app.disable('x-powered-by');

app.use(cors());

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.get('/', (_request, response) => {
  response.status(200).json({
    success: true,
    message: 'Welcome to Internship Project Tracker API',
  });
});

app.use('/api', apiRouter);

app.use(notFoundHandler);

app.use(errorHandler);

export default app;