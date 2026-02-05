import 'ingredient.dart';

/// Represents a dish with its ingredients
class Dish {
  final String id;
  final String name;
  final List<Ingredient> ingredients;
  final String? notes;

  Dish({
    required this.id,
    required this.name,
    required this.ingredients,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'notes': notes,
    };
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String,
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }

  Dish copyWith({
    String? id,
    String? name,
    List<Ingredient>? ingredients,
    String? notes,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      notes: notes ?? this.notes,
    );
  }
}
