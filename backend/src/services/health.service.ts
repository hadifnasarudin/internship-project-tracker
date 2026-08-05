export interface HealthData{
    status: string;
    timestamp: string;
    uptime: number;
}

export function getHealthStatus(): HealthData{
    return {
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
    };
}