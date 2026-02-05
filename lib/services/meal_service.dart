import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

/// Service for managing meals with local storage
class MealService {
  static const String _mealsKey = 'meals';
  
  /// Save meals to local storage
  Future<void> saveMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = meals.map((meal) => meal.toJson()).toList();
    await prefs.setString(_mealsKey, jsonEncode(mealsJson));
  }

  /// Load meals from local storage
  Future<List<Meal>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsString = prefs.getString(_mealsKey);
    
    if (mealsString == null) {
      return [];
    }

    final mealsJson = jsonDecode(mealsString) as List;
    return mealsJson
        .map((json) => Meal.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Add a new meal
  Future<void> addMeal(Meal meal) async {
    final meals = await loadMeals();
    meals.add(meal);
    await saveMeals(meals);
  }

  /// Update an existing meal
  Future<void> updateMeal(String mealId, Meal updatedMeal) async {
    final meals = await loadMeals();
    final index = meals.indexWhere((m) => m.id == mealId);
    
    if (index != -1) {
      meals[index] = updatedMeal;
      await saveMeals(meals);
    }
  }

  /// Delete a meal
  Future<void> deleteMeal(String mealId) async {
    final meals = await loadMeals();
    meals.removeWhere((m) => m.id == mealId);
    await saveMeals(meals);
  }

  /// Get meals for today
  Future<List<Meal>> getTodaysMeals() async {
    final meals = await loadMeals();
    return meals.where((meal) => meal.isScheduledForToday()).toList()
      ..sort((a, b) {
        if (a.scheduledTime == null) return 1;
        if (b.scheduledTime == null) return -1;
        return a.scheduledTime!.compareTo(b.scheduledTime!);
      });
  }

  /// Get upcoming meals (not yet passed)
  Future<List<Meal>> getUpcomingMeals() async {
    final todaysMeals = await getTodaysMeals();
    return todaysMeals.where((meal) => !meal.hasPassed()).toList();
  }

  /// Get all meals sorted by time
  Future<List<Meal>> getAllMealsSorted() async {
    final meals = await loadMeals();
    meals.sort((a, b) {
      if (a.scheduledTime == null) return 1;
      if (b.scheduledTime == null) return -1;
      return a.scheduledTime!.compareTo(b.scheduledTime!);
    });
    return meals;
  }

  /// Clear all meals
  Future<void> clearAllMeals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mealsKey);
  }
}
