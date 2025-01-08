const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const initializeDatabase = require('./config/init-db');
const testRoutes = require('./routes/testRoutes');

const app = express();

app.use(cors({
  origin: '*', // Be more restrictive in production
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Initialize database when app starts
initializeDatabase().catch(console.error);

app.use('/api/auth', authRoutes);

// Only add test routes in development
if (process.env.NODE_ENV !== 'production') {
  app.use('/api/test', testRoutes);
}

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 