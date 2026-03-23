import '../entities/canteen_entity.dart';
import '../entities/recent_order_entity.dart';
import '../entities/settings_entity.dart';

/// Repository interface for home screen data operations
abstract class HomeRepository {
  /// Fetch all active canteens
  Future<List<CanteenEntity>> getCanteens();

  /// Fetch recent orders for a specific user (limit: 10)
  Future<List<RecentOrderEntity>> getRecentOrders(String userId);

  /// Fetch global settings (break slots, cutoff time)
  Future<SettingsEntity> getSettings();

  /// Search for menu items or canteens by query
  Future<List<CanteenEntity>> searchCanteens(String query);

  /// Stream recent orders for a user, updating in real time
  Stream<List<RecentOrderEntity>> watchRecentOrders(String userId);
}
