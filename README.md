# FridgeAI - Smart Fridge Management System

A modern web application for managing your fridge inventory with a Flutter frontend and Node.js backend.

## Quick Start

### 1. Database Setup
CREATE DATABASE fridge_app;
USE fridge_app;

### 2. Backend Setup
cd my_first_app_backend
npm install express mysql2 bcrypt jsonwebtoken cors dotenv
node src/app.js

### 3. Frontend Setup
cd my_first_app
flutter pub get
flutter run -d chrome

## Features

### Current Features
- User Authentication
  - Email/Password Login
  - Social Login (Google, GitHub, Facebook)
- Responsive UI
  - Light/Dark Theme Support
  - Animated Transitions
  - Loading States

### Planned Features
- Inventory Management
- Shopping List
- Profile Management

## Testing

### Create Test User
Visit: `http://localhost:3000/api/test/reset`

Default credentials:
Email: john@example.com
Password: password123

## API Endpoints

### Authentication
- `POST /api/auth/signup` - Create account
- `POST /api/auth/login` - Login
- `POST /api/auth/:provider` - Social login

### Test Routes (Development)
- `GET /api/test/reset` - Reset database
- `GET /api/test/users` - View users

## Configuration

### Backend (.env)
JWT_SECRET=your-secret-key-here
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=fridge_app
PORT=3000

### Database Tables
- users
- user_profiles
- social_logins
- sessions
- password_reset_tokens

## Tech Stack

### Frontend
- Flutter/Dart
- SVG Support
- HTTP Client
- Shared Preferences

### Backend
- Node.js/Express
- MySQL
- JWT Authentication
- bcrypt Password Hashing

## Development Status
- ✅ User Authentication
- ✅ Database Setup
- ✅ API Integration
- 🚧 Inventory Management
- 🚧 Shopping List
- 🚧 Profile Page

## Contributing
1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License
MIT License

## Contact
Create an issue for bugs or feature requests.