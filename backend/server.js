// Backend Express + OpenAI API dla SpeedStudy
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Sprawdzenie czy klucz API jest ustawiony
if (!process.env.OPENAI_API_KEY) {
  console.warn('⚠️  OSTRZEŻENIE: OPENAI_API_KEY nie jest ustawiony w zmiennych środowiskowych!');
  console.warn('   Ustaw go w pliku .env lub zmiennej środowiskowej przed uruchomieniem.');
}

// Endpoint zdrowotny
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'SpeedStudy Backend działa',
    hasApiKey: !!process.env.OPENAI_API_KEY 
  });
});

// Endpoint do generowania podsumowania
app.post('/api/generate-summary', async (req, res) => {
  try {
    const { text } = req.body;

    if (!text) {
      return res.status(400).json({ 
        error: 'Brak tekstu do przetworzenia',
        message: 'Pole "text" jest wymagane' 
      });
    }

    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ 
        error: 'Brak konfiguracji API',
        message: 'OPENAI_API_KEY nie jest ustawiony' 
      });
    }

    // Wywołanie OpenAI API
    const fetch = (await import('node-fetch')).default;
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'Jesteś asystentem edukacyjnym. Twórz zwięzłe i pomocne podsumowania materiałów do nauki.'
          },
          {
            role: 'user',
            content: `Utwórz podsumowanie następującego tekstu:\n\n${text}`
          }
        ],
        temperature: 0.7,
        max_tokens: 500
      })
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Błąd OpenAI API:', errorData);
      return res.status(response.status).json({ 
        error: 'Błąd API OpenAI',
        details: errorData 
      });
    }

    const data = await response.json();
    const summary = data.choices[0].message.content;

    res.json({ 
      summary,
      usage: data.usage 
    });

  } catch (error) {
    console.error('Błąd podczas generowania podsumowania:', error);
    res.status(500).json({ 
      error: 'Błąd serwera',
      message: error.message 
    });
  }
});

// Endpoint do generowania quizu
app.post('/api/generate-quiz', async (req, res) => {
  try {
    const { text, numberOfQuestions = 5 } = req.body;

    if (!text) {
      return res.status(400).json({ 
        error: 'Brak tekstu do przetworzenia',
        message: 'Pole "text" jest wymagane' 
      });
    }

    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ 
        error: 'Brak konfiguracji API',
        message: 'OPENAI_API_KEY nie jest ustawiony' 
      });
    }

    // Wywołanie OpenAI API
    const fetch = (await import('node-fetch')).default;
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'Jesteś asystentem edukacyjnym. Twórz pytania quizowe w formacie JSON.'
          },
          {
            role: 'user',
            content: `Na podstawie poniższego tekstu, wygeneruj ${numberOfQuestions} pytań quizowych. Odpowiedź w formacie JSON:\n[{"question": "pytanie", "options": ["A", "B", "C", "D"], "correct": 0}]\n\nTekst:\n${text}`
          }
        ],
        temperature: 0.8,
        max_tokens: 1000
      })
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Błąd OpenAI API:', errorData);
      return res.status(response.status).json({ 
        error: 'Błąd API OpenAI',
        details: errorData 
      });
    }

    const data = await response.json();
    const quizContent = data.choices[0].message.content;

    // Próba parsowania JSON (może być otoczony markdown)
    let quiz;
    try {
      const jsonMatch = quizContent.match(/\[[\s\S]*\]/);
      quiz = JSON.parse(jsonMatch ? jsonMatch[0] : quizContent);
    } catch (parseError) {
      quiz = { raw: quizContent };
    }

    res.json({ 
      quiz,
      usage: data.usage 
    });

  } catch (error) {
    console.error('Błąd podczas generowania quizu:', error);
    res.status(500).json({ 
      error: 'Błąd serwera',
      message: error.message 
    });
  }
});

// Uruchomienie serwera
app.listen(PORT, () => {
  console.log(`🚀 SpeedStudy Backend uruchomiony na porcie ${PORT}`);
  console.log(`   Health check: http://localhost:${PORT}/health`);
  console.log(`   API Key: ${process.env.OPENAI_API_KEY ? '✓ ustawiony' : '✗ brak'}`);
});
