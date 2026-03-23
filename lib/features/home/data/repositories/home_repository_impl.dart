import '../../domain/entities/canteen_entity.dart';
import '../../domain/entities/recent_order_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Implementation of HomeRepository
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CanteenEntity>> getCanteens() async {
    try {
      final canteenModels = await remoteDataSource.getCanteens();
      return canteenModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get canteens - $e');
    }
  }

  @override
  Future<List<RecentOrderEntity>> getRecentOrders(String userId) async {
    try {
      final orderModels = await remoteDataSource.getRecentOrders(userId);
      return orderModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get recent orders - $e');
    }
  }

  @override
  Future<SettingsEntity> getSettings() async {
    try {
      final settingsModel = await remoteDataSource.getSettings();
      return settingsModel.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get settings - $e');
    }
  }

  @override
  Future<List<CanteenEntity>> searchCanteens(String query) async {
    try {
      final canteenModels = await remoteDataSource.searchCanteens(query);
      return canteenModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search canteens - $e');
    }
  }

  @override
  Stream<List<RecentOrderEntity>> watchRecentOrders(String userId) {
    return remoteDataSource
        .watchRecentOrders(userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
