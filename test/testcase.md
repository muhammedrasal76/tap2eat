

Test Case ID
Module
Test Description
Expected Result
Actual Result
TC002
User Authentication
Enter invalid email or incorrect password on the login screen and click "Login".

Error message is displayed (e.g., "Invalid credentials"). User remains on the login page.


TC003
User Authentication
Login with a user account that has the canteen_admin role.
User is redirected to the Canteen Admin Dashboard (/canteen-dashboard). Navigation sidebar shows canteen-specific menu items (Dashboard, Menu, Settings).


TC004
User Authentication
Login with a user account that has an unauthorized role (e.g., student or delivery_student).
User is redirected to the "Not Authorized" page. Access to admin panels is denied.


TC005
Canteen Dashboard
Login as canteen admin and navigate to the Dashboard screen. Verify stat cards and analytics charts are displayed.
Dashboard displays stat cards (total orders, revenue, pending orders) and analytics charts with correct data for the canteen.


TC006
Canteen Dashboard
While on the canteen dashboard, place a new order from the mobile app.
The new order appears in real-time on the dashboard without requiring a manual page refresh. Order count updates automatically.


TC007
Canteen Dashboard
Click on a pending order and change its status from "pending" → "preparing" → "ready for pickup/delivery".
Order status transitions correctly at each step. Status badge updates in real-time. Timestamp is recorded for each status change.


TC008
Order Management
Use the filter options to filter orders by status (e.g., "preparing"), order type (e.g., "delivery"), and date range.
Only orders matching all selected filter criteria are displayed. Order count reflects filtered results.


TC009
Order Management
Enter an order ID in the search bar on the orders list.
The matching order is displayed in the list. Non-matching orders are hidden. Clearing the search restores the full list.


TC010
Order Management
Click on an order row to open the order details dialog.
Order details dialog opens showing complete order information: customer name, items ordered, quantities, prices, order type, status, and timestamps.


TC011
Menu Management
Click "Add Item" button. Fill in item name, description, price, category, and upload an image. Click "Save".
New menu item is created and appears in the menu list. Success message is displayed. Item data matches the entered values.


TC012
Menu Management
Select an existing menu item and click "Edit". Modify the item name and price. Click "Save".
Menu item is updated with the new values. Success message is displayed. Changes are reflected immediately in the menu list.


TC013
Menu Management
Select an existing menu item and click "Delete". Confirm the deletion in the confirmation dialog.
Menu item is removed from the list. Success message is displayed. Item no longer appears in the menu.


TC014
Menu Management
Use the search bar and category filter to find specific menu items.
Only menu items matching the search keyword and selected category are displayed. Results update as the user types.


TC015
Canteen Settings
Navigate to Settings. Update canteen name and max concurrent orders value. Click "Save".
Settings are saved successfully. Updated canteen name and max concurrent orders are reflected. Success message is displayed.


TC016
Canteen Settings
Toggle the canteen active/inactive switch on the Settings page.
Canteen status changes between active and inactive. When inactive, the canteen stops accepting new orders. Status change is saved to Firestore.


TC017
Master Admin Dashboard
Login as master admin and navigate to the Master Dashboard. Verify system-wide analytics are displayed.
Dashboard shows system-wide statistics: total orders across all canteens, total revenue, active canteens count, and user metrics with charts.


TC018
Break Slots Management
Navigate to Break Slots Management. Click "Add Break Slot". Enter slot name, start time, and end time. Click "Save".
New break slot is created and appears in the break slots list. Delivery orders are allowed during this time slot.


TC019
Break Slots Management
Select an existing break slot and edit its time range. Then delete another break slot using the delete button.
Edited break slot reflects the updated time range. Deleted break slot is removed from the list. Changes are persisted in Firestore.


TC020
Break Slots Management
Attempt to add a new break slot whose time range overlaps with an existing break slot.
Validation error is displayed indicating time slot overlap. The overlapping break slot is not saved. User is prompted to adjust the time range.


TC021
Audit Logs
Login as master admin. Navigate to Audit Logs. Apply filters by date range and action type.
Audit logs are displayed in chronological order. Filters correctly narrow down the log entries. Each log shows timestamp, user, action, and details.


TC022
Delivery Assignment
Open a delivery order and click "Assign Delivery". Select an available delivery student from the list. Confirm assignment.
Delivery student is assigned to the order. Order status updates to reflect the assignment. Notification is sent to the delivery student.


TC023
Delivery Assignment
Open an order with a pending delivery offer and click "Cancel Offer".
Delivery offer is cancelled. Delivery student assignment is removed. Order returns to awaiting delivery assignment state.


TC024
Onboarding
Launch the app for the first time after installation. Swipe through all 3 onboarding pages and tap "Get Started".
Onboarding carousel displays 3 pages with page indicators. "Skip" and "Next" buttons are functional. Tapping "Get Started" on the final page navigates to the Login Screen. Onboarding is not shown again on subsequent launches.


TC025
Onboarding
Tap the "Skip" button on the first onboarding page.
Onboarding is skipped entirely. User is navigated directly to the Login Screen.


TC026
Student Authentication
Open the app and enter a valid student email and password on the Login Screen. Tap "Sign In".
User is authenticated via Firebase. User is redirected to the Student Home Page. Welcome header displays the user's name.


TC027
Student Authentication
Enter an invalid email format or leave the password field empty on the Login Screen and tap "Sign In".
Inline validation errors are displayed for invalid fields. Form is not submitted. User remains on the Login Screen.


TC028
Student Registration
Navigate to the Registration Screen. Fill in all required fields (name, email, password) with valid data. Select "Student" role, enter department, phone, classroom, and block. Tap "Create Account".
New user account is created in Firebase Authentication. User profile with role "student" is saved to Firestore. User is redirected to the Home Page after successful registration.


TC029
Student Registration
Navigate to the Registration Screen. Toggle the role to "Teacher". Verify that role-specific fields change.
Department field is hidden and Designation field is displayed. All other common fields remain unchanged.


TC030
Student Registration
Attempt to register with an email that is already in use.
Error message is displayed indicating the email is already registered. User remains on the Registration Screen. No duplicate account is created.


TC031
Student Registration
Attempt to submit the registration form with one or more required fields left empty.
Inline validation errors are shown for each empty required field. Form is not submitted until all required fields are filled.


TC032
Home Page
Login as a student and verify the Home Page loads correctly.
Home Page displays a personalized welcome header with the user's name, a search bar, recent orders in a horizontal scroll list, and canteen cards showing name and active/inactive status.


TC033
Home Page
Type a canteen name in the search bar on the Home Page.
Canteen cards are filtered in real time to show only canteens matching the search query. Clearing the search restores the full canteen list.


TC034
Home Page
Tap on a canteen card on the Home Page.
User is navigated to the Menu Page for the selected canteen. Menu items for that canteen are displayed grouped by category.


TC035
Menu Browsing
Navigate to a canteen's Menu Page. Verify menu items are displayed with correct details.
Menu items are grouped by category (Breakfast, Lunch, Snacks, Beverages, Desserts). Each item shows image, name, description, price in rupees, and availability status.


TC036
Menu Browsing
View a menu item that has zero stock.
Item is visually dimmed and displays an "Unavailable" indicator. The "Add" button is disabled. User cannot add the item to the cart.


TC037
Cart Management
Tap the "Add" button on an available menu item.
Item is added to the cart with quantity 1. The "Add" button transforms into increment/decrement quantity controls. A floating cart summary bar appears at the bottom showing item count and total.


TC038
Cart Management
Use the increment (+) and decrement (−) buttons on a cart item to adjust its quantity.
Quantity updates correctly. Cart total updates in real time. Decrementing to 0 removes the item from the cart.


TC039
Cart Management
Add an item from Canteen A to the cart, then try to add an item from Canteen B.
A confirmation dialog appears asking the user to clear the existing cart before adding items from a different canteen. Confirming clears the cart and adds the new item. Cancelling keeps the existing cart unchanged.


TC040
Checkout
Navigate to the Checkout Page with items in the cart. Verify the order summary is displayed.
Checkout Page shows the canteen name, list of cart items with quantities and prices, subtotal, and total amount. Fulfillment Type Selector defaults to Pickup.


TC041
Checkout
Select "Delivery" as the fulfillment type on the Checkout Page.
Delivery option is selected. Break Slot Picker appears showing available time slots. Delivery fee is added to the order summary. Total amount updates to include the delivery fee.


TC042
Checkout
Select the "Deliver Now" toggle in the Break Slot Picker.
"Deliver Now" option is selected. Time slot selection is bypassed. Order is marked for immediate delivery.


TC043
Checkout
Tap "Place Order" with valid cart items and fulfillment selection.
Order is submitted to Firestore. Loading indicator is shown during submission. Upon success, user is navigated to the Order Confirmation Page. Cart is cleared.


TC044
Checkout
Adjust item quantities on the Checkout Page using increment, decrement, and delete buttons.
Item quantities update correctly. Deleting an item removes it from the checkout list. Order summary recalculates subtotal and total in real time.


TC045
Order Confirmation
Verify the Order Confirmation Page after successfully placing an order.
Page displays a success animation (animated checkmark), the generated Order ID, a "View Order" button, and a "Back to Home" button. Both buttons navigate to their respective destinations.


TC046
Order Detail
Tap "View Order" on the Order Confirmation Page or tap an order from Order History.
Order Detail Page displays the order status badge, canteen name, fulfillment type (Pickup/Delivery), break slot info, list of items with quantities and prices, and price summary (subtotal, delivery fee, total).


TC047
Order Detail
Place a delivery order and check the Order Detail Page after a delivery student is assigned.
Delivery student information is displayed on the Order Detail Page. Status updates reflect assignment and delivery progress in real time.


TC048
Order History
Navigate to the Order History Page from the bottom navigation.
Page displays a list of past orders sorted by date (most recent first). Each order card shows Order ID, canteen name, date/time, item count, total amount, and status badge with color coding.


TC049
Order History
Pull down on the Order History Page to refresh.
Order list is refreshed with latest data from Firestore. Any new orders placed since last load appear in the list.


TC050
Order History
Tap on an order card in the Order History list.
User is navigated to the Order Detail Page for the selected order with full order information displayed.


TC051
Order Status Banner
Place an order from a canteen and then navigate back to that canteen's Menu Page.
An Order Status Banner appears at the top of the Menu Page showing the active order's current status with a colored background. Tapping the banner navigates to the Order Detail Page.


TC052
Delivery Mode
Navigate to the Profile Page. Toggle the "Delivery Mode" switch on.
Delivery mode is enabled. A Delivery tab appears in the bottom navigation. User can access the Delivery Home Page.


TC053
Delivery Mode
Toggle the "Delivery Mode" switch off on the Profile Page.
Delivery mode is disabled. The Delivery tab is removed from bottom navigation. User can no longer access delivery features.


TC054
Delivery Status Toggle
Navigate to the Delivery Home Page. Toggle the Online/Offline switch to Online.
Status updates to Online in Firestore. Green status banner is displayed. Delivery student becomes visible to canteen admins for delivery assignments.


TC055
Delivery Status Toggle
Toggle the Online/Offline switch to Offline on the Delivery Home Page.
Status updates to Offline in Firestore. Grey status banner is displayed. Delivery student is removed from the available delivery pool.


TC056
Delivery Assignment
While online as a delivery student, receive a delivery assignment notification.
Delivery Assignment Popup appears as a modal dialog showing canteen name, order items, delivery fee, and a countdown timer. "Accept" and "Reject" buttons are displayed.


TC057
Delivery Assignment
Tap "Accept" on the Delivery Assignment Popup.
Assignment is accepted. Popup dismisses. User is navigated to the Delivery Tracking Page for the assigned order. Order status updates in Firestore.


TC058
Delivery Assignment
Tap "Reject" on the Delivery Assignment Popup.
Assignment is rejected. Popup dismisses. Delivery student remains on the Delivery Home Page. Assignment is marked as rejected in Firestore.


TC059
Delivery Assignment
Let the countdown timer on the Delivery Assignment Popup expire without taking action.
Popup is automatically dismissed when the timer reaches zero. Assignment is marked as expired in Firestore. Delivery student remains on the Delivery Home Page.


TC060
Delivery Tracking
Accept a delivery assignment and navigate to the Delivery Tracking Page. Verify the status timeline.
Status timeline displays delivery states (Assigned, Picked Up, Delivering, Delivered) with the current state highlighted. Order items are listed with quantities. A contextual action button is displayed based on current state.


TC061
Delivery Tracking
Tap "Start Delivering" on the Delivery Tracking Page when the order is in "Picked Up" status.
Delivery status updates to "Delivering" in Firestore. Status timeline advances. Button changes to "Mark as Delivered". Loading state is shown during the update.


TC062
Delivery Tracking
Tap "Mark as Delivered" on the Delivery Tracking Page when the delivery is in transit.
Delivery status updates to "Delivered" in Firestore. Status timeline shows all steps as completed. Delivery is marked as complete. User is navigated back to the Delivery Home Page.


TC063
Delivery Home Page
Complete multiple deliveries and check the Delivery Home Page.
Delivery History List displays all completed delivery assignments as cards showing order details, delivery fee earned, and completion status. Active delivery card is not shown when no delivery is in progress.


TC064
Profile Page
Navigate to the Profile Page and verify displayed information.
Profile Page shows User Info Card (name, email, phone), Role Badge with appropriate color coding, and for delivery-enabled users, Delivery Stats showing total completed deliveries and total earnings in rupees.


TC065
Profile Page
Tap the "Logout" button on the Profile Page.
User is signed out of Firebase Authentication. User is redirected to the Login Screen. Cached user data is cleared.


TC066
Splash Screen
Launch the app when the user is already authenticated.
Splash Screen displays the Tap2Eat logo with a loading animation. After authentication state is resolved, user is automatically routed to the Home Page based on their role.


TC067
Splash Screen
Launch the app when the user is not authenticated.
Splash Screen displays briefly. User is redirected to the Onboarding Screen (first launch) or Login Screen (subsequent launches).


TC068
Real-time Updates
Place an order and have the canteen admin change its status from the admin panel.
Order status updates in real time on the student app — Order Detail Page status badge updates, Order History card status badge updates, and Menu Page order status banner updates without requiring manual refresh.



