# Tap2Eat Backend Data Structure Reference

> **Purpose:** Complete reference for mobile app developers implementing against the shared Firestore backend.
> Generated from the admin panel codebase — models, providers, and seed scripts.

---

## 1. Overview & Collection Map

Firestore is the sole backend. All collections live at the root level except `menu_items`, which is a subcollection under each canteen document.

```
Firestore
├── users/{uid}                          # All user accounts
├── canteens/{canteen_id}                # Canteen profiles
│   └── menu_items/{item_id}             # Menu items (subcollection)
├── orders/{order_id}                    # All orders (cross-canteen)
├── settings/global                      # Single doc: break slots + config
├── audit_logs/{log_id}                  # System audit trail
└── earnings/{earning_id}               # Delivery student earnings
```

Authentication: Firebase Auth (email/password). Each Auth user has a matching Firestore document in `users/{uid}`.

---

## 2. `users` Collection

**Path:** `users/{uid}` (document ID = Firebase Auth UID)

| Field              | Type     | Required | Description |
|--------------------|----------|----------|-------------|
| `email`            | `string` | Yes      | Login email |
| `name`             | `string` | Yes      | Display name |
| `role`             | `string` | Yes      | One of: `master_admin`, `canteen_admin`, `student`, `delivery_student` |
| `canteen_id`       | `string` | No       | Set only for `canteen_admin` — links to `canteens/{id}` |
| `class_id`         | `string` | No       | Student class identifier (mobile app use) |
| `designation`      | `string` | No       | Staff designation (mobile app use) |
| `earnings_balance` | `number` | No       | Delivery student accumulated earnings |

### Roles

| Role               | Access |
|--------------------|--------|
| `master_admin`     | System-wide analytics, break slot management, audit logs |
| `canteen_admin`    | Manage orders, menu, and settings for their assigned canteen |
| `student`          | Place and track orders (mobile app) |
| `delivery_student` | Accept delivery assignments, earn delivery fees (mobile app) |

### Example Document

```json
// users/{uid} — canteen admin
{
  "email": "canteen1@tap2eat.com",
  "name": "Suresh Patel",
  "role": "canteen_admin",
  "canteen_id": "canteen_1"
}

// users/{uid} — student
{
  "email": "student1@tap2eat.com",
  "name": "Rahul Verma",
  "role": "student"
}

// users/{uid} — delivery student
{
  "email": "delivery1@tap2eat.com",
  "name": "Vikram Rao",
  "role": "delivery_student"
}
```

---

## 3. `canteens` Collection

**Path:** `canteens/{canteen_id}`

| Field                   | Type      | Required | Default | Description |
|-------------------------|-----------|----------|---------|-------------|
| `name`                  | `string`  | Yes      | —       | Canteen display name |
| `max_concurrent_orders` | `int`     | Yes      | `10`    | Max orders accepted per fulfillment time slot |
| `is_active`             | `boolean` | Yes      | `true`  | Whether canteen is currently operational |

### Example Document

```json
// canteens/canteen_1
{
  "name": "Main Campus Canteen",
  "max_concurrent_orders": 20,
  "is_active": true
}
```

---

## 4. `menu_items` Subcollection

**Path:** `canteens/{canteen_id}/menu_items/{item_id}`

| Field         | Type      | Required | Default     | Description |
|---------------|-----------|----------|-------------|-------------|
| `name`        | `string`  | Yes      | —           | Item name |
| `description` | `string`  | Yes      | —           | Item description |
| `price`       | `number`  | Yes      | —           | Price in INR (e.g. `45.00`) |
| `category`    | `string`  | Yes      | —           | One of: `Breakfast`, `Lunch`, `Snacks`, `Beverages`, `Desserts` |
| `image_url`   | `string`  | No       | `null`      | URL to item image |
| `stock`       | `int`     | Yes      | —           | Current available stock count |
| `is_available`| `boolean` | Yes      | `stock > 0` | **Derived field** — always equals `stock > 0` |

### `is_available` Derivation Rule

`is_available` is **never set independently**. It is always computed as `stock > 0`:
- When stock is set/updated, `is_available` is written as `stock > 0`
- When reading, if `stock` field is missing, fallback: `is_available == true` → stock defaults to `50`; `is_available == false` → stock defaults to `0`
- The mobile app should treat `is_available` as the display flag but `stock` as the source of truth

### Example Document

```json
// canteens/canteen_1/menu_items/{auto_id}
{
  "name": "Masala Dosa",
  "description": "Crispy dosa filled with spiced potato",
  "price": 45.00,
  "category": "Breakfast",
  "image_url": null,
  "stock": 30,
  "is_available": true
}

// Out-of-stock item
{
  "name": "Vanilla Ice Cream",
  "description": "Single scoop vanilla ice cream",
  "price": 35.00,
  "category": "Desserts",
  "image_url": null,
  "stock": 0,
  "is_available": false
}
```

---

## 5. `orders` Collection

**Path:** `orders/{order_id}`

| Field                 | Type        | Required | Description |
|-----------------------|-------------|----------|-------------|
| `canteen_id`          | `string`    | Yes      | Reference to `canteens/{id}` |
| `user_id`             | `string`    | Yes      | Reference to `users/{uid}` (the student who placed the order) |
| `items`               | `array`     | Yes      | Array of embedded item objects (see below) |
| `total_amount`        | `number`    | Yes      | Calculated total (see formula below) |
| `fulfillment_slot`    | `Timestamp` | Yes      | Scheduled pickup/delivery time |
| `fulfillment_type`    | `string`    | Yes      | `pickup` or `delivery` |
| `status`              | `string`    | Yes      | Current order status (see lifecycle below) |
| `delivery_fee`        | `number`    | Yes      | `0` for pickup, `10` for delivery |
| `delivery_student_id` | `string`    | No       | Set when a delivery student is assigned |
| `created_at`          | `Timestamp` | Yes      | Order creation time |
| `updated_at`          | `Timestamp` | Yes      | Last status change time |

### Embedded Item Object

Each element in the `items` array:

| Field      | Type     | Description |
|------------|----------|-------------|
| `id`       | `string` | Reference to `menu_items/{item_id}` within the canteen |
| `name`     | `string` | Item name (denormalized for display) |
| `quantity` | `int`    | Number of units ordered |
| `price`    | `number` | Unit price at time of order (snapshot, not a live reference) |

### `total_amount` Formula

```
total_amount = SUM(item.price * item.quantity for each item) + delivery_fee
```

- `delivery_fee` = `0` when `fulfillment_type == "pickup"`
- `delivery_fee` = `10` when `fulfillment_type == "delivery"`

### Example Document

```json
// orders/{auto_id}
{
  "canteen_id": "canteen_1",
  "user_id": "abc123uid",
  "items": [
    { "id": "menuItem1Id", "name": "Masala Dosa", "quantity": 2, "price": 45.00 },
    { "id": "menuItem2Id", "name": "Masala Chai", "quantity": 1, "price": 15.00 }
  ],
  "total_amount": 105.00,
  "fulfillment_slot": "2025-01-15T10:30:00Z (Timestamp)",
  "fulfillment_type": "pickup",
  "status": "pending",
  "delivery_fee": 0,
  "created_at": "2025-01-15T09:00:00Z (Timestamp)",
  "updated_at": "2025-01-15T09:00:00Z (Timestamp)"
}

// Delivery order with assigned student
{
  "canteen_id": "canteen_1",
  "user_id": "xyz456uid",
  "items": [
    { "id": "menuItem3Id", "name": "Paneer Butter Masala", "quantity": 1, "price": 95.00 },
    { "id": "menuItem4Id", "name": "Masala Chai", "quantity": 2, "price": 15.00 }
  ],
  "total_amount": 135.00,
  "fulfillment_slot": "2025-01-15T11:15:00Z (Timestamp)",
  "fulfillment_type": "delivery",
  "status": "assigned",
  "delivery_fee": 10,
  "delivery_student_id": "delivery1uid",
  "created_at": "2025-01-15T09:30:00Z (Timestamp)",
  "updated_at": "2025-01-15T09:40:00Z (Timestamp)"
}
```

---

## 6. Order Status Lifecycle

### All 8 Statuses

| Status       | Description |
|--------------|-------------|
| `pending`    | Order placed, awaiting canteen acceptance |
| `preparing`  | Canteen has accepted and started preparing |
| `ready`      | Food is ready for pickup or delivery assignment |
| `assigned`   | Delivery student assigned (delivery orders only) |
| `delivering` | Delivery student is en route (delivery orders only) |
| `delivered`  | Delivery student has handed off the order (delivery orders only) |
| `completed`  | Order fully finished (pickup collected or delivery confirmed) |
| `cancelled`  | Order cancelled |

### Valid Status Transitions

```
                    ┌──────────────────────────┐
                    │                          │
  pending ──→ preparing ──→ ready ──→ completed     (pickup flow)
     │            │           │
     │            │           ├──→ assigned ──→ delivering ──→ delivered ──→ completed
     │            │           │                                              (delivery flow)
     │            │           │
     └────────────┴───────────┴──→ cancelled
```

**Pickup flow:** `pending` → `preparing` → `ready` → `completed`

**Delivery flow:** `pending` → `preparing` → `ready` → `assigned` → `delivering` → `delivered` → `completed`

**Cancellation:** Can be cancelled from `pending`, `preparing`, `ready`, `assigned`, or `delivering`

### Stock Triggers on Status Change

| Transition | Stock Action |
|------------|-------------|
| `pending` → `preparing` | **Decrement** stock for each item by its quantity (via Firestore transaction) |
| Any of `[preparing, ready, assigned, delivering]` → `cancelled` | **Restore** stock for each item by its quantity (via Firestore transaction) |
| All other transitions | No stock change |

Stock operations run inside a Firestore transaction that:
1. Reads all affected menu item documents
2. Validates sufficient stock exists (for decrement)
3. Updates `stock` and `is_available` (`stock > 0`) atomically
4. Updates the order status

If stock is insufficient during `pending` → `preparing`, the transaction throws an error and the status change is rejected.

---

## 7. `settings/global` Document

**Path:** `settings/global` (single document)

| Field                  | Type    | Description |
|------------------------|---------|-------------|
| `break_slots`          | `array` | Array of break slot objects |
| `order_cutoff_minutes` | `int`   | Minutes before a break slot starts when ordering closes (e.g. `5`) |

### Break Slot Object

Each element in the `break_slots` array:

| Field         | Type        | Description |
|---------------|-------------|-------------|
| `start_time`  | `Timestamp` | Slot start time (only hours/minutes matter, date portion ignored) |
| `end_time`    | `Timestamp` | Slot end time |
| `day_of_week` | `int`       | `1` = Monday, `2` = Tuesday, ... `7` = Sunday |
| `label`       | `string`    | Human-readable label (e.g. `"Morning Break"`, `"Lunch Break"`) |
| `is_active`   | `boolean`   | Whether this slot is currently enabled |

### Example Document

```json
// settings/global
{
  "order_cutoff_minutes": 5,
  "break_slots": [
    {
      "start_time": "Timestamp (10:20)",
      "end_time": "Timestamp (10:40)",
      "day_of_week": 1,
      "label": "Morning Break",
      "is_active": true
    },
    {
      "start_time": "Timestamp (13:00)",
      "end_time": "Timestamp (13:30)",
      "day_of_week": 1,
      "label": "Lunch Break",
      "is_active": true
    },
    {
      "start_time": "Timestamp (10:20)",
      "end_time": "Timestamp (10:40)",
      "day_of_week": 4,
      "label": "Morning Break (Inactive)",
      "is_active": false
    }
  ]
}
```

### Notes for Mobile App
- Break slots define when delivery is available
- Only show active slots (`is_active == true`) to students
- Apply `order_cutoff_minutes`: if current time is within `order_cutoff_minutes` of a slot's `start_time`, that slot should be closed for new orders
- The `start_time`/`end_time` Timestamps use a fixed date — extract only the hours and minutes, then apply them to the current day matching `day_of_week`

---

## 8. `audit_logs` Collection

**Path:** `audit_logs/{log_id}`

| Field           | Type        | Required | Description |
|-----------------|-------------|----------|-------------|
| `user_id`       | `string`    | Yes      | UID of the user who performed the action |
| `user_name`     | `string`    | Yes      | Display name at time of action |
| `user_role`     | `string`    | Yes      | Role at time of action |
| `action`        | `string`    | Yes      | Action type (see table below) |
| `resource_type` | `string`    | No       | Type of affected resource |
| `resource_id`   | `string`    | No       | ID of affected resource |
| `metadata`      | `map`       | No       | Action-specific details |
| `timestamp`     | `Timestamp` | Yes      | When the action occurred |

### All 11 Action Types

| Action               | Resource Type | Typical Metadata |
|----------------------|---------------|------------------|
| `user.login`         | —             | — |
| `user.logout`        | —             | — |
| `order.created`      | `order`       | `{ canteen_id, total_amount }` |
| `order.updated`      | `order`       | `{ old_status, new_status }` |
| `menu.created`       | `menu_item`   | `{ item_name, canteen_id }` |
| `menu.updated`       | `menu_item`   | `{ item_name, field, old_value, new_value }` |
| `menu.deleted`       | `menu_item`   | `{ item_name, canteen_id }` |
| `canteen.updated`    | `canteen`     | `{ field, old_value, new_value }` |
| `break_slot.created` | `break_slot`  | `{ label, day_of_week }` |
| `break_slot.updated` | `break_slot`  | `{ label, field, day_of_week }` |
| `break_slot.deleted` | `break_slot`  | `{ label, day_of_week }` |

### Example Document

```json
// audit_logs/{auto_id}
{
  "user_id": "canteen1uid",
  "user_name": "Suresh Patel",
  "user_role": "canteen_admin",
  "action": "menu.updated",
  "resource_type": "menu_item",
  "resource_id": "menuItemDocId",
  "metadata": {
    "item_name": "Veg Thali",
    "field": "price",
    "old_value": 75,
    "new_value": 80
  },
  "timestamp": "2025-01-10T10:15:00Z (Timestamp)"
}
```

---

## 9. `earnings` Collection

**Path:** `earnings/{earning_id}`

| Field                  | Type        | Required | Description |
|------------------------|-------------|----------|-------------|
| `delivery_student_id`  | `string`    | Yes      | UID of the delivery student |
| `order_id`             | `string`    | Yes      | Reference to `orders/{id}` |
| `amount`               | `number`    | Yes      | Earning amount (equals `delivery_fee`, currently `10`) |
| `status`               | `string`    | Yes      | `pending` or `paid` |
| `created_at`           | `Timestamp` | Yes      | When the earning was recorded |

### Relationships
- One earning per delivery order
- Created when a delivery student is assigned to an order
- `amount` matches the `delivery_fee` on the order
- `delivery_student_id` references `users/{uid}` where `role == "delivery_student"`
- `order_id` references `orders/{id}`

### Example Document

```json
// earnings/{auto_id}
{
  "delivery_student_id": "delivery1uid",
  "order_id": "order5id",
  "amount": 10,
  "status": "paid",
  "created_at": "2025-01-14T13:15:00Z (Timestamp)"
}
```

---

## 10. Auth Flow

### Login Sequence

```
1. Firebase Auth: signInWithEmailAndPassword(email, password)
2. On success: Firebase Auth returns User object with uid
3. Load Firestore: users/{uid} → read `role` and `canteen_id`
4. Route based on role:
   - master_admin    → Master Admin dashboard
   - canteen_admin   → Canteen Admin dashboard (scoped to canteen_id)
   - student         → Student app home
   - delivery_student → Delivery app home
   - Unknown role    → Not Authorized screen
```

### Auth State Listening

The app listens to `FirebaseAuth.authStateChanges()`. On each change:
- If user is non-null: load `users/{uid}` for role and canteen_id
- If user is null: clear role and canteen_id, redirect to login

### 3-Phase Initialization (Admin Panel)

1. **Not initialized** → Show splash screen
2. **Initialized, not authenticated** → Show login screen
3. **Authenticated, role loaded** → Route to role-specific dashboard

The mobile app should implement a similar guard: don't show the main UI until both Firebase Auth state and the user's Firestore document have been loaded.

---

## 11. Stock Management

### End-to-End Flow

```
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  Admin sets      │     │  Order accepted   │     │  Order cancelled  │
│  stock = 30      │     │  (pending →       │     │  (preparing →     │
│  is_available    │     │   preparing)      │     │   cancelled)      │
│  = true          │     │  stock -= qty     │     │  stock += qty     │
│                  │     │  is_available =   │     │  is_available =   │
│                  │     │  (stock > 0)      │     │  (stock > 0)      │
└─────────────────┘     └──────────────────┘     └──────────────────┘
```

### When Stock Changes

| Event | Stock Action | `is_available` Update |
|-------|-------------|----------------------|
| Admin creates/edits menu item | Set to specified value | `stock > 0` |
| Admin explicitly updates stock | Set to specified value | `stock > 0` |
| Order status: `pending` → `preparing` | Decrement by each item's `quantity` | `stock > 0` |
| Order status: `[preparing\|ready\|assigned\|delivering]` → `cancelled` | Restore by each item's `quantity` | `stock > 0` |

### Transaction Safety

Stock decrements and restores use **Firestore transactions** to prevent race conditions:

1. **Read phase:** Fetch current stock for all items in the order
2. **Validate phase:** Ensure `currentStock >= quantity` for each item (decrement only)
3. **Write phase:** Update `stock` and `is_available` for each item, update order `status`

If validation fails (insufficient stock), the entire transaction is rolled back — the order status stays unchanged.

### Auto-Unavailable at Stock 0

When stock reaches `0` after a decrement:
- `is_available` is set to `false`
- The item should no longer appear as orderable in the mobile app
- It will reappear if stock is restored (via cancellation or manual admin update)

### Mobile App Responsibilities

- Display items where `is_available == true` (or show out-of-stock items as disabled)
- Do **not** decrement stock client-side — the admin panel handles stock changes server-side during order status transitions
- The mobile app should check `is_available` before allowing an item to be added to cart
- Real-time listeners on `menu_items` subcollection will automatically reflect stock changes

---

## 12. Business Rules

### Ordering Constraints (Mobile App Must Enforce)

1. **Scheduled fulfillment slots only** — Orders are placed for a specific future time slot, not on-demand
2. **Break slot delivery** — Delivery is only available during active break slots from `settings/global`
3. **Order cutoff** — Stop accepting orders `order_cutoff_minutes` before a break slot's `start_time`
4. **Max concurrent orders** — Before placing an order, check that the number of active orders (status in `[pending, preparing, ready]`) for the target `canteen_id` + `fulfillment_slot` does not exceed `max_concurrent_orders`
5. **Stock availability** — Only show orderable items where `is_available == true`
6. **Role-based access** — Only `student` and `delivery_student` roles use the mobile app; `canteen_admin` and `master_admin` use the admin panel

### Delivery Rules

- Delivery fee is a flat `10` INR
- Delivery orders can only be placed during active break slots
- Pickup orders can be placed for any fulfillment slot (still subject to cutoff and max concurrent rules)
- A delivery student is assigned after the order reaches `ready` status
- The `delivery_student_id` field is set when assignment happens

### Price Snapshot

- Item prices in an order are **snapshotted at order creation time**
- If a menu item's price changes after an order is placed, the order's `total_amount` does not change
- The mobile app should read the current price from `menu_items` and embed it in the order's `items` array

---

## 13. Test Credentials

All accounts use password: **`Test@123`**

| Email | Role | Canteen | Name |
|-------|------|---------|------|
| `master@tap2eat.com` | `master_admin` | — | Dr. Rajesh Kumar |
| `canteen1@tap2eat.com` | `canteen_admin` | `canteen_1` | Suresh Patel |
| `canteen2@tap2eat.com` | `canteen_admin` | `canteen_2` | Anita Sharma |
| `student1@tap2eat.com` | `student` | — | Rahul Verma |
| `student2@tap2eat.com` | `student` | — | Priya Singh |
| `student3@tap2eat.com` | `student` | — | Amit Joshi |
| `delivery1@tap2eat.com` | `delivery_student` | — | Vikram Rao |
| `delivery2@tap2eat.com` | `delivery_student` | — | Karan Mehta |

### Seeded Canteens

| ID | Name | Max Concurrent Orders |
|----|------|-----------------------|
| `canteen_1` | Main Campus Canteen | 20 |
| `canteen_2` | Engineering Block Cafe | 15 |

### Seeded Data Counts

| Collection | Count |
|------------|-------|
| Firebase Auth users | 8 |
| `users` | 8 |
| `canteens` | 2 |
| `menu_items` (total) | 22 (12 in canteen_1 + 10 in canteen_2) |
| `orders` | 15 (8 in canteen_1 + 7 in canteen_2) |
| `settings/global` break slots | 7 (1 inactive) |
| `audit_logs` | 12 |
| `earnings` | 4 |

### Reseed Command

```bash
npm run seed    # Clears ALL data and reseeds from scratch
```

Requires `serviceAccountKey.json` in project root.
