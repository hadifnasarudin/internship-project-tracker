import type { ErrorRequestHandler } from 'express';

import { AppError } from '../errors/app-error.js';
import { env } from '../config/env.js';

export const errorHandler: ErrorRequestHandler = (
  error,
  _request,
  response,
  _next,
) => {
  if (error instanceof AppError) {
    response.status(error.statusCode).json({
      success: false,
      message: error.message,
    });

    return;
  }

  console.error(error);

  response.status(500).json({
    success: false,
    message:
      env.nodeEnv === 'production'
        ? 'Internal server error'
        : error instanceof Error
          ? error.message
          : 'Unknown error',
  });
};