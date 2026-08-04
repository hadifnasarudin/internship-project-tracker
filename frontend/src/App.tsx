import { useEffect, useState } from 'react';

interface HealthResponse {
  success: boolean;
  message: string;
  timestamp: string;
}

function App() {
  const [health, setHealth] = useState<HealthResponse | null>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const checkApiHealth = async () => {
      try {
        const response = await fetch('http://localhost:5001/api/health');

        if (!response.ok) {
          throw new Error('Failed to connect to the API');
        }

        const data = (await response.json()) as HealthResponse;
        setHealth(data);
      } catch (err) {
        const message =
          err instanceof Error ? err.message : 'An unexpected error occurred';

        setError(message);
      }
    };

    void checkApiHealth();
  }, []);

  return (
    <main>
      <h1>Internship Project Tracker</h1>

      {health && (
        <section>
          <h2>Backend Status</h2>
          <p>{health.message}</p>
          <p>Checked at: {health.timestamp}</p>
        </section>
      )}

      {error && <p>Backend error: {error}</p>}
    </main>
  );
}

export default App;