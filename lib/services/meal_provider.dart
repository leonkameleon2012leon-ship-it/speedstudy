import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../services/notification_service.dart';

/// Provider for managing meal state
class MealProvider with ChangeNotifier {
  final MealService _mealService = MealService();
  final NotificationService _notificationService = NotificationService();

  List<Meal> _meals = [];
  bool _isLoading = false;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  List<Meal> get todaysMeals {
    return _meals.where((meal) => meal.isScheduledForToday()).toList()
      ..sort((a, b) {
        if (a.scheduledTime == null) return 1;
        if (b.scheduledTime == null) return -1;
        return a.scheduledTime!.compareTo(b.scheduledTime!);
      });
  }

  List<Meal> get upcomingMeals {
    return todaysMeals.where((meal) => !meal.hasPassed()).toList();
  }

  /// Initialize provider
  Future<void> initialize() async {
    await _notificationService.initialize();
    await loadMeals();
  }

  /// Load all meals
  Future<void> loadMeals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _meals = await _mealService.loadMeals();
    } catch (e) {
      debugPrint('Error loading meals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new meal
  Future<void> addMeal(Meal meal) async {
    try {
      await _mealService.addMeal(meal);
      _meals.add(meal);
      
      // Schedule notification
      await _notificationService.scheduleMealNotification(meal);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding meal: $e');
      rethrow;
    }
  }

  /// Update an existing meal
  Future<void> updateMeal(String mealId, Meal updatedMeal) async {
    try {
      await _mealService.updateMeal(mealId, updatedMeal);
      
      final index = _meals.indexWhere((m) => m.id == mealId);
      if (index != -1) {
        _meals[index] = updatedMeal;
        
        // Reschedule notification
        await _notificationService.cancelMealNotification(mealId);
        await _notificationService.scheduleMealNotification(updatedMeal);
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating meal: $e');
      rethrow;
    }
  }

  /// Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _mealService.deleteMeal(mealId);
      _meals.removeWhere((m) => m.id == mealId);
      
      // Cancel notification
      await _notificationService.cancelMealNotification(mealId);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting meal: $e');
      rethrow;
    }
  }

  /// Refresh meals and reschedule all notifications
  Future<void> refreshMeals() async {
    await loadMeals();
    await _notificationService.cancelAllNotifications();
    await _notificationService.scheduleMealNotifications(_meals);
  }

  /// Request notification permissions
  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestPermissions();
  }
}
