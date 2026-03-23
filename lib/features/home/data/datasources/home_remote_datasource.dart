import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../config/constants/firebase_constants.dart';
import '../models/canteen_model.dart';
import '../models/recent_order_model.dart';
import '../models/settings_model.dart';

/// Remote data source for home screen data (Firestore)
abstract class HomeRemoteDataSource {
  Future<List<CanteenModel>> getCanteens();
  Future<List<RecentOrderModel>> getRecentOrders(String userId);
  Future<SettingsModel> getSettings();
  Future<List<CanteenModel>> searchCanteens(String query);
  Stream<List<RecentOrderModel>> watchRecentOrders(String userId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CanteenModel>> getCanteens() async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.canteensCollection)
          .where(FirebaseConstants.canteenIsActive, isEqualTo: true)
          .get();

      print('🔍 DEBUG: Found ${querySnapshot.docs.length} canteens');

      // Fetch canteens with menu items from subcollection
      final canteens = <CanteenModel>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        print('🔍 DEBUG: Canteen ${doc.id}:');
        print('  - Name: ${data['name']}');

        // Fetch menu items from subcollection
        final menuItemsSnapshot = await firestore
            .collection(FirebaseConstants.canteensCollection)
            .doc(doc.id)
            .collection('menu_items')
            .get();

        print('  - Menu items in subcollection: ${menuItemsSnapshot.docs.length}');

        // Convert menu items subcollection to array format
        final menuItems = menuItemsSnapshot.docs.map((itemDoc) {
          final itemData = itemDoc.data();
          itemData['id'] = itemDoc.id; // Use document ID as item ID
          return itemData;
        }).toList();

        // Add menu_items array to canteen data
        data['menu_items'] = menuItems;

        if (menuItems.isNotEmpty) {
          print('  - First item: ${menuItems[0]}');
        }

        canteens.add(CanteenModel.fromJson(data));
      }

      return canteens;
    } catch (e) {
      print('❌ ERROR fetching canteens: $e');
      throw Exception('Failed to fetch canteens: $e');
    }
  }

  @override
  Future<List<RecentOrderModel>> getRecentOrders(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where(FirebaseConstants.orderUserId, isEqualTo: userId)
          .orderBy(FirebaseConstants.orderCreatedAt, descending: true)
          .limit(10)
          .get();

      final orders = <RecentOrderModel>[];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Fetch canteen name
        final canteenDoc = await firestore
            .collection(FirebaseConstants.canteensCollection)
            .doc(data[FirebaseConstants.orderCanteenId] as String)
            .get();

        if (canteenDoc.exists) {
          data['canteen_name'] =
              canteenDoc.data()?[FirebaseConstants.canteenName];
        }

        orders.add(RecentOrderModel.fromJson(data));
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch recent orders: $e');
    }
  }

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.settingsDocument)
          .doc('global')
          .get();

      if (!doc.exists) {
        throw Exception('Settings document not found');
      }

      return SettingsModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch settings: $e');
    }
  }

  @override
  Future<List<CanteenModel>> searchCanteens(String query) async {
    try {
      if (query.isEmpty) {
        return await getCanteens();
      }

      // Firestore doesn't support full-text search, so fetch all and filter locally
      final allCanteens = await getCanteens();

      final lowercaseQuery = query.toLowerCase();
      return allCanteens.where((canteen) {
        // Search in canteen name
        if (canteen.name.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }

        // Search in menu items
        return canteen.menuItems.any((item) =>
            item.name.toLowerCase().contains(lowercaseQuery) ||
            item.category.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search canteens: $e');
    }
  }

  @override
  Stream<List<RecentOrderModel>> watchRecentOrders(String userId) {
    return firestore
        .collection(FirebaseConstants.ordersCollection)
        .where(FirebaseConstants.orderUserId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return RecentOrderModel.fromJson(data);
          }).toList();
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders.take(10).toList();
        });
  }
}
