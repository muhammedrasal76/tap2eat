# Tap2Eat Student App — Test Cases

| Test Case ID | Module | Test Description | Expected Result | Actual Result |
|---|---|---|---|---|
| TC-SPLS-001 | Splash Screen | Launch app when user is not authenticated for the first time | Splash logo is shown briefly; user is navigated to the Onboarding screen | |
| TC-SPLS-002 | Splash Screen | Launch app when user is not authenticated (returning user) | Splash logo is shown briefly; user is navigated to the Login screen | |
| TC-SPLS-003 | Splash Screen | Launch app when user is authenticated as Student/Teacher | Splash logo is shown; user is automatically routed to the Home Page | |
| TC-SPLS-004 | Splash Screen | Launch app when user is authenticated as Delivery Student | Splash logo is shown; user is routed to the Delivery Home Page | |
| TC-OB-001 | Onboarding | Launch the app for the first time after installation | Three-page onboarding carousel is displayed with page indicators, Skip button, and Next button | |
| TC-OB-002 | Onboarding | Tap "Next" on each onboarding page | Advances to the next page; the final page displays a "Get Started" button | |
| TC-OB-003 | Onboarding | Tap "Skip" on any onboarding page | Onboarding is skipped; user is navigated directly to the Login screen | |
| TC-OB-004 | Onboarding | Tap "Get Started" on the final onboarding page | User is navigated to the Login screen | |
| TC-OB-005 | Onboarding | Launch the app a second time after completing onboarding | Onboarding is not shown; user is taken to Login or Home based on auth state | |
| TC-AUTH-001 | Login | Enter a valid email and password and tap "Sign In" | User is authenticated via Firebase and navigated to the Home screen | |
| TC-AUTH-002 | Login | Enter an invalid email format and tap "Sign In" | Inline validation error is shown; form is not submitted | |
| TC-AUTH-003 | Login | Enter a password shorter than 6 characters and tap "Sign In" | Validation error is shown; form is not submitted | |
| TC-AUTH-004 | Login | Enter correct email but wrong password and tap "Sign In" | Snackbar error message is shown (e.g., "Invalid credentials"); user remains on Login screen | |
| TC-AUTH-005 | Login | Leave both email and password fields empty and tap "Sign In" | Validation errors shown for both fields; form is not submitted | |
| TC-AUTH-006 | Login | Tap the "Sign Up" link at the bottom of Login screen | User is navigated to the Registration screen | |
| TC-REG-001 | Registration | Fill all required fields as a Student with valid data and tap "Create Account" | Account is created in Firebase; user profile saved to Firestore with role "student"; navigated to Home screen | |
| TC-REG-002 | Registration | Fill all required fields as a Teacher with valid data and tap "Create Account" | Account is created in Firebase; user profile saved with role "teacher"; navigated to Home screen | |
| TC-REG-003 | Registration | Select "Student" role using the role toggle | Department field is shown; Designation field is hidden | |
| TC-REG-004 | Registration | Select "Teacher" role using the role toggle | Designation field is shown; Department field is hidden | |
| TC-REG-005 | Registration | Leave one or more required fields empty and tap "Create Account" | Inline validation errors shown for all empty required fields; form not submitted | |
| TC-REG-006 | Registration | Enter an email that is already registered and tap "Create Account" | Error message shown indicating the email is already in use; no duplicate account created | |
| TC-REG-007 | Registration | Enter a password shorter than 6 characters | Validation error is shown on the password field | |
| TC-HOME-001 | Home | Log in as a Student and view the Home screen | Personalized welcome header, search bar, Recent Orders horizontal list, and Canteen Cards are displayed | |
| TC-HOME-002 | Home | Log in as a Teacher and view the Home screen | Same layout as Student; no delivery-specific UI elements are shown | |
| TC-HOME-003 | Home | Type a valid canteen name in the search bar | Canteen cards filter in real time to show only matching canteens | |
| TC-HOME-004 | Home | Clear the text in the search bar | Full list of canteens is restored | |
| TC-HOME-005 | Home | Type a search term that matches no canteen | Empty state is shown in the canteen list area | |
| TC-HOME-006 | Home | View Recent Orders section when orders exist | Horizontal scrollable list shows order ID, status badge, and total amount for each recent order | |
| TC-HOME-007 | Home | View Home screen when no canteens are available | Empty state widget is displayed with an appropriate message | |
| TC-HOME-008 | Home | Tap on a canteen card | User is navigated to the Menu page for the selected canteen | |
| TC-MENU-001 | Menu | Open the Menu page for a canteen | Menu items are displayed and grouped by category (Breakfast, Lunch, Snacks, Beverages, Desserts) | |
| TC-MENU-002 | Menu | View a menu item with stock available | Item card shows image, name, description, price in rupees, and an "Add" button | |
| TC-MENU-003 | Menu | View a menu item with zero stock | Item card is visually dimmed; "Unavailable" indicator is shown; "Add" button is disabled | |
| TC-MENU-004 | Menu | Tap "Add" on an available menu item | Item is added to cart with quantity 1; button transforms into +/− quantity controls; floating cart bar appears | |
| TC-MENU-005 | Menu | Tap "+" on a cart item on the Menu page | Item quantity increments by 1; cart bar total updates | |
| TC-MENU-006 | Menu | Tap "−" on a cart item that has quantity 1 | Item is removed from cart; button reverts to "Add"; cart bar disappears if cart is now empty | |
| TC-MENU-007 | Menu | Tap "−" on a cart item that has quantity greater than 1 | Item quantity decrements by 1; cart bar total updates | |
| TC-MENU-008 | Menu | Add items from Canteen A, then tap "Add" on an item from Canteen B | Confirmation dialog appears asking the user to clear the existing cart | |
| TC-MENU-009 | Menu | Confirm clearing cart in the multi-canteen dialog | Existing cart is cleared; new item from Canteen B is added to cart | |
| TC-MENU-010 | Menu | Cancel the multi-canteen confirmation dialog | Existing cart from Canteen A is preserved; no item from Canteen B is added | |
| TC-MENU-011 | Menu | Tap "View Cart" on the floating cart summary bar | User is navigated to the Checkout page | |
| TC-MENU-012 | Menu | Active order exists for the canteen; navigate to that canteen's Menu page | Order Status Banner is displayed at the top of the Menu page showing current order status | |
| TC-CART-001 | Cart | Open Checkout page and verify Order Summary Card | Subtotal, delivery fee (if applicable), and total are correctly calculated and displayed | |
| TC-CART-002 | Cart | Tap "+" on a cart item in Checkout | Item quantity increases; subtotal and total update accordingly | |
| TC-CART-003 | Cart | Tap "−" on a cart item in Checkout | Item quantity decreases; subtotal and total update accordingly | |
| TC-CART-004 | Cart | Delete a cart item using the delete button in Checkout | Item is removed from the list; subtotal and total recalculate | |
| TC-ORD-001 | Checkout | Open Checkout page with items in cart | Canteen name, cart items with quantities, Order Summary Card, and Fulfillment Type Selector are displayed | |
| TC-ORD-002 | Checkout | Select "Pickup" as fulfillment type | Pickup is highlighted; break slot picker is hidden; delivery fee is not shown in the summary | |
| TC-ORD-003 | Checkout | Select "Delivery" as fulfillment type | Delivery is highlighted; break slot picker appears; delivery fee is added to the order summary | |
| TC-ORD-004 | Checkout | Select a break slot from the picker | Selected slot is highlighted; fulfillment time is set accordingly | |
| TC-ORD-005 | Checkout | Tap "Place Order" with Pickup selected and items in cart | Order is submitted to Firestore; user is navigated to Order Confirmation page; cart is cleared | |
| TC-ORD-006 | Checkout | Tap "Place Order" with Delivery and a valid break slot selected | Order with delivery details is submitted; user is navigated to Order Confirmation page | |
| TC-ORD-007 | Checkout | Tap "Place Order" while order submission is in progress | Button shows loading indicator and is disabled; duplicate submission is prevented | |
| TC-CONF-001 | Order Confirmation | View Order Confirmation page after a successful order | Animated checkmark, confirmation message, and generated Order ID are displayed | |
| TC-CONF-002 | Order Confirmation | Tap "View Order" on Order Confirmation page | User is navigated to the Order Detail page for the placed order | |
| TC-CONF-003 | Order Confirmation | Tap "Back to Home" on Order Confirmation page | User is navigated back to the Home screen | |
| TC-HIST-001 | Order History | Navigate to Order History page | Paginated list of past orders displayed; sorted by most recent first; each card shows Order ID, canteen, date, item count, total, and status badge | |
| TC-HIST-002 | Order History | Pull down to refresh Order History page | List reloads with the latest order data from Firestore | |
| TC-HIST-003 | Order History | Open Order History when the user has no past orders | Empty state message is displayed | |
| TC-HIST-004 | Order History | Tap on an order card in Order History | User is navigated to the Order Detail page for that order | |
| TC-DET-001 | Order Detail | Open Order Detail page for a Pickup order | Status badge, canteen name, Pickup fulfillment label, items list, subtotal, and total are displayed | |
| TC-DET-002 | Order Detail | Open Order Detail page for a Delivery order | Delivery fulfillment info with break slot label, delivery fee line in price summary, and delivery student info (when assigned) are displayed | |
| TC-DET-003 | Order Detail | View Order Detail when order status is "Preparing" | Status badge shows "Preparing" with appropriate color; real-time update reflected | |
| TC-DET-004 | Order Detail | View Order Detail when order status is "Delivered" | Status badge shows "Delivered" in green; order is marked as complete | |
| TC-DET-005 | Order Detail | Admin updates order status from admin panel; check Order Detail page | Order status badge updates in real time without requiring manual refresh | |
| TC-DLVR-001 | Delivery Home | Open Delivery Home page as a Delivery Student | Online status banner, Active Delivery card (if applicable), and Delivery History list are displayed | |
| TC-DLVR-002 | Delivery Home | Toggle Online/Offline switch to Online | Banner turns green; availability status updated in Firestore; student becomes visible for assignments | |
| TC-DLVR-003 | Delivery Home | Toggle Online/Offline switch to Offline | Banner turns grey; student is removed from available delivery pool in Firestore | |
| TC-DLVR-004 | Delivery Home | Tap Active Delivery card when an active assignment exists | User is navigated to the Delivery Tracking page for the active assignment | |
| TC-DLVR-005 | Delivery Home | View Delivery History after completing deliveries | Completed delivery assignment cards are shown with order ID, delivery fee earned, and completion status | |
| TC-DLVR-006 | Delivery Assignment | Receive a delivery assignment notification while online | Delivery Assignment Popup appears as a modal with countdown timer, order details, and Accept/Reject buttons | |
| TC-DLVR-007 | Delivery Assignment | Tap "Accept" on the Delivery Assignment Popup | Assignment is accepted; popup closes; Active Delivery card appears on Delivery Home | |
| TC-DLVR-008 | Delivery Assignment | Tap "Reject" on the Delivery Assignment Popup | Assignment is rejected; popup closes; student remains on Delivery Home; assignment marked rejected in Firestore | |
| TC-DLVR-009 | Delivery Assignment | Let the countdown timer on Delivery Assignment Popup expire | Popup auto-dismisses when timer reaches zero; assignment marked as expired in Firestore | |
| TC-DLVR-010 | Delivery Tracking | Open Delivery Tracking page for an active assignment | Status timeline (Assigned → Picked Up → Delivering → Delivered), order items, and contextual action button are displayed | |
| TC-DLVR-011 | Delivery Tracking | Tap "Start Delivering" when order is in Picked Up state | Status updates to Delivering in Firestore; timeline advances; button changes to "Mark as Delivered" | |
| TC-DLVR-012 | Delivery Tracking | Tap "Mark as Delivered" when delivery is in transit | Status updates to Delivered in Firestore; timeline shows all steps complete; user navigated back to Delivery Home | |
| TC-DLVR-013 | Delivery Tracking | Action button shows loading state during status update | Button is disabled and shows loading indicator during the Firestore update; prevents duplicate submissions | |
| TC-PROF-001 | Profile | Navigate to the Profile page | User Info Card (name, email, phone), Role Badge, and Logout button are displayed | |
| TC-PROF-002 | Profile | View Profile page as a Delivery Student with completed deliveries | Delivery Stats section shows total completed deliveries and total earnings formatted in rupees | |
| TC-PROF-003 | Profile | Toggle "Delivery Mode" switch ON on Profile page | A Delivery tab appears in the bottom navigation; user can access Delivery Home | |
| TC-PROF-004 | Profile | Toggle "Delivery Mode" switch OFF on Profile page | Delivery tab is removed from bottom navigation; delivery features are inaccessible | |
| TC-PROF-005 | Profile | Tap "Logout" button | User is signed out of Firebase; navigated to Login screen; cached session data is cleared | |
| TC-NOTIF-001 | Notifications | Order status is updated by canteen admin (e.g., Accepted → Preparing) | Push notification appears in device tray with the updated order status | |
| TC-NOTIF-002 | Notifications | Delivery assignment notification received while app is in foreground | Delivery Assignment Popup dialog is displayed immediately within the app | |
| TC-NOTIF-003 | Notifications | Tap an order status notification from the device notification tray | App opens and navigates to the relevant Order Detail page for that order | |
| TC-NOTIF-004 | Notifications | Tap a delivery assignment notification from the device tray | App opens and the Delivery Assignment Popup is shown to the delivery student | |
