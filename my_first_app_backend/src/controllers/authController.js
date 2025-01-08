const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../config/database');
const config = require('../config/config');

const generateToken = (userId) => {
  return jwt.sign({ userId }, config.jwt.secret, { expiresIn: config.jwt.expiresIn });
};

exports.signup = async (req, res) => {
  const { fullName, email, password } = req.body;
  
  try {
    // Check if user exists
    const [existingUsers] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    
    if (existingUsers.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const [result] = await db.query(
      'INSERT INTO users (full_name, email, password_hash) VALUES (?, ?, ?)',
      [fullName, email, hashedPassword]
    );

    const token = generateToken(result.insertId);

    res.status(201).json({
      message: 'User created successfully',
      token,
      user: {
        id: result.insertId,
        fullName,
        email
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error creating user', error: error.message });
  }
};

exports.login = async (req, res) => {
  console.log('Login attempt:', req.body);
  const { email, password } = req.body;

  try {
    // Find user
    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    console.log('Found users:', users);
    
    if (users.length === 0) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid email or password' 
      });
    }

    const user = users[0];

    // Compare password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    
    if (!isValidPassword) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid email or password' 
      });
    }

    // Generate token
    const token = jwt.sign({ userId: user.user_id }, config.jwt.secret, {
      expiresIn: config.jwt.expiresIn
    });

    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.user_id,
          fullName: user.full_name,
          email: user.email
        }
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error logging in', 
      error: error.message 
    });
  }
};

exports.socialLogin = async (req, res) => {
  const { provider, token, email, fullName, providerId } = req.body;

  try {
    // Check if user exists
    let [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    let userId;

    if (users.length === 0) {
      // Create new user
      const [result] = await db.query(
        'INSERT INTO users (full_name, email) VALUES (?, ?)',
        [fullName, email]
      );
      userId = result.insertId;
    } else {
      userId = users[0].user_id;
    }

    // Add or update social login
    await db.query(
      'INSERT INTO social_logins (user_id, provider, provider_user_id) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE provider_user_id = ?',
      [userId, provider, providerId, providerId]
    );

    const authToken = generateToken(userId);

    res.json({
      token: authToken,
      user: {
        id: userId,
        fullName,
        email
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error with social login', error: error.message });
  }
}; 