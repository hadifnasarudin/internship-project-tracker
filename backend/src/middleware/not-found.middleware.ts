import type { NextFunction, Request, Response } from 'express';

import { AppError } from '../errors/app-error.js';

export function notFoundHandler(
  request: Request,
  _response: Response,
  next: NextFunction,
): void {
  next(
    new AppError(
      `Route ${request.method} ${request.originalUrl} not found`,
      404,
    ),
  );
}