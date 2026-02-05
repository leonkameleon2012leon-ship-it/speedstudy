import 'dish.dart';

/// Meal categories
enum MealCategory {
  breakfast,
  lunch,
  snack,
  dinner,
}

extension MealCategoryExtension on MealCategory {
  String get displayName {
    switch (this) {
      case MealCategory.breakfast:
        return 'Breakfast';
      case MealCategory.lunch:
        return 'Lunch';
      case MealCategory.snack:
        return 'Snack';
      case MealCategory.dinner:
        return 'Dinner';
    }
  }

  String get emoji {
    switch (this) {
      case MealCategory.breakfast:
        return '🌅';
      case MealCategory.lunch:
        return '🍽️';
      case MealCategory.snack:
        return '🍪';
      case MealCategory.dinner:
        return '🌙';
    }
  }
}

/// Represents a meal with its dishes and scheduled time
class Meal {
  final String id;
  final MealCategory category;
  final List<Dish> dishes;
  final DateTime? scheduledTime;

  Meal({
    required this.id,
    required this.category,
    required this.dishes,
    this.scheduledTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.index,
      'dishes': dishes.map((d) => d.toJson()).toList(),
      'scheduledTime': scheduledTime?.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      category: MealCategory.values[json['category'] as int],
      dishes: (json['dishes'] as List)
          .map((d) => Dish.fromJson(d as Map<String, dynamic>))
          .toList(),
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'] as String)
          : null,
    );
  }

  Meal copyWith({
    String? id,
    MealCategory? category,
    List<Dish>? dishes,
    DateTime? scheduledTime,
  }) {
    return Meal(
      id: id ?? this.id,
      category: category ?? this.category,
      dishes: dishes ?? this.dishes,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }

  /// Check if meal is scheduled for today
  bool isScheduledForToday() {
    if (scheduledTime == null) return false;
    final now = DateTime.now();
    return scheduledTime!.year == now.year &&
        scheduledTime!.month == now.month &&
        scheduledTime!.day == now.day;
  }

  /// Check if meal time has passed
  bool hasPassed() {
    if (scheduledTime == null) return false;
    return DateTime.now().isAfter(scheduledTime!);
  }

  /// Get time until meal
  Duration? timeUntilMeal() {
    if (scheduledTime == null) return null;
    return scheduledTime!.difference(DateTime.now());
  }
}
