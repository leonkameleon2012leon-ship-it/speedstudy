import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
import '../services/meal_provider.dart';
import 'meal_management_screen.dart';
import 'daily_planner_screen.dart';

/// Dashboard view showing scheduled eating times
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _computeRemainingTime(Duration? gap) {
    if (gap == null) return 'No time';
    if (gap.isNegative) return 'Ready now';
    
    final hrs = gap.inHours;
    final mins = gap.inMinutes.remainder(60);
    
    if (hrs == 0) return '$mins minutes';
    return '$hrs hours $mins min';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dining, size: 120, color: Colors.orange[200]),
            SizedBox(height: 32),
            Text('Ready to plan?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Text('Schedule your meals and get reminders',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(BuildContext ctx, Meal mealEntry) {
    final gap = mealEntry.timeUntilMeal();
    final remainingText = _computeRemainingTime(gap);
    final clockText = mealEntry.scheduledTime != null
        ? DateFormat.jm().format(mealEntry.scheduledTime!)
        : 'Not scheduled';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => MealManagementScreen(mealToEdit: mealEntry),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(mealEntry.category.emoji,
                          style: TextStyle(fontSize: 36)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealEntry.category.displayName,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(clockText,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(remainingText,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      backgroundColor: Colors.orange[100],
                    ),
                  ],
                ),
                if (mealEntry.dishes.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mealEntry.dishes
                          .map((dishItem) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle,
                                        size: 8, color: Colors.orange),
                                    SizedBox(width: 10),
                                    Text(dishItem.name,
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nowDate = DateTime.now();
    final headerDate = DateFormat('EEEE, MMM d').format(nowDate);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Today\'s Menu', style: TextStyle(fontSize: 26)),
        backgroundColor: Colors.orange[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.view_day, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DailyPlannerScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[600],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(headerDate,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 8),
                Consumer<MealProvider>(
                  builder: (ctx, dataSource, _) {
                    final pendingList = dataSource.upcomingMeals;
                    return Text(
                      pendingList.isEmpty
                          ? 'Nothing scheduled yet'
                          : '${pendingList.length} upcoming',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MealProvider>(
              builder: (ctx, dataSource, _) {
                if (dataSource.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                final pendingList = dataSource.upcomingMeals;

                if (pendingList.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 16, bottom: 80),
                  itemCount: pendingList.length,
                  itemBuilder: (ctx, idx) => _buildMealTile(ctx, pendingList[idx]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MealManagementScreen()),
        ),
        backgroundColor: Colors.orange[700],
        icon: Icon(Icons.add_circle_outline, size: 30),
        label: Text('New Meal', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
