# Firebase Firestore Database Setup Guide for Tap2Eat Home Screen

## Overview
This guide explains the complete Firebase Firestore database structure needed to support the home screen features (canteens display, recent orders, settings for Time Lock Policy).

## Database Architecture

Your Firestore database needs **3 collections** and **1 global settings document**:

1. **`canteens`** collection - Stores all canteen information
2. **`orders`** collection - Stores all order history
3. **`users`** collection - Stores user profiles (already exists for auth)
4. **`global/settings`** document - Stores app-wide settings like break times

---

## Collection 1: `canteens` (D4 Schema)

### Purpose
Stores information about each canteen including menu items, operational status, and order capacity limits.

### Collection Path
```
/canteens/{canteenId}
```

### Document Structure
Each canteen document should have these fields:

| Field Name | Type | Required | Description | Example |
|------------|------|----------|-------------|---------|
| `name` | string | ✅ | Name of the canteen | "The Grill" |
| `menu_items` | array | ✅ | Array of menu item objects | See Menu Item structure below |
| `max_concurrent_orders` | number | ✅ | Max orders allowed per time slot | 50 |
| `is_active` | boolean | ✅ | Whether canteen is currently open | true |
| `image_url` | string | ❌ | URL to canteen image | "https://..." |

### Menu Item Object Structure (nested in menu_items array)
Each object in the `menu_items` array should have:

| Field Name | Type | Required | Description | Example |
|------------|------|----------|-------------|---------|
| `id` | string | ✅ | Unique menu item ID | "item_001" |
| `name` | string | ✅ | Name of the dish | "Burger Combo" |
| `description` | string | ✅ | Description of the dish | "Beef burger with fries" |
| `price` | number | ✅ | Price in rupees | 150.0 |
| `category` | string | ✅ | Food category | "Burgers" |
| `image_url` | string | ✅ | URL to food image | "https://..." |
| `is_available` | boolean | ✅ | Whether item is currently available | true |

### Example Canteen Document

```json
{
  "name": "The Grill",
  "is_active": true,
  "max_concurrent_orders": 50,
  "image_url": "https://example.com/canteen-grill.jpg",
  "menu_items": [
    {
      "id": "item_001",
      "name": "Burger Combo",
      "description": "Beef burger with fries and drink",
      "price": 150.0,
      "category": "Burgers",
      "image_url": "https://example.com/burger.jpg",
      "is_available": true
    },
    {
      "id": "item_002",
      "name": "Grilled Chicken",
      "description": "Grilled chicken with vegetables",
      "price": 180.0,
      "category": "Grilled",
      "image_url": "https://example.com/chicken.jpg",
      "is_available": true
    }
  ]
}
```

### How to Create in Firebase Console

1. Go to Firebase Console → Firestore Database
2. Click "Start collection"
3. Collection ID: `canteens`
4. Add first document with auto-generated ID or custom ID like `canteen_001`
5. Add all fields listed above
6. For `menu_items`, click "Add field" → Type: "array" → Add objects with the structure shown

---

## Collection 2: `orders` (D2 Schema)

### Purpose
Stores all order history for all users. The home screen queries this to show "Recently Ordered" items.

### Collection Path
```
/orders/{orderId}
```

### Document Structure

| Field Name | Type | Required | Description | Example |
|------------|------|----------|-------------|---------|
| `user_id` | string | ✅ | User who placed the order | "user123" |
| `canteen_id` | string | ✅ | Reference to canteen document ID | "canteen_001" |
| `items` | array | ✅ | Array of ordered items | See Order Item structure below |
| `total_amount` | number | ✅ | Total order amount | 300.0 |
| `fulfillment_slot` | timestamp | ✅ | When order should be ready | Firestore Timestamp |
| `fulfillment_type` | string | ✅ | "pickup" or "delivery" | "pickup" |
| `status` | string | ✅ | Order status | "completed" |
| `delivery_student_id` | string | ❌ | Delivery student (if delivery) | "user456" |
| `delivery_fee` | number | ❌ | Delivery fee (if delivery) | 20.0 |
| `created_at` | timestamp | ✅ | When order was created | Firestore Timestamp |
| `updated_at` | timestamp | ✅ | Last update time | Firestore Timestamp |

### Order Item Object Structure (nested in items array)

| Field Name | Type | Required | Description | Example |
|------------|------|----------|-------------|---------|
| `menu_item_id` | string | ✅ | Reference to menu item | "item_001" |
| `name` | string | ✅ | Item name (for display) | "Burger Combo" |
| `quantity` | number | ✅ | Number of items ordered | 2 |
| `price` | number | ✅ | Price per item | 150.0 |
| `image_url` | string | ❌ | Item image URL | "https://..." |

### Valid Values for Enums

**`fulfillment_type`:**
- `"pickup"` - Student picks up from canteen
- `"delivery"` - Delivered to teacher (only during break times)

**`status`:**
- `"pending"` - Order placed, waiting
- `"preparing"` - Canteen is preparing
- `"ready"` - Ready for pickup/delivery
- `"assigned"` - Delivery assigned (delivery only)
- `"delivering"` - Being delivered (delivery only)
- `"delivered"` - Delivery completed
- `"completed"` - Order picked up or delivered
- `"cancelled"` - Order was cancelled

### Example Order Document

```json
{
  "user_id": "user123",
  "canteen_id": "canteen_001",
  "items": [
    {
      "menu_item_id": "item_001",
      "name": "Burger Combo",
      "quantity": 2,
      "price": 150.0,
      "image_url": "https://example.com/burger.jpg"
    }
  ],
  "total_amount": 300.0,
  "fulfillment_slot": "2025-01-15T13:00:00.000Z",
  "fulfillment_type": "pickup",
  "status": "completed",
  "delivery_student_id": null,
  "delivery_fee": null,
  "created_at": "2025-01-15T12:30:00.000Z",
  "updated_at": "2025-01-15T13:15:00.000Z"
}
```

### How to Create in Firebase Console

1. Go to Firestore Database → Start collection
2. Collection ID: `orders`
3. Add document with auto-generated ID
4. Add all fields listed above
5. **Important for timestamps:**
   - Click field type dropdown → Select "timestamp"
   - Use current date/time or set specific time
6. For `items` array, add objects with the structure shown

---

## Document 3: `global/settings` (D3 Schema)

### Purpose
Stores global app settings, particularly break time slots for the Time Lock Policy (controls when delivery students can go online).

### Document Path
```
/global/settings
```

**Note:** This is a single document, not a collection. The collection is `global`, and `settings` is the document ID.

### Document Structure

| Field Name | Type | Required | Description | Example |
|------------|------|----------|-------------|---------|
| `break_slots` | array | ✅ | Array of Firestore Timestamps for break times | Array of timestamps |
| `order_cutoff_minutes` | number | ✅ | Minutes in advance orders must be placed | 5 |

### Example Settings Document

```json
{
  "break_slots": [
    "2025-01-15T10:30:00.000Z",
    "2025-01-15T13:00:00.000Z",
    "2025-01-15T15:30:00.000Z"
  ],
  "order_cutoff_minutes": 5
}
```

### Break Slots Explanation

Each timestamp in `break_slots` represents the **start time** of a 1-hour break period. The app uses `TimeLockHelper` to check if the current time falls within any break slot ± 1 hour.

**Example:**
- If `break_slots` contains `2025-01-15T13:00:00.000Z` (1:00 PM)
- The break period is from **1:00 PM to 2:00 PM**
- Delivery students can only see "Go Online" button during this window

### How to Create in Firebase Console

1. Go to Firestore Database
2. Click "Start collection"
3. Collection ID: `global`
4. Document ID: `settings` (manual, not auto-generated)
5. Add fields:
   - `break_slots`: Type "array" → Add timestamp entries
   - `order_cutoff_minutes`: Type "number" → Value: 5
6. **For break_slots:**
   - Click "Add item" in array
   - Select type "timestamp"
   - Set your campus break times (usually 3-4 breaks per day)

---

## Quick Setup Checklist

To get your home screen working with test data, create:

### ✅ Minimum Required Data

1. **At least 1 canteen** in `canteens` collection:
   - With `is_active: true`
   - With at least 2-3 menu items
   - Include `image_url` for better UI (use placeholder images if needed)

2. **At least 2-3 orders** in `orders` collection:
   - All with `user_id` matching your test user's Firebase Auth UID
   - With `status: "completed"` or `"delivered"` to show in recent orders
   - Include `image_url` in items for better display
   - Use recent `created_at` timestamps (within last week)

3. **Settings document** at `global/settings`:
   - Add 3 break time slots for your campus schedule
   - Set `order_cutoff_minutes: 5`

### 🎯 Example Test Data Setup

**Step 1:** Create 2 canteens
```
canteens/canteen_001 - "The Grill" (burgers, fries)
canteens/canteen_002 - "Pasta Paradise" (pasta, pizza)
```

**Step 2:** Create 3 recent orders for your test user
```
orders/order_001 - Burger from "The Grill" (completed)
orders/order_002 - Pasta from "Pasta Paradise" (completed)
orders/order_003 - Pizza from "Pasta Paradise" (delivered)
```

**Step 3:** Create settings
```
global/settings - Break slots at 10:30 AM, 1:00 PM, 3:30 PM
```

---

## How the App Queries This Data

### On Home Screen Load (`HomeProvider.initialize()`):

1. **Fetch Canteens:**
   ```
   Query: canteens where is_active == true
   Used for: Displaying available canteens list
   ```

2. **Fetch Recent Orders:**
   ```
   Query: orders where user_id == currentUser.uid
   Order by: created_at descending
   Limit: 10
   Used for: "Recently Ordered" horizontal scroll section
   ```

3. **Fetch Settings:**
   ```
   Query: global/settings document
   Used for: Time Lock Policy (showing "Go Online" button)
   ```

### When User Searches:

```
Query: canteens where is_active == true (fetch all)
Filter locally: Check if query matches canteen name OR any menu item name/category
```

---

## Image URLs - Important Notes

### Recommended Approach

For production, use **Firebase Storage** to host images:

1. Upload canteen and food images to Firebase Storage
2. Get download URLs
3. Use those URLs in `image_url` fields

### For Testing (Quick Setup)

You can use placeholder image services:
- Unsplash: `https://source.unsplash.com/300x200/?burger`
- Lorem Picsum: `https://picsum.photos/300/200`
- Or any public image URLs

### Example Image URLs by Category

```
Burgers: https://source.unsplash.com/300x200/?burger
Pasta: https://source.unsplash.com/300x200/?pasta
Pizza: https://source.unsplash.com/300x200/?pizza
Grilled: https://source.unsplash.com/300x200/?grilled,chicken
Canteen: https://source.unsplash.com/400x200/?restaurant,cafeteria
```

---

## Security Rules (Important!)

Your current Firestore security rules should allow:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Canteens - Read by all authenticated users
    match /canteens/{canteenId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins via backend
    }

    // Orders - Users can read their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null &&
                     resource.data.user_id == request.auth.uid;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }

    // Global settings - Read by all authenticated users
    match /global/settings {
      allow read: if request.auth != null;
      allow write: if false; // Only admins via backend
    }
  }
}
```

---

## Testing Your Setup

### After adding data to Firestore:

1. **Launch your app**
2. **Login** with a test user
3. **Check home screen displays:**
   - ✅ Your canteens in the "Canteens" section
   - ✅ Recent orders in "Recently Ordered" (if orders exist for that user)
   - ✅ "Go Online" button (only if user is delivery student AND current time is within a break slot)
   - ✅ Search bar filters canteens when typing

### Troubleshooting

**No canteens showing?**
- Check `is_active: true` on canteen documents
- Verify user is authenticated
- Check Firestore security rules

**No recent orders showing?**
- Verify `user_id` in order documents matches your Firebase Auth UID
- Check you have at least one completed order
- Orders must have recent `created_at` timestamps

**"Go Online" button not showing for delivery student?**
- Check user role is `delivery_student` in users collection
- Verify current time is within a break slot
- Check `global/settings` break_slots are set correctly

---

## Summary: What to Add Now

To make your home screen work immediately, add this minimal test data:

| Collection/Document | What to Add | Why |
|---------------------|-------------|-----|
| `canteens/test_canteen_1` | 1 canteen with 3 menu items, `is_active: true` | Display in canteens list |
| `orders/test_order_1` | 1 completed order with your user_id | Show in "Recently Ordered" |
| `orders/test_order_2` | 1 more completed order | Populate recent orders section |
| `global/settings` | Break slots + cutoff minutes | Enable Time Lock Policy |

Then run your app and verify everything displays correctly!
