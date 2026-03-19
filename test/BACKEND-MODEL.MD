collection name:users

{
  "email": "delivery1@tap2eat.com",
  "fcm_tokens": [],
  "name": "Vikram Rao",
  "role": "student"
}

collection :settings

{
  "break_slots": [
    {
      "day_of_week": 1,
      "start_time": "February 11, 2026 at 10:20:00 AM UTC+5:30",
      "end_time": "February 11, 2026 at 10:40:00 AM UTC+5:30",
      "label": "Morning Break",
      "is_active": true
    },
    {
      "day_of_week": 1,
      "end_time": "February 11, 2026 at 1:30:00 PM UTC+5:30",
      "label": "Lunch Break",
      "is_active": true
    }
  ]
}
Settings Configuration Overview:
Collection Path: settings > global

Active Slots:

Morning Break: 10:20 AM – 10:40 AM

Lunch Break: Ending at 1:30 PM

Day Reference: Both slots are configured for day_of_week: 1.


collection name:orders

{
  "canteen_id": "canteen_2",
  "created_at": "February 6, 2026 at 9:30:00 AM UTC+5:30",
  "delivery_fee": 0,
  "fulfillment_slot": "February 6, 2026 at 10:30:00 AM UTC+5:30",
  "fulfillment_type": "pickup",
  "items": [
    {
      "id": "9roUIvMvqiRuAHCyVApC",
      "name": "Upma",
      "price": 30,
      "quantity": 1
    },
    {
      "id": "dMVxrJ8uGrmbGWBSwBbi",
      "name": "French Fries",
      "price": 40,
      "quantity": 1
    }
  ],
  "status": "completed",
  "total_amount": 70,
  "updated_at": "February 6, 2026 at 9:40:00 AM UTC+5:30",
  "user_id": "MmbSD51ImkUf3EJubiGklaiid122"
}


collection name:earnings

{
  "amount": 10,
  "created_at": "February 11, 2026 at 9:45:00 AM UTC+5:30",
  "delivery_student_id": "1lCat5S57kNZawok3D7LKeBNzOI3",
  "order_id": "UbjhkowpKxyoKEdOJPgG",
  "status": "pending"
}




collection name:delivery_profiles


{
  "current_order_id": null,
  "email": "delivery1@tap2eat.com",
  "is_active": true,
  "is_online": true,
  "last_assigned_at": "February 11, 2026 at 9:30:00 AM UTC+5:30",
  "name": "Vikram Rao",
  "online_since": "February 11, 2026 at 8:00:00 AM UTC+5:30"
}


collection name:canteens

Canteen InformationThis data represents the high-level details for a specific facility, such as the Main Campus Canteen.FieldValueDescriptionname"Main Campus Canteen"The official name of the facility.is_activetrueIndicates if the canteen is currently accepting orders.max_concurrent_orders20The limit for how many orders can be processed simultaneously.Menu Item DetailsEach canteen has a menu_items subcollection. Below is an example of an individual item (e.g., Vada Pav) within that collection.Item Name: "Vada Pav"Price: 25Category: "Snacks"Description: "Mumbai style potato vada in pav"Availability: trueStock: 39 units remainingImage URL: null (currently no image assigned)





cloude function:
{
  "functions": [
    { "name": "toggleDeliveryMode", "trigger": "HTTP Request", "version": "v2" },
    { "name": "rejectDeliveryAssignment", "trigger": "HTTP Request", "version": "v2" },
    { "name": "acceptDeliveryAssignment", "trigger": "HTTP Request", "version": "v2" },
    { "name": "registerFcmToken", "trigger": "HTTP Request", "version": "v2" },
    { "name": "checkDeliveryTimeouts", "trigger": "Scheduled (Cron)", "version": "v2" },
    { "name": "updateDeliveryStudentStatus", "trigger": "HTTP Request", "version": "v2" },
    { "name": "onOrderStatusChange", "trigger": "Firestore Trigger", "version": "v2" }
  ]
}

for rederence:@/Users/rasal/college project/tap2eat_admin/functions