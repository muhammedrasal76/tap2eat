# Firestore Setup Guide

This guide will help you set up Firebase Firestore with initial seed data to test the home screen integration.

## Option 1: Automatic Seed Script (Recommended)

### Prerequisites
- Node.js installed
- Firebase Admin SDK service account key

### Steps

1. **Install dependencies:**
   ```bash
   cd "tap2eat_app"
   npm install firebase-admin
   ```

2. **Download Service Account Key:**
   - Go to Firebase Console → Project Settings → Service Accounts
   - Click "Generate new private key"
   - Save the JSON file as `service-account-key.json` in the `tap2eat_app` directory
   - **Important:** Add this file to `.gitignore` to avoid committing credentials!

3. **Update the seed script:**
   Edit `firestore_seed_data.js` and replace:
   ```javascript
   const serviceAccount = require('./service-account-key.json');
   ```

4. **Run the seed script:**
   ```bash
   node firestore_seed_data.js
   ```

This will create:
- 1 settings document with break slots
- 3 canteens with menu items
- 3 sample users (student, teacher, delivery student)
- 1 sample order

---

## Option 2: Manual Setup via Firebase Console

### 1. Create Settings Document

Navigate to: **Firestore Database → `settings` collection → `global` document**

```json
{
  "break_slots": [
    [Timestamp: Today at 10:30 AM],
    [Timestamp: Today at 1:00 PM],
    [Timestamp: Today at 3:30 PM]
  ],
  "order_cutoff_minutes": 5
}
```

### 2. Create Canteens

Navigate to: **Firestore Database → `canteens` collection**

#### Canteen 1: The Grill
```json
{
  "name": "The Grill",
  "max_concurrent_orders": 50,
  "is_active": true,
  "menu_items": [
    {
      "id": "item_001",
      "name": "Burger Combo",
      "description": "Beef burger with fries and drink",
      "price": 150.0,
      "category": "Burgers",
      "image_url": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop",
      "is_available": true
    },
    {
      "id": "item_002",
      "name": "Grilled Chicken",
      "description": "Grilled chicken with vegetables",
      "price": 180.0,
      "category": "Grilled",
      "image_url": "https://images.unsplash.com/photo-1562967914-608f82629710?w=300&h=200&fit=crop",
      "is_available": true
    }
  ]
}
```

#### Canteen 2: Pasta Paradise
```json
{
  "name": "Pasta Paradise",
  "max_concurrent_orders": 40,
  "is_active": true,
  "menu_items": [
    {
      "id": "item_004",
      "name": "Spaghetti Carbonara",
      "description": "Creamy pasta with bacon",
      "price": 200.0,
      "category": "Pasta",
      "image_url": "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300&h=200&fit=crop",
      "is_available": true
    },
    {
      "id": "item_005",
      "name": "Margherita Pizza",
      "description": "Classic tomato and mozzarella pizza",
      "price": 250.0,
      "category": "Pizza",
      "image_url": "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=200&fit=crop",
      "is_available": true
    }
  ]
}
```

### 3. Create Test Users

Navigate to: **Firestore Database → `users` collection**

#### Student User (Document ID: `sample_student_user`)
```json
{
  "role": "student",
  "email": "student@example.com",
  "name": "John Student",
  "class_id": "CSE-3A",
  "created_at": [Server Timestamp]
}
```

#### Teacher User (Document ID: `sample_teacher_user`)
```json
{
  "role": "teacher",
  "email": "teacher@example.com",
  "name": "Dr. Sarah Teacher",
  "designation": "Professor",
  "created_at": [Server Timestamp]
}
```

### 4. Update Firestore Security Rules

Make sure your `firestore.rules` allows read access for testing:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read canteens and settings
    match /canteens/{canteenId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }

    match /settings/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }

    // Users can read their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false; // Use Cloud Functions for order operations
    }

    // Users can read their own profile
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false; // Only admin can write
    }
  }
}
```

---

## Testing the Home Screen

After seeding the data:

1. **Run the Flutter app:**
   ```bash
   flutter run
   ```

2. **Sign in with Firebase Authentication** (you'll need to create test users in Firebase Authentication that match the Firestore user documents)

3. **Navigate to the Home Screen** - you should see:
   - Welcome message with user name
   - Search bar for canteens
   - List of canteens with menu items
   - Recent orders (if any exist for the user)

## Troubleshooting

### "Settings document not found" error
- Make sure the settings document is at path: `settings/global`
- Verify the document exists in Firebase Console

### Canteens not loading
- Check Firestore rules allow read access for authenticated users
- Verify the user is signed in with Firebase Authentication
- Check the Flutter debug console for error messages

### Recent orders not showing
- This is normal if the signed-in user has no orders
- Orders will only show for the specific user_id that matches the authenticated user

### Images not loading
- The seed data uses placeholder images from Unsplash
- You can replace these URLs with your own image URLs or local assets

## Next Steps

After successfully testing with seed data:

1. Build the menu browsing feature
2. Implement order placement functionality
3. Add order tracking
4. Implement delivery features
5. Build the admin panel

## Data Schema Reference

See `prd.md` and `tap2eat_app/spec/scope.md` for complete data model specifications (D1-D4).
