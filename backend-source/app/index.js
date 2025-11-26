require('dotenv').config();
const express = require('express');
const { pool } = require('./db');

const app = express();
const PORT = process.env.PORT || 8000;

app.use(express.json());

// Basic health check endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'success',
    message: 'Node.js application is running!',
    timestamp: new Date()
  });
});

// Database test endpoint
app.get('/db-test', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({
      status: 'success',
      message: 'Database connection successful!',
      data: result.rows[0],
      timestamp: new Date()
    });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Database connection failed',
      error: error.message
    });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
