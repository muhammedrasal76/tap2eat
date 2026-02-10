# Firebase Firestore REST API - Testing Guide

## 🔗 API Endpoint for Canteens

### Base URL
```
https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents
```

### Get All Canteens
```
GET https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens
```

### Get Specific Canteen
```
GET https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens/{canteenId}
```

Replace `{canteenId}` with actual canteen document ID (e.g., `abc123`)

---

## 📮 Postman Setup

### Method 1: Public Access (No Auth - for testing only)

If your Firestore rules allow unauthenticated reads:

**Request:**
- **Method:** GET
- **URL:** `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens`
- **Headers:** None required

**Note:** This only works if your `firestore.rules` has:
```javascript
match /canteens/{canteenId} {
  allow read: if true;  // Allow public reads
}
```

### Method 2: With API Key

**Request:**
- **Method:** GET
- **URL:** `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens?key=YOUR_API_KEY`
- **Headers:** None required

**Get API Key:**
1. Go to [Firebase Console](https://console.firebase.google.com/project/tap2eat-7642c/settings/general)
2. Scroll to "Web API Key"
3. Copy the key

**Example:**
```
https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens?key=AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Method 3: With Authentication Token (Most Secure)

**Request:**
- **Method:** GET
- **URL:** `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens`
- **Headers:**
  ```
  Authorization: Bearer YOUR_ID_TOKEN
  ```

**Get ID Token:**

Option A - Using Firebase Auth REST API:
```bash
# Sign in to get ID token
curl -X POST \
  'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=YOUR_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "student@example.com",
    "password": "your-password",
    "returnSecureToken": true
  }'
```

Response will include `idToken` - use that in Authorization header.

Option B - Get from Flutter app:
```dart
final user = FirebaseAuth.instance.currentUser;
final idToken = await user?.getIdToken();
print('ID Token: $idToken');
```

---

## 📊 Query Parameters

### Filter Active Canteens Only
```
https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens?structuredQuery={
  "where": {
    "fieldFilter": {
      "field": {"fieldPath": "is_active"},
      "op": "EQUAL",
      "value": {"booleanValue": true}
    }
  }
}
```

**Note:** URL encode the JSON when using in Postman.

### Simplified Query (use :runQuery endpoint)
```
POST https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents:runQuery
```

**Body (JSON):**
```json
{
  "structuredQuery": {
    "from": [{"collectionId": "canteens"}],
    "where": {
      "fieldFilter": {
        "field": {"fieldPath": "is_active"},
        "op": "EQUAL",
        "value": {"booleanValue": true}
      }
    }
  }
}
```

---

## 🧪 Postman Collection Examples

### Example 1: Get All Canteens (Simple)

**Postman Setup:**
1. Create new request
2. Method: `GET`
3. URL: `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens`
4. Click **Send**

**Expected Response:**
```json
{
  "documents": [
    {
      "name": "projects/tap2eat-7642c/databases/(default)/documents/canteens/abc123",
      "fields": {
        "name": {
          "stringValue": "The Grill"
        },
        "is_active": {
          "booleanValue": true
        },
        "max_concurrent_orders": {
          "integerValue": "50"
        },
        "menu_items": {
          "arrayValue": {
            "values": [
              {
                "mapValue": {
                  "fields": {
                    "name": {"stringValue": "Burger Combo"},
                    "price": {"doubleValue": 150.0},
                    "category": {"stringValue": "Burgers"}
                  }
                }
              }
            ]
          }
        }
      }
    }
  ]
}
```

### Example 2: Get Specific Canteen

**Postman Setup:**
1. Method: `GET`
2. URL: `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens/YOUR_CANTEEN_ID`
3. Replace `YOUR_CANTEEN_ID` with actual ID from previous response

### Example 3: Query Active Canteens

**Postman Setup:**
1. Method: `POST`
2. URL: `https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents:runQuery`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
```json
{
  "structuredQuery": {
    "from": [{"collectionId": "canteens"}],
    "where": {
      "fieldFilter": {
        "field": {"fieldPath": "is_active"},
        "op": "EQUAL",
        "value": {"booleanValue": true}
      }
    }
  }
}
```

---

## 🔑 Getting Your API Key

### Step 1: Firebase Console
1. Go to https://console.firebase.google.com/
2. Select project: **tap2eat-7642c**
3. Click gear icon (⚙️) → **Project settings**
4. Scroll to **Web API Key**
5. Copy the key (starts with `AIzaSy...`)

### Step 2: Test in Postman
```
https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens?key=YOUR_COPIED_KEY
```

---

## 📋 Quick Reference

| Action | Method | URL |
|--------|--------|-----|
| List all canteens | GET | `/canteens` |
| Get one canteen | GET | `/canteens/{id}` |
| Query canteens | POST | `/canteens:runQuery` |
| List settings | GET | `/settings/global` |
| List all orders | GET | `/orders` |
| List users | GET | `/users` |

**Full Base Path:**
```
https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents
```

---

## 🐛 Troubleshooting

### Error: Permission Denied
**Solution:** Add API key or ID token, or update Firestore rules to allow reads:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /canteens/{canteenId} {
      allow read: if true;  // Temporary for testing
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
```

### Error: Not Found
**Solution:** Check:
- Project ID is correct: `tap2eat-7642c`
- Collection name is correct: `canteens`
- Database ID is correct: `(default)`

### Error: Invalid API Key
**Solution:**
1. Get fresh API key from Firebase Console
2. Make sure it's Web API Key (not Server Key)
3. Enable required APIs in Google Cloud Console

---

## 🎯 Testing Workflow

1. **First:** Test without auth to see if data exists
   ```
   GET https://firestore.googleapis.com/v1/projects/tap2eat-7642c/databases/(default)/documents/canteens
   ```

2. **If permission denied:** Add `?key=YOUR_API_KEY`

3. **Verify data structure:** Check response has `menu_items` array

4. **Test filtering:** Use `:runQuery` with filters

5. **Compare with app:** Make sure API response matches what app expects

---

## 💡 Pro Tips

1. **Use Postman Collections:** Save all requests as a collection for reuse
2. **Environment Variables:** Store API key and project ID as Postman variables
3. **Pretty Print:** Add `?prettyPrint=true` to URL for formatted JSON
4. **Inspect Network Tab:** In Flutter app, check actual API calls in DevTools

---

## 📱 Example: Compare API vs App

### API Response (Firestore REST):
```json
{
  "fields": {
    "name": {"stringValue": "Burger"},
    "price": {"doubleValue": 150.0}
  }
}
```

### App Expects (after parsing):
```json
{
  "name": "Burger",
  "price": 150.0
}
```

The app's models automatically convert between these formats! ✅

---

**Ready to test? Start with the simple GET request and verify your data exists!** 🚀
