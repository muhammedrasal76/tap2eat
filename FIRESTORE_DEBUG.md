# Debugging "No Menu Items Available"

## Issue
Menu screen shows "No menu items available" even after seeding data.

## Debug Steps

### Step 1: Check if data exists in Firestore

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Navigate to **Firestore Database**
3. Check the `canteens` collection
4. Click on a canteen document
5. Verify it has:
   - ✅ `name` field
   - ✅ `menu_items` field (array)
   - ✅ `is_active: true`

### Step 2: Check menu_items structure

The `menu_items` array should look like this:

```json
{
  "menu_items": [
    {
      "id": "item_001",
      "name": "Burger Combo",
      "description": "Beef burger with fries and drink",
      "price": 150.0,
      "category": "Burgers",
      "image_url": "https://...",
      "is_available": true
    }
  ]
}
```

**Important:** Each item MUST have an `id` field!

### Step 3: Run the app with debug logging

```bash
cd "tap2eat_app"
flutter run
```

Check the console output for debug messages:
```
🔍 DEBUG: Found 3 canteens
🔍 DEBUG: Canteen xyz123:
  - Name: The Grill
  - Menu items count: 3
  - First item: {id: item_001, name: Burger Combo, ...}
```

### Step 4: If menu_items is empty or null

**Option A: Reseed the database**
```bash
cd "tap2eat_app"
node firestore_seed_data.js
```

**Option B: Manually add items in Firebase Console**

1. Go to your canteen document
2. Click **Edit**
3. Add field: `menu_items` (array)
4. Add array element (map):
   ```
   id: "item_001"
   name: "Test Item"
   description: "Test description"
   price: 100
   category: "Test"
   image_url: ""
   is_available: true
   ```

### Step 5: Check Firestore Rules

Make sure your `firestore.rules` allows reading canteens:

```javascript
match /canteens/{canteenId} {
  allow read: if request.auth != null;
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
```

## Common Issues

### Issue 1: menu_items field is missing
**Fix:** Run the seed script or add manually in Firebase Console

### Issue 2: menu_items is null
**Fix:** The converter now handles null, but still need data!

### Issue 3: Items missing 'id' field
**Fix:** The converter now auto-generates IDs, but items should have them

### Issue 4: is_active is false
**Fix:** Set `is_active: true` in Firestore

### Issue 5: User not authenticated
**Fix:** Make sure you're signed in with Firebase Auth

## Expected Console Output

```
🔍 DEBUG: Found 3 canteens
🔍 DEBUG: Canteen abc123:
  - Name: The Grill
  - Menu items count: 3
  - First item: {id: item_001, name: Burger Combo, price: 150.0, ...}
HomeProvider initialization complete
```

## Still Not Working?

1. **Clear app data:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check authentication:**
   - Make sure you're signed in
   - User must be authenticated to read canteens

3. **Verify Firebase project:**
   - Check you're connected to the correct Firebase project
   - Run `firebase projects:list` to verify

4. **Check internet connection:**
   - Firestore requires internet access
   - Try on a different network

5. **Look for error messages:**
   - Check the debug console
   - Look for red error messages
   - Check `❌ ERROR` logs

## Testing with curl (Advanced)

Test if Firestore has data:
```bash
# Get your Firestore URL from Firebase Console
curl "https://firestore.googleapis.com/v1/projects/YOUR_PROJECT/databases/(default)/documents/canteens"
```

This should return JSON with your canteen data.

---

**After following these steps, you should see menu items!**

If still stuck, check:
- Are you sure the seed script ran successfully?
- Did you see "✨ Firestore seed completed successfully!"?
- Are you connected to the internet?
