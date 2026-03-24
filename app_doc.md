# Tap2Eat — Complete Project Documentation

> **Who is this for?** This document is written for someone who has never used Flutter before. Every technical term is explained in plain English. This covers everything about the Tap2Eat app — what it is, how it works, how it's built, and what each screen does.

---

## Table of Contents

1. [What is Tap2Eat?](#1-what-is-tap2eat)
2. [Tech Stack — Tools & Technologies Used](#2-tech-stack--tools--technologies-used)
3. [How to Run the Project](#3-how-to-run-the-project)
4. [App Architecture — How the Code is Organized](#4-app-architecture--how-the-code-is-organized)
5. [Folder Structure](#5-folder-structure)
6. [User Roles](#6-user-roles)
7. [Screens & Pages Walkthrough](#7-screens--pages-walkthrough)
8. [Data Flow Diagrams (DFD)](#8-data-flow-diagrams-dfd)
9. [Step-by-Step Data Flows](#9-step-by-step-data-flows)
10. [Firebase Database Structure](#10-firebase-database-structure)
11. [Key Features](#11-key-features)
12. [Current Development Status](#12-current-development-status)

---

## 1. What is Tap2Eat?

**Tap2Eat** is a mobile app for college campuses that lets students and teachers order food from campus canteens directly from their phone — and even get it delivered to their classroom during break times.

### The Problem It Solves

At a college canteen, long queues waste break time. Students often skip meals because of the wait. Teachers sometimes can't leave class at all. Tap2Eat solves this by:

- Letting students **browse menus and pre-order food** before the break starts
- Letting **fellow students earn money** by delivering orders to classrooms
- Giving canteen staff a way to **manage orders digitally** instead of handling cash slips

### Who Uses It

| Person | What They Can Do |
|--------|-----------------|
| Student | Browse canteens, order food for pickup or delivery |
| Teacher | Same as student, plus get food delivered to the staffroom |
| Delivery Student | Go online during breaks to pick up and deliver orders |
| Canteen Admin | See incoming orders, manage menu items |
| Master Admin | Manage the whole system |

---

## 2. Tech Stack — Tools & Technologies Used

Think of the tech stack as the list of tools used to build the app. Here's each one explained simply:

### Flutter & Dart

**Flutter** is a toolkit made by Google for building mobile apps. Instead of building separate apps for Android and iPhone, Flutter lets you write one codebase and it runs on both. Think of it like Microsoft Word — one app, works on Windows and Mac.

**Dart** is the programming language Flutter uses. It's similar to JavaScript or Java but designed specifically to work with Flutter.

### Firebase (The Backend / Server)

**Firebase** is a set of cloud services by Google that acts as the server/database for the app. You don't need to build your own server — Firebase handles it.

| Firebase Service | What it does in Tap2Eat |
|-----------------|------------------------|
| **Firebase Auth** | Handles login and registration (like "Sign in with Google") |
| **Cloud Firestore** | The database — stores all users, orders, menus, canteens |
| **Cloud Functions** | Server-side logic — things like "place an order" that must run securely on the server |
| **Firebase Messaging (FCM)** | Sends push notifications — delivery students get notified when an order is assigned to them |

### Provider (State Management)

**State** is just a fancy word for "the current data the app is showing." For example, the number of items in your cart is "state."

**Provider** is a system that keeps track of state and automatically updates the screen when data changes. Think of it like a live scoreboard — when the score changes, everyone watching sees the update instantly.

### GoRouter (Navigation)

**GoRouter** handles navigation between screens. Think of it as a GPS for the app — you tell it where to go (e.g., `/checkout`) and it takes you there. It also handles deep links (opening a specific screen from a notification).

### Google Fonts

Loads custom fonts (Sora and Inter) from Google's font library to make the app look polished.

### Other Libraries

| Library | Purpose |
|---------|---------|
| `freezed` | Makes data objects immutable (unchangeable after creation) — prevents bugs |
| `json_serializable` | Automatically converts database JSON data into Dart objects |
| `equatable` | Makes it easy to compare two objects (e.g., check if two orders are the same) |
| `intl` | Formats dates and currency (e.g., "March 24, 2026" or "₹120.00") |
| `shared_preferences` | Stores small bits of data on the phone (like "has user seen onboarding") |

---

## 3. How to Run the Project

### Prerequisites

Before running, make sure you have these installed:

1. **Flutter SDK** — Download from flutter.dev (version 3.x or later)
2. **Android Studio or VS Code** — The code editor
3. **A phone or emulator** — Either connect a real Android/iPhone or use an emulator
4. **Firebase configured** — The `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files must be in place

### Steps

```bash
# 1. Go into the project folder
cd tap2eat_app

# 2. Download all dependencies (libraries the app needs)
flutter pub get

# 3. Generate code (freezed models need this)
dart run build_runner build

# 4. Run the app
flutter run
```

### Common Issues

| Problem | Solution |
|---------|----------|
| "Firebase not initialized" | Make sure `google-services.json` is in `android/app/` |
| "Null check operator" crash | Usually means a Firebase field name mismatch — check Firestore field names |
| Fonts not loading | Run `flutter pub get` again |

---

## 4. App Architecture — How the Code is Organized

Tap2Eat uses **Clean Architecture**. This is a coding pattern that separates the app into 3 clear layers, like the floors of a building.

```
┌─────────────────────────────────────┐
│         PRESENTATION LAYER          │  ← What the user sees (screens, buttons)
│    (Pages, Widgets, Providers)      │
├─────────────────────────────────────┤
│           DOMAIN LAYER              │  ← Business rules (what the app does)
│      (Entities, Use Cases)          │
├─────────────────────────────────────┤
│            DATA LAYER               │  ← Where data comes from (Firebase)
│  (Models, DataSources, Repos)       │
└─────────────────────────────────────┘
```

### Layer 1: Presentation (The UI)

This is everything the user sees and interacts with. It contains:

- **Pages** — Full screens (like the Home Page, Checkout Page)
- **Widgets** — Small reusable UI pieces (like a button, a card)
- **Providers** — The brains behind each screen; they hold data and tell the screen when to update

**Analogy:** The presentation layer is like a waiter at a restaurant. They take your order and bring you food, but they don't cook the food or decide the menu.

### Layer 2: Domain (The Business Logic)

This is the core of the app — the rules of how things work. It contains:

- **Entities** — Pure data objects (e.g., `OrderEntity` has an id, items, total)
- **Use Cases** — Single actions the app can do (e.g., `PlaceOrderUseCase`, `GetMenuUseCase`)
- **Repository Interfaces** — Contracts that say "here's what the data layer must be able to do"

**Analogy:** The domain layer is like the kitchen. It knows the recipe and the rules. It doesn't care if the order came from a waiter, a drive-through, or an app.

### Layer 3: Data (The Database)

This layer talks to Firebase and converts raw database data into usable objects. It contains:

- **Models** — Like entities but with extra code for reading/writing JSON from Firebase
- **DataSources** — Classes that actually call Firebase APIs
- **Repository Implementations** — Connect the domain layer to the data layer

**Analogy:** The data layer is like the grocery store the kitchen gets ingredients from. It doesn't know what's being cooked — it just provides the raw materials.

### Why This Structure?

- You can change Firebase to a different database without touching the screens
- Each layer is easy to test independently
- New features can be added without breaking existing code

---

## 5. Folder Structure

```
tap2eat_app/
│
├── lib/                          # All app code lives here
│   │
│   ├── main.dart                 # Entry point — starts the app
│   │
│   ├── config/                   # App-wide settings
│   │   ├── constants/            # Shared constants (collection names, enums)
│   │   │   ├── enum_values.dart  # UserRole, OrderStatus, FulfillmentType
│   │   │   ├── firebase_constants.dart  # Firestore collection/field names
│   │   │   └── app_constants.dart
│   │   ├── routes/               # Screen navigation
│   │   │   ├── route_names.dart  # All route path strings
│   │   │   └── app_router.dart   # GoRouter setup (maps paths to screens)
│   │   └── theme/                # Visual styling
│   │       ├── app_theme.dart    # Dark theme definition
│   │       ├── colors.dart       # Color palette
│   │       └── text_styles.dart  # Font sizes and weights
│   │
│   ├── core/                     # Shared utilities & base classes
│   │   ├── usecase/
│   │   │   └── usecase.dart      # Base UseCase class all use cases extend
│   │   ├── services/
│   │   │   └── notification_service.dart  # FCM push notification handler
│   │   ├── exceptions/
│   │   │   └── app_exception.dart         # Custom error types
│   │   └── utils/
│   │       ├── time_lock_helper.dart      # Break time validation logic
│   │       ├── formatters/               # Date/currency formatting
│   │       └── validators/               # Email/password validation
│   │
│   ├── shared/                   # Widgets used across multiple features
│   │   ├── widgets/
│   │   │   ├── app_button.dart           # Standard filled button
│   │   │   ├── app_outline_button.dart   # Standard outline button
│   │   │   ├── app_text_field.dart       # Standard text input
│   │   │   ├── loading_spinner.dart      # Loading indicator
│   │   │   └── empty_state_widget.dart   # "Nothing here" placeholder
│   │   └── providers/
│   │       └── firebase_provider.dart    # Firebase initialization
│   │
│   └── features/                 # Each feature is self-contained
│       │
│       ├── auth/                 # Login, Register, Onboarding, Splash
│       │   ├── domain/
│       │   └── presentation/
│       │       ├── pages/        # splash_page, login_page, register_page, onboarding_page
│       │       ├── providers/    # auth_provider, onboarding_provider
│       │       └── widgets/      # Onboarding screen components
│       │
│       ├── home/                 # Home screen, canteen list, recent orders
│       │   ├── data/
│       │   │   ├── datasources/  # home_remote_datasource.dart (Firestore calls)
│       │   │   ├── models/       # canteen_model, recent_order_model, etc.
│       │   │   └── repositories/ # home_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/     # canteen_entity, recent_order_entity, settings_entity
│       │   │   ├── repositories/ # home_repository.dart (interface)
│       │   │   └── usecases/     # get_canteens, get_settings, watch_recent_orders, etc.
│       │   └── presentation/
│       │       ├── pages/        # home_page.dart
│       │       ├── providers/    # home_provider.dart
│       │       └── widgets/      # canteen_card, recent_order_card, search_bar
│       │
│       ├── menu/                 # Menu browsing and cart
│       │   └── presentation/
│       │       ├── pages/        # menu_page.dart
│       │       ├── providers/    # cart_provider.dart
│       │       └── widgets/      # menu_item_card, cart_button
│       │
│       ├── order/                # Checkout, order history, order detail
│       │   ├── data/
│       │   │   ├── datasources/  # order_remote_datasource.dart
│       │   │   └── repositories/ # order_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── repositories/ # order_repository.dart
│       │   │   └── usecases/     # create_order, watch_order_history, etc.
│       │   └── presentation/
│       │       ├── pages/        # checkout_page, order_history_page, order_detail_page, confirmation_page
│       │       ├── providers/    # order_provider.dart
│       │       └── widgets/      # fulfillment_type_selector, order_history_card
│       │
│       └── delivery/             # Delivery student dashboard and tracking
│           ├── data/
│           │   ├── datasources/  # delivery_remote_datasource.dart
│           │   └── repositories/ # delivery_repository_impl.dart
│           ├── domain/
│           │   ├── entities/     # delivery_assignment_entity, customer_info_entity
│           │   ├── repositories/ # delivery_repository.dart
│           │   └── usecases/     # accept_assignment, reject_assignment, update_status, etc.
│           └── presentation/
│               ├── pages/        # delivery_home_page, delivery_tracking_page
│               ├── providers/    # delivery_provider.dart
│               └── widgets/      # delivery_assignment_popup, delivery_order_card
│
├── android/                      # Android-specific config
├── ios/                          # iOS-specific config
├── pubspec.yaml                  # Dependency list (like package.json in Node.js)
├── firestore.rules               # Firebase security rules
└── firestore.indexes.json        # Firestore query indexes
```

---

## 6. User Roles

The app behaves differently depending on who is logged in. Here's a breakdown:

### Student
- Can browse all canteens and their menus
- Can add items to cart and place orders
- Fulfillment type: **Pickup only** (must collect from canteen)
- Can view order history and track order status

### Teacher
- Same as student, but can also choose **Delivery** as a fulfillment option
- Food gets delivered to their classroom/staffroom during break time

### Delivery Student
- A regular student who opts into delivery mode via a toggle in Profile
- During break times, they can **go online** to receive delivery assignments
- Gets a push notification when an order is assigned to them
- Can accept or reject assignments (with a countdown timer)
- Earns a delivery fee (₹10 per order) for each completed delivery

### Canteen Admin
- Manages the canteen's menu (add/edit/remove items)
- Views incoming orders and updates order status (preparing, ready)

### Master Admin
- Full access to everything
- Manages canteens, settings, break slots, and all users

---

## 7. Screens & Pages Walkthrough

### Screen 1: Splash Screen
**File:** `lib/features/auth/presentation/pages/splash_page.dart`

The first screen shown when the app opens. It:
1. Initializes Firebase
2. Checks if the user is already logged in
3. Redirects to the correct home screen based on role, or to Login if not logged in

---

### Screen 2: Onboarding Screen
**File:** `lib/features/auth/presentation/pages/onboarding_page.dart`

A 3-slide introduction shown only the first time the app is opened. Explains what Tap2Eat does. After completing it, `shared_preferences` records that onboarding was seen so it never shows again.

---

### Screen 3: Login Screen
**File:** `lib/features/auth/presentation/pages/login_page.dart`

Standard email + password login form. Uses Firebase Authentication. On success, fetches the user's role from Firestore and navigates to the appropriate home screen.

---

### Screen 4: Register Screen
**File:** `lib/features/auth/presentation/pages/register_page.dart`

New user registration form. Collects:
- Name, email, password
- Role (Student / Teacher)
- Phone number
- Classroom number and block name (for delivery location)
- Designation (for teachers)

On success, creates a Firebase Auth account and a Firestore document in the `users` collection.

---

### Screen 5: Home Screen
**File:** `lib/features/home/presentation/pages/home_page.dart`

The main hub of the app. Has 3 tabs at the bottom:

**Tab 1 — Home (Feed)**
- Welcome message with user's name
- Search bar to find canteens by name
- "Recently Ordered" horizontal scroll list
- List of all active canteens with their menu previews
- For delivery students: a "Go Online" button appears during break times

**Tab 2 — Orders**
- Full order history list
- Each card shows canteen name, total, status badge, and date
- Tap any order to see full details
- Pull down to refresh

**Tab 3 — Profile**
- User info (name, email, role badge)
- Delivery mode toggle (for students: switch between student and delivery student)
- Delivery stats (deliveries completed, total earnings)
- Logout button

---

### Screen 6: Menu Screen
**File:** `lib/features/menu/presentation/pages/menu_page.dart`

Shows a specific canteen's full menu after tapping a canteen card. Displays:
- Canteen name and active order count banner
- Capacity warning if canteen is near its max order limit
- Menu items with name, description, price, and an Add button
- Floating Cart button (bottom right) showing item count and subtotal
- Tapping the cart button navigates to Checkout

---

### Screen 7: Checkout Screen
**File:** `lib/features/order/presentation/pages/checkout_page.dart`

Review and confirm your order. Contains:
- List of cart items with quantity +/- controls
- **Fulfillment Type Selector** (only shown to teachers):
  - Pickup: collect from canteen yourself
  - Delivery: delivered to your location during break
- **Break Slot Picker** (only for delivery): choose which break time to receive delivery
- **"Deliver Now"** option if a delivery student is currently available
- Order summary (subtotal + delivery fee + total)
- Place Order button

---

### Screen 8: Order Confirmation Screen
**File:** `lib/features/order/presentation/pages/order_confirmation_page.dart`

Shown immediately after a successful order placement. Displays:
- Success message and order ID
- Estimated fulfillment time
- Button to track the order (goes to Order Detail)
- Button to go back to Home

---

### Screen 9: Order Detail Screen
**File:** `lib/features/order/presentation/pages/order_detail_page.dart`

Full details for a specific order. Updated in real-time via Firestore streams:
- Canteen name and order date
- All ordered items with quantities and prices
- Fulfillment type and slot time
- Current order status with a visual progress indicator
- For delivery orders: delivery person's name and contact
- Status automatically updates as canteen/delivery student changes it

---

### Screen 10: Order History Screen
**File:** `lib/features/order/presentation/pages/order_history_page.dart`

A full-page list of all past orders (also accessible from Home Tab 2). Each order card shows:
- Canteen name
- Status badge (color-coded)
- Item count and total
- Date and time

---

### Screen 11: Delivery Home Screen
**File:** `lib/features/delivery/presentation/pages/delivery_home_page.dart`

Shown when the user is in Delivery Student mode. Replaces the regular Home tab. Contains:
- Online/Offline toggle (only usable during break times)
- Current assignment card (if currently delivering)
- Delivery history list
- When a new order is assigned, a popup appears automatically

**Assignment Popup:**
- Shows order details (canteen, items, delivery fee)
- Accept and Reject buttons
- Countdown timer (assignment expires if not responded to)

---

### Screen 12: Delivery Tracking Screen
**File:** `lib/features/delivery/presentation/pages/delivery_tracking_page.dart`

After accepting an assignment, the delivery student sees this screen:
- Order items list
- Customer details (name, classroom number, block/building)
- Current status
- Action buttons to advance status (e.g., "Mark as Picked Up", "Mark as Delivered")
- Real-time updates via Firestore

---

## 8. Data Flow Diagrams (DFD)

A Data Flow Diagram (DFD) shows how data moves through a system. Arrows show data moving between external entities (people/systems), processes (what the app does), and data stores (databases).

**Symbols used:**
- `[ ]` = External entity (a person or system outside the app)
- `( )` = Process (something the app does)
- `=== ===` = Data store (database)

---

### Level 0 DFD — Context Diagram

The simplest view: the entire app as one black box.

```
                        login/register info
           ┌──────────────────────────────────────┐
           │                                      ▼
    [Student/Teacher]  ──── order request ──► (  TAP2EAT  ) ──── order data ───► [Firebase DB]
           ◄──── order status / menu ────────    SYSTEM    ◄──── menu/orders ────
                                              (          )
    [Delivery Student] ──── online status ──►           ◄──── assignment data ── [Firebase DB]
           ◄──── assignment notification ────           ──── delivery status ──►

    [Firebase Cloud    ──── push message ───►
     Messaging]        ◄────────────────────           ──── trigger message ──►
```

---

### Level 1 DFD — Major Processes

Breaking the system into its main processes:

```
                    ┌──────────────────────────────────────────────────────────┐
                    │                     TAP2EAT SYSTEM                       │
                    │                                                          │
[User]─credentials─►(1. Authentication)─user profile─► ═══ users DB ═══      │
       ◄─auth token─                                                          │
                    │                                                          │
[User]─browse req──►(2. Menu & Canteen   )─query─► ═══ canteens DB ═══       │
       ◄─menu data──    Discovery         ◄─data──                            │
                    │                                                          │
[User]─cart+confirm►(3. Order Placement  )─write─► ═══ orders DB ═══         │
       ◄─order ID───    (Cloud Function)  ─────────────────────────►          │
                    │                    triggers                              │
                    │                       │                                  │
                    │                       ▼                                  │
[Delivery]◄─FCM push(4. Delivery          )─update─► ═══ delivery_profiles ══│
[Student]──accept──►    Assignment         ◄─read──                           │
                    │                                                          │
[User]─order ID────►(5. Order Tracking   )─listen─► ═══ orders DB ═══        │
       ◄─live status     (Real-time Stream)◄─stream─                          │
                    │                                                          │
                    └──────────────────────────────────────────────────────────┘
```

---

### Level 2 DFD — Order Placement (Detailed)

A deep dive into exactly what happens when a user places an order:

```
[User]
  │
  │ (1) Cart items + fulfillment choice
  ▼
(Validate Cart)
  │ check: cart not empty, fulfillment slot valid, canteen within capacity
  ▼
(Check Canteen Capacity) ──read── ═══ orders DB ═══
  │                                (count active orders)
  │ capacity OK
  ▼
(Call Cloud Function: placeOrder)
  │
  ├──write──► ═══ orders DB ═══  (create order document)
  │
  ├──read───► ═══ settings DB ═══ (get break slots, cutoff time)
  │
  │  if delivery order:
  ├──read───► ═══ delivery_profiles DB ═══ (find available delivery student)
  │
  │  if student found:
  ├──write──► ═══ delivery_profiles DB ═══ (assign order to student)
  │
  └──trigger─► (Firebase Messaging) ──FCM push──► [Delivery Student Phone]
                                                         │
                                                         │ Accept/Reject
                                                         ▼
                                              (Cloud Function: acceptAssignment)
                                                         │
                                              ──update──► ═══ orders DB ═══
                                              (status: "assigned")
                                                         │
                                              ──stream──► [User's Order Detail Screen]
                                              (real-time status update)
```

---

### Level 2 DFD — Authentication Flow

```
[New User]
  │ name, email, password, role, phone, classroom
  ▼
(Validate Inputs)
  │ email format OK, password strength OK
  ▼
(Firebase Auth: createUser)
  │ returns uid
  ▼
(Write User Profile) ──write──► ═══ users DB ═══
  │                              {uid, name, email, role, phone, classroom, block}
  │ if role = delivery_student:
  ├──write──► ═══ delivery_profiles DB ═══
  │           {uid, is_online: false, is_active: true}
  │
  └──► (Get FCM Token) ──update──► ═══ users DB ═══
                                    {fcm_tokens: [token]}

[Returning User]
  │ email + password
  ▼
(Firebase Auth: signIn)
  │ returns uid
  ▼
(Read User Role) ──read──► ═══ users DB ═══
  │               returns role field
  ▼
(Navigate to role-appropriate Home Screen)
```

---

### Level 2 DFD — Real-Time Order Tracking

```
[User] opens Order Detail Screen
  │
  ▼
(Subscribe to Firestore Stream)
  │ watchOrderDetail(orderId)
  │
  └──stream listener──► ═══ orders DB ═══
                              │
                    [Canteen Admin changes status]
                    "preparing" → writes to orders DB
                              │
                    Firestore detects change ──stream event──►
                              │
                    (OrderProvider receives event)
                              │
                    (notifyListeners() called)
                              │
                    (Order Detail Screen rebuilds)
                              │
                    [User sees updated status badge]
                    without refreshing the page
```

---

## 9. Step-by-Step Data Flows

### Flow 1: Student Orders Food (Pickup)

```
Step 1: User opens app
        → Splash screen checks Firebase Auth
        → User is logged in → fetch role from Firestore
        → Role = "student" → navigate to Home Screen

Step 2: User browses canteens
        → HomeProvider calls GetCanteensUseCase
        → UseCase calls HomeRepository
        → Repository calls HomeRemoteDataSource
        → DataSource queries Firestore: collection("canteens")
        → Returns list of CanteenEntity objects
        → Home screen displays canteen cards

Step 3: User taps a canteen
        → Navigates to Menu Screen with canteen data passed along
        → Menu screen shows all menu items from canteen.menuItems

Step 4: User taps "Add" on menu items
        → CartProvider.addItem(menuItem) called
        → Cart state updates
        → Cart button shows item count

Step 5: User taps Cart button → Checkout Screen
        → CheckoutPage reads CartProvider for items
        → Teachers see fulfillment selector (Pickup chosen for students)
        → OrderProvider.fetchActiveOrderCount() checks canteen capacity

Step 6: User taps "Place Order"
        → OrderProvider.placeOrder() called
        → Calls CreateOrderUseCase
        → UseCase calls Cloud Function "placeOrder" via Firebase
        → Cloud Function creates document in orders collection
        → Returns new order ID

Step 7: Navigation → Order Confirmation Screen
        → Shows order ID and estimated pickup time
        → CartProvider.clearCart() empties the cart

Step 8: User taps "Track Order"
        → Order Detail Screen opens
        → OrderProvider.fetchOrderDetail(orderId) starts Firestore stream
        → Status updates automatically as canteen prepares the order
```

---

### Flow 2: Delivery Student Receives and Delivers an Order

```
Step 1: Student switches to Delivery Mode
        → Profile tab → toggle Delivery Mode ON
        → AuthProvider.toggleDeliveryMode() called
        → Updates user's role in Firestore to "delivery_student"
        → Creates/activates delivery_profiles document

Step 2: Delivery student goes online during break time
        → Delivery Home Screen → tap "Go Online"
        → TimeLockHelper checks current time is within a break slot
        → DeliveryProvider.toggleOnlineStatus() called
        → Updates delivery_profiles/{uid}.is_online = true in Firestore

Step 3: A student places a delivery order (happens simultaneously)
        → Cloud Function placeOrder runs
        → Searches delivery_profiles for is_online = true students
        → Picks the available delivery student
        → Assigns order: delivery_profiles/{uid}.current_order_id = orderId
        → Sends FCM push notification to delivery student's device

Step 4: Delivery student's phone receives notification
        → NotificationService handles the FCM message
        → DeliveryProvider.setPendingAssignment(data) called
        → Assignment popup appears on Delivery Home Screen
        → Popup shows: canteen name, delivery fee, item count, countdown timer

Step 5: Delivery student taps Accept
        → DeliveryProvider.acceptAssignment() calls Cloud Function
        → Cloud Function updates order status to "assigned"
        → Navigates to Delivery Tracking Screen

Step 6: Delivery student goes to canteen, picks up food
        → Taps "Mark as Picked Up" button
        → DeliveryProvider.updateDeliveryStatus("delivering")
        → Cloud Function updates order status to "delivering"
        → Customer's Order Detail Screen shows "Out for delivery"

Step 7: Delivery student delivers to classroom
        → Taps "Mark as Delivered"
        → Cloud Function updates status to "delivered"
        → Earnings record created in earnings collection
        → Customer sees "Delivered" status
        → Delivery student goes back online for next order
```

---

## 10. Firebase Database Structure

Firebase Firestore is a NoSQL database. Data is organized in **collections** (like folders) containing **documents** (like files). Each document has **fields** (key-value pairs).

---

### Collection: `users`

Stores every registered user's profile.

```
users/
  {userId}/
    email           : "john@college.edu"        (string)
    name            : "John Doe"                 (string)
    role            : "student"                  (string)
                      → "student" | "teacher" | "delivery_student"
                        "canteen_admin" | "master_admin"
    phone_number    : "9876543210"               (string)
    classroom_number: "A-101"                    (string)
    block_name      : "Block A"                  (string)
    designation     : "Professor"                (string, teachers only)
    fcm_tokens      : ["token1", "token2"]       (array — push notification tokens)
    created_at      : Timestamp                  (when account was created)
```

---

### Collection: `canteens`

One document per canteen on campus.

```
canteens/
  {canteenId}/
    name                  : "Main Canteen"    (string)
    is_active             : true              (boolean — visible to users?)
    max_concurrent_orders : 20               (int — max orders at one time)

    menu_items/           ← SUBCOLLECTION (items belonging to this canteen)
      {itemId}/
        name        : "Veg Biryani"           (string)
        description : "Aromatic rice dish"    (string)
        price       : 60.0                    (number)
        category    : "Rice"                  (string)
        image_url   : "https://..."           (string, optional)
        is_available: true                    (boolean)
        stock       : 50                      (int — items remaining)
```

---

### Collection: `orders`

Every order ever placed by any user.

```
orders/
  {orderId}/
    canteen_id        : "canteen_abc123"      (string — which canteen)
    canteen_name      : "Main Canteen"        (string)
    user_id           : "user_xyz789"         (string — who ordered)
    items             : [                     (array of ordered items)
      {
        menu_item_id : "item_123",
        name         : "Veg Biryani",
        quantity     : 2,
        price        : 60.0
      }
    ]
    total_amount      : 130.0                 (number — includes delivery fee)
    fulfillment_slot  : Timestamp             (when order should be ready)
    fulfillment_type  : "pickup"              (string — "pickup" or "delivery")
    status            : "preparing"           (string — see Order Status below)
    delivery_student_id: "user_delivery_456" (string, only for delivery orders)
    delivery_fee      : 10.0                  (number — 0 for pickup)
    created_at        : Timestamp
    updated_at        : Timestamp
```

**Order Status Values (in order of progression):**

| Status | Meaning |
|--------|---------|
| `pending` | Order placed, waiting for canteen to acknowledge |
| `preparing` | Canteen is cooking/preparing the order |
| `ready` | Food is ready for pickup or delivery handoff |
| `assigned` | A delivery student has accepted the delivery |
| `delivering` | Delivery student picked up food and is on the way |
| `delivered` | Food has been delivered to the customer |
| `completed` | Customer confirmed receipt (or auto-completed) |
| `cancelled` | Order was cancelled |

---

### Collection: `settings`

Global app settings. Contains one document called `global`.

```
settings/
  global/
    order_cutoff_minutes : 5           (int — how many minutes before slot, orders close)
    break_slots          : [           (array — available delivery time windows)
      {
        label      : "Lunch Break",
        day_of_week: 1,                (1=Monday, 7=Sunday)
        start_time : "12:00",
        end_time   : "13:00",
        is_active  : true
      }
    ]
```

---

### Collection: `delivery_profiles`

One document per delivery student. Tracks their online/offline status.

```
delivery_profiles/
  {userId}/
    email            : "student@college.edu"   (string)
    name             : "Jane Doe"              (string)
    is_active        : true                    (boolean — allowed to deliver)
    is_online        : true                    (boolean — currently available)
    current_order_id : "order_abc"             (string — active delivery, null if none)
    last_assigned_at : Timestamp
    online_since     : Timestamp
```

---

### Collection: `earnings`

Tracks money earned by each delivery student.

```
earnings/
  {earningId}/
    delivery_student_id : "user_delivery_456"  (string)
    amount              : 10.0                  (number — delivery fee earned)
    order_id            : "order_abc123"        (string — which order)
    created_at          : Timestamp
```

---

### Collection: `audit_logs`

Tracks important system events for admin review.

```
audit_logs/
  {logId}/
    user_id   : "user_xyz"        (string — who performed the action)
    action    : "order_placed"    (string — what happened)
    timestamp : Timestamp
    details   : { ... }           (object — additional context)
```

---

## 11. Key Features

### Time Lock Policy (Break Time Enforcement)
The app enforces that delivery orders can **only be placed and delivered during break times**. The logic lives in `lib/core/utils/time_lock_helper.dart`. It checks:
- Is the current time within a configured break slot?
- Is there at least `order_cutoff_minutes` (5 min by default) before the slot starts?

If conditions aren't met:
- The "Go Online" button is hidden for delivery students
- Delivery option is disabled in checkout

### Real-Time Updates via Firestore Streams
Instead of the user having to manually refresh, the app uses Firestore's **real-time streams**. When data changes in the database (e.g., order status changes from "preparing" to "ready"), the app automatically updates the screen without any refresh. This is used for:
- Order status tracking
- Delivery assignment notifications
- Recent orders on the home screen

### Role-Based UI
The app shows different things depending on who is logged in:
- Students see pickup-only checkout
- Teachers see pickup + delivery options
- Delivery students see the Delivery Dashboard instead of the regular home feed
- The "Go Online" toggle is only visible to delivery students

### Push Notifications (FCM)
Firebase Cloud Messaging (FCM) sends silent push notifications to delivery students when they are assigned a new order. The app:
1. Generates a unique FCM token for each device
2. Stores the token in `users/{uid}.fcm_tokens`
3. Cloud Functions use this token to send a targeted message
4. The app receives the message and shows the assignment popup

### Cart Isolation
The cart is always tied to a single canteen. If a user tries to add items from a different canteen, the app clears the current cart and starts fresh. This prevents mixed orders from multiple canteens.

### Capacity Management
Canteens can set a `max_concurrent_orders` limit. Before an order is placed, the app checks how many orders are currently being prepared. If the canteen is at capacity, a warning is shown and the order may be blocked.

---

## 12. Current Development Status

### Completed

| Feature | Status |
|---------|--------|
| Authentication (login, register, logout) | Done |
| Onboarding flow | Done |
| Home screen with canteen list and search | Done |
| Recent orders on home screen | Done |
| Menu browsing | Done |
| Cart management | Done |
| Checkout (pickup + delivery) | Done |
| Order placement via Cloud Function | Done |
| Order confirmation screen | Done |
| Order history tab | Done |
| Order detail with real-time tracking | Done |
| Delivery student dashboard | Done |
| Delivery assignment (FCM + popup) | Done |
| Real-time delivery tracking | Done |
| Break time enforcement (Time Lock Policy) | Done |
| Push notifications | Done |
| Delivery mode toggle in profile | Done |

### In Progress / Planned

| Feature | Status |
|---------|--------|
| Earnings dashboard for delivery students | Planned |
| Settings/profile editing page | Planned |
| Order cancellation | Planned |
| Canteen admin dashboard | Planned |
| Master admin dashboard | Planned |
| Rating and feedback system | Future |

---

## Quick Reference: Important File Locations

| What you're looking for | File path |
|-------------------------|-----------|
| App entry point | `lib/main.dart` |
| All route paths | `lib/config/routes/route_names.dart` |
| Navigation setup | `lib/config/routes/app_router.dart` |
| Color palette | `lib/config/theme/colors.dart` |
| Firebase collection names | `lib/config/constants/firebase_constants.dart` |
| UserRole / OrderStatus enums | `lib/config/constants/enum_values.dart` |
| Break time validation | `lib/core/utils/time_lock_helper.dart` |
| Push notification handling | `lib/core/services/notification_service.dart` |
| Login screen | `lib/features/auth/presentation/pages/login_page.dart` |
| Home screen | `lib/features/home/presentation/pages/home_page.dart` |
| Menu screen | `lib/features/menu/presentation/pages/menu_page.dart` |
| Cart state | `lib/features/menu/presentation/providers/cart_provider.dart` |
| Checkout screen | `lib/features/order/presentation/pages/checkout_page.dart` |
| Order tracking | `lib/features/order/presentation/pages/order_detail_page.dart` |
| Delivery dashboard | `lib/features/delivery/presentation/pages/delivery_home_page.dart` |
| Auth state management | `lib/features/auth/presentation/providers/auth_provider.dart` |
| Order state management | `lib/features/order/presentation/providers/order_provider.dart` |
| Firebase security rules | `firestore.rules` |

---

*Documentation written for college review — Tap2Eat v1.0.0*
