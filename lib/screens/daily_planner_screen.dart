import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
import '../services/meal_provider.dart';
import 'meal_management_screen.dart';

/// Full day overview with timeline visualization
class DailyPlannerScreen extends StatelessWidget {
  const DailyPlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Daily Schedule'),
        backgroundColor: Colors.orange[600],
      ),
      body: Consumer<MealProvider>(
        builder: (ctx, dataStore, _) {
          final todayMeals = dataStore.todaysMeals;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _HeaderSection(mealCount: todayMeals.length),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              if (todayMeals.isEmpty)
                SliverFillRemaining(
                  child: _EmptyDayView(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, idx) => _TimelineEntry(
                        meal: todayMeals[idx],
                        isFirst: idx == 0,
                        isLast: idx == todayMeals.length - 1,
                      ),
                      childCount: todayMeals.length,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final int mealCount;

  const _HeaderSection({required this.mealCount});

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todayStr,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.event_note, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text(
                '$mealCount ${mealCount == 1 ? 'Meal' : 'Meals'} Today',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyDayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 100, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            'No meals scheduled today',
            style: TextStyle(fontSize: 22, color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          Text(
            'Add meals to plan your day',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final Meal meal;
  final bool isFirst;
  final bool isLast;

  const _TimelineEntry({
    required this.meal,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isPast = meal.hasPassed();
    final timeStr = meal.scheduledTime != null
        ? DateFormat('h:mm a').format(meal.scheduledTime!)
        : 'Anytime';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 80,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: isPast ? Colors.grey[400] : Colors.orange[300],
                    ),
                  ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPast ? Colors.grey[400] : Colors.orange[500],
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isPast ? Icons.check : Icons.schedule,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: Colors.orange[300],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Meal content card
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealManagementScreen(mealToEdit: meal),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 24),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPast ? Colors.grey[300]! : Colors.orange[200]!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          meal.category.emoji,
                          style: TextStyle(
                            fontSize: 32,
                            color: isPast ? Colors.black38 : null,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.category.displayName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isPast ? Colors.grey[600] : Colors.black87,
                                ),
                              ),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isPast ? Colors.grey[500] : Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPast)
                          Chip(
                            label: Text('Completed', style: TextStyle(fontSize: 12)),
                            backgroundColor: Colors.grey[300],
                          ),
                      ],
                    ),
                    if (meal.dishes.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Divider(color: Colors.grey[300]),
                      SizedBox(height: 8),
                      ...meal.dishes.map(
                        (d) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isPast ? Colors.grey[400] : Colors.orange,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  d.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isPast ? Colors.grey[600] : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
