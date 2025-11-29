/// User roles in the system
enum UserRole {
  student,
  teacher,
  deliveryStudent,
}

/// Order status values
enum OrderStatus {
  pending, // Order placed, waiting for fulfillment slot
  preparing, // Canteen is preparing the order
  ready, // Order is ready for pickup or delivery
  assigned, // Delivery assigned to a delivery student (delivery orders only)
  delivering, // Order is being delivered (delivery orders only)
  delivered, // Delivery completed
  completed, // Order picked up or delivered successfully
  cancelled, // Order was cancelled
}

/// Fulfillment types for orders
enum FulfillmentType {
  pickup, // Student picks up from canteen
  delivery, // Delivered to teacher (only during break times)
}

/// Extension methods for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.deliveryStudent:
        return 'Delivery Student';
    }
  }

  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.deliveryStudent:
        return 'delivery_student';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'delivery_student':
        return UserRole.deliveryStudent;
      default:
        throw Exception('Invalid user role: $value');
    }
  }
}

/// Extension methods for OrderStatus
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.assigned:
        return 'Assigned';
      case OrderStatus.delivering:
        return 'Delivering';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.assigned:
        return 'assigned';
      case OrderStatus.delivering:
        return 'delivering';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'assigned':
        return OrderStatus.assigned;
      case 'delivering':
        return OrderStatus.delivering;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw Exception('Invalid order status: $value');
    }
  }
}

/// Extension methods for FulfillmentType
extension FulfillmentTypeExtension on FulfillmentType {
  String get displayName {
    switch (this) {
      case FulfillmentType.pickup:
        return 'Pickup';
      case FulfillmentType.delivery:
        return 'Delivery';
    }
  }

  String get value {
    switch (this) {
      case FulfillmentType.pickup:
        return 'pickup';
      case FulfillmentType.delivery:
        return 'delivery';
    }
  }

  static FulfillmentType fromString(String value) {
    switch (value) {
      case 'pickup':
        return FulfillmentType.pickup;
      case 'delivery':
        return FulfillmentType.delivery;
      default:
        throw Exception('Invalid fulfillment type: $value');
    }
  }
}
