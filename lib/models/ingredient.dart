/// Represents an ingredient in a dish
class Ingredient {
  final String id;
  final String name;
  final String amount;

  Ingredient({
    required this.id,
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as String,
    );
  }

  Ingredient copyWith({
    String? id,
    String? name,
    String? amount,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
