title Tap2Eat Mobile Application - Multi-Level Data Flow Diagram
direction right

// LEVEL 0: Context Diagram

Student [icon: user, color: lightblue]
Teacher [icon: user, color: lightblue]
Delivery Student [icon: user-check, color: orange]
Firebase Backend [icon: database, color: purple]
Tap2Eat Mobile App [shape: oval, color: green, icon: smartphone]

// Level 0 Relationships
Student > Tap2Eat Mobile App: Login credentials, Order details, Menu requests
Teacher > Tap2Eat Mobile App: Login credentials, Order details, Menu requests
Tap2Eat Mobile App > Delivery Student: Delivery requests, Earnings updates
Tap2Eat Mobile App > Firebase Backend: Order data, User data, Menu data, Settings

// LEVEL 1: Major Processes

// External Entities (reused)
Student_L1 [icon: user, color: lightblue]
Teacher_L1 [icon: user, color: lightblue]
Delivery Student_L1 [icon: user-check, color: orange]
Firebase Backend_L1 [icon: database, color: purple]

// Data Stores
Users D1 [icon: users, color: lightgrey]
Orders D2 [icon: file-text, color: lightgrey]
Settings D3 [icon: settings, color: lightgrey]
Canteens D4 [icon: coffee, color: lightgrey]

// Main Processes
User Authentication [shape: rectangle, color: blue, icon: log-in]
Menu Browsing [shape: rectangle, color: teal, icon: book-open]
Order Management [shape: rectangle, color: orange, icon: shopping-cart]
Order Tracking [shape: rectangle, color: yellow, icon: activity]
Delivery Handling [shape: rectangle, color: pink, icon: truck]

// Grouping for clarity
Tap2Eat Core Processes [color: green, icon: smartphone] {
  User Authentication
  Menu Browsing
  Order Management
  Order Tracking
  Delivery Handling
}

// Level 1 Relationships

// User Authentication
Student_L1 > User Authentication: Login/Register credentials
User Authentication > Users D1: Store/Retrieve user data
User Authentication > Teacher_L1: Authentication token, User profile
User Authentication > Firebase Backend_L1: User data

// Menu Browsing
Student_L1 > Menu Browsing: Menu request
Menu Browsing > Canteens D4: Fetch menu items
Menu Browsing > Settings D3: Fetch available time slots
Menu Browsing > Teacher_L1: Menu items, Available time slots
Menu Browsing > Firebase Backend_L1: Menu data, Settings

// Order Management
Student_L1 > Order Management: Order details (items, time slot, fulfillment type)
Order Management > Orders D2: Store/Retrieve order data
Order Management > Settings D3: Validate time lock, throttling
Order Management > Canteens D4: Check menu availability
Order Management > Teacher_L1: Order confirmation/rejection
Order Management > Firebase Backend_L1: Order data

// Order Tracking
Student_L1 > Order Tracking: Order status request
Order Tracking > Orders D2: Retrieve order status
Order Tracking > Teacher_L1: Current order status updates
Order Tracking > Firebase Backend_L1: Order data

// Delivery Handling
Delivery Handling > Orders D2: Assign/retrieve delivery orders
Delivery Handling > Users D1: Update delivery student status
Delivery Handling > Settings D3: Validate time lock
Delivery Handling > Delivery Student_L1: Delivery requests, Earnings updates
Delivery Handling > Firebase Backend_L1: Order data, User data, Settings

// Aggregated flows to Firebase Backend
Student < Tap2Eat Mobile App: Order confirmations, Menu data, Order status
Teacher < Tap2Eat Mobile App: Order confirmations, Menu data, Order status
Tap2Eat Mobile App < Delivery Student: Availability status, Delivery confirmations
Tap2Eat Mobile App < Firebase Backend: Order data, User data, Menu data, Settings
User Authentication < Teacher_L1: Login/Register credentials
Student_L1 < User Authentication: Authentication token, User profile
Menu Browsing < Teacher_L1: Menu request
Student_L1 < Menu Browsing: Menu items, Available time slots
Order Management < Teacher_L1: Order details (items, time slot, fulfillment type)
Student_L1 < Order Management: Order confirmation/rejection
Order Tracking < Teacher_L1: Order status request
Student_L1 < Order Tracking: Current order status updates
Delivery Handling < Delivery Student_L1: Go online status, Delivery acceptance/completion
User Authentication < Firebase Backend_L1: Auth, User data
Menu Browsing < Firebase Backend_L1: Menu data, Settings
Order Management < Firebase Backend_L1: Order data
Order Tracking < Firebase Backend_L1: Order data
Delivery Handling < Firebase Backend_L1: Order data, User data, Settings