const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const auth = require('../middleware/auth');
const db = require('../config/database');

router.post('/signup', authController.signup);
router.post('/login', authController.login);
router.post('/:provider', authController.socialLogin);
router.get('/users', async (req, res) => {
  try {
    const [users] = await db.query(`
      SELECT u.*, up.profile_picture, up.preferences
      FROM users u
      LEFT JOIN user_profiles up ON u.user_id = up.user_id
    `);
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching users' });
  }
});

module.exports = router; 