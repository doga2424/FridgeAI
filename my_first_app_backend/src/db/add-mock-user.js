const mysql = require('mysql2/promise');
require('dotenv').config();

async function addMockUser() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  try {
    // Using a simple password for testing
    const simplePassword = 'password123';

    // Insert mock user
    const [result] = await connection.execute(
      'INSERT INTO users (email, password) VALUES (?, ?)',
      ['john@example.com', simplePassword]
    );

    console.log('Mock user added successfully!');
    console.log('User credentials:');
    console.log('Email: john@example.com');
    console.log('Password: password123');

  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      console.log('Mock user already exists!');
    } else {
      console.error('Error adding mock user:', error);
    }
  } finally {
    await connection.end();
  }
}

addMockUser(); 