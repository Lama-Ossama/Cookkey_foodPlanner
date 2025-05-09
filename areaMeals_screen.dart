import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';
import 'package:food_planner_app/services/listMealBasedonArea.dart';
import 'package:food_planner_app/widgets/meal_tile.dart';


class AreaMealsScreen extends StatefulWidget {
  const AreaMealsScreen({super.key});

  @override
  State<AreaMealsScreen> createState() => _AreaMealsScreenState();
}

class _AreaMealsScreenState extends State<AreaMealsScreen> {
  late Future<List<MealSummary>> _mealsFuture;
  late String areaName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    areaName = ModalRoute.of(context)!.settings.arguments as String;
    _mealsFuture = MealsByAreaService().fetchMealsByArea(areaName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAC6),
      appBar: AppBar(
        backgroundColor:kPrimaryColor,
        title: Text(areaName),
        iconTheme: const IconThemeData(color: Colors.brown),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFFF1D6),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<MealSummary>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No meals found.'));
          }

          final meals = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return MealTile(meal: meal); // استدعاء الويجت الجديدة
            }
,
          );
        },
      ),
    );
  }
}
