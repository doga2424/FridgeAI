const express = require('express');
const router = express.Router();
const db = require('../config/database');
const bcrypt = require('bcrypt');

router.all('/seed', async (req, res) => {
  try {
    // Clear existing data (optional)
    await db.query('DELETE FROM social_logins');
    await db.query('DELETE FROM user_profiles');
    await db.query('DELETE FROM users');

    // Mock users data
    const users = [
      {
        name: 'John',
        surname: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        profile: {
          picture: 'john_profile.jpg',
          preferences: { theme: 'light', notifications: true }
        },
        social: { provider: 'google', providerId: 'google_123' }
      },
      {
        name: 'Jane',
        surname: 'Smith',
        email: 'jane@example.com',
        password: 'password123',
        profile: {
          picture: 'jane_profile.jpg',
          preferences: { theme: 'dark', notifications: false }
        },
        social: { provider: 'facebook', providerId: 'facebook_456' }
      },
      {
        name: 'Bob',
        surname: 'Wilson',
        email: 'bob@example.com',
        password: 'password123',
        profile: {
          picture: 'bob_profile.jpg',
          preferences: { theme: 'light', notifications: true }
        },
        social: { provider: 'github', providerId: 'github_789' }
      }
    ];

    // Insert users
    for (const user of users) {
      const hashedPassword = await bcrypt.hash(user.password, 10);
      
      // Insert user with separate name fields
      const [userResult] = await db.query(
        'INSERT INTO users (name, surname, email, password_hash) VALUES (?, ?, ?, ?)',
        [user.name, user.surname, user.email, hashedPassword]
      );

      // Insert profile
      await db.query(
        'INSERT INTO user_profiles (user_id, profile_picture, preferences) VALUES (?, ?, ?)',
        [userResult.insertId, user.profile.picture, JSON.stringify(user.profile.preferences)]
      );

      // Insert social login
      await db.query(
        'INSERT INTO social_logins (user_id, provider, provider_user_id) VALUES (?, ?, ?)',
        [userResult.insertId, user.social.provider, user.social.providerId]
      );
    }

    res.json({ 
      message: 'Test data added successfully',
      testCredentials: users.map(u => ({ email: u.email, password: u.password }))
    });
  } catch (error) {
    console.error('Error seeding test data:', error);
    res.status(500).json({ message: 'Error seeding test data', error: error.message });
  }
});

// Add a route to view all users with their profiles
router.get('/users', async (req, res) => {
  try {
    const [users] = await db.query(`
      SELECT 
        u.user_id,
        u.name,
        u.surname,
        u.email,
        u.created_at,
        up.profile_picture,
        up.preferences,
        sl.provider as social_provider
      FROM users u
      LEFT JOIN user_profiles up ON u.user_id = up.user_id
      LEFT JOIN social_logins sl ON u.user_id = sl.user_id
    `);
    res.json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ message: 'Error fetching users', error: error.message });
  }
});

router.all('/reset', async (req, res) => {
  try {
    // Clear existing data
    await db.query('DELETE FROM social_logins');
    await db.query('DELETE FROM user_profiles');
    await db.query('DELETE FROM users');

    // Create test user with known password
    const hashedPassword = await bcrypt.hash('password123', 10);
    const [userResult] = await db.query(
      'INSERT INTO users (name, surname, email, password_hash) VALUES (?, ?, ?, ?)',
      ['John', 'Doe', 'john@example.com', hashedPassword]
    );

    // Add profile
    await db.query(
      'INSERT INTO user_profiles (user_id, profile_picture, preferences) VALUES (?, ?, ?)',
      [userResult.insertId, 'john_profile.jpg', JSON.stringify({ theme: 'light', notifications: true })]
    );

    res.json({ 
      message: 'Test user created',
      credentials: {
        email: 'john@example.com',
        password: 'password123'
      }
    });
  } catch (error) {
    console.error('Error creating test user:', error);
    res.status(500).json({ message: 'Error creating test user' });
  }
});

module.exports = router; 