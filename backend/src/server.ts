import app from './app.js';
import { env } from './config/env.js';

const server = app.listen(env.port, () => {
  console.log(
    `Server running in ${env.nodeEnv} mode at http://localhost:${env.port}`,
  );
});

function shutdown(signal: string): void {
  console.log(`${signal} received. Closing server...`);

  server.close(() => {
    console.log('Server closed successfully');
    process.exit(0);
  });
}

process.on('SIGINT', () => {
  shutdown('SIGINT');
});

process.on('SIGTERM', () => {
  shutdown('SIGTERM');
});