import React, { useState } from 'react';

/**
 * Komponent Chat dla SpeedStudy
 * 
 * Prosty komponent React do komunikacji z backendem Express.
 * Wysyła tekst do endpointu /api/generate-summary i wyświetla odpowiedź.
 */
const Chat = () => {
  const [text, setText] = useState('');
  const [summary, setSummary] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001';

  const handleGenerateSummary = async () => {
    if (!text.trim()) {
      setError('Proszę wprowadzić tekst');
      return;
    }

    setLoading(true);
    setError('');
    setSummary('');

    try {
      const response = await fetch(`${API_URL}/api/generate-summary`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ text }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Błąd podczas generowania podsumowania');
      }

      const data = await response.json();
      setSummary(data.summary);
    } catch (err) {
      console.error('Błąd:', err);
      setError(err.message || 'Wystąpił błąd podczas komunikacji z serwerem');
    } finally {
      setLoading(false);
    }
  };

  const handleGenerateQuiz = async () => {
    if (!text.trim()) {
      setError('Proszę wprowadzić tekst');
      return;
    }

    setLoading(true);
    setError('');
    setSummary('');

    try {
      const response = await fetch(`${API_URL}/api/generate-quiz`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ text, numberOfQuestions: 5 }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Błąd podczas generowania quizu');
      }

      const data = await response.json();
      setSummary(JSON.stringify(data.quiz, null, 2));
    } catch (err) {
      console.error('Błąd:', err);
      setError(err.message || 'Wystąpił błąd podczas komunikacji z serwerem');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.title}>SpeedStudy - Chat AI</h1>
      
      <div style={styles.inputSection}>
        <label style={styles.label}>
          Wprowadź tekst do analizy:
        </label>
        <textarea
          style={styles.textarea}
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="Wpisz lub wklej tekst materiału do nauki..."
          rows={8}
          disabled={loading}
        />
      </div>

      <div style={styles.buttonGroup}>
        <button
          style={styles.button}
          onClick={handleGenerateSummary}
          disabled={loading}
        >
          {loading ? 'Generowanie...' : 'Generuj podsumowanie'}
        </button>
        <button
          style={styles.button}
          onClick={handleGenerateQuiz}
          disabled={loading}
        >
          {loading ? 'Generowanie...' : 'Generuj quiz'}
        </button>
      </div>

      {error && (
        <div style={styles.error}>
          ❌ {error}
        </div>
      )}

      {summary && (
        <div style={styles.resultSection}>
          <h2 style={styles.resultTitle}>Wynik:</h2>
          <div style={styles.result}>
            {summary}
          </div>
        </div>
      )}

      <div style={styles.info}>
        ℹ️ Upewnij się, że backend działa na {API_URL}
      </div>
    </div>
  );
};

const styles = {
  container: {
    maxWidth: '800px',
    margin: '0 auto',
    padding: '20px',
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
  },
  title: {
    textAlign: 'center',
    color: '#333',
    marginBottom: '30px',
  },
  inputSection: {
    marginBottom: '20px',
  },
  label: {
    display: 'block',
    marginBottom: '8px',
    fontWeight: '600',
    color: '#555',
  },
  textarea: {
    width: '100%',
    padding: '12px',
    fontSize: '14px',
    border: '1px solid #ddd',
    borderRadius: '4px',
    fontFamily: 'inherit',
    resize: 'vertical',
  },
  buttonGroup: {
    display: 'flex',
    gap: '10px',
    marginBottom: '20px',
  },
  button: {
    flex: 1,
    padding: '12px 24px',
    fontSize: '16px',
    fontWeight: '600',
    color: 'white',
    backgroundColor: '#007bff',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
    transition: 'background-color 0.2s',
  },
  error: {
    padding: '12px',
    backgroundColor: '#fee',
    color: '#c33',
    borderRadius: '4px',
    marginBottom: '20px',
  },
  resultSection: {
    marginTop: '20px',
  },
  resultTitle: {
    marginBottom: '10px',
    color: '#333',
  },
  result: {
    padding: '16px',
    backgroundColor: '#f8f9fa',
    border: '1px solid #dee2e6',
    borderRadius: '4px',
    whiteSpace: 'pre-wrap',
    fontFamily: 'monospace',
    fontSize: '14px',
    lineHeight: '1.6',
  },
  info: {
    marginTop: '20px',
    padding: '10px',
    backgroundColor: '#e7f3ff',
    color: '#004085',
    borderRadius: '4px',
    fontSize: '14px',
  },
};

export default Chat;
