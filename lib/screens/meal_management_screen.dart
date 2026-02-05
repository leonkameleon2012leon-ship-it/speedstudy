import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../models/dish.dart';
import '../models/ingredient.dart';
import '../services/meal_provider.dart';

/// Screen for managing meals with custom form builder pattern
class MealManagementScreen extends StatefulWidget {
  final Meal? mealToEdit;

  const MealManagementScreen({Key? key, this.mealToEdit}) : super(key: key);

  @override
  State<MealManagementScreen> createState() => _MealManagementScreenState();
}

class _MealManagementScreenState extends State<MealManagementScreen> {
  late MealCategory _chosenCategory;
  DateTime? _chosenDateTime;
  final List<DishBuilder> _dishBuilders = [];
  final _formKeyGlobal = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _chosenCategory = widget.mealToEdit?.category ?? MealCategory.breakfast;
    _chosenDateTime = widget.mealToEdit?.scheduledTime;
    
    if (widget.mealToEdit != null) {
      for (var d in widget.mealToEdit!.dishes) {
        _dishBuilders.add(DishBuilder.fromExisting(d));
      }
    }
  }

  void _appendDish() {
    setState(() {
      _dishBuilders.add(DishBuilder.empty());
    });
  }

  void _removeDish(int position) {
    setState(() {
      _dishBuilders.removeAt(position);
    });
  }

  Future<void> _selectDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _chosenDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _chosenDateTime != null
            ? TimeOfDay.fromDateTime(_chosenDateTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _chosenDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _persistMeal() async {
    if (!_formKeyGlobal.currentState!.validate()) return;

    final builtDishes = _dishBuilders
        .where((builder) => builder.hasContent())
        .map((builder) => builder.build())
        .toList();

    final mealObject = Meal(
      id: widget.mealToEdit?.id ?? 'meal_${DateTime.now().millisecondsSinceEpoch}',
      category: _chosenCategory,
      dishes: builtDishes,
      scheduledTime: _chosenDateTime,
    );

    final provider = context.read<MealProvider>();

    try {
      if (widget.mealToEdit != null) {
        await provider.updateMeal(widget.mealToEdit!.id, mealObject);
      } else {
        await provider.addMeal(mealObject);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(widget.mealToEdit != null ? 'Edit Meal' : 'Create Meal'),
        backgroundColor: Colors.orange[600],
        actions: [
          if (widget.mealToEdit != null)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete Meal?'),
                    content: Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  await context.read<MealProvider>().deleteMeal(widget.mealToEdit!.id);
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: Form(
        key: _formKeyGlobal,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            _CategorySelector(
              selectedCategory: _chosenCategory,
              onChanged: (cat) => setState(() => _chosenCategory = cat),
            ),
            SizedBox(height: 24),
            _TimeSelector(
              selectedTime: _chosenDateTime,
              onTap: _selectDateTime,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dishes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _appendDish,
                  icon: Icon(Icons.add),
                  label: Text('Add Dish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ..._dishBuilders.asMap().entries.map((entry) {
              return _DishEditorWidget(
                builder: entry.value,
                index: entry.key,
                onRemove: () => _removeDish(entry.key),
              );
            }).toList(),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _persistMeal,
        icon: Icon(Icons.check),
        label: Text('Save Meal'),
        backgroundColor: Colors.green[600],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final MealCategory selectedCategory;
  final Function(MealCategory) onChanged;

  const _CategorySelector({
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meal Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: MealCategory.values.map((cat) {
              final isSelected = cat == selectedCategory;
              return GestureDetector(
                onTap: () => onChanged(cat),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[400] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cat.emoji, style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text(
                        cat.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final DateTime? selectedTime;
  final VoidCallback onTap;

  const _TimeSelector({required this.selectedTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeDisplay = selectedTime != null
        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
        : 'Not set';

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meal Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.orange[700], size: 28),
                  SizedBox(width: 12),
                  Text(timeDisplay, style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DishEditorWidget extends StatelessWidget {
  final DishBuilder builder;
  final int index;
  final VoidCallback onRemove;

  const _DishEditorWidget({
    required this.builder,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Dish ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: onRemove,
              ),
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            initialValue: builder.dishNameController.text,
            decoration: InputDecoration(
              labelText: 'Dish Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.restaurant),
            ),
            onChanged: (val) => builder.dishNameController.text = val,
            validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            initialValue: builder.ingredientsText,
            decoration: InputDecoration(
              labelText: 'Ingredients (comma separated)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.list),
              hintText: 'e.g., flour, eggs, milk',
            ),
            maxLines: 2,
            onChanged: (val) => builder.ingredientsText = val,
          ),
        ],
      ),
    );
  }
}

class DishBuilder {
  final TextEditingController dishNameController;
  String ingredientsText;

  DishBuilder.empty()
      : dishNameController = TextEditingController(),
        ingredientsText = '';

  DishBuilder.fromExisting(Dish existing)
      : dishNameController = TextEditingController(text: existing.name),
        ingredientsText = existing.ingredients.map((i) => '${i.name} (${i.amount})').join(', ');

  bool hasContent() => dishNameController.text.isNotEmpty;

  Dish build() {
    final ingredientsList = ingredientsText.isEmpty
        ? <Ingredient>[]
        : ingredientsText.split(',').map((part) {
            final trimmed = part.trim();
            return Ingredient(
              id: 'ing_${DateTime.now().millisecondsSinceEpoch}_${trimmed.hashCode}',
              name: trimmed,
              amount: '1 serving',
            );
          }).toList();

    return Dish(
      id: 'dish_${DateTime.now().millisecondsSinceEpoch}',
      name: dishNameController.text,
      ingredients: ingredientsList,
    );
  }
}
