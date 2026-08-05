import type { Request, Response } from 'express';

import { getHealthStatus } from '../services/health.service.js';
import type { ApiResponse } from '../types/api-response.js';
import type { HealthData } from '../services/health.service.js';

export function getHealth(_request:Request, 
    response: Response<ApiResponse<HealthData>>): void {
        const healthData = getHealthStatus();

        response.status(200).json({
            success: true,
            message: 'Internship Project Tracker API is running',
            data: healthData,
        });
}