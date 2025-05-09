import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/helper/plan_database.dart';
import 'package:food_planner_app/models/planned_meal_model.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  late Future<List<PlannedMeal>> _weeklyPlanFuture;
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _loadWeeklyPlan();
  }

  void _loadWeeklyPlan() {
    _weeklyPlanFuture = PlanDatabaseHelper.instance.getAllPlannedMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Plan 📅'),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFFF1D6),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFEAC6),
      body: FutureBuilder<List<PlannedMeal>>(
        future: _weeklyPlanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Initialize empty map for all days
          final Map<String, List<PlannedMeal>> mealsByDay = {};
          for (var day in daysOfWeek) {
            mealsByDay[day] = [];
          }

          // Populate with actual meals if data exists
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            for (var meal in snapshot.data!) {
              if (mealsByDay.containsKey(meal.day)) {
                mealsByDay[meal.day]!.add(meal);
              }
            }
          }

          return ListView.builder(
            itemCount: daysOfWeek.length,
            itemBuilder: (context, dayIndex) {
              final day = daysOfWeek[dayIndex];
              final dayMeals = mealsByDay[day]!;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 12),
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    if (dayMeals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No meal planned for this day',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: dayMeals.map((meal) => ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              meal.thumbnail,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            meal.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await PlanDatabaseHelper.instance
                                  .removePlannedMeal(meal.id);
                              setState(() {
                                _loadWeeklyPlan();
                              });
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'mealDetails_screen',
                              arguments: meal.id,
                            );
                          },
                        )).toList(),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}